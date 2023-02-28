require "matrix"

# lines = File.read("aoc-20.ex")
# lines = File.read("aoc-20.ex2")
# lines = File.read("aoc-20.ex3")
# lines = File.read("aoc-20.ex4")
lines = File.read("aoc-20.in")

MOVE_MAP = {"N" => Vector[-1, 0], "E" => Vector[0, 1], "S" => Vector[1, 0], "W" => Vector[0, -1]}

class Room
    attr_accessor :pos, :exits
    def initialize(pos)
        @pos = pos
        @exits = [nil, nil, nil, nil]  # N, E, S, W
    end
    def to_s
        "ROOM[#{@pos[0]},#{@pos[1]}] #{"N" unless @exits[0].nil?}#{"E" unless @exits[1].nil?}#{"S" unless @exits[2].nil?}#{"W" unless @exits[3].nil?}"
    end
    alias_method :inspect, :to_s  # For Rooms in a Hash
end

$map = {Vector[0,0] => Room.new(Vector[0, 0])}
$bounds = [Float::INFINITY, 0, Float::INFINITY, 0]
def add_map(new_room, from_room, from_dir)
    # Create the room, if needed.
    if $map[new_room].nil?
        $map[new_room] = Room.new(new_room)

        # If this room extends the bounds of the map.
        $bounds[0] = new_room[0] if new_room[0] < $bounds[0]
        $bounds[1] = new_room[0] if new_room[0] > $bounds[1]
        $bounds[2] = new_room[1] if new_room[1] < $bounds[2]
        $bounds[3] = new_room[1] if new_room[1] > $bounds[3]
    end

    # Link the opposing directions (eg. create the doors).
    $map[from_room].exits[MOVE_MAP.keys.index(from_dir)] = $map[new_room]
    $map[new_room].exits[(MOVE_MAP.keys.index(from_dir) + 2) % 4] = $map[from_room]
end

def process(chars, curr_room)
    # puts "PROCESS: #{chars} #{curr_room}"
    start_room = curr_room
    char_pos = 0
    while char_pos < chars.length
        char = chars[char_pos]
        char_pos += 1  # Here instead of final in loop, to catch with next.

        case char
        when "|" then
            curr_room = start_room
        when "(" then
            nest = 1
            start_pos = char_pos
            while (nest > 0 && char_pos < chars.length)
                nest_char = chars[char_pos]
                char_pos += 1
                nest += 1 if nest_char == "("
                nest -= 1 if nest_char == ")"
            end
            puts "ERROR: CAN NOT FIND END OF NESTING! #{chars[start_pos...chars.length]}" if nest > 0
            process(chars[start_pos..(char_pos - 2)], curr_room)
        when ")" then puts "ERROR: FOUND CLOSE BRACKETS ALONE!"
        else
            next_room = curr_room + MOVE_MAP[char]
            # puts "ADDING: next: #{next_room} curr: #{curr_room}, dir: #{char}"
            add_map(next_room, curr_room, char)
            curr_room = next_room
        end
    end
end

lines = lines[1...-1]  # Trim off start and end of expression.
# puts lines

process(lines, Vector[0,0])
# $map.each {|k,v| puts "#{k} => #{v}"}

single_exits = $map.select{|k,v| v.exits.compact.length == 1}
# single_exits.each {|k,v| puts "#{k} => #{v}"}

total_dists = [0]
queue = []
queue.push([0, $map[Vector[0,0]]])

distances = Hash.new
while queue.length > 0
    curr = queue.shift

    if curr[0] > 1000
        total_dists.push(curr[0])
    end

    new_dist = curr[0] + 1
    (0..3).each do |i|  # For each potential neighbor...
        next if curr[1].exits[i].nil?

        f_pos = curr[1].exits[i]
        if (distances[f_pos].nil? || new_dist < distances[f_pos])
            distances[f_pos] = new_dist
            queue.push([new_dist, f_pos])
        end
    end
end

# puts "TOTALS: #{total_dists}"
puts "FINAL: #{total_dists.length}"