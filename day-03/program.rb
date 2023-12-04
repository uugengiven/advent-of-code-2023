class Serial
    attr_accessor :number
    attr_accessor :start
    attr_accessor :end
    attr_accessor :row
    attr_accessor :is_serial

    def initialize(number)
        @number = number
        @start = 0
        @end = 0
        @row = 0
        @is_serial = false
    end
end

class Pokken # things like Number or Symbol are reserved words but ruby will let me rewrite them and I deffo don't want to do that
    attr_accessor :value
    attr_accessor :column
    attr_accessor :row
    attr_accessor :is_gear
    attr_accessor :gear_value

    def initialize(value, column, row)
        @value = value
        @column = column
        @row = row
        @is_gear = false
        @gear_value = 0
    end
end

def build_arrays()
    serials = []
    pokkens = []
    # open a file and read it line by line
    # open the file
    file = File.open("input.txt")

    # read the file line by line
    current_line = 0
    file.each do |line|
        current_number = ""
        current_start = nil
        line.chars.each_with_index do |char, index|
            # see if char is a number
            if char =~ /[[:digit:]]/
                # add the number to the current number
                current_number += char
                if current_start == nil
                    current_start = index
                end
            else
                if current_start != nil
                    # create a new serial
                    serial = Serial.new(current_number.to_i)
                    serial.start = current_start
                    serial.end = index-1
                    serial.row = current_line
                    # add the serial to the array
                    serials << serial
                end
                current_start = nil
                current_number = ""
                if char != "\n" && char != "."
                    pokken = Pokken.new(char, index, current_line)
                    pokkens << pokken
                end
            end
        end
        current_line += 1
    end

    # close the file
    file.close
    [serials, pokkens]
end

def mark_serials_and_gears(serials, pokkens)
    pokkens.each do |pokken|
        # check if the pokken is in a row with a serial
        connections = []
        serials.each do |serial|
            if serial.row == pokken.row || serial.row == pokken.row - 1 || serial.row == pokken.row + 1
                if serial.start <= pokken.column + 1  && serial.end >= pokken.column - 1
                    serial.is_serial = true
                    connections << serial.number
                end
            end
        end
        if connections.length == 2 && pokken.value == "*"
            pokken.is_gear = true
            pokken.gear_value = connections[0] * connections[1]
        end
    end
end

serials, pokkens = build_arrays()
mark_serials_and_gears(serials, pokkens)

# print all the serials
# serials.each do |serial|
#     puts "#{serial.number} #{serial.start} #{serial.end} #{serial.row} #{serial.is_serial}"
# end

# sum all the serials where is_serial is true
sum = 0
serials.each do |serial|
    if serial.is_serial
        sum += serial.number
    end
end

gear_sum = 0
# sum all the pokken values where is_gear is true
pokkens.each do |pokken|
    if pokken.is_gear
        gear_sum += pokken.gear_value
    end
end


puts "The sum of serials is #{sum}"
puts "The sum of gears is #{gear_sum}"