
def hot_chocolate(num_str):
    board = '37'
    elf1 = 0
    elf2 = 1

    while True:
        board += str(int(board[elf1]) + int(board[elf2]))

        elf1 = (elf1 + int(board[elf1]) + 1) % len(board)
        elf2 = (elf2 + int(board[elf2]) + 1) % len(board)

        if num_str in board[-(len(num_str) + 1):]:
            print(board.index(num_str))
            break


hot_chocolate('635041')