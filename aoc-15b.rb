require "matrix"

# LINES = File.read('aoc-15.ex').split("\n")
# LINES = File.read('aoc-15.ex2').split("\n")
# LINES = File.read('aoc-15.ex3').split("\n")
# LINES = File.read('aoc-15.ex4').split("\n")
# LINES = File.read('aoc-15.ex5').split("\n")
# LINES = File.read('aoc-15.ex6').split("\n")
LINES = File.read('aoc-15.in').split("\n")
DIRS = [Vector[-1,0], Vector[0,-1], Vector[0,1], Vector[1,0]]  # Use [row,col]

class Unit
    START_HP = 200
    ATTACK = 3
    attr_accessor :type, :hp, :pos, :attack, :alive
    def initialize(type, y, x)
        @type = type
        @hp = START_HP
        @pos = Vector[y,x]
        @attack = ATTACK
        @alive = true
    end

    def to_s
        "UNIT:#{@type} HP:#{@hp} POS:#{@pos}"
    end
end

# Remove players from map and collect player metadata.
all_units = []
LINES.each_with_index do |line, row|
    (0...line.length).each do |col|
        if LINES[row][col] == 'E' or LINES[row][col] == 'G'
            all_units.push(Unit.new(LINES[row][col], row, col))
            LINES[row][col] = '.'
        end
    end
end
# puts LINES
# puts all_units

def print_map(all_units)
    new_lines = Marshal.load(Marshal.dump(LINES))
    all_units.each {|u| new_lines[u.pos[0]][u.pos[1]] = u.type if u.alive}
    puts new_lines
end

def move(all_units)
    # old_units = Marshal.load(Marshal.dump(all_units))
    all_units.each do |char|
        next unless char.alive

        distances = Hash.new
        previous = Hash.new

        queue = []
        queue.push([1, char.pos])
        distances[char.pos] = 0

        found_level = Float::INFINITY

        targets = []
        DIRS.each do |dir|
            f_pos = char.pos + dir
            all_units.each do |check|
                next if check == char || !check.alive
                # puts "TEST: C:#{char.pos} K:#{check.pos} F:#{f_pos}"
                if check.pos == f_pos && char.type != check.type
                    # puts "NON_MOVE: C:#{char.pos} ADDING: 0 :#{char.pos}"
                    targets.push([check, 0, char.pos])
                    found_level = 0
                end
            end
        end

        while queue.length > 0 && found_level > 0
            curr = queue.shift
            # puts "Q: #{curr[0]} POS: #{curr[1]}"
            # next if targets.length > 0  # Skip branches if we've found targets.
            next if curr[0] > found_level

            DIRS.each do |dir|  # For each potential neighbor...
                f_pos = curr[1] + dir
                # puts "\tCHECKING: #{f_pos} LINE: #{LINES[f_pos[0]][f_pos[1]]}"
                if LINES[f_pos[0]][f_pos[1]] == '.'  # Check map for wall
                    skip_add = false
                    all_units.each do |check|
                        next if check == char || !check.alive
                        if check.pos == f_pos
                            if char.type != check.type  # If enemy...
                                # puts "C:#{char.pos} ADDING: #{curr[0]}:#{curr[1]}"
                                targets.push([check, curr[0], curr[1]])  # Using previous hash
                                found_level = curr[0]
                            end
                            skip_add = true  # Can't walk through units.
                        end
                    end
                    # alt = 1 + distances[curr[1]]
                    # puts "ALT: #{alt}"
                    # if (!skip_add && (distances[f_pos].nil? || alt < distances[f_pos]))
                    #     distances[f_pos] = alt
                    #     previous[f_pos] = curr[1]
                    #     queue.push([alt, f_pos])
                    # end
                    new_round = curr[0] + 1
                    if (!skip_add && (distances[f_pos].nil? || new_round < distances[f_pos]))
                        distances[f_pos] = new_round
                        previous[f_pos] = curr[1]
                        queue.push([new_round, f_pos])
                        # queue.push([new_round, f_pos]) if queue.index([new_round, f_pos]).nil?
                    end
                end
            end
        end

        if targets.length > 0
            # Sort
            targets.sort_by!{|t| t[2].to_a}
            # if char.pos == Vector[10,12]
            #     puts "C:#{char.pos} D:#{targets.map {|t| t[1]}} T:#{targets.map {|t| t[0].to_s}} P:#{targets.map {|t| t[2]}}"
            # end

            # Move
            nearest_target = targets[0]  # Only interested in nearest enemy.
            if nearest_target[1] > 1  # More than 1 step away?
                next_pos = nearest_target[2]
                next_pos = previous[next_pos] while previous[next_pos] != char.pos
                # puts "#{char} GOES TO #{next_pos}"
                char.pos = next_pos  # Step towards nearest enemy.
            end

            d_to_closest = (nearest_target[0].pos - char.pos).to_a.collect!{|v| v.abs}.sum
            # puts "\tC:#{char} T:#{nearest_target[0]} D_TO_T: #{d_to_closest}"
            if d_to_closest == 1  # In melee range!
                targets_by_hp = targets.select {|t| (t[0].pos - char.pos).to_a.collect!{|t| t.abs}.sum == 1}.sort_by {|t| t[0].hp}
                target = targets_by_hp[0]  # Lowest hp in melee range.
                target[0].hp -= char.attack
                # puts "#{char} HITS #{target[0]}"

                if target[0].hp <= 0
                    # puts "#{char} KILLS #{target[0]}"
                    target[0].hp = 0
                    target[0].alive = false
                    return 2 if target[0].type == 'E'
                end
            end
        else
            all_alive = all_units.select {|unit| unit.alive }
            all_elves = all_alive.select {|unit| unit.type == 'E'}
            return 1 if all_elves.length == 0 || all_elves.length == all_alive.length
        end
    end

    return 0
end

winning = false
elf_attack = 4
until winning
    # puts "NEW ATTACK: #{elf_attack}"
    new_units = Marshal.load(Marshal.dump(all_units))  # New copy!
    new_units.each{|u| u.attack = elf_attack if u.type == 'E'}

    moves = 0
    playing = 0
    while playing == 0
        moves += 1
        # puts "TURN: #{moves}"

        new_units.sort_by! {|unit| unit.pos.to_a }  # Resort the units for moves
        playing = move(new_units)

        if playing == 1  # Elves did not die!
            all_hp = new_units.sum {|u| u.hp}
            moves -= 1
            total_score = moves * all_hp
            winning = true

            puts "END: #{moves} * #{all_hp}"
            # puts new_units
        end

        # Print out progress
        # puts new_units
        # print_map(new_units)
        # puts ""
    end

    elf_attack += 1
end

puts "TOTAL: #{total_score}"