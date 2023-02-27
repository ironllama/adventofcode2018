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

start = Time.now
history = []
(1..1000).each do |i|
    lines = change(lines)

    # puts "GEN: #{i} DIFF: #{Time.now - start} TIME: #{Time.now.strftime("%H:%M:%S")}"
    # lines.each {|line| puts line }

    # roffset = history.rindex(lines)
    offset = history.index(lines)
    unless offset.nil?
        # puts "REP: #{i} PREV: #{offset}"
        series_total =  i - offset - 1;  # Total number of items in repeating series.

        series_idx = (1000000000 - offset) % series_total
        # series_idx = (500 - offset) % series_total  # REP: 500 PREV: 471 TOTAL: 177784
        # series_idx = (1000 - offset) % series_total  #REP: 1000 PREV: 467 TOTAL: 174584
        # series_idx = (i - offset) % series_total - 1 #REP: 1000 PREV: 467 TOTAL: 174584
        # puts "I: #{i} OFF: #{offset} T: #{series_total} IDX: #{series_idx}"

        lumberyards = 0
        woods = 0
        history[offset + series_idx - 1].each do |line|
            (0...line.length).each do |col|
                woods += 1 if line[col] == "|"
                lumberyards += 1 if line[col] == "#"
            end
        end

        puts "I: #{i} TOTAL: #{woods * lumberyards}"
        break
    end
    history.push(lines)
end