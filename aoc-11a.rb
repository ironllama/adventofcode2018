max = 300
# serial = 18
# serial = 42
serial = 8199

def get_power(x, y, serial)
    (((((x + 10) * y + serial) * (x + 10)) / 100) % 10) - 5
end
# puts get_power(122, 79, 57);
# puts get_power(217, 196, 39);
# puts get_power(101, 153, 71);

grid = Array.new(max) { Array.new(max, 0) }
(1..max).each do |row|
    (1..max).each do |col|
        val = get_power(col, row, serial)
        # puts "row #{row} col #{col} P #{val}"
        grid[row - 1][col - 1] = val
    end
end
# grid.each { |row| row.each { |col| print format(' %02d ', col) }; puts "" }

highest = [0, 0, 0]
(1..298).each do |row|
    (1..298).each do |col|
        square = 0
        (0...3).each do |i_row|
            (0...3).each do |i_col|
                val = grid[row + i_row - 1][col + i_col - 1]
                square += val
            end
        end
        # puts "square #{col}, #{row} = #{square}"
        if square > highest[2]
            highest = [col, row, square]
        end
    end
end

puts "HIGH: #{highest}"