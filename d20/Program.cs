var path = args.Length > 0 ? args[0] : Path.Combine(AppContext.BaseDirectory, "in.txt");
if (!File.Exists(path)) path = "in.txt";

var kind = new Dictionary<string, char>();
var outs = new Dictionary<string, string[]>();
foreach (var line in File.ReadLines(path))
{
    var parts = line.Split(" -> ");
    var name = parts[0];
    var type = 'b';
    if (name[0] == '%' || name[0] == '&') { type = name[0]; name = name[1..]; }
    kind[name] = type;
    outs[name] = parts[1].Split(", ");
}

var ins = new Dictionary<string, List<string>>();
foreach (var (src, dsts) in outs)
    foreach (var d in dsts)
    {
        if (!ins.ContainsKey(d)) ins[d] = new();
        ins[d].Add(src);
    }

// the conjunction feeding rx, and the cycle length of each of its inputs
var feeder = ins.ContainsKey("rx") ? ins["rx"][0] : null;
var seen = new Dictionary<string, long>();

var on = new HashSet<string>();
var memory = new Dictionary<string, Dictionary<string, bool>>();
foreach (var (n, k) in kind)
    if (k == '&') memory[n] = ins[n].ToDictionary(i => i, i => false);

long low = 0, high = 0;
for (long press = 1; press <= 1000 || (feeder != null && seen.Count < ins[feeder].Count); press++)
{
    var queue = new Queue<(string from, string to, bool pulse)>();
    queue.Enqueue(("button", "broadcaster", false));
    while (queue.Count > 0)
    {
        var (from, to, pulse) = queue.Dequeue();
        if (press <= 1000) { if (pulse) high++; else low++; }
        if (to == feeder && pulse && !seen.ContainsKey(from)) seen[from] = press;
        if (!kind.TryGetValue(to, out var k)) continue;

        bool send;
        if (k == '%')
        {
            if (pulse) continue;
            if (!on.Remove(to)) on.Add(to);
            send = on.Contains(to);
        }
        else if (k == '&')
        {
            memory[to][from] = pulse;
            send = !memory[to].Values.All(v => v);
        }
        else send = pulse;

        foreach (var d in outs[to]) queue.Enqueue((to, d, send));
    }
}

static long Gcd(long a, long b) => b == 0 ? a : Gcd(b, a % b);
Console.WriteLine(low * high);
if (feeder != null) Console.WriteLine(seen.Values.Aggregate(1L, (a, b) => a / Gcd(a, b) * b));
