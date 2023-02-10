# line = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2";
line = File.read("aoc-08.in");

$tokens = line.split(" ").map { |t| t.to_i }
$totalMeta = 0

def processChild(pos)
    currNumChild = $tokens[pos]
    currNumMeta = $tokens[pos + 1]
    # p "pos: #{pos} numChild: #{currNumChild} currNumMeta #{currNumMeta} total: #{$totalMeta}"

    pos += 2  # Get past the header

    for child in 1..currNumChild  # Process any children
        pos = processChild(pos)
    end

    for meta in 1..currNumMeta  # Process trailing meta info
        $totalMeta += $tokens[pos]
        pos += 1
    end

    return pos
end

processChild(0)
p "TOTAL: #{$totalMeta}"