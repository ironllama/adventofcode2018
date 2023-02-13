# lines = File.read('aoc-10.ex').split("\n")
lines = File.read('aoc-10.in').split("\n")

$lights = []
$vels = []
$maxX = $maxY = 0
$minX = $minY = Float::INFINITY

lines.map do |line|
    pos = line[line.index('<') + 1, line.index('>')].split(", ").map { |i| i.to_i }
    $lights.push(pos)
    vel_start = line.index('v')
    vel = line[line.index('<', vel_start) + 1, line.index('>', vel_start)].split(", ").map { |i| i.to_i }
    $vels.push(vel)

    if pos[0] > $maxX then $maxX = pos[0] end
    if pos[1] > $maxY then $maxY = pos[1] end
    if pos[0] < $minX then $minX = pos[0] end
    if pos[1] < $minY then $minY = pos[1] end
    end
# puts "LIGHT: #{$lights}"

def printLights()
    grid = Array.new($maxY - $minY + 1) { Array.new($maxX - $minX + 1, '.') }

    offsetY = $minY - 0
    offsetX = $minX - 0
    $lights.each do |light|
        newX = light[0] - offsetX
        newY = light[1] - offsetY
        grid[light[1] - offsetY][light[0] - offsetX] = '#'
    end

    grid.each { |row| puts row.join("") }
end
# printLights()

def tick(forward = true)
    $maxX = $maxY = 0
    $minX = $minY = Float::INFINITY
    $lights.each_with_index do |light, idx|
        if forward
            light[0] += $vels[idx][0]
            light[1] += $vels[idx][1]
        else
            light[0] -= $vels[idx][0]
            light[1] -= $vels[idx][1]
        end

        if light[0] < $minX then $minX = light[0] end
        if light[0] > $maxX then $maxX = light[0] end

        if light[1] < $minY then $minY = light[1] end
        if light[1] > $maxY then $maxY = light[1] end
    end
end

num_in_row = 5
i = 1
found = false
smallest = ($maxX - $minX) * ($maxY - $minY)
while(not found) do
    tick()

    # See if total area is growing against to see if words are found.
    new_area = (($maxX - $minX) * ($maxY - $minY))
    if new_area <= smallest
        smallest = new_area
    else
        found = true
        puts "SEC: #{i - 1}"
        tick(false)
        # printLights()
        break
    end
    i += 1
end