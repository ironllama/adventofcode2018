# Translated from https://www.reddit.com/r/adventofcode/comments/a8s17l/comment/ecdqzdg/?utm_source=share&utm_medium=web2x&context=3

lines = File.read('aoc-23.in').split("\n")

bots = []
lines.each do |line|
    nums = line[5..].split(">, r=")
    pos = nums[0].split(",").map(&:to_i)
    sig = nums[1].to_i

    bots.push(pos.push(sig))
end
# puts "BOTS: #{bots}"

# Get distance for each nanobot and use range to create an imaginary line from
# closest possible and furthest possible point distances (using the range).
transitions = []
bots.each do |x, y, z, r|
    d = x.abs + y.abs + z.abs
    transitions.push([[0, d - r].max, 1])  # Negatives same as positives for range.
    transitions.push([d + r + 1, -1])  # '+ 1' is optional for edge cases.
end
transitions.sort!  # Sort with closest point distance to 0,0 first.

# Finds the furthest nanobot (hence the sort, above) that is still part of the
# largest overlapping group of nanobots, and gets the closest point distance on
# that nanobot's range.
count = 0
maxCount = 0
maxD = 0
transitions.each do |d, e|
    count += e
    if count > maxCount
        maxCount = count
        maxD = d
    end
end
puts "MAX: #{maxD}"
