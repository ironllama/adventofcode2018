# Tried turning on tail call recursion, but still doesn't seem to work.
# RubyVM::InstructionSequence.compile_option = {
#   tailcall_optimization: true,
#   trace_instruction: false
# }

# Recursive -- doesn't work for strings that are too long. No tail recursion?
# def reactPolymer(inStr, currIdx)
#     if currIdx == inStr.length - 1  # Check to see if we've made it to the end!
#         return inStr
#     end

#     currLetter = inStr[currIdx]
#     nextLetter = inStr[currIdx + 1]
#     # p ("CHECKING: CURR: #{currLetter} AND NEXT: #{nextLetter}")

#     if currLetter.upcase == nextLetter.upcase  # First, check if same type.
#         unless currLetter == nextLetter  # Unless same case (if different case)
#             # p ("DELETING")
#             inStr.slice!(currIdx, 2)
#             currIdx -= 2  # Back up iterator, so that this position is rechecked.
#         end
#     end

#     return reactPolymer(inStr, currIdx + 1)  # Process the next letter
# end

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

newStr = reactPolymer(allStr, 0)
p "FINAL: #{newStr}"
puts "FINAL LENGTH: #{newStr.length}"