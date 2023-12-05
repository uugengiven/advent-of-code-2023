package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	content, error := os.ReadFile("input.txt")

	if error != nil {
		fmt.Println(error)
		os.Exit(1)
	}

	lines := strings.Split(string(content), "\n")
	winningNumbers := make([][]int, 0)
	for _, line := range lines {
		// process the line
		winners, myNumbers := parseLine(line)
		overlap := getWinners(winners, myNumbers)
		winningNumbers = append(winningNumbers, overlap)
		fmt.Println(winners)
		fmt.Println(myNumbers)
		fmt.Println(overlap)
		fmt.Println(len(overlap))
	}

	sum := 0
	for _, winners := range winningNumbers {

		if len(winners) > 0 {
			sum += intPow(2, len(winners)-1)
		}
	}
	fmt.Println(sum)

	fatStacks := make([]int, len(lines))
	for i := 0; i < len(lines); i++ {
		totalWins := len(winningNumbers[i])
		fatStacks[i] += 1
		cards := fatStacks[i]
		for j := i + 1; j <= i+totalWins; j++ {
			if j < len(lines) {
				fatStacks[j] += cards
			}
		}
	}

	fmt.Println(fatStacks)
	sum = 0
	for _, fatStack := range fatStacks {
		sum += fatStack
	}
	fmt.Println(sum)
}

func intPow(x, y int) int {
	if y == 0 {
		return 1
	}
	result := x
	for i := 2; i <= y; i++ {
		result *= x
	}
	return result
}

// create function that takes in a string and returns two arrays of ints
func parseLine(line string) ([]int, []int) {
	// split string into two parts
	cardParts := strings.Split(line, ":")

	numbers := strings.Split(cardParts[1], "|")

	swinners := strings.Split(strings.TrimSpace(strings.Replace(numbers[0], "  ", " ", -1)), " ")
	smyNumbers := strings.Split(strings.TrimSpace(strings.Replace(numbers[1], "  ", " ", -1)), " ")

	fmt.Println(swinners)
	fmt.Println(smyNumbers)
	// convert string array to int array
	winners := make([]int, len(swinners))
	myNumbers := make([]int, len(smyNumbers))

	for i, s := range swinners {
		winners[i], _ = strconv.Atoi(s)
	}

	for i, s := range smyNumbers {
		myNumbers[i], _ = strconv.Atoi(s)
	}

	return winners, myNumbers
}

func getWinners(winners []int, myNumbers []int) []int {
	overlap := make([]int, 0)
	myNumbersMap := make(map[int]bool)

	for _, num := range myNumbers {
		if num > 0 {
			myNumbersMap[num] = true
		}
	}

	for _, num := range winners {
		if myNumbersMap[num] {
			overlap = append(overlap, num)
		}
	}

	return overlap
}
