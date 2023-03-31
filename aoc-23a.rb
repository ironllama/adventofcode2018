# lines = File.read('aoc-23.ex').split("\n")
lines = File.read('aoc-23.in').split("\n")

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

in_range = 0
all_nanobots.each do |k, v|
    dist = (k[0] - best_pos[0]).abs + (k[1] - best_pos[1]).abs + (k[2] - best_pos[2]).abs;
    if dist <= best_sig
        in_range += 1
    end
end

puts "TOTAL: #{in_range}"