# allLineString = %[#1 @ 1,3: 4x4
# #2 @ 3,1: 4x4
# #3 @ 5,5: 2x2
# ]
# allLinesArr = allLineString.split("\n")

allLinesArr = File.read('aoc-03.in').split("\n")
# p allLinesArr

oneDimension = 1000

# wholeFabric = Array.new(oneDimension, Array.new(oneDimension, 0));  # Every inner array is a reference to the same array. Ugh
wholeFabric = Array.new(oneDimension) { Array.new(oneDimension, 0) }
# wholeFabric.each { |thisArr| p thisArr.object_id }  # Check to be sure we're not just using the same empty array everywhere.

overlap = 0

allLinesArr.each do |thisLine|
    allTokens = thisLine.split(" ")
    startPointArr = allTokens[2].chomp(":").split(",").map!(&:to_i)
    lengthsArr = allTokens[3].split("x").map!(&:to_i)

    (startPointArr[0]..(startPointArr[0] + lengthsArr[0] - 1)).each.with_index do |value_x, idx_x|
        (startPointArr[1]..(startPointArr[1] + lengthsArr[1] - 1)).each_with_index do |value_y, idx_y|
            # p "X: #{value_x} Y: #{value_y} CURR: #{wholeFabric[value_x][value_y]}"
            wholeFabric[value_x][value_y] += 1
            overlap += 1 if wholeFabric[value_x][value_y] == 2
        end
    end

    # wholeFabric.each { |thisArr| p thisArr.join }  # Checking progress
end

allLinesArr.each do |thisLine|
    allTokens = thisLine.split(" ")
    startPointArr = allTokens[2].chomp(":").split(",").map!(&:to_i)  # The & calls to_proc on the symbol(:) identified as to_i
    lengthsArr = allTokens[3].split("x").map!(&:to_i)

    noOverlap = true

    (startPointArr[0]..(startPointArr[0] + lengthsArr[0] - 1)).each.with_index do |value_x, idx_x|
        (startPointArr[1]..(startPointArr[1] + lengthsArr[1] - 1)).each_with_index do |value_y, idx_y|
            # p "X: #{value_x} Y: #{value_y} CURR: #{wholeFabric[value_x][value_y]}"
            if wholeFabric[value_x][value_y] > 1
                noOverlap = false
                break
            end
        end

        if noOverlap == false
            break
        end
    end 

    if noOverlap
        puts "NO OVERLAP: #{thisLine}"
        break
    end
end


# wholeFabric.each { |thisArr| p thisArr.join }
# puts "OVERLAP: #{overlap}"