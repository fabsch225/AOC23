args = argv();
if numel(args) > 0
  fn = args{1};
else
  fn = fullfile(fileparts(mfilename('fullpath')), 'in.txt');
end
g = strsplit(strtrim(fileread(fn)), "\n");
g = char(g);
n = rows(g);
[sr, sc] = find(g == 'S');
open = repmat(g ~= '#', 5, 5);
cur = false(size(open));
cur(2*n + sr, 2*n + sc) = true;

target = 26501365;
half = mod(target, n);
ys = [];
for i = 1:half + 2*n
  nxt = zeros(size(cur), 'logical');
  nxt(1:end-1, :) = cur(2:end, :);
  nxt(2:end, :) = nxt(2:end, :) | cur(1:end-1, :);
  nxt(:, 1:end-1) = nxt(:, 1:end-1) | cur(:, 2:end);
  nxt(:, 2:end) = nxt(:, 2:end) | cur(:, 1:end-1);
  cur = nxt & open;
  if i == 64
    p1 = nnz(cur);
  end
  if any(i == half + n * (0:2))
    ys(end+1) = nnz(cur);
  end
end

k = (target - half) / n;
d1 = ys(2) - ys(1);
d2 = ys(3) - 2*ys(2) + ys(1);
p2 = ys(1) + d1*k + d2*k*(k-1)/2;
printf("%d\n%d\n", p1, p2);
