$roster = {}
$currentGuard = ""
$currentGuardAwake = true
$currentGuardSleepStart = 0

def processLine(inLine)
    month = inLine[6, 2]
    day = inLine[9, 2]
    hour = inLine[12, 2]
    minute = inLine[15, 2].to_i
    action = inLine[19, 1]
    # p "MONTH: #{month} DAY: #{day} HOUR: #{hour} MINUTE: #{minute} ACTION: #{action}"
    p "ERROR: Unexpected hour: #{inLine}" if hour != "00" && hour != "23"

    if action == "G"
        numEnd = inLine.index(' ', 26)
        $currentGuard = inLine[26, numEnd - 26]
        # p "GUARD: #{$currentGuard}"
    elsif $currentGuard == ""
        p "ERROR: No guard provided, yet: #{inLine}"
        return
    end

    if action == "f"
        $currentGuardAwake = false
        $currentGuardSleepStart = minute
    elsif action == "w"
        if $currentGuardAwake
            p "ERROR: Guard is already awake: #{inLine}"
            return
        end

        minutesSlept = minute - $currentGuardSleepStart

        if $roster.key?($currentGuard)
            $roster[$currentGuard][:totalSlept] += minutesSlept
        else
            $roster[$currentGuard] = { totalSlept: minutesSlept, minutesAsleep: Array.new(60, 0) }  # Two dots to include end param in range.
        end

        ($currentGuardSleepStart...minute).each do |thisMinute|
            $roster[$currentGuard][:minutesAsleep][thisMinute] += 1
        end

        $currentGuardAwake = true
        $currentGuardSleepStart = 0

        # p "CURRENT: #{$roster[$currentGuard]}"
    end
end


# allLinesStr = %{[1518-11-01 00:00] Guard #10 begins shift
# [1518-11-01 00:05] falls asleep
# [1518-11-01 00:25] wakes up
# [1518-11-01 00:30] falls asleep
# [1518-11-01 00:55] wakes up
# [1518-11-01 23:58] Guard #99 begins shift
# [1518-11-03 00:05] Guard #10 begins shift
# [1518-11-03 00:24] falls asleep
# [1518-11-03 00:29] wakes up
# [1518-11-04 00:02] Guard #99 begins shift
# [1518-11-04 00:36] falls asleep
# [1518-11-04 00:46] wakes up
# [1518-11-05 00:03] Guard #99 begins shift
# [1518-11-05 00:45] falls asleep
# [1518-11-05 00:55] wakes up
# [1518-11-02 00:40] falls asleep
# [1518-11-02 00:50] wakes up
# }

allLinesStr = File.read("aoc-04.in")

allLinesStr.split("\n").sort!.each do |thisLine|
    processLine(thisLine)
end

$roster = $roster.sort_by { |key, val| -val[:totalSlept] }
# p $roster
# guardSleptMost = Hash[*$roster.first]
guardSleptMost, guardSleptTimes = $roster.first
# p "SLEPT MOST: #{guardSleptMost} SLEPT TIME: #{guardSleptTimes}"
# commonSleepTime = guardSleptTimes[:minutesAsleep].each_with_index.max[1]  # Gets the last highest, if there are dups of the highest
commonSleepTime = guardSleptTimes[:minutesAsleep].index(guardSleptTimes[:minutesAsleep].max)  # Gets the first highest, if there are dups of the highest
p "GUARD: #{guardSleptMost} HOURS: #{guardSleptTimes[:totalSlept]} MOST LIKELY ASLEEP AT: #{commonSleepTime}"
puts "ID X MINUTE = #{guardSleptMost.to_i * commonSleepTime}"