letter_range = ('A'..'M').to_a

forward_map = {
    'A' => 'A',
    'K' => 'B',
    'Q' => 'C',
    'J' => 'D',
    'T' => 'E',
    '9' => 'F',
    '8' => 'G',
    '7' => 'H',
    '6' => 'I',
    '5' => 'J',
    '4' => 'K',
    '3' => 'L',
    '2' => 'M'
}

joker_map = {
    'A' => 'A',
    'K' => 'B',
    'Q' => 'C',
    'T' => 'D',
    '9' => 'E',
    '8' => 'F',
    '7' => 'G',
    '6' => 'H',
    '5' => 'I',
    '4' => 'J',
    '3' => 'K',
    '2' => 'L',
    'J' => 'M',
}


hand_values = {
    'five of a kind' => 10,
    'four of a kind' => 9,
    'full house' => 8,
    'three of a kind' => 7,
    'two pair' => 6,
    'one pair' => 5,
    'high card' => 4
}

def convert_hand(hand, forward_map)
    converted_hand = []

    hand.each_char do |c|
        converted_hand << forward_map[c]
    end

    return converted_hand.join('')
end

def get_hand_type_with_jokers(hand)
    hand_type = get_hand_type(hand)
    number_of_jokers = hand.count('M')

    # jokers switch to the card with the highest count in the hand
    # or the highest card if there are not multiples

    if number_of_jokers == 1
        if hand_type == 'high card'
            hand_type = 'one pair'
        elsif hand_type == 'one pair'
            hand_type = 'three of a kind'
        elsif hand_type == 'two pair'
            hand_type = 'full house'
        elsif hand_type == 'three of a kind'
            hand_type = 'four of a kind'
        elsif hand_type == 'four of a kind'
            hand_type = 'five of a kind'
        end
    elsif number_of_jokers == 2
        if hand_type == 'one pair'
            hand_type = 'three of a kind'
        elsif hand_type == 'two pair'
            hand_type = 'four of a kind'
        elsif hand_type == 'full house'
            hand_type = 'five of a kind'
        end
    elsif number_of_jokers == 3
        if hand_type == 'three of a kind'
            hand_type = 'four of a kind'
        elsif hand_type == 'full house'
            hand_type = 'five of a kind'
        end
    elsif number_of_jokers == 4
        hand_type = 'five of a kind'
    end

    return hand_type
end

def get_hand_type(hand)
    hand = hand.chars.sort.join('')
    hand_type = 'high card'

    # five of a kind
    if hand[0] == hand[4]
        hand_type = 'five of a kind'
    # four of a kind
    elsif hand[0] == hand[3] || hand[1] == hand[4]
        hand_type = 'four of a kind'
    # full house
    elsif hand[0] == hand[2] && hand[3] == hand[4]
        hand_type = 'full house'
    elsif hand[0] == hand[1] && hand[2] == hand[4]
        hand_type = 'full house'
    # three of a kind
    elsif hand[0] == hand[2] || hand[1] == hand[3] || hand[2] == hand[4]
        hand_type = 'three of a kind'
    # two pair
    elsif hand[0] == hand[1] && hand[2] == hand[3]
        hand_type = 'two pair'
    elsif hand[0] == hand[1] && hand[3] == hand[4]
        hand_type = 'two pair'
    elsif hand[1] == hand[2] && hand[3] == hand[4]
        hand_type = 'two pair'
    # one pair
    elsif hand[0] == hand[1] || hand[1] == hand[2] || hand[2] == hand[3] || hand[3] == hand[4]
        hand_type = 'one pair'
    end

    return hand_type
end

# letter_range.each do |a|
#     letter_range.each do |b|
#         letter_range.each do |c|
#             letter_range.each do |d|
#                 letter_range.each do |e|
#                     hand = [a, b, c, d, e]
#                     hand.sort!
#                     hand = hand.join('')
#                     hands_type[hand] = get_hand_type_with_jokers(hand)
#                 end
#             end
#         end
#     end
# end

# read input
input = File.read('input.txt').split("\n")

# map over input to create hands
hands = input.map do |line|
    row = line.split(' ')
    row << convert_hand(row[0], joker_map)
    row << get_hand_type_with_jokers(row[-1])
end

# sort hands based on their hand type then row[0]
hands.sort! do |a, b|
    if hand_values[a[-1]] == hand_values[b[-1]]
        b[2] <=> a[2]
    else
        hand_values[a[-1]] <=> hand_values[b[-1]]
    end
end

sum = 0
hands.each_with_index do |hand, index|
    value = hand[1].to_i * (index + 1)
    sum += value
    print hand
    puts
    puts value
end
puts sum
