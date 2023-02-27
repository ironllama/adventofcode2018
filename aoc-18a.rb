require "matrix"

# lines = File.read("aoc-18.ex").split("\n")
lines = File.read("aoc-18.in").split("\n")

NEIGHBORS = [Vector[-1, 0], Vector[-1, 1], Vector[0, 1], Vector[1, 1], Vector[1, 0], Vector[1, -1], Vector[0, -1], Vector[-1, -1]]
def change(lines)
    new_lines = Marshal.load(Marshal.dump(lines))

    lines.each_with_index do |line, row|
        # line.each_with_index do |acre, col|
        (0...line.length).each do |col|
            neighbors_sym = []
            NEIGHBORS.each do |neighbor|
                neighbor_pos = Vector.elements([row, col]) + neighbor
                next unless neighbor_pos[0] >= 0 && neighbor_pos[0] < lines.length && neighbor_pos[1] >= 0 && neighbor_pos[1] < line.length

                neighbors_sym.push(lines[neighbor_pos[0]][neighbor_pos[1]])  # Have to use lines instead of new_lines for simultaneous changes.
            end

            # puts "CHECKING: [#{row}, #{col}]: #{line[col]} N: #{neighbors_sym}"
            case line[col]
            when "."
                new_lines[row][col] = "|" if neighbors_sym.select {|x| x == "|"}.length >= 3
            when "|"
                new_lines[row][col] = "#" if neighbors_sym.select {|x| x == "#"}.length >= 3
            when "#"
                lumberyard = false
                trees = false
                neighbors_sym.each do |n|
                    lumberyard = true if n == "#"
                    trees = true if n == "|"
                end
                new_lines[row][col] = "." if !lumberyard || !trees
            end
        end
    end

    return new_lines
end

(1..10).each do |i|
    lines = change(lines)
end
# puts ""
# lines.each {|line| puts line }

lumberyards = 0
woods = 0
lines.each do |line|
    (0...line.length).each do |col|
        woods += 1 if line[col] == "|"
        lumberyards += 1 if line[col] == "#"
    end
end
puts "TOTAL: #{woods * lumberyards}"