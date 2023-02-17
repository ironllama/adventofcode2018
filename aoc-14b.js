function hot_chocolate(num_str) {
    board = [3, 7];
    elf1 = 0;
    elf2 = 1;

    // let i = 0;
    // while (board.slice(board.length - num_str.length - 1).join("").indexOf(num_str) == -1) {
    while (true) {
        // if ((i += 1) % 1000 == 0) console.log(`LOOP: ${i} LEN: ${board.length}`);

        // Add new recipes
        let new_recipe = board[elf1] + board[elf2];
        if (new_recipe >= 10) {
            board.push(1);
            new_recipe %= 10;
        }
        board.push(new_recipe);

        // Move elves
        elf1 = (elf1 + board[elf1] + 1) % board.length;
        elf2 = (elf2 + board[elf2] + 1) % board.length;

        // puts $board.join(" ")
        // curr = $board.last(num_str.length + 1).join()  // Extra +1 in case last number is part of a double digit addition
        // puts "//{curr} vs //{num_str}"
        test = board.slice(board.length - num_str.length - 1).join("").indexOf(num_str);
        if (test !== -1) {
            console.log(board.length - num_str.length - (test == 0 ? 1 : 0));
            // console.log(board.join("").indexOf(num_str));
            break
        }
    }
}

// hot_chocolate('59414');
// hot_chocolate('779251')
hot_chocolate('635041');
