# read a text file line by line

# open the file
file = open('input.txt', 'r')

# create a dictionary of numbers and their string representations
valid = {
    "one": "o1e",
    "two": "t2o",
    "three": "t3e",
    "four": "f4r",
    "five": "f5e",
    "six": "s6x",
    "seven": "s7n",
    "eight": "e8t",
    "nine": "n9e"
}

# create a sum variable
sum = 0

# read the file line by line
for line in file:
    # replace the words with their string representations
    for key, value in valid.items():
        line = line.replace(key, value)
    # find digits in the line
    digits = [str(d) for d in line if d.isdigit()]
    # add the first and last digits to the sum
    sum += int(digits[0] + digits[-1])
        

print(sum)
