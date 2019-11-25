$currentNum = 0
$seenNums = Array.new
$notfound = true

def processLine(inLine)
    inLine = inLine.strip
    return if inLine == nil || inLine == ''

    thisNum = inLine[1..-1].to_i

    if inLine[0] == '+'
        $currentNum += thisNum
    else
        $currentNum -= thisNum
    end

    # puts $currentNum  # Progress so far...

    # Check if number has been seen before? If not, add it to the list and continue. Otherwise, print it out and stop.
    if $seenNums.include? $currentNum
        # puts $currentNum
        $notfound = false
    else
        $seenNums.push($currentNum)
    end

    # p "LINE: [#{inLine}] CURR: [#{$currentNum}] SEEN: [#{$seenNums}]"
end

# Test data
# testString = %{
# +3
# +3
# +4
# -2
# -4
# }
# testString = %{
#     +7
#     +7
#     -2
#     -7
#     -4
# }

while $notfound do
    # testString.each_line do |line|
    #     processLine(line)
    #     if $notfound == false
    #         break
    #     end
    # end

    File.foreach("aoc-01.in") {  # Read file one line at a time.
        # |line| puts line
        |line| processLine(line)
        if $notfound == false
            break
        end
    }
end

p "DUP: #{$currentNum}"