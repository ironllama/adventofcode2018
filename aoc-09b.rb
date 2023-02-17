require_relative "./circular_linked_list.rb"

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
# endMarble = tokens[6].to_i
endMarble = tokens[6].to_i * 100
# puts "PLAYERS: #{numPlayers} END: #{endMarble}"

# buffer = [0]  # ~1.5h
buffer = CircularList.new  # 5s
buffer.insert_end(0)

currMarble = 1
currPos = 0

scores = Array.new(numPlayers, 0)


while currMarble <= endMarble
    # Note that player 9 has index 0!
    currPlayer = currMarble % numPlayers
    if currMarble % 23 == 0
        7.times do
            buffer.move_prev
        end
        removed = buffer.remove(buffer.current)
        scores[currPlayer] += removed.data + currMarble
    else
        2.times do
            buffer.move_next
        end
        buffer.insert_current(currMarble)
    end

    # print "[#{currPlayer}] "
    # buffer.print_with_current

    currMarble += 1
end

# puts "#{scores}"
puts "#{scores.max}"
