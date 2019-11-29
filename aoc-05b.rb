# Standard loop instead of recursion.
def reactPolymer(inStr, currIdx)
    while (currIdx < inStr.length - 1) do
        currLetter = inStr[currIdx]
        nextLetter = inStr[currIdx + 1]
        # p ("CHECKING: CURR: #{currLetter} AND NEXT: #{nextLetter}")

        if currLetter.upcase == nextLetter.upcase  # First, check if same type.
            unless currLetter == nextLetter  # Unless same case (if different case)
                # p ("DELETING")
                inStr.slice!(currIdx, 2)
                currIdx -= 2  # Back up iterator, so that this position is rechecked.
            end
        end

        currIdx += 1
    end

    return inStr
end

# allStr = "dabAcCaCBAcCcaDA";
allStr = File.read("aoc-05.in")

shortestRemoved = ""
shortestLength = allStr.length

('A'..'Z').each do |thisType|
    newPattern = thisType + thisType.downcase
    newStr = allStr.gsub(/[#{newPattern}]/, '')
    # p "REMOVING TYPE: #{newPattern} RESULT: #{newStr}"

    newStr = reactPolymer(newStr, 0)
    # p "REACTED: #{newStr}"
    # puts "REACTED LENGTH: #{newStr.length}"

    if newStr.length < shortestLength
        shortestRemoved = thisType
        shortestLength = newStr.length
    end
end

puts "SHORTEST with #{shortestRemoved} REMOVED: #{shortestLength}"
