# lines = File.read('aoc-24.ex').split("\n")
lines = File.read('aoc-24.in').split("\n")

class Group
    attr_accessor :id, :team, :num, :hp, :dam, :type, :init, :immune, :weak, :e_power, :oppo, :oppo_dam
    def initialize(id, team, num, hp, dam, type, init, weak = [], immune = [])
        @id = id
        @team = team
        @num = num
        @hp = hp
        @dam = dam
        @type = type
        @init = init
        @weak = weak
        @immune = immune

        @e_power = num * dam
        @oppo = nil
        @oppo_dam = 0
    end

    def to_s
        "ID[#{@id}] TEAM[#{@team}] NUM[#{@num}] HP[#{@hp}]"
    end
    alias_method :inspect, :to_s
end

all_teams = []

curr = "IMM"
lines.each do |line|
    if line.empty?
        curr = "INF"
        next
    end
    next if line[-1] == ":"

    toks = line.split(" ")
    does_idx = toks.index("does")

    weak = []
    imm = []

    mods_start = line.index("(")
    if !mods_start.nil?
        mods_str = line[(mods_start + 1)...line.index(")")]
        mods_all = mods_str.split(";")
        mods_all.each do |mod|
            mod_toks = mod.strip.split(" ")
            curr_mod = mod_toks[2..].map! {|x| x.delete_suffix(",")}
            if mod_toks[0] == "weak"
                weak = curr_mod
            else
                imm = curr_mod
            end
            # puts "MOD[#{ mod_toks[0] == "immune" ? "IMM" : "WEAK"}] VAL[#{curr_mod}] WEAK[#{weak}] IMM[#{imm}]"
        end
    end

    all_teams.push(Group.new(all_teams.size, curr, toks[0].to_i, toks[4].to_i, toks[does_idx + 1].to_i, toks[does_idx + 2], toks[-1].to_i, weak, imm))
end
all_teams.sort_by! {|g| g.init }.reverse!.each_with_index {|g, i| g.id = i}  # Sort descending by init, and then re-assign IDs on the order.
# all_teams.each {|g| puts "#{g} DAM[#{g.dam}] TYPE[#{g.type}] INIT[#{g.init}] WEAK[#{g.weak}] IMM[#{g.immune}] E_PWR[#{g.e_power}]"}

def num_team(arr, team)
    arr.reduce(0) {|total, g| g.team == team ? total + g.num : total}
end

def play(all_teams)
    while true
        # Target Selection

        turn = {}
        targeted = []

        # Update and sort by effective power
        all_teams.each {|g| g.e_power = g.num * g.dam }
        by_e_power = all_teams.sort_by {|g| [g.e_power, g.init] }.reverse

        by_e_power.each_with_index do |attacker, a_i|
            best_dam = 0
            attacker.oppo = nil
            attacker.oppo_dam = 0

            by_e_power.each_with_index do |defender, d_i|
                next if a_i == d_i || targeted.include?(defender.id) || attacker.team == defender.team || defender.num == 0
                imm_mod = defender.immune.include?(attacker.type) ? 0 : 1
                weak_mod = defender.weak.include?(attacker.type) ? 2 : 1
                total_dam = attacker.e_power * weak_mod * imm_mod
                next if total_dam == 0

                if total_dam > attacker.oppo_dam ||
                    (total_dam == attacker.oppo_dam && defender.e_power > all_teams[attacker.oppo].e_power) ||
                    (total_dam == attacker.oppo_dam && defender.e_power == all_teams[attacker.oppo].e_power && defender.init > all_teams[attacker.oppo].init)
                    attacker.oppo_dam = total_dam
                    attacker.oppo = defender.id
                end
            end

            if !attacker.oppo.nil?
                targeted.push(attacker.oppo)
                # puts "TARGET ATTACKER: #{attacker} TOTAL_DAMAGE[#{attacker.oppo_dam}]"
                # puts "\tTARGET DEFENDER: #{all_teams[attacker.oppo]}"
            end
        end

        # Attack Phase
        total_killed = 0  # There are stalemates where the battle hangs. If no one is killed in a round, we need to stop fighting.
        all_teams.each do |attacker|
            next if attacker.num == 0 || attacker.oppo.nil?

            defender = all_teams[attacker.oppo]
            killed = 0

            # Update effective power and damage in case of reduced numbers from attack earlier in same round.
            attacker.e_power = attacker.num * attacker.dam
            imm_mod = defender.immune.include?(attacker.type) ? 0 : 1
            weak_mod = defender.weak.include?(attacker.type) ? 2 : 1
            attacker.oppo_dam = attacker.e_power * weak_mod * imm_mod

            while attacker.oppo_dam > 0 && defender.num > 0
                if attacker.oppo_dam > defender.hp
                    defender.num -= 1
                    attacker.oppo_dam -= defender.hp
                    killed += 1
                else
                    break  # Ran out of enough damage to kill a unit.
                end
            end
            # puts "ATTACK ATTACKER: #{attacker} TOTAL_DAMAGE[#{attacker.oppo_dam}] KILLED[#{killed}]"
            # puts "\tATTACK DEFENDER: #{all_teams[attacker.oppo]}"
            total_killed += killed
        end

        # all_teams.each {|g| puts "#{g} TYPE[#{g.type}] WEAK#{g.weak} IMM#{g.immune} HP[#{g.hp}] DAM[#{g.dam}]"}
        # puts "TARGETED: #{targeted}"

        home_team = num_team(all_teams, "IMM")
        if home_team == 0
            return 0
        elsif num_team(all_teams, "INF") == 0
            return home_team
        elsif total_killed == 0
            # puts " STALEMATE"
            return 0
        end
    end
end

boost_amt = 1
imm_num = 0
while true
    new_teams = Marshal.load(Marshal.dump(all_teams))
    new_teams.each {|x| x.dam += boost_amt if x.team == "IMM"}
    # print "BOOST: #{boost_amt}"
    imm_num = play(new_teams)
    # puts " NUM: #{imm_num}"
    break if imm_num > 0
    boost_amt += 1
end

# left = all_teams.reduce(0) {|sum, g| sum + g.num }
puts "END: #{imm_num}"

# 15-26 stalls? Stalemates w/ type vs immune
# 18-19 stalls? Stalemates w/ not enough dam to kill
