def dirs: {R: [1, 0], D: [0, 1], L: [-1, 0], U: [0, -1]};

def lagoon:
  reduce .[] as [$d, $n] ({x: 0, y: 0, area: 0, edge: 0};
    (dirs[$d]) as [$dx, $dy]
    | .x as $x | .y as $y
    | .x += $dx * $n | .y += $dy * $n
    | .area += $x * .y - $y * .x
    | .edge += $n)
  | (.area | fabs) / 2 + .edge / 2 + 1;

[inputs | split(" ")] as $plan
| ($plan | map([.[0], (.[1] | tonumber)]) | lagoon),
  ($plan | map(.[2] | ltrimstr("(#") | rtrimstr(")")
      | [({"0": "R", "1": "D", "2": "L", "3": "U"}[.[5:]]),
         (.[:5] | explode | map(if . > 57 then . - 87 else . - 48 end) | reduce .[] as $h (0; . * 16 + $h))])
    | lagoon)
