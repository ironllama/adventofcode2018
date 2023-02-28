# reg = [goal, ip, v1, v2, v3, delay]

# Painful line-by-line translation of the "machine code" in aoc-21.in

# DEBUG = true
DEBUG = false

v1 = v2 = v3 = 0
# goal = 15823996

v2 = v3 | 65536  # 6  16-bit
v3 = 16098955 # 7

nums = []
loops = 0
loop do
    puts "LOOP: #{loops} V1: #{v1} V2: #{v2} V3: #{v3}" if DEBUG
    # 16777216 = 24-bit
    v3 = ((((v2 & 255) + v3) & 16777215) * 65899) & 16777215  # 8, 9, 10, 11, 12

    if 256 > v2  # 13, 14
        puts "V3: #{v3}" if DEBUG
        # break if v3 == goal  # 16, 28

        # The results cycle! So, we stop at the end of first cycle.
        nums.index(v3).nil? ? nums.push(v3) : break

        # 29, 30
        v2 = v3 | 65536  # 6
        v3 = 16098955 # 7
        next
    end

    # delay = 0  # 15, 17
    # while ((delay + 1) * 256) < v2  # 18, 19, 20, 21
    #     delay += 1  # 22, 24, 25
    # end

    # v2 = delay + 1  # 23, 26, 27

    # Above boils down to this.
    v2 = v2 / 256  # 15, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27

    loops += 1
end

# puts "ENDS! #{loops} LEN: #{nums.length}"
puts "FINAL: #{nums.pop}"