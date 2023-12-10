def conns : Char → List (Int × Int)
  | '|' => [(-1, 0), (1, 0)]
  | '-' => [(0, -1), (0, 1)]
  | 'L' => [(-1, 0), (0, 1)]
  | 'J' => [(-1, 0), (0, -1)]
  | '7' => [(1, 0), (0, -1)]
  | 'F' => [(1, 0), (0, 1)]
  | _ => []

def tile (g : Array (Array Char)) (p : Int × Int) : Char :=
  if p.1 < 0 || p.2 < 0 then '.'
  else (g[p.1.toNat]?.bind (·[p.2.toNat]?)).getD '.'

partial def walk (g : Array (Array Char)) (s p d : Int × Int) (len area : Int) : Int × Int :=
  let q := (p.1 + d.1, p.2 + d.2)
  let len := len + 1
  let area := area + p.1 * q.2 - q.1 * p.2
  if q == s then (len, area)
  else
    let back := (-d.1, -d.2)
    match (conns (tile g q)).find? (· != back) with
    | some d' => walk g s q d' len area
    | none => (len, area)

def main (args : List String) : IO Unit := do
  let file := args.headD "in.txt"
  let txt ← IO.FS.readFile file
  let g := (txt.splitOn "\n").filter (· != "") |>.map (·.toList.toArray) |>.toArray
  let mut s : Int × Int := (0, 0)
  for i in [0:g.size] do
    for j in [0:g[i]!.size] do
      if g[i]![j]! == 'S' then s := (i, j)
  let dirs : List (Int × Int) := [(-1, 0), (0, 1), (1, 0), (0, -1)]
  let some d := dirs.find? fun d =>
      (conns (tile g (s.1 + d.1, s.2 + d.2))).contains (-d.1, -d.2)
    | throw (IO.userError "no start")
  let (len, area) := walk g s s d 0 0
  let a := (if area < 0 then -area else area) / 2
  IO.println (len / 2)
  IO.println (a - len / 2 + 1)
