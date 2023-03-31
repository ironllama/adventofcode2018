# lines = File.read('aoc-25.ex').split("\n")
# lines = File.read('aoc-25.ex2').split("\n")
# lines = File.read('aoc-25.ex3').split("\n")
# lines = File.read('aoc-25.ex4').split("\n")
lines = File.read('aoc-25.in').split("\n")

all_points = []
lines.map! {|line| line.split(",").map!(&:to_i)}
lines.sort!
# puts "#{lines}"

def same_constellation(a, b)
    deviation = 0
    a.each_with_index do |xyza, i|
        dist = (xyza - b[i]).abs
        deviation += dist
        return false if deviation > 3  # Skip rest of coords if already too far away.
    end
    return true
end

# Initial population of all constellations.
all_constellations = []
lines.each do |new_point|
    con_found = false
    all_constellations.each do |con|
        con.each do |point|
            if same_constellation(point, new_point)
                con_found = true
                break
            end
        end
        if con_found == true  # Add if found in this constellation.
            con.push(new_point)
            break
        end
    end
    all_constellations.push([new_point]) if con_found == false
end
# all_constellations.each_with_index {|x, i| puts "(#{i}) #{x}"}

# See if improvements can be made. Some constellations might be able to be combined.
all_constellations.sort_by! {|x| x.size}
while true
    movement = false
    catch (:done) do
        all_constellations.each_with_index do |outer, i|
            all_constellations.each_with_index do |inner, k|
                next if i == k
                outer.each do |outer_point|
                    inner.each do |inner_point|
                        if same_constellation(inner_point, outer_point)
                            # puts "COMBINING! ALL: #{all_constellations.size} NEW: #{inner.size} + #{outer.size}"
                            all_constellations[k] = inner + outer
                            rem = all_constellations.slice!(i, 1)
                            movement = true
                            throw :done
                        end
                    end
                end
            end
        end
    end
    break if movement == false
end

# all_constellations.each_with_index {|x, i| puts "(#{i}) #{x}"}
puts "NUM: #{all_constellations.size}"