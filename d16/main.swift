import Foundation

let path = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "in.txt"
let grid = try! String(contentsOfFile: path, encoding: .utf8)
    .split(separator: "\n").map { Array($0) }
let h = grid.count
let w = grid[0].count

// directions: 0 up, 1 right, 2 down, 3 left
let dr = [-1, 0, 1, 0]
let dc = [0, 1, 0, -1]

struct Beam { var r: Int; var c: Int; var d: Int }

func energized(_ start: Beam) -> Int {
    var seen = [Bool](repeating: false, count: h * w * 4)
    var lit = [Bool](repeating: false, count: h * w)
    var stack = [start]
    var count = 0
    while let b = stack.popLast() {
        guard b.r >= 0, b.r < h, b.c >= 0, b.c < w else { continue }
        let cell = (b.r * w + b.c)
        if seen[cell * 4 + b.d] { continue }
        seen[cell * 4 + b.d] = true
        if !lit[cell] { lit[cell] = true; count += 1 }
        var next: [Int]
        switch grid[b.r][b.c] {
        case "/": next = [[1, 0, 3, 2][b.d]]
        case "\\": next = [[3, 2, 1, 0][b.d]]
        case "|" where b.d % 2 == 1: next = [0, 2]
        case "-" where b.d % 2 == 0: next = [1, 3]
        default: next = [b.d]
        }
        for d in next {
            stack.append(Beam(r: b.r + dr[d], c: b.c + dc[d], d: d))
        }
    }
    return count
}

print("part 1:", energized(Beam(r: 0, c: 0, d: 1)))

var best = 0
for i in 0..<h {
    best = max(best, energized(Beam(r: i, c: 0, d: 1)), energized(Beam(r: i, c: w - 1, d: 3)))
}
for j in 0..<w {
    best = max(best, energized(Beam(r: 0, c: j, d: 2)), energized(Beam(r: h - 1, c: j, d: 0)))
}
print("part 2:", best)
