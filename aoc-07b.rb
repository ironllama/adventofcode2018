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

allLetters.each do |thisLetter, thisValue|
    thisValue[:to].sort!()
    thisValue[:from].sort!()
end

# p allLetters
# allLetters.each do |thisKey, thisVal|
#     p "[#{thisKey}] => #{thisVal}"
# end

# Find the starting points.
lettersNextStage = []
allLetters.each do |thisKey, thisVal|
    if allLetters[thisKey][:from].length == 0 && allLetters[thisKey][:to].length != 0
        lettersNextStage.push(thisKey)
    end
end
# p "START: #{lettersNextStage}"


# allOrderLen = 6
# num_workers = 2
# sec_offset = 0

allOrderLen = 26
num_workers = 5
sec_offset = 60

alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
totalSeconds = 0
outputLetters = ""

class Worker
    attr_accessor :letter, :currTick, :name

    def initialize(inName)
        @name = inName
        @letter = "."
        @currTick = 0
    end
end
allWorkers = Array.new(num_workers) { |i| Worker.new(i) }

# allOrderLen = order.length
while outputLetters.length != allOrderLen do

    # # Print current status.
    # print "BEGIN SEC: #{totalSeconds}\t"
    # allWorkers.each do |thisWorker|
    #     print "#{thisWorker.letter}\t"
    # end
    # print "[#{outputLetters}]\n"

    # Complete work for each worker.
    allWorkers.each do |thisWorker|
        if thisWorker.currTick == 0  # If this worker is free...
            #If the worker just finished a letter, add it to the finished outputs.
            if thisWorker.letter != "."
                outputLetters = outputLetters + thisWorker.letter
                thisWorker.letter = "."
            end
        end
    end

    # Assign work, if possible, to all the workers.
    allWorkers.each do |thisWorker|
        # p "CHECKING: [#{thisWorker.name}] #{thisWorker.letter}:#{thisWorker.currTick} NEXT:#{lettersNextStage} OUTPUT:#{outputLetters}"
        if thisWorker.currTick == 0  # If this worker is free...
            # If there are more letters to work on...
            if lettersNextStage.length > 0
                # Get the next available letter that has fulfilled priors.
                lettersNextStage.each do |currLetter|
                    prereqsFulfilled = true
                    allLetters[currLetter][:from].each do |checkMe|
                        unless outputLetters.include?(checkMe)
                            prereqsFulfilled = false
                            # p "UNFULFILLED: #{checkMe} vs OUTPUT:#{outputLetters}"
                            break
                        end
                    end

                    # If the current letter's prereq's have been fulfilled, use it, otherwise skip it.
                    if prereqsFulfilled
                        # Remove it from the available letters list.
                        # p "PULL AVAILABLE: #{currLetter}"
                        lettersNextStage.delete(currLetter)

                        # Add the new to letters to the list of next letters. Skip duplicates.
                        allLetters[currLetter][:to].each do |addMe|
                            unless lettersNextStage.include?(addMe)
                                lettersNextStage.push(addMe)
                            end
                        end
                        lettersNextStage.sort!()  # Sort the list of next letters.
                        # p "CURR: #{currLetter}    TO: #{allLetters[currLetter][:to]}    NEXT: #{lettersNextStage}"

                        thisWorker.letter = currLetter
                        thisWorker.currTick = alpha.index(currLetter) + sec_offset
                        break  # Found letter, so break out of finding letters.
                    # else
                    #     p "SKIPPING: #{currLetter}"
                    end
                end
            else
                next  # If no more letters to work on, go to next worker.
            end
        else
            # If the worker is still working on something, advance their work timer.
            thisWorker.currTick -= 1
        end
    end

    # End of second.
    totalSeconds += 1
end

p totalSeconds - 1
