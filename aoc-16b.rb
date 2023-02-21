require "matrix"

lines = File.read("aoc-16.in").split("\n")

# DEBUG = true
DEBUG = false

samples = []
i = 0
while i < lines.length
    break if lines[i] == "" && lines[i + 1] == ""

    if lines[i][0] == "B"
        before = Vector.elements(lines[i].split("[")[1].split(", ").collect!(&:to_i))
        op = lines[i + 1].split(" ").collect!(&:to_i)
        after = Vector.elements(lines[i + 2].split("[")[1].split(", ").collect!(&:to_i))
        diff = after - before
        samples.push([op, before, after, diff])
        i += 3
    end

    i += 1
end

instructions = []
while i < lines.length
    instructions.push(lines[i].split(" ").collect!(&:to_i)) unless lines[i] == ""
    i += 1
end
# samples.each {|i| puts "[#{i[0].join(", ")}], [#{i[1].to_a.join(", ")}], [#{i[2].to_a.join(", ")}]"}
# puts "NUM samples: #{samples.length}"

def calc(op, line, type)
    possible = []

    if type.length == 2
        # A as value
        work_copy = line[1].map(&:clone)  # Shallow copy!
        work_copy[line[0][3]] = line[0][1].send(op.to_sym, work_copy[line[0][2]]) ? 1 : 0
        puts "#{op} -- #{line} valid w/ A as value." if DEBUG && work_copy == line[2]

        possible.push(type + 'ir') if work_copy == line[2]
    end

    # Register
    work_copy = line[1].map(&:clone)  # Shallow copy!
    new_type = type
    if type == 'set'
        work_copy[line[0][3]] = work_copy[line[0][1]]
        puts "cp -- #{line} valid w/ A as register." if DEBUG && work_copy == line[2]
    else
        res = work_copy[line[0][1]].send(op.to_sym, work_copy[line[0][2]])
        if type.length == 2
            res = res ? 1 : 0
            new_type += 'r'
        end
        work_copy[line[0][3]] = res
        puts "#{op} -- #{line} valid w/ B as register." if DEBUG && work_copy == line[2]
    end
    possible.push(new_type + 'r') if work_copy == line[2]

    # Value
    work_copy = line[1].map(&:clone)  # Shallow copy!
    new_type = type
    if type == 'set'
        work_copy[line[0][3]] = line[0][1]
        puts "cp -- #{line} valid w/ A as value." if DEBUG && work_copy == line[2]
    else
        res = work_copy[line[0][1]].send(op.to_sym, line[0][2])
        if type.length == 2
            res = res ? 1 : 0
            new_type += 'r'
        end
        work_copy[line[0][3]] = res
        puts "#{op} -- #{line} valid w/ B as value." if DEBUG && work_copy == line[2]
    end
    possible.push(new_type + 'i') if work_copy == line[2]

    return possible
end

def count_op_codes(line)
    possible = []

    possible += calc(:+, line, 'add')
    possible += calc(:*, line, 'mul')
    possible += calc(:&, line, 'ban')
    possible += calc(:|, line, 'bor')

    possible += calc(nil, line, 'set')

    possible += calc(:>, line, 'gt')
    possible += calc(:==, line, 'eq')
end

combos = []
samples.each {|l| combos.push([l[0][0], count_op_codes(l)])}
combos.each {|c| puts "#{c[0]} -- #{c[1].join(", ")}"} if DEBUG

codes = {}
i = 0
while combos.length > 0
    puts "OUTER: #{i}/#{combos.length} C:#{combos[i]}" if DEBUG
    if combos[i][1].length == 1
        found_code = combos[i][1][0]
        found_num = combos[i][0]
        codes[combos[i][0]] = found_code  # Record the code

        # Delete the others in the combos list.
        k = combos.length - 1
        while k >= 0
            if combos[k][0] == found_num # Delete combo if it is for the code
                puts "\tDELETED: #{combos.slice!(k)}" if DEBUG
                combos.slice!(k)
            else  # Remove code from combo list
                pos = combos[k][1].index(found_code)
                combos[k][1].slice!(pos) unless pos.nil?
            end
            k -= 1  # Next
        end
        # puts "SO FAR: #{codes}"
        # puts "SO FAR: #{combos}"
        i = 0
    else
        i += 1  # Only advance if code was not found
    end
end

# puts codes
(0..15).each {|i| puts "#{i}: #{codes[i]}"} if DEBUG

register = [0, 0, 0, 0]
instructions.each do |i|
    op_str = codes[i[0]]

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
    print "#{i} -- #{register}" if DEBUG
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
    puts " -- #{register}" if DEBUG
end

puts register[0]