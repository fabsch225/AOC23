const fs = require('fs');
const file = process.argv[2] || __dirname + '/in.txt';
let grid = fs.readFileSync(file, 'utf8').trim().split('\n').map(l => l.split(''));

const tiltNorth = g => {
  for (let c = 0; c < g[0].length; c++) {
    let free = 0;
    for (let r = 0; r < g.length; r++) {
      if (g[r][c] === '#') free = r + 1;
      else if (g[r][c] === 'O') {
        g[r][c] = '.';
        g[free++][c] = 'O';
      }
    }
  }
};

const rotate = g => g[0].map((_, c) => g.map(row => row[c]).reverse());

const load = g => g.reduce((s, row, r) => s + row.filter(x => x === 'O').length * (g.length - r), 0);

const spin = g => {
  for (let i = 0; i < 4; i++) {
    tiltNorth(g);
    g = rotate(g);
  }
  return g;
};

const first = grid.map(r => [...r]);
tiltNorth(first);
console.log(load(first));

const seen = new Map();
const loads = [];
const total = 1000000000;
for (let i = 0; i < total; i++) {
  const key = grid.map(r => r.join('')).join('\n');
  if (seen.has(key)) {
    const start = seen.get(key);
    console.log(loads[start + (total - start) % (i - start)]);
    break;
  }
  seen.set(key, i);
  loads.push(load(grid));
  grid = spin(grid);
}
