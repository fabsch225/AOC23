#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>
using namespace std;

vector<string> g;
int H, W;
const int dr[] = {-1, 0, 1, 0}, dc[] = {0, 1, 0, -1};
const string arrows = "^>v<";

struct Edge { int to, len; };
vector<vector<Edge>> adj;
vector<int> visitedNode;
int target;

bool open(int r, int c) { return r >= 0 && r < H && c >= 0 && c < W && g[r][c] != '#'; }

int junctionCount(int r, int c) {
    int n = 0;
    for (int d = 0; d < 4; d++) n += open(r + dr[d], c + dc[d]);
    return n;
}

vector<vector<Edge>> build(bool slopes, const map<pair<int, int>, int>& id) {
    vector<vector<Edge>> res(id.size());
    for (auto& [pos, from] : id) {
        for (int d = 0; d < 4; d++) {
            int r = pos.first, c = pos.second, pd = d, len = 0;
            bool ok = true;
            while (true) {
                size_t a = arrows.find(g[r][c]);
                if (slopes && a != string::npos && (int)a != pd) { ok = false; break; }
                int nr = r + dr[pd], nc = c + dc[pd];
                if (!open(nr, nc)) { ok = false; break; }
                r = nr; c = nc; len++;
                if (id.count({r, c})) break;
                int nd = -1;
                for (int k = 0; k < 4; k++) {
                    if (k == (pd + 2) % 4) continue;
                    if (open(r + dr[k], c + dc[k])) nd = k;
                }
                if (nd < 0) { ok = false; break; }
                pd = nd;
            }
            if (ok && !(r == pos.first && c == pos.second)) res[from].push_back({id.at({r, c}), len});
        }
    }
    return res;
}

int longest(int node, long long seen) {
    if (node == target) return 0;
    int best = -1;
    for (auto [to, len] : adj[node]) {
        if (seen >> to & 1) continue;
        int sub = longest(to, seen | 1LL << to);
        if (sub >= 0) best = max(best, sub + len);
    }
    return best;
}

int main(int argc, char** argv) {
    ifstream in(argc > 1 ? argv[1] : "in.txt");
    string line;
    while (getline(in, line)) if (!line.empty()) g.push_back(line);
    H = g.size(); W = g[0].size();

    map<pair<int, int>, int> id;
    id[{0, (int)g[0].find('.')}] = 0;
    for (int r = 1; r < H - 1; r++)
        for (int c = 0; c < W; c++)
            if (g[r][c] != '#' && junctionCount(r, c) > 2) id[{r, c}] = id.size();
    id[{H - 1, (int)g[H - 1].find('.')}] = id.size();
    target = id.size() - 1;

    for (bool slopes : {true, false}) {
        adj = build(slopes, id);
        cout << longest(0, 1) << endl;
    }
}
