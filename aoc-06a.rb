# allStr = %{1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
# }

allStr = File.read("aoc-06.in")

allArr = allStr.split("\n")

lowest_x = -1
lowest_y = -1
highest_x = -1
highest_y = -1

# Find the boundaries...
allArr.each do |thisXy|
    xyArr = thisXy.split(", ").map!(&:to_i)
    # p xyArr.join("|")

    if lowest_x == -1 || xyArr[0] < lowest_x
        lowest_x = xyArr[0]
    end
    if highest_x == -1 || xyArr[1] > highest_x
        highest_x = xyArr[1]
    end
    if lowest_y == -1 || xyArr[0] < lowest_y
        lowest_y = xyArr[0]
    end
    if highest_y == -1 || xyArr[1] > highest_y
        highest_y = xyArr[1]
    end
end
# p "TOP LEFT: #{lowest_x}, #{lowest_y}   BOTTOM RIGHT: #{highest_x}, #{highest_y}"

allCounts = Array.new(allArr.length, 0)  # Array of number of coordinates that are shortest distance from each point.

# (lowest_x..highest_x).each do |this_x|
#     (lowest_y..highest_y).each do |this_y|
(lowest_y..highest_y).each do |this_y|
    (lowest_x..highest_x).each do |this_x|
        # distancesFromEachPoint = Array.new(allArr.length)

        # Skip to next if the coordinates are actually just one of the points.
        # checkStr = "#{this_x}, #{this_y}"
        # next if allArr.include?(checkStr)

        distancesFromEachPoint = []
        allArr.each_with_index do |thisXy, idx|
            xyArr = thisXy.split(", ").map!(&:to_i)

            thisDistance = (this_x - xyArr[0]).abs + (this_y - xyArr[1]).abs
            # p "DISTANCE: #{thisDistance}"
            # distancesFromEachPoint[idx] = thisDistance
            distancesFromEachPoint.push([idx, thisDistance])
        end
        # shortest = distancesFromEachPoint.index(distancesFromEachPoint.min)  # Not good if more than one.
        # p "distancesFromEachPoint: #{distancesFromEachPoint}" if this_y == 1
        distancesFromEachPoint = distancesFromEachPoint.sort_by { |val| val[1] }
        # p "SORTED: distancesFromEachPoint: #{distancesFromEachPoint}" if this_y == 1
        shortestIdx = distancesFromEachPoint[0][0]
        shortestAmt = distancesFromEachPoint[0][1]
        # p "SHORTEST: #{distancesFromEachPoint[0]} NEXT: #{distancesFromEachPoint[1]}"
        if distancesFromEachPoint[1][1] != shortestAmt  # Make sure the shortest distance from only one point, not two or more.
            allCounts[shortestIdx] += 1  # Increment the number of coordinates that are closest to this point.

            # if allArr.include?("#{this_x}, #{this_y}")
            #     print "\t" + ('A'..'Z').to_a[shortestIdx]
            # else
            #     print "\t" + ('a'..'z').to_a[shortestIdx]
            # end
        else
            # print "\t."
        end
    end
    # print "\n"
end

# Remove those that are part of or touching the boundary
# p "BEFORE allArr: #{allArr}"
# allArr = allArr.select do |thisXy|
allArr.each_with_index do |thisXy, idx|
    xyArr = thisXy.split(", ").map!(&:to_i)
    if xyArr[0] == lowest_x || xyArr[0] == highest_x || xyArr[1] == lowest_y || xyArr[1] == highest_y
        allCounts[idx] = 0
    end
end
# p "AFTER allArr: #{allArr}"

p allCounts
p "INDEX: #{allCounts.index(allCounts.max)} #XY: #{allArr[allCounts.index(allCounts.max)]} MAX: #{allCounts.max}"