# lines = File.read('aoc-17.ex').split("\n")
lines = File.read('aoc-17.in').split("\n")

$stuff = {[0, 500] => '+'}  # To get rid of dupes and to store symbols
$low_y = Float::INFINITY
$high_y = 0
$low_x = Float::INFINITY
$high_x = -Float::INFINITY
$end_y = 0

def add_new(coord, sym)
    # return unless coord[0] < 7  # Limiter for testing.
    $stuff[coord] = sym

    # $low_y = coord[0] if coord[0] < $low_y
    $high_y = coord[0] if coord[0] > $high_y
    $low_x = coord[1] if coord[1] < $low_x
    $high_x = coord[1] if coord[1] > $high_x
end

def print_status()
    (0..$high_y).each do |row|
        # (0..$high_x).each do |col|  # Full area for testing.
        ($low_x..$high_x).each do |col|
            if $stuff.key?([row, col])
                print $stuff[[row, col]]
            else
                print "."
            end
        end
        puts ""
    end
end

lines.each do |line|
    new_stuff = [0, 0]
    coords = line.split(", ")

    kv = coords[0].split("=")
    xy = kv[0] == 'y' ? 0 : 1
    new_stuff[xy] = kv[1].to_i

    kv = coords[1].split("=")
    xy = kv[0] == 'y' ? 0 : 1
    vr = kv[1].split("..")
    (vr[0].to_i..vr[1].to_i).each do |i|
        new_stuff[xy] = i
        add_new([new_stuff[0], new_stuff[1]], "#")

        $low_y = new_stuff[0] if new_stuff[0] < $low_y
    end
end
$end_y = $high_y  # Finishing point.
# $stuff.each {|s| puts "#{s}" }
# puts "Y: 0-#{$high_y} X: #{$low_x}-#{$high_x}"

# until spring[0] > $high_y
def pour_down(spring)
    # puts "POURING: #{spring}"
    top_spring = spring[0]

    # Pour down
    curr = spring[0]
    while true
        curr += 1

        return spring if $stuff[[curr, spring[1]]] == "|"  # Already an existing overflow, skip
        return [curr - 1, spring[1]] if curr > $end_y  # Bottom of all buckets

        if $stuff[[curr, spring[1]]].nil?
            add_new([curr, spring[1]], "|")
            spring = [curr, spring[1]]  # New lowest point for water.
        else
            break
        end
    end

    catch (:done) do
        while true
            new_pour = [nil, nil]  # Any overflow squares for recursion.
            to_add = []  # Water squares for display.

            # Spread left and right
            [-1, 1].each_with_index do |x, i|
                curr = spring[1]
                while true
                    curr += x
                    # puts "TEST: Y:#{spring[0]}, X:#{curr}"
                    if $stuff[[spring[0], curr]].nil?
                        to_add.push([spring[0], curr])
                        if $stuff[[spring[0] + 1, curr]].nil?  # If no base
                            new_pour[i] = [spring[0], curr]
                            break
                        end
                    else
                        break
                    end
                end
            end

            # Add the appropriate water symbol.
            to_add.each {|i| add_new(i, new_pour[0] != nil || new_pour[1] != nil ? "|" : "~")}

            # Pour over and recurse as needed.
            continue = true
            [-1, 1].each_with_index do |x, i|
                new_top = nil
                new_top = pour_down(new_pour[i]) unless new_pour[i].nil?
                unless new_top.nil?
                    new_pos = new_top[1] + x
                    new_pos += x while !$stuff[[new_pour[i][0], new_pos]].nil? && $stuff[[new_pour[i][0], new_pos]] != "#"
                    continue = false if $stuff[[new_pour[i][0], new_pos]].nil?
                    # puts "LEFT START: [#{new_pour[0][0]}, #{new_top[1] - 1}] END: [#{new_pour[0][0]}, #{new_pos}] SYM: #{$stuff[[new_pour[0][0], new_pos]]}"
                end
            end

            break unless continue  # If it pours over one side into nothing, then we're finished with the level.
            break unless spring[0] > top_spring  # If we're too high, we're finished with the level.

            spring[0] -= 1  # Go up one level.
        end
    end

    return spring
end

pour_down([0, 500])
# print_status()

puts $stuff.values.select {|v| v != "#"}.length - $low_y  # -$low_y to remove the water above the first #