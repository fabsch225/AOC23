open System.IO

let path = if fsi.CommandLineArgs.Length > 1 then fsi.CommandLineArgs.[1] else Path.Combine(__SOURCE_DIRECTORY__, "in.txt")

let bricks =
    File.ReadAllLines path
    |> Array.filter (fun l -> l <> "")
    |> Array.map (fun l ->
        let n = l.Replace("~", ",").Split(',') |> Array.map int
        (n.[0], n.[1], n.[2], n.[3], n.[4], n.[5]))
    |> Array.sortBy (fun (_, _, z1, _, _, z2) -> min z1 z2)

let count = bricks.Length
let below = Array.init count (fun _ -> System.Collections.Generic.HashSet<int>())
let above = Array.init count (fun _ -> System.Collections.Generic.HashSet<int>())
let top = System.Collections.Generic.Dictionary<(int * int), int * int>()

bricks |> Array.iteri (fun i (x1, y1, z1, x2, y2, z2) ->
    let cells = [ for x in min x1 x2 .. max x1 x2 do for y in min y1 y2 .. max y1 y2 -> (x, y) ]
    let get c = match top.TryGetValue c with | true, v -> v | _ -> (0, -1)
    let h = cells |> List.map (get >> fst) |> List.max
    for c in cells do
        let (ch, j) = get c
        if ch = h && j >= 0 then
            below.[i].Add j |> ignore
            above.[j].Add i |> ignore
    let height = abs (z2 - z1) + 1
    for c in cells do top.[c] <- (h + height, i))

let part1 =
    [ 0 .. count - 1 ]
    |> List.filter (fun i -> above.[i] |> Seq.forall (fun j -> below.[j].Count > 1))
    |> List.length

let falling start =
    let fallen = System.Collections.Generic.HashSet<int>([ start ])
    let queue = System.Collections.Generic.Queue<int>([ start ])
    while queue.Count > 0 do
        let i = queue.Dequeue()
        for j in above.[i] do
            if not (fallen.Contains j) && below.[j] |> Seq.forall fallen.Contains then
                fallen.Add j |> ignore
                queue.Enqueue j
    fallen.Count - 1

let part2 = [ 0 .. count - 1 ] |> List.sumBy falling

printfn "%d" part1
printfn "%d" part2
