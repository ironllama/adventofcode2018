# lines = File.read('aoc-23.ex').split("\n")
# lines = File.read('aoc-23.ex2').split("\n")
lines = File.read('aoc-23.in').split("\n")


# DEBUG = true
DEBUG = false

all_nanobots = {}
best_sig = 0;
best_pos = nil;

lines.each do |line|
    nums = line[5..].split(">, r=")
    pos = nums[0].split(",").map(&:to_i)
    sig = nums[1].to_i
    # puts "NUMS: #{nums} POS: #{pos} SIG: #{sig}"

    all_nanobots[pos] = sig

    if sig > best_sig
        best_sig = sig
        best_pos = pos
    end
end

# in_range = 0
in_range = []
all_nanobots.each do |k, v|
    dist = (k[0] - best_pos[0]).abs + (k[1] - best_pos[1]).abs + (k[2] - best_pos[2]).abs;
    if dist <= best_sig
        # in_range += 1
        in_range.push([k, v])

        # Tried pre-computing the ranges. Still need the original bot point, so not great.
        # in_range.push([[[k[0] - v, k[0] + v], [k[1] - v, k[1] + v], [k[2] - v, k[2] + v]], v])
    end
end

# puts "TOTAL: #{in_range.size}"

in_range.sort!{|a, b| a[1] <=> b[1]}  # Sort by range to process shorter ranges first... ?
# puts "IN_RANGE:"
# in_range.each {|x| puts "#{x}"}

range = [[nil, nil], [nil, nil], [nil, nil]]
in_range.each do |nb|
    x_range = [nb[0][0] - nb[1], nb[0][0] + nb[1]]
    y_range = [nb[0][1] - nb[1], nb[0][1] + nb[1]]
    z_range = [nb[0][2] - nb[1], nb[0][2] + nb[1]]
    range[0][0] = x_range[0].abs if range[0][0] == nil || (x_range[0] > range[0][0])  # abs because negative same distance as positive, reduces range
    range[0][1] = x_range[1] if range[0][1] == nil || (x_range[1] < range[0][1])
    range[1][0] = y_range[0] if range[1][0] == nil || (y_range[0] > range[1][0])
    range[1][1] = y_range[1] if range[1][1] == nil || (y_range[1] < range[1][1])
    range[2][0] = z_range[0] if range[2][0] == nil || (z_range[0] > range[2][0])
    range[2][1] = z_range[1] if range[2][1] == nil || (z_range[1] < range[2][1])

    # If you've precomputed the ranges.
    # range[0][0] = nb[0][0][0] if range[0][0] == nil || (nb[0][0][0] > range[0][0])
    # range[0][1] = nb[0][0][1] if range[0][1] == nil || (nb[0][0][1] < range[0][1])
    # range[1][0] = nb[0][1][0] if range[1][0] == nil || (nb[0][1][0] > range[1][0])
    # range[1][1] = nb[0][1][1] if range[1][1] == nil || (nb[0][1][1] < range[1][1])
    # range[2][0] = nb[0][2][0] if range[2][0] == nil || (nb[0][2][0] > range[2][0])
    # range[2][1] = nb[0][2][1] if range[2][1] == nil || (nb[0][2][1] < range[2][1])
end

puts "RANGE: #{range}"

highest_num_in_range = 0
best_coords = []

# (range[2][0]..range[2][1]).each do |z|
#     puts "Z: #{z}" if z % 1000000 == 0
#     (range[1][0]..range[1][1]).each do |y|
#         puts "Z: #{z} Y: #{y}" if y % 1000000 == 0

        # z and y might already be closest to 0, with the lowest values. Assumption.
        # x is more tricky, with the negative end of the range.
        z = range[2][0]
        y = range[1][0]
        (range[0][0]..range[0][1]).each do |x|
        # (0..range[0][1]).each do |x|  # Ignore the negative end of range, since it should be the same dist as positive?
            puts "Z: #{z} Y: #{y} X: #{x}" if x % 1000000 == 0 if DEBUG
            num_in_range = 0
            in_range.each do |nb|
                dist = (x - nb[0][0]).abs
                next if dist > nb[1]
                dist += (y - nb[0][1]).abs
                next if dist > nb[1]
                dist += (z - nb[0][2]).abs;
                num_in_range += 1 if dist <= nb[1]
            end
            if num_in_range > highest_num_in_range
                highest_num_in_range = num_in_range
                best_coords = [x, y, z]
                puts "HIGHEST: #{highest_num_in_range} AT #{best_coords}" if DEBUG
            end
        end
#     end
# end

puts "BEST: #{best_coords} IN_RANGE: #{highest_num_in_range}" if DEBUG
puts "FINAL: #{best_coords.sum}"  # Takes about 45 minutes, lol. >.<