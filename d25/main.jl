file = length(ARGS) > 0 ? ARGS[1] : joinpath(@__DIR__, "in.txt")

ids = Dict{String,Int}()
id(s) = get!(ids, s, length(ids) + 1)
edges = Tuple{Int,Int}[]
for line in eachline(file)
    isempty(strip(line)) && continue
    a, rest = split(line, ": ")
    for b in split(rest)
        push!(edges, (id(a), id(String(b))))
    end
end

n = length(ids)
adj = [Int[] for _ in 1:n]
for (a, b) in edges
    push!(adj[a], b)
    push!(adj[b], a)
end

# unit capacity flow on undirected edges, flow[(u, v)] = +1 means one unit went u -> v
function maxflow(s, t, limit)
    flow = Dict{Tuple{Int,Int},Int}()
    f = 0
    while f <= limit
        prev = zeros(Int, n)
        prev[s] = s
        queue = [s]
        head = 1
        while head <= length(queue) && prev[t] == 0
            u = queue[head]
            head += 1
            for v in adj[u]
                prev[v] == 0 && get(flow, (u, v), 0) < 1 || continue
                prev[v] = u
                push!(queue, v)
            end
        end
        if prev[t] == 0
            return f, count(!=(0), prev)
        end
        v = t
        while v != s
            u = prev[v]
            flow[(u, v)] = get(flow, (u, v), 0) + 1
            flow[(v, u)] = get(flow, (v, u), 0) - 1
            v = u
        end
        f += 1
    end
    return f, 0
end

for t in 2:n
    f, size = maxflow(1, t, 3)
    if f == 3
        println(size * (n - size))
        break
    end
end
