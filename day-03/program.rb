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



def build_serials()
    serials = []

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
            end
        end
        current_line += 1
    end

    # close the file
    file.close
    serials
end

def mark_serials(serials)
    # open the file
    file = File.open("input.txt")
    ignore_array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "\n"]

    # read the file line by line
    current_line = 0
    file.each do |line|
        line.chars.each_with_index do |char, index|
            # see if char is a symbol
            if !ignore_array.include?(char)
                # check if the serial is in the line
                serials.each do |serial|
                    if serial.row == current_line || serial.row == current_line - 1 || serial.row == current_line + 1
                        if serial.start <= index + 1  && serial.end >= index - 1
                            serial.is_serial = true
                        end
                    end
                end
            end
        end
        current_line += 1
    end

    # close the file
    file.close
    serials
end

def get_gears(serials)
    # open the file
    file = File.open("input.txt")
    ignore_array = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "\n"]

    gears = []
    # read the file line by line
    current_line = 0
    file.each do |line|
        line.chars.each_with_index do |char, index|
            # see if char is a symbol
            if char == "*"
                # check if the serial is in the line
                connections = []
                serials.each do |serial|
                    if serial.row == current_line || serial.row == current_line - 1 || serial.row == current_line + 1
                        if serial.start <= index + 1  && serial.end >= index - 1
                            connections << serial.number
                        end
                    end
                end
                if connections.length == 2
                    gears << connections[0] * connections[1]
                end
            end

        end
        current_line += 1
    end

    # close the file
    file.close
    gears
end


serials = build_serials()
gears = get_gears(serials)
serials = mark_serials(serials)

# print all the serials
serials.each do |serial|
    puts "#{serial.number} #{serial.start} #{serial.end} #{serial.row} #{serial.is_serial}"
end

# sum all the serials where is_serial is true
sum = 0
serials.each do |serial|
    if serial.is_serial
        sum += serial.number
    end
end

gear_sum = 0
# sum all the gears
gears.each do |gear|
    gear_sum += gear
end


puts "The sum of serials is #{sum}"
puts "The sum of gears is #{gear_sum}"