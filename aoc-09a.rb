# numPlayers = 9
# endMarble = 25
# numPlayers = 10
# endMarble = 1618
# numPlayers = 13
# endMarble = 7999
# numPlayers = 17
# endMarble = 1104
# numPlayers = 21
# endMarble = 6111
# numPlayers = 30
# endMarble = 5807
tokens = File.read("aoc-09.in").split(" ")
numPlayers = tokens[0].to_i
endMarble = tokens[6].to_i
# puts "PLAYERS: #{numPlayers} END: #{endMarble}"

buffer = [0]

currMarble = 1
currPos = 0

scores = Array.new(numPlayers, 0)

while currMarble <= endMarble
    # Note that player 9 has index 0!
    currPlayer = currMarble % numPlayers
    if currMarble % 23 == 0
        scores[currPlayer] += currMarble
        currPos -= 7
        currPos %= buffer.length
        removed = buffer.slice!(currPos, 1)
        scores[currPlayer] += removed[0]
    else
        currPos += 2
        currPos %= buffer.length
        # p "SPLICE: currMarble: #{currMarble} currPos: #{currPos} length: #{buffer.length}"
        if currPos == 0
            buffer.push(currMarble)
            currPos = buffer.length - 1
        else
            buffer[currPos, 0] = currMarble
        end
    end

    # print "[#{currPlayer}] "
    # buffer.each_with_index do |num, idx|
    #     if idx == currPos
    #         print "(#{num})"
    #     else
    #         print " #{num} "
    #     end
    # end
    # puts ""  # puts, instead of p, to ignore double-quotes as output

    currMarble += 1
end

# puts "#{scores}"
puts "#{scores.max}"
