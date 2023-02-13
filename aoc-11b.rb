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

highest = [0, 0, 0, -Float::INFINITY]
high_in_row = 5  # Arbitrary number from testing
# max.downto(1) do |size|
catch (:done) do
    1.upto(max) do |size|
        puts "SIZE: #{size} HIGH: #{highest}"
        high_updated = false
        (1..(max - size + 1)).each do |row|
            (1..(max - size + 1)).each do |col|
                square = 0
                (0...size).each do |i_row|
                    (0...size).each do |i_col|
                        val = grid[row + i_row - 1][col + i_col - 1]
                        square += val
                    end
                end
                # puts "square #{col}, #{row} = #{square}"
                if square > highest[3]
                    highest = [col, row, size, square]
                    high_updated = true
                end
            end
        end
        if high_updated
            high_in_row = 5
        else
            high_in_row -= 1
            throw :done if high_in_row == 0
        end
    end
end

puts "HIGH: #{highest}"