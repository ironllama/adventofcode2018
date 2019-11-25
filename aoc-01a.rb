$currentNum = 0

def processLine(inLine)
    thisNum = inLine[1..-1].to_i

    if inLine[0] == '+'
        $currentNum += thisNum
    else
        $currentNum -= thisNum
    end

    # puts $currentNum  # Progress so far...
end


#Using heredoc
# testString = <<AOC_INPUT
# +1
# -2
# +3
# +1
# AOC_INPUT

#Using Percent Strings
# testString = %{
# +1
# -2
# +3
# +1
# }

# testString.each_line do |line|
#     processLine(line)
# end

#file_data = File.read("user.txt").split  # Read each line into an array.
File.foreach("aoc-01.in") {  # Read file one line at a time.
    # |line| puts line
    |line| processLine(line)
}

puts $currentNum