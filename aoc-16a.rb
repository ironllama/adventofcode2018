require "matrix"

# lines = %{
# Before: [3, 2, 1, 1]
# 9 2 1 2
# After:  [3, 2, 2, 1]
# }.split("\n")
# lines = %{
# Before: [3, 2, 2, 1]
# 9 2 1 2
# After:  [3, 2, 1, 1]
# }.split("\n")
lines = File.read("aoc-16.in").split("\n")

# DEBUG = true
DEBUG = false

instructions = []
i = 0
while i < lines.length
    break if lines[i] == "" && lines[i + 1] == ""

    if lines[i][0] == "B"
        before = Vector.elements(lines[i].split("[")[1].split(", ").collect!(&:to_i))
        op = lines[i + 1].split(" ").collect!(&:to_i)
        after = Vector.elements(lines[i + 2].split("[")[1].split(", ").collect!(&:to_i))
        diff = after - before
        instructions.push([op, before, after, diff])
        i += 3
    end

    i += 1
end
# instructions.each {|i| puts "[#{i[0].to_a.join(", ")}], [#{i[1].join(", ")}], [#{i[2].to_a.join(", ")}]"}
# puts "NUM INSTRUCTIONS: #{instructions.length}"

def calc(op, line)
    possible = 0

    # B as register
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = work_copy[line[0][1]].send(op.to_sym, work_copy[line[0][2]])
    possible += 1 if work_copy == line[2]
    puts "#{op} -- #{line} valid w/ B as register." if DEBUG && work_copy == line[2]

    # B as value
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = work_copy[line[0][1]].send(op.to_sym, line[0][2])
    possible += 1 if work_copy == line[2]
    puts "#{op} -- #{line} valid w/ B as value." if DEBUG && work_copy == line[2]

    return possible
end

def copy(line)
    possible = 0

    # A as register
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = work_copy[line[0][1]]
    possible += 1 if work_copy == line[2]
    puts "cp -- #{line} valid w/ A as register." if DEBUG && work_copy == line[2]

    # A as value
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = line[0][1]
    possible += 1 if work_copy == line[2]
    puts "cp -- #{line} valid w/ A as value." if DEBUG && work_copy == line[2]

    return possible
end

def comp(op, line)
    possible = 0

    # A as value
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = line[0][1].send(op.to_sym, work_copy[line[0][2]]) ? 1 : 0
    possible += 1 if work_copy == line[2]
    puts "#{op} -- #{line} valid w/ A as value." if DEBUG && work_copy == line[2]

    # B as value
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = work_copy[line[0][1]].send(op.to_sym, line[0][2]) ? 1 : 0
    possible += 1 if work_copy == line[2]
    puts "#{op} -- #{line} valid w/ B as value." if DEBUG && work_copy == line[2]

    # B as register
    work_copy = line[1].map(&:clone)  # Shallow copy!
    work_copy[line[0][3]] = work_copy[line[0][1]].send(op.to_sym, work_copy[line[0][2]]) ? 1 : 0
    possible += 1 if work_copy == line[2]
    puts "#{op} -- #{line} valid w/ B as register." if DEBUG && work_copy == line[2]

    return possible
end

def count_op_codes(line)
    possible = 0

    possible += calc(:+, line)  #vr
    possible += calc(:*, line)  #rv
    possible += calc(:&, line)  #rv
    possible += calc(:|, line)  #rv

    possible += copy(line)  #vr

    possible += comp(:>, line)
    possible += comp(:==, line)
end

total = 0
instructions.each {|l| total += 1 if count_op_codes(l) >= 3}
puts "TOTAL: #{total}"