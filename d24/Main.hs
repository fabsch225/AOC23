module Main where

import Data.List (find, tails)
import Data.Ratio
import System.Environment (getArgs)

type Stone = ([Integer], [Integer])

parse :: String -> Stone
parse l = splitAt 3 (map read (words (map clean l)))
  where clean c = if c `elem` ",@" then ' ' else c

-- xy paths: p + t*v = q + s*w, both t and s must be >= 0
crossing :: Stone -> Stone -> Maybe (Rational, Rational)
crossing ([px, py, _], [vx, vy, _]) ([qx, qy, _], [wx, wy, _])
  | det == 0 = Nothing
  | t < 0 || s < 0 = Nothing
  | otherwise = Just (fromInteger px + t * fromInteger vx, fromInteger py + t * fromInteger vy)
  where
    det = wx * vy - vx * wy
    t = fromInteger (wx * (qy - py) - wy * (qx - px)) / fromInteger det
    s = fromInteger (vx * (qy - py) - vy * (qx - px)) / fromInteger det
crossing _ _ = Nothing

part1 :: Integer -> Integer -> [Stone] -> Int
part1 lo hi stones = length
  [ () | (a : rest) <- tails stones, b <- rest, Just (x, y) <- [crossing a b], inside x, inside y ]
  where inside v = v >= fromInteger lo && v <= fromInteger hi

cross :: Num a => [a] -> [a] -> [a]
cross [a1, a2, a3] [b1, b2, b3] = [a2 * b3 - a3 * b2, a3 * b1 - a1 * b3, a1 * b2 - a2 * b1]
cross _ _ = error "cross"

sub :: [Integer] -> [Integer] -> [Integer]
sub = zipWith (-)

-- rock p, v: p x (vi - vj) + (pi - pj) x v = pi x vi - pj x vj, linear in (p, v)
equations :: Stone -> Stone -> [[Rational]]
equations (pi', vi) (pj, vj) = zipWith row [0 ..] (cross pi' vi `sub` cross pj vj)
  where
    dv = sub vi vj
    dp = sub pi' pj
    -- coefficient of unit vector e_k in cross(e_k, dv) / cross(dp, e_k)
    row i rhs = map fromInteger (pcoef i ++ vcoef i ++ [rhs])
    pcoef i = [cross (unit k) dv !! i | k <- [0 .. 2]]
    vcoef i = [cross dp (unit k) !! i | k <- [0 .. 2]]
    unit k = [if j == k then 1 else 0 | j <- [0 .. 2]]

gauss :: [[Rational]] -> [Rational]
gauss m = go 0 m
  where
    n = length (head m) - 1
    go c rows
      | c == n = [last r / (r !! c') | (r, c') <- zip (take n rows) [0 ..]]
      | otherwise = case find ((/= 0) . (!! c)) (drop c rows) of
          Nothing -> error "singular"
          Just p ->
            let others = filter (/= p) (drop c rows)
                p' = map (/ (p !! c)) p
                elim r = zipWith (-) r (map (* (r !! c)) p')
                top = map elim (take c rows)
            in go (c + 1) (top ++ [p'] ++ map elim others)

part2 :: [Stone] -> (Integer, [Integer], Bool)
part2 stones = (sum (take 3 sol), sol, all hits stones)
  where
    (s0 : rest) = stones
    eqs = concat [equations s0 s | s <- take 3 rest]
    sol = map whole (gauss eqs)
    whole r = if denominator r == 1 then numerator r else error "rock is not integral"
    (p, v) = splitAt 3 sol
    hits (q, w) = cross (sub p q) (sub v w) == [0, 0, 0]

main :: IO ()
main = do
  args <- getArgs
  input <- readFile (case args of (f : _) -> f; _ -> "in.txt")
  let stones = map parse (lines input)
      (lo, hi) = case args of
        (_ : _) -> (7, 27)
        _ -> (200000000000000, 400000000000000)
      (ans, rock, ok) = part2 stones
  putStrLn ("part 1: " ++ show (part1 lo hi stones))
  putStrLn ("part 2: " ++ show ans)
  putStrLn ("rock " ++ show rock ++ " hits all: " ++ show ok)
