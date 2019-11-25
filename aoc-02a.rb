$matches = {}  # Each key is the number of matches and values contains the lines themselves.

def processLine(inLine)
    # p inLine

    inLineArr = inLine.strip.chars.sort_by(&:downcase)
    # p inLineArr

    numRepeat = 0
    inLineArr.each_index do |thisPos|
        # p "COMPARING: [#{inLineArr[thisPos]}] and [#{inLineArr[thisPos + 1]}]"
        if inLineArr[thisPos] == inLineArr[thisPos + 1]  # If the next letter is the same as this one...
            numRepeat += 1
        else  # The next letter is not the same.
            if numRepeat > 0  # If there were repeating characters...
                # numKey = numRepeat.to_sym  # Using symbols in the hash for efficiency.
                numKey = numRepeat + 1  # Since it's just an integer, not much gains in efficiency using symbols?
                # p "REPEAT: #{inLineArr[thisPos]} x #{numKey}"

                if $matches.key?(numKey)  # Matches stores how many of each number of matches exists.
                    unless $matches[numKey].include?(inLineArr)
                        $matches[numKey].push(inLineArr)
                    end
                else
                    $matches[numKey] = [inLineArr] 
                end

                numRepeat = 0  # Reset the count of repeating characters.
            end
        end
    end
end

# testString = %{ abcdef
#     bababc
#     abbcde
#     abcccd
#     aabcdd
#     abcdee
#     ababab
# }

# testString.each_line do |line|
#     processLine(line)
# end

File.foreach("aoc-02.in") do |line|
    processLine(line)
end

# p $matches

total = 1;
$matches.each do |thisKey, thisValue|
    p thisKey.to_s + ": " + thisValue.length.to_s
    total *= thisValue.length
end
print "CHECKSUM: " + total.to_s