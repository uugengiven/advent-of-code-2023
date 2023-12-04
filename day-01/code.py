# read a text file line by line

# open the file
file = open('input.txt', 'r')

# create a sum variable
sum = 0

# read the file line by line
for line in file:
    # find digits in the line
    digits = [str(d) for d in line if d.isdigit()]
    # print the sum of the digits
    sum += int(digits[0] + digits[-1])

print(sum)
