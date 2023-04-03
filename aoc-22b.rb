# require 'matrix'  # Vectors have a small performance hit over standard array, but not too bad for this problem.
require_relative './priority_queue'

# DEBUG = true
DEBUG = false

# $depth = 510
# $target = Vector[10, 10]
# $target = [10, 10]
$depth = 7740
# $target = Vector[12, 763]
$target = [12, 763]  # Just slightly faster than Vectors

# $grid = {}  # Arrays are slow, but Hashes are VERY SLOW.
$grid = []
$grid_size = [$target[0] + 1, $target[1] + 1]

class Region
    attr_accessor :pos_x, :pos_y, :geo_idx, :ero_lvl, :type, :pri, :from
    def initialize(pos_x, pos_y)
        @pos_x = pos_x
        @pos_y = pos_y
        @geo_idx = geologic_index(pos_x, pos_y)
        @ero_lvl = erosion_level(@geo_idx)
        @type = @ero_lvl % 3

        @from = nil
    end

    def to_s
        "ROOM[#{@pos_x},#{@pos_y}] GI: #{@geo_idx} EL: #{@ero_lvl} TY: #{@type} FROM: #{@from}"
    end
    alias_method :inspect, :to_s  # For Rooms in a Hash
end

def geologic_index(x, y)
    return 0 if y == $target[1] && x == $target[0]
    return x * 16807 if y == 0
    return y * 48271 if x == 0
    # return $grid[Vector[x - 1, y]].ero_lvl * $grid[Vector[x, y - 1]].ero_lvl
    return $grid[y][x - 1].ero_lvl * $grid[y - 1][x].ero_lvl
end

def erosion_level(gi)
    return (gi + $depth) % 20183
end

# def add_row()
#     $grid.push([])

#     # $grid_size[1] += 1  # Keeping track, just like .size
#     # (0...$grid_size[0] + 800).each {|x| $grid[Vector[x, $grid_size[1] - 1]] = Region.new([x, $grid_size[1] - 1])}
#     # (0...$grid_size[0] + 800).each {|x| $grid[$grid_size[1] - 1].push(Region.new(x, $grid_size[1] - 1))}

#     # (0...$grid_size[0]).each {|x| $grid[$grid_size[1] - 1].push(Region.new(x, $grid_size[1] - 1))}

#     # grid_size_x = $grid[0].size
#     # grid_size_x = $target[0] + 1 if grid_size_x == 0  # First time it is run, there is no size on $grid[0]
#     # (0...grid_size_x).each {|x| $grid[$grid.size - 1].push(Region.new(x, $grid.size - 1))}

#     (0..$target[0] + 800).each {|x| $grid[$grid.size - 1].push(Region.new(x, $grid.size - 1))}
# end

# def add_col()
#     # $grid_size[0] += 1  # Keeping track, just like .size
#     # (0...$grid_size[1]).each {|y| $grid[Vector[$grid_size[0] - 1, y]] = Region.new([$grid_size[0] - 1, y])}
#     # (0...$grid_size[1]).each {|y| $grid[y].push(Region.new($grid_size[0] - 1, y))}

#     (0...$grid.size).each {|y| $grid[y].push(Region.new($grid[0].size - 1, y))}
# end

$region = [".", "=", "|"]

# Generate the map!
# total = 0
# $grid_size[1] = 0;  # If you use add_col/add_row
(0..$target[1] + 800).each do |y|
# (0..$target[1]).each do |y|
    # add_row();
    $grid.push([])
    (0..$target[0] + 800).each do |x|
    # (0..$t_x + 800).each do |x|
        # $grid[Vector[x, y]] = Region.new(x, y)
        # total += $grid[Vector[x, y]].type
        $grid[y].push(Region.new(x, y))
        # total += $grid[y][x].type

        # if y == 0 && x == 0 then print "M"
        # elsif y == $target[1] && x == $target[0] then print "T"
        # else print $region[$grid[[x, y]].type] end
    end
    # puts ""
end

# total = 0
# (0...$grid.size).each do |y|
#     (0...$grid[0].size).each do |x|
#         total += $grid[y][x].type
#     end
# end
# puts "TOTAL: #{total} #{$grid[0].size} #{$grid.size}"
# puts "GRID SIZE: #{$grid_size}"
# puts $grid


# Now for the pathfinding!

# DIRS = [Vector[0, 1], Vector[-1, 0], Vector[1, 0], Vector[0,-1]]  # Uses [x,y]
DIRS = [[0, 1], [-1, 0], [1, 0], [0,-1]]  # Uses [x,y]
TOOL_COMPAT = [[1, 2], [0, 1], [0, 2]]  # 0 = neither, 1 = climbing, 2 = torch

def h(c)
    # c.zip(n).map!{|u,v| (u-v).abs}.reduce(:+)  # Manhattan distance. #SLLLLOOOOWWWWW.
    (c[0] - $target[0]).abs + (c[1] - $target[1]).abs
end

# Using objects is slow. Better off just using array!
# class QState
#     include Comparable
#     attr_accessor :pri, :pos, :tool
#     def initialize(pri, pos, tool)
#         @pri = pri
#         @pos = pos
#         @tool = tool
#     end

#     def <=>(b)
#         # puts "COMPARING: #{pri} vs #{b.pri}"
#         return [pri, pos.to_a, tool] <=> [b.pri, b.pos.to_a, tool]  # Multiple for sorting AND test for existing.
#     end

#     def to_s
#         "PRI[#{@pri}] POS[#{@pos[0]},#{@pos[1]}] TOOL: #{@tool}"
#     end
#     alias_method :inspect, :to_s  # For Rooms in a Hash
# end

# Need to over-rde <= and < for arrays, since the Priority Queue uses them to get the min priority.
class Array
    def <= other
        self[0] <= other[0]
    end

    def < other
        self[0] < other[0]
    end
end


# start_pos = Vector[0, 0]
start_pos = [0, 0]
start_x = start_pos[0]
start_y = start_pos[1]

# This needs more in the state, other than just pos, since priority, tools are relevant.
openSet = PriorityQueue.new("min")
# openSet << QState.new(0, start_pos, 2)  # Using objects is slow. Better off just using array!
openSet << [0, start_pos, 2]
# openSet << [0, start_x, start_y, 2]  # Marginal performance benefit, if any.

# start = Region.new(start_pos)
# start.gScore = 0
# start.fScore = h(start_pos, $target)
# $grid[start_pos] = start

# gScore = {[start_pos, 2] => 0}  # Key with array in array is slower than just array.
# fScore = {[start_pos, 2] => h(start_pos)}
# gScore = {[start_pos[0], start_pos[1], 2] => 0}  # Key with array is slower than string.
# fScore = {[start_pos[0], start_pos[1], 2] => h(start_pos)}
# gScore = {"#{start_pos},2" => 0}  # Better than array, but slow because of array covert and format.
# fScore = {"#{start_pos},2" => h(start_pos)}
gScore = {"#{start_x},#{start_y},2" => 0}  # Best of key formats.
fScore = {"#{start_x},#{start_y},2" => h(start_pos)}

# curr = nil
while openSet.elements.size > 0
    # curr = openSet.pop  # Assuming QState object.
    # c_pri = curr.pri
    # c_pos = curr.pos
    # c_tool = curr.tool

    c_pri, c_pos, c_tool = openSet.pop  # Assuming array.

    c_x = c_pos[0]
    c_y = c_pos[1]

    # c_pri, c_x, c_y, c_tool = openSet.pop
    # c_pos = Vector[c_x, c_y]
    # c_pos = [c_x, c_y]

    # next if curr.nil?
    # c_key = [c_pos, c_tool]
    # c_key = [c_x, c_y, c_tool]
    # c_key = "#{c_pos},#{c_tool}"
    c_key = "#{c_x},#{c_y},#{c_tool}"

    # puts "LOOP[#{c_pri}] POS[#{c_pos}] TOOL[#{c_tool}] Q.SIZE[#{openSet.elements.size}]" if DEBUG
    # puts "LOOP[#{c_pri}] POS[#{(c_pos.to_a)[0]},#{(c_pos.to_a)[1]}] TOOL[#{c_tool}] Q.SIZE[#{openSet.elements.size}]"
    # puts "LOOP[" << c_pri.to_s << "] POS[" << c_x.to_s << ", " << c_y.to_s << "] TOOL[" << c_tool.to_s << "] Q.SIZE[" << openSet.elements.size.to_s << "]"

    if c_pos[0] == $target[0] && c_pos[1] == $target[1] && c_tool == 2
    # if c_x == $t_x && c_y == $t_y && c_tool == 2
        # puts "FINISHED!!! DIST[#{c_pri}] POS[#{c_pos}] TOOL#{c_tool}" if DEBUG
        # puts "FINISHED!!! DIST[#{c_pri}] POS[#{c_x}, #{c_y}] TOOL[#{c_tool}]"
        break
    end

    DIRS.each do |dir|
        # n_pos = c_pos + dir  # Assuming c_pos is a Vector.
        n_pos = [c_pos[0] + dir[0], c_pos[1] + dir[1]]
        n_x = n_pos[0]
        n_y = n_pos[1]

        # next if n_pos[0] < 0 || n_pos[1] < 0
        next if n_x < 0 || n_y < 0

        # Create neighbor, if they don't exist already...
        # Using $grid as a Hash is SSSSLLLLOOOOOOWWWWW!
        # $grid[n_pos] = Region.new(n_pos) if !$grid.key?(n_pos)
        # add_col if !$grid.key?([n_pos[0], 0])
        # add_row if !$grid.key?([0, n_pos[1]])
        # puts "\tNEIGHBOR: #{n_pos} #{$grid[n_pos]}" if DEBUG
        # add_col if !$grid.key?([n_x, 0])
        # add_row if !$grid.key?([0, n_y])
        # add_row if $grid.size <= n_y  # Doing this dynamically is slower in Ruby. (But faster in JS?!)
        # add_col if $grid[0].size <= n_x

        # Check region type against current equipment to augment distance, if required
        # Also assign correct tool to be able to move.
        new_tool = c_tool
        distance = 1
        # Using $grid as a Hash is SSSSLLLLOOOOOOWWWWW!
        # if !TOOL_COMPAT[$grid[n_pos].type].include?(c_tool)
        #     distance += 7
        #     first_tool = TOOL_COMPAT[$grid[n_pos].type][0]
        #     if (TOOL_COMPAT[$grid[c_pos].type].include?(first_tool))
        #         new_tool = first_tool
        #     else
        #         new_tool = TOOL_COMPAT[$grid[n_pos].type][1]
        #     end
        # end
        if !TOOL_COMPAT[$grid[n_y][n_x].type].include?(c_tool)
            distance += 7
            new_tool = TOOL_COMPAT[$grid[n_y][n_x].type][0]
            if !TOOL_COMPAT[$grid[c_y][c_x].type].include?(new_tool)
                new_tool = TOOL_COMPAT[$grid[n_y][n_x].type][1]
            end
        end

        # n_key = [n_pos, new_tool]
        # n_key = [n_x, n_y, new_tool]
        # n_key = "#{n_pos},#{new_tool}"
        n_key = "#{n_x},#{n_y},#{new_tool}"

        tentative_gScore = gScore[c_key] + distance;

        # puts "\tGSCORES: #{tentative_gScore} vs #{gScore[n_key]}" if DEBUG
        if !gScore.key?(n_key) || tentative_gScore < gScore[n_key]
            # $grid[n_pos].from = c_pos
            # $grid[n_pos].from = c_pos

            gScore[n_key] = tentative_gScore
            fScore[n_key] = tentative_gScore + h(n_pos)

            # new_state = QState.new(fScore[n_key], n_pos, new_tool)
            new_state = [fScore[n_key], n_pos, new_tool]
            # new_state = [fScore[n_key], n_x, n_y, new_tool]
            # new_state = [fScore[n_key], n_pos[0], n_pos[1], new_tool]
            # puts "\tADDING: #{new_state} EXISTS: #{openSet.elements.include?(new_state)}" if DEBUG
            # openSet << new_state if !openSet.elements.include?(new_state)
            openSet << new_state
        end
    end
end

# path_pos = $target
# puts "PATH:"
# while path_pos != start_pos
#     puts $grid[path_pos]
#     path_pos = $grid[path_pos].from
# end

puts "TOTAL: #{c_pri}"