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
        # @attributes.each_with_object("") do |attribute, result|
        #     result << "#{attribute[1].to_s}"
        # end
        # self.inspect
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

# def melee(all_units, curr)
#     all_units.each do |curr|
#         attack_target = nil
#         all_units.each do |check|
#             next if check == curr
#             DIRS.each do |dir|
#                 if curr.pos + dir == check.pos &&
#                     curr.type != check.type &&
#                     (attack_target.nil? || check.hp < attack_target.hp)
#                         attack_target = check
#                 end
#             end
#         end

#         unless attack_target.nil?
#             attack_target.hp -= curr.attack
#         end
#     end
# end

def move(all_units)
    all_units.each do |char|
        next unless char.alive

        targets = []

        queue = []
        queue.push([1, char.pos])

        distances = Hash.new
        previous = Hash.new

        while queue.length > 0
            curr = queue.shift
            # puts "Q: #{curr[0]} POS: #{curr[1]}"
            new_round = curr[0] + 1
            next if targets.length > 0  # Skip branches if we've found targets.

            DIRS.each do |dir|  # For each potential neighbor...
                f_pos = curr[1] + dir
                # puts "\tCHECKING: #{f_pos} LINE: #{LINES[f_pos[0]][f_pos[1]]}"
                if LINES[f_pos[0]][f_pos[1]] == '.'  # Check map for wall
                    skip_add = false
                    all_units.each do |check|
                        next if check == char || !check.alive
                        if check.pos == f_pos
                            if char.type != check.type  # If enemy...
                                # targets.push([check, curr[2]])  # Using state path
                                targets.push([check, curr[0], curr[1]])  # Using previous hash
                            end
                            skip_add = true  # Can't walk through units.
                        end
                    end
                    # puts "\tSKIP CHECK: #{skip_add} PAST: #{curr[2]} EXISTS: #{curr[2].include?(f_pos)}"
                    # if !skip_add && !curr[2].include?(f_pos)
                    #     # puts "\tADDING: #{f_pos}"
                    #     new_path = Marshal.load(Marshal.dump(curr[2]))
                    #     not_queued = queue.index {|q| q[1] == f_pos}.nil?
                    #     queue.push([new_round, f_pos, new_path.push(f_pos)]) if not_queued
                    # end
                    if (!skip_add && (distances[f_pos].nil? || new_round < distances[f_pos]))
                        distances[f_pos] = new_round
                        previous[f_pos] = curr[1]
                        queue.push([new_round, f_pos])
                    end
                end
            end
        end

        targets.each_with_index do |target, i|
            # puts "#{char} #{i}: #{target[0]} PATH:#{target[1]}"
            # puts "#{char} #{i}: #{target[0]} NUM_STEPS:#{target[1]}"
        end
        if targets.length > 0
            # Move
            nearest_target = targets[0]  # Only interested in nearest enemy.
            # if nearest_target[1].length > 1  # More than 1 step away?
            #     char.pos = nearest_target[1][1]  # Step towards nearest enemy.
            # end
            if nearest_target[1] > 1  # More than 1 step away?
                next_pos = nearest_target[2]
                next_pos = previous[next_pos] while previous[next_pos] != char.pos
                # char.pos = nearest_target[1][1]  # Step towards nearest enemy.
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
                    puts "#{char} KILLS #{target[0]}"
                    target[0].hp = 0
                    target[0].alive = false
                end
            end
        else
            all_alive = all_units.select {|unit| unit.alive }
            all_elves = all_alive.select {|unit| unit.type == 'E'}
            return false if all_elves.length == 0 || all_elves.length == all_alive.length
        end
    end

    return true
end

# melee(all_units)
moves = 0
playing = true
while playing
    moves += 1
    # puts "TURN: #{moves}"

    all_units.sort_by! {|unit| unit.pos.to_a }  # Resort the units for moves
    playing = move(all_units)

    if !playing
        all_hp = all_units.sum {|u| u.hp}
        moves -= 1
        # puts "END: #{moves} * #{all_hp}"
        total_score = moves * all_hp
    end
end

# puts all_units
puts "TOTAL: #{total_score}"