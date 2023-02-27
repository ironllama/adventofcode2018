# lines = File.read("aoc-19.ex").split("\n")
lines = File.read("aoc-19.in").split("\n")

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

# loop_num = 0
register = [0, 0, 0, 0, 0, 0]
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

    break if register[ip] + 1 >= instructions.length

    register[ip] += 1
    # loop_num += 1
    # puts "LOOP: #{loop_num}" if loop_num % 1000 == 0
end

# puts "[#{register.join(", ")}] -- LOOPS: #{loop_num}"
# puts "[#{register.join(", ")}]"
puts register[0]