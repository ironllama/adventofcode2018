# allStr = %{1, 1
# 1, 6
# 8, 3
# 3, 4
# 5, 5
# 8, 9
# }
# limit = 32

allStr = File.read("aoc-06.in")
limit = 10000

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

# allCounts = Array.new(allArr.length, 0)  # Array of number of coordinates that are shortest distance from each point.
numInRegion = 0

(lowest_y..highest_y).each do |this_y|
    (lowest_x..highest_x).each do |this_x|

        distancesFromEachPoint = []
        distancesFromAllOthers = 0
        allArr.each_with_index do |thisXy, idx|
            xyArr = thisXy.split(", ").map!(&:to_i)

            thisDistance = (this_x - xyArr[0]).abs + (this_y - xyArr[1]).abs
            # p "DISTANCE: #{thisDistance}"
            distancesFromAllOthers += thisDistance
        end

        if distancesFromAllOthers < limit  # Make sure the shortest distance from only one point, not two or more.
            numInRegion += 1

            # if allArr.include?("#{this_x}, #{this_y}")
            #     print "\t" + ('A'..'Z').to_a[allArr.index("#{this_x}, #{this_y}")]
            # else
            #     print "\t#"
            # end
        else
            # print "\t."
        end
    end
    # print "\n"
end

puts "REGION SIZE: #{numInRegion}"