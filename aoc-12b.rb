# After running part A to over 1000 generations, it's clear that it eventually
# converges into multiple (6?) distinct bands that just move to the right.
# After pulling out the totals and the gaps, I used a spreadsheet to figure
# out the differences and create a formula.
# Output:
# Gen   Plants  Diff
# 100:	2580	-2580
# 200:	4680	-2100
# 300:	6780	-2100
# 400:	8880	-2100
# 500:	10980	-2100
# 600:	13080	-2100
# 700:	15180	-2100
# 800:	17280	-2100
# 900:	19380	-2100
# 1000:	21480	-2100

# Formula: ((Gen / 100) - 1) * 2100 + 2580
max_gens = 50000000000
puts "NUM: #{((max_gens / 100) - 1) * 2100 + 2580}"