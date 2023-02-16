# lines = File.read('aoc-12.ex').split("\n")
lines = File.read('aoc-12.in').split("\n")

state = lines[0].split(": ")[1]
# puts "STATE: #{state}"
mods = lines.drop(2).reduce([]) do |a, line|
    a.push(line.split(" => ")) if line[-1] != "."; a
end
# puts "MODS: #{mods}"

max_gens = 20
test_len = 5
pos_zero = 0

(1..max_gens).each do |num_gens|
    if state[0...5] != "....."
        state.insert(0, ".....")
        pos_zero += 5
        # puts "PADDED LEFT: #{state}"
    end
    if state[-5..-1] != "....."
        state.concat(".....")
        # puts "PADDED RIGHT: #{state}"
    end
    # puts "#{num_gens}: #{state}"

    new_state = Marshal.load(Marshal.dump(state))
    # num_plants = 0
    (0...(new_state.length - test_len)).each do |idx|
        token = state[idx, test_len]
        # puts "#{idx} TESTING: #{token}"

        found = false
        mods.each do |mod|
            # puts "TESTING: #{mod[0]} == #{token}"
            if mod[0] == token
                # puts "MATCH"
                new_state[idx + 2] = mod[1]
                # num_plants += 1
                # num_plants += (idx + 2) - pos_zero
                found = true
                break
            end
        end
        if not found
            new_state[idx + 2] = "."
        end
    end

    # total_plants += num_plants
    state = new_state

    # puts "#{num_gens}: #{state} #{total_plants}"
    num_gens -= 1
end

total_plants = 0
(0...state.length).each do |idx|
    if state[idx] == '#'
        # total_plants += 1
        total_plants += idx - pos_zero
    end
end
puts "TOTAL: #{total_plants}"