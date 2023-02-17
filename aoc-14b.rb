def hot_chocolate(num_str)
    # Large arrays are SSSSLLLLLOOOOWWWW w/ Ruby. GGGAAAAHHHHH! Use strings.
    # board = [3, 7]
    board = "37"
    elf1 = 0
    elf2 = 1

    # i = 0
    loop do
        # puts "LOOP: #{i} LEN: #{board.length}" if (i += 1) % 1000 == 0
        # if (i % 100000 == 0) then break end;

        # Add new recipes
        new_recipe = (board[elf1].to_i + board[elf2].to_i).to_s
        # board.concat(new_recipe.digits.reverse)
        board << new_recipe

        # Move elves
        elf1 = (elf1 + board[elf1].to_i + 1) % board.length
        elf2 = (elf2 + board[elf2].to_i + 1) % board.length

        # puts board
        # curr = board.last(num_str.length + 1).join()  # Extra +1 in case last number is part of a double digit addition
        test = board.length > num_str.length ? board[-(num_str.length + 1)..-1].index(num_str) : nil
        unless test.nil?
            puts board.length - num_str.length - (test == 0 ? 1 : 0)
            # puts board.index(num_str)
            break
        end
    end
end

# hot_chocolate('51589')
# hot_chocolate('01245')
# hot_chocolate('92510')
# hot_chocolate('59414')
# hot_chocolate('515891')
# hot_chocolate('779251')
hot_chocolate('635041')