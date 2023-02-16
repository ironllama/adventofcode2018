# lines = File.read('aoc-13.ex').split("\n")
# line_max = 13
lines = File.read('aoc-13.in').split("\n")
line_max = 150

cars = []
# Take all the cars off of the map, and into their own array with pos, facing, and intersection index
lines.each_with_index do |line, row|
    (0...line_max).each do |col|
        if col < line.length  # Some lines have fewer chars than line_max
            found = -1
            case line[col]
            when "^"
                found = 0
                line[col] = "|"
            when ">"
                found = 1
                line [col] = "-"
            when "v"
                found = 2
                line[col] = "|"
            when "<"
                found = 3
                line [col] = "-"
            end
            if found != -1
                cars.push([row, col, found, 0])
            end
        end
    end
end

def print_map(lines, cars)
    new_lines = Marshal.load(Marshal.dump(lines))
    puts "PRINT CARS: #{cars}"
    cars.each { |car| new_lines[car[0]][car[1]] = car[2] == 0 ? "^" : car[2] == 1 ? ">" : car[2] == 2 ? "v" : "<" }
    new_lines.each { |line| puts line }
end
# print_map(lines, cars)

ticks = 1
catch (:done) do
    while true
        cars.each_with_index do |car, idx|
            # Scope out the new spot and move the car.
            if car[2] == 0
                new_spot = lines[car[0] - 1][car[1]]
                car[0] -= 1
            elsif car[2] == 1
                new_spot = lines[car[0]][car[1] + 1]
                car[1] += 1
            elsif car[2] == 2
                new_spot = lines[car[0] + 1][car[1]]
                car[0] += 1
            elsif car[2] == 3
                new_spot = lines[car[0]][car[1] - 1]
                car[1] -= 1
            end

            if new_spot == "+"
                # If the new spot is an intersection, do the turns
                case car[3]
                when 0
                    car[2] = (car[2] - 1) % 4
                when 2
                    car[2] = (car[2] + 1) % 4
                end
                car[3] = (car[3] + 1) % 3
            elsif new_spot == "/"
                # If the new spot is a curve, rotate the car
                if (car[2] == 1 || car[2] == 3)
                    car[2] = (car[2] - 1) % 4
                else
                    car[2] = (car[2] + 1) % 4
                end
            elsif new_spot == "\\"
                # If the new spot is a curve, rotate the car
                if (car[2] == 1 || car[2] == 3)
                    car[2] = (car[2] + 1) % 4
                else
                    car[2] = (car[2] - 1) % 4
                end
            end

            cars.each_with_index do |other_car, other_idx|
                if idx != other_idx
                    if car[0] == other_car[0] && car[1] == other_car[1]
                        puts "BOOM! #{car[1]},#{car[0]} TICK: #{ticks}"
                        throw :done
                    end
                end
            end
        end

        ticks += 1
        # if ticks > 20 then break end
        # print_map(lines, cars)
    end
end