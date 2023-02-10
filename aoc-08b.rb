# line = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2";
line = File.read("aoc-08.in");

$tokens = line.split(" ").map { |t| t.to_i }
$totalMeta = 0

def processChild(pos)
    numChild = $tokens[pos]
    numMeta = $tokens[pos + 1]
    # p "pos: #{pos} numChild: #{numChild} numMeta #{numMeta} total: #{$totalMeta}"

    pos += 2  # Get past the header
    totalValue = 0

    if numChild > 0
        childValues = []
        for child in 1..numChild  # Process any children
            pos, value = processChild(pos)
            childValues.push(value);
        end
        for meta in 1..numMeta  # Process trailing meta info
            childValuePos = $tokens[pos] - 1
            totalValue += childValues[childValuePos] if childValuePos <= childValues.length - 1
            # p "CHILDREN: #{childValues} childValuePos:#{childValuePos} value: #{value}"
            pos += 1
        end
    else
        for meta in 1..numMeta  # Process trailing meta info
            totalValue += $tokens[pos]
            # p "CHILDREN: #{childValues} token:#{$tokens[pos]} value: #{value}"
            pos += 1
        end
    end

    return pos, totalValue
end

pos, value = processChild(0)
p "TOTAL: #{value}"