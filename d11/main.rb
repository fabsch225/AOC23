grid = File.readlines(ARGV[0] || File.join(__dir__, 'in.txt')).map(&:chomp)

galaxies = []
grid.each_with_index do |row, y|
  row.each_char.with_index { |c, x| galaxies << [y, x] if c == '#' }
end

empty_rows = (0...grid.size).reject { |y| galaxies.any? { |g| g[0] == y } }
empty_cols = (0...grid[0].size).reject { |x| galaxies.any? { |g| g[1] == x } }

def total(galaxies, empty_rows, empty_cols, factor)
  pos = galaxies.map do |y, x|
    [y + empty_rows.count { |r| r < y } * (factor - 1),
     x + empty_cols.count { |c| c < x } * (factor - 1)]
  end
  pos.combination(2).sum { |a, b| (a[0] - b[0]).abs + (a[1] - b[1]).abs }
end

puts total(galaxies, empty_rows, empty_cols, 2)
puts total(galaxies, empty_rows, empty_cols, 1_000_000)
