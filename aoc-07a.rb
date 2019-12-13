# allLinesStr = %{Step C must be finished before step A can begin.
# Step C must be finished before step F can begin.
# Step A must be finished before step B can begin.
# Step A must be finished before step D can begin.
# Step B must be finished before step E can begin.
# Step D must be finished before step E can begin.
# Step F must be finished before step E can begin.
# }

allLinesStr = File.read('aoc-07.in')

allLinesArr = allLinesStr.split("\n")

allLetters = {}
('A'..'Z').each do |thisLetter|
    allLetters[thisLetter] = { :to => [], :from => [] }
end
# p allLetters

# Organize all the inputs to get the to/from relationships.
allLinesArr.each do |thisLine|
    fromChar = thisLine[5]
    toChar = thisLine[36]
    # p "FROM: #{fromChar}   TO: #{toChar}"

    allLetters[fromChar][:to].push(toChar)
    allLetters[toChar][:from].push(fromChar)
end
# p allLetters
allLetters.each do |thisKey, thisVal|
    p "[#{thisKey}] => #{thisVal}"
end

# Find the starting points.
startChars = []
allLetters.each do |thisKey, thisVal|
    if allLetters[thisKey][:from].length == 0
        startChars.push(thisKey)
    end
end
# p "START: #{startChar}"

# Recursively process the letters
def printAndGoToNext(lettersNextStage, allLetters, outputLetters)
    lettersNextStage.sort!()  # Sort the next letters.
    currLetter = lettersNextStage.shift()  # Pull out the first one to process it.

    # Make sure the prereqs for the current letter are fulfilled == all the from's have been visited.
    prereqs = allLetters[currLetter][:from].sort!()
    # p "OUTPUT: #{outputLetters}    PREREQ: #{prereqs}"
    prereqsFulfilled = true
    prereqs.each do |checkMe|
        unless outputLetters.include?(checkMe)
            prereqsFulfilled = false
        end
    end

    # If the current letter's prereq's have been fulfilled, use it, otherwise skip it.
    if prereqsFulfilled
        outputLetters += currLetter

        # Add the new letters to the list of next letters. Skip duplicates.
        # lettersNextStage.concat(allLetters[currLetter][:to])
        allLetters[currLetter][:to].each do |addMe|
            unless lettersNextStage.include?(addMe)
                lettersNextStage.push(addMe)
            end
        end
        # p "CURR: #{currLetter}    TO: #{allLetters[currLetter][:to]}    NEXT: #{lettersNextStage}"
    else
        p "SKIPPING: #{currLetter}"
    end
    # print(currLetter)
    # p "CURR: #{currLetter}    TO: #{allLetters[currLetter][:to]}    NEXT: #{lettersNextStage}"

    # If there are more letters to process, recurse. Otherwise, print the results!
    if lettersNextStage.length > 0
        printAndGoToNext(lettersNextStage, allLetters, outputLetters)
    else
        puts "FINAL: #{outputLetters}"
    end

end

printAndGoToNext(startChars, allLetters, "")

# allLetters.each do |thisKey, thisLetter|
#     puts "[#{thisKey}]: #{allLetters[thisKey]}"
# end
