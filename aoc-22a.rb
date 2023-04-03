# $depth = 510
# $target = [10, 10]
# $depth = 510
# $target = [3, 5]
$depth = 7740
$target = [12, 763]

$all_els = Array.new($target[1] + 1) {Array.new($target[0] + 1, 0)}
$grid = Array.new($target[1] + 1) {Array.new($target[0] + 1, 0)}

def geologic_index(y, x)
    return 0 if y == $target[1] && x == $target[0]
    return x * 16807 if y == 0
    return y * 48271 if x == 0
    return $all_els[y][x - 1] * $all_els[y - 1][x]
end

def erosion_level(gi)
    return (gi + $depth) % 20183
end

$region = [".", "=", "|"]
def print_area
    puts "AREA:"
    $grid.each_with_index do |row, y|
        row.each_with_index do |col, x|
            if y == 0 && x == 0 then print "M"
            elsif y == $target[1] && x == $target[0] then print "T"
            else print $region[col] end
        end
        puts ""
    end
end

# Generate the map!
(0..$target[1]).each do |row|
    (0..$target[0]).each do |col|
        gi = geologic_index(row, col)
        el = erosion_level(gi)
        $all_els[row][col] = el
        ty = el % 3
        # puts "NEW: [#{row}, #{col}] gi: #{gi} el: #{el} ty: #{ty}"
        $grid[row][col] = ty
    end
end

# print_area

total = $grid.flatten.reduce(:+)
puts "TOTAL: #{total}"