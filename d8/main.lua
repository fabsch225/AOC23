local f = assert(io.open(arg[1] or "in.txt"))
local turns = f:read("l")
local L, R, starts = {}, {}, {}
for line in f:lines() do
  local a, l, r = line:match("(%w+) = %((%w+), (%w+)%)")
  if a then
    L[a], R[a] = l, r
    if a:sub(-1) == "A" then starts[#starts + 1] = a end
  end
end
f:close()

local function steps(node, done)
  local n = 0
  while not done(node) do
    local t = turns:sub(n % #turns + 1, n % #turns + 1)
    node = (t == "L" and L or R)[node]
    n = n + 1
  end
  return n
end

local function gcd(a, b)
  while b ~= 0 do a, b = b, a % b end
  return a
end

print("part 1:", L.AAA and steps("AAA", function(n) return n == "ZZZ" end) or "n/a")

local total = 1
for _, s in ipairs(starts) do
  local n = steps(s, function(n) return n:sub(-1) == "Z" end)
  total = total // gcd(total, n) * n
end
print("part 2:", total)
