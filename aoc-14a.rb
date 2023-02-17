$board = []
$board.push(3)
$board.push(7)
$elf1 = 0
$elf2 = 1

def hot_chocolate(num)
    # i = 0
    while $board.length < (num + 10)
        # puts "LOOP: #{i += 1} LEN: #{$board.length}"
        # Add new recipes
        new_recipe = $board[$elf1] + $board[$elf2]
        if new_recipe >= 10
            $board.push(1)
            new_recipe %= 10
        end
        $board.push(new_recipe)

        # Move elves
        $elf1 = ($elf1 + $board[$elf1] + 1) % $board.length
        $elf2 = ($elf2 + $board[$elf2] + 1) % $board.length

        # puts $board.join(" ")
    end

    # Print out the 10 recipes.
    puts $board[num, 10].join()
end

# hot_chocolate(9)
# hot_chocolate(5)
# hot_chocolate(18)
# hot_chocolate(2018)
hot_chocolate(635041)




# SSSLLLLOOOOOWWWW
# require_relative "./circular_linked_list.rb"
# $board = CircularList.new
# $elf1 = $board.insert_end(3)
# $elf2 = $board.insert_end(7)

# def hot_chocolate(num)
#     i = 0
#     while $board.length < (num + 10)
#         puts "LOOP: #{i += 1} LEN: #{$board.length}"
#         # Add new recipes
#         new_recipe = $elf1.data + $elf2.data
#         if new_recipe >= 10
#             $board.insert_end(1)
#         end
#         new_recipe %= 10
#         $board.insert_end(new_recipe)

#         # Move elves
#         ($elf1.data + 1).times { $elf1 = $elf1.next }
#         ($elf2.data + 1).times { $elf2 = $elf2.next }

#         # $board.print_list
#     end

#     # Print out the 10 recipes.
#     ptr = $board.head
#     num.times { ptr = ptr.next }
#     10.times { print ptr.data; ptr = ptr.next }
#     puts ""
# end