allLinesArr = File.read("aoc-02.in").split  # Read each line into an array. Also takes care of open/close.
# p file_data

# allLinesStr = %[abcde
# fghij
# klmno
# pqrst
# fguij
# axcye
# wvxyz
# ]
# allLinesArr = allLinesStr.split("\n")

common = ""

while allLinesArr.length > 0 && common == "" do
    baseLineChars = allLinesArr.shift.chars

    allLinesArr.each do |checkLine|
        # p "BASELINE: #{baseLineChars.join}  CHECKLINE: #{checkLine}"

        checkLineChars = checkLine.chars
        diff = 0;
        diffPos = 0;

        baseLineChars.each_index do |thisIdx|
            baseChar = baseLineChars[thisIdx]
            checkChar = checkLineChars[thisIdx]
            # p "BASE: #{baseChar} CHECK: #{checkChar}"

            if baseChar != checkChar
                diff +=1
                diffPos = thisIdx
            end

            break if diff > 1
        end

        if diff == 1
            baseLineChars.slice!(diffPos, 1)
            common = baseLineChars.join
            break
        end
    end
end

puts "COMMON: #{common}"