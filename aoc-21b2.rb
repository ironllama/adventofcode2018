# I figured pretty early on that just updating part 1 would be slow, but didn't really
# know why. So, after I solved it (by painstakingly translating the instructions to
# code), I went back and updated the part a to see just how slow.
# aoc-21b: ~0.5sec
# aco-21b2: 1414sec (~23.5min)

lines = File.read("aoc-21.in").split("\n")

# DEBUG = true
DEBUG = false

ip = 0
instructions = []
lines.each do |line|
    tokens = line.split(" ")
    if tokens[0] == "#ip"
        ip = tokens[1].to_i
        puts "NEW IP: #{ip}" if DEBUG
    else
        (1..3).each {|i| tokens[i] = tokens[i].to_i}
        instructions.push(tokens)
    end
end


loop_num = 0
register = [0, 0, 0, 0, 0, 0]
# register = [12, 18, 0, 65536, 14559001, 255]

nums = []
while register[ip] < instructions.length
# while register[ip] < instructions.length &&
#         register[ip] != 28  # Seems instruction 28 ("eqrr 4 0 5") determines stop!

    if register[ip] == 28
        nums.index(register[4]).nil? ? nums.push(register[4]) : break
        # puts "NEW: #{register[4]} LEN: #{nums.length}"
    end

    i = instructions[register[ip]]

    op_str = i[0]

    op = nil
    l = nil
    case op_str[0..1]
    when 'ad' then op = :+
    when 'mu' then op = :*
    when 'ba' then op = :&
    when 'bo' then op = :|
    when 'se' then
    when 'gt'
        op = :>
        l = op_str[-2] == 'r' ? register[i[1]] : i[1]
    when 'eq'
        op = :==
        l = op_str[-2] == 'r' ? register[i[1]] : i[1]
    else
        puts "UNKNOWN COMMAND: #{op_str}"
        next
    end

    # Progress debugging output.
    print "ip=#{register[ip]} #{register}" if DEBUG
    if !op.nil?
        r = op_str[-1] == 'r' ? register[i[2]] : i[2]
        if l.nil?
            register[i[3]] = register[i[1]].send(op.to_sym, r)
        else
            register[i[3]] = l.send(op.to_sym, r) ? 1 : 0
        end
    else
        r = op_str[-1] == 'r' ? register[i[1]] : i[1]
        register[i[3]] = r
    end
    puts " #{i.join(" ")} #{register}" if DEBUG

    # break if register[ip] + 1 >= instructions.length
    # break if register[ip] == ip  # Cycling has begun!

    register[ip] += 1

    loop_num += 1
    # puts "LOOP: #{loop_num}" if loop_num % 1000000 == 0
end
puts "[#{register.join(", ")}] -- LOOPS: #{loop_num}" if DEBUG

# puts register[4]
puts "FINAL: #{nums.pop}"