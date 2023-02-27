# lines = File.read("aoc-19.ex").split("\n")
lines = File.read("aoc-19.in").split("\n")

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
register = [1, 0, 0, 0, 0, 0]

# Lots of manual pattern searching!
# register = [0, 0, 10551378, 3, 10551378, 1]
# register = [1, 0, 5275689, 3, 10551378, 2]
# register = [3, 0, 10551378, 3, 10551378, 2]
# register = [3, 0, 3517126, 3, 10551378, 3]
# register = [6, 0, 10551378, 3, 10551378, 3]
# register = [6, 0, 10551378, 3, 10551378, 4]
# register = [6, 0, 10551378, 3, 10551378, 5]
# register = [6, 0, 1758563, 3, 10551378, 6]  # reg[0] 12
# register = [12, 0, 10551378, 3, 10551378, 6]
# register = [12, 0, 53022, 3, 10551378, 199]
# register = [211, 0, 26511, 3, 10551378, 398]
# register = [609, 0, 17674, 3, 10551378, 597]
# register = [1206, 0, 8837, 3, 10551378, 1194]
# register = [2400, 0, 1194, 3, 10551378, 8837]
# register = [11237, 0, 597, 3, 10551378, 17674]
# register = [28911, 0, 398, 3, 10551378, 26511]
# register = [55422, 0, 199, 3, 10551378, 53022]
# register = [108444, 0, 6, 3, 10551378, 1758563]
# register = [1867007, 0, 3, 3, 10551378, 3517126]
# register = [5384133, 0, 2, 3, 10551378, 5275689]
# register = [10659822, 0, 1, 3, 10551378, 10551378]
# register = [21211200, 0, 10551378, 3, 10551378, 10551378]

while register[ip] < instructions.length
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
    break if register[ip] == ip  # Cycling has begun!

    register[ip] += 1

    loop_num += 1
    # puts "LOOP: #{loop_num}" if loop_num % 1000000 == 0
end
puts "[#{register.join(", ")}] -- LOOPS: #{loop_num}" if DEBUG

# Get all factors of common divisors for register[5]
divisors = []
i = 1
while i*i < register[4]
    # puts i if register[5] % i == 0
    if register[4] % i == 0
        divisors.push(i)
        divisors.push(register[4] / i)
    end
    i += 1
end
puts "DIV: #{divisors.join(", ")}" if DEBUG

puts "TOTAL: #{divisors.sum}"