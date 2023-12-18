import java.nio.file.*;
import java.util.*;

public class Main {
    static int[][] g;
    static int n, m;

    static int solve(int lo, int hi) {
        int[] dr = {-1, 0, 1, 0}, dc = {0, 1, 0, -1};
        int[][][] dist = new int[n][m][2];
        for (int[][] a : dist) for (int[] b : a) Arrays.fill(b, Integer.MAX_VALUE);
        PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[0] - b[0]);
        // axis 0 = last move vertical, 1 = last move horizontal
        dist[0][0][0] = dist[0][0][1] = 0;
        pq.add(new int[]{0, 0, 0, 0});
        pq.add(new int[]{0, 0, 0, 1});
        while (!pq.isEmpty()) {
            int[] cur = pq.poll();
            int d = cur[0], r = cur[1], c = cur[2], ax = cur[3];
            if (d > dist[r][c][ax]) continue;
            if (r == n - 1 && c == m - 1) return d;
            for (int k = 0; k < 4; k++) {
                if (k % 2 == ax) continue;
                int cost = d;
                for (int s = 1; s <= hi; s++) {
                    int nr = r + dr[k] * s, nc = c + dc[k] * s;
                    if (nr < 0 || nr >= n || nc < 0 || nc >= m) break;
                    cost += g[nr][nc];
                    if (s >= lo && cost < dist[nr][nc][k % 2]) {
                        dist[nr][nc][k % 2] = cost;
                        pq.add(new int[]{cost, nr, nc, k % 2});
                    }
                }
            }
        }
        return -1;
    }

    public static void main(String[] args) throws Exception {
        Path p = args.length > 0 ? Path.of(args[0]) : Path.of(System.getProperty("user.dir"), "in.txt");
        List<String> lines = Files.readAllLines(p);
        lines.removeIf(String::isBlank);
        n = lines.size();
        m = lines.get(0).length();
        g = new int[n][m];
        for (int i = 0; i < n; i++)
            for (int j = 0; j < m; j++)
                g[i][j] = lines.get(i).charAt(j) - '0';
        System.out.println(solve(1, 3));
        System.out.println(solve(4, 10));
    }
}
