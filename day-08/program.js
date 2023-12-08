// read in input.txt file line by line
// the first line goes into a variable called steps
// skip the second line
// all additional lines are split up as follows: a = (x, y)
// a is the string that goes into a dictionary called nodes
// with an array [x, y] as the value

// create a dictionary called nodes
const nodes = {};

const fs = require('fs');

const readFile = () => {
    // read in input.txt file line by line
    return fs.readFileSync('input.txt', 'utf8').split('\n');
}

const parseInput = (input) => {
    // the first line goes into a variable called steps
    // after removing the newline character at the end
    const steps = input[0].replace('\r', '');
    
    // skip the second line
    // all additional lines are split up as follows: a = (x, y)
    // a is the string that goes into a dictionary called nodes
    // with an array [x, y] as the value
    for (let i = 2; i < input.length; i++) {
        const line = input[i];
        const splitLine = line.split(' = ');
        const key = splitLine[0];
        const value = splitLine[1].replace('(', '').replace(')', '').replace('\r', '').split(', ');
        nodes[key] = value;
    }
    return steps;
}

const part1 = () => {
    const file = readFile();
    const steps = parseInput(file);
    let current = 'AAA';
    let total_steps = 0;
    console.log(steps);
    while(current !== 'ZZZ') {
        const direction = steps[(total_steps) % steps.length];
        console.log("direction: " + direction);
        if(direction === 'L') {
            current = nodes[current][0];
        }
        else {
            current = nodes[current][1];
        }    
        console.log(current);
        total_steps++;
    }
    console.log(total_steps);
}

const part2 = () => {
    const file = readFile();
    const steps = parseInput(file);
    console.log(steps.length);
    let starts = findAllThatEndWith('A');
    const results = starts.map(start => findZUntilRepeat(start, steps));
    console.log(results);
    // get the least common multiple of the results
    // 1. find the greatest common divisor
    // 2. divide the product of the results by the gcd
    // 3. return the result
    let product = (results[0] * results[1]) / gcd(results[0], results[1])
    for(let i = 2; i < results.length; i++) {
        product = (product * results[i]) / gcd(product, results[i]);
    }    
    console.log(product);
}

const findGCD = (values) => {
    let result = values[0];
    for(let i = 1; i < values.length; i++) {
        result = gcd(result, values[i]);
    }
    return result;
}

const gcd = (a, b) => {
    if(!b) {
        return a;
    }
    return gcd(b, a % b);
}

const findZUntilRepeat = (start, steps) => {
    const places = {};
    let found_repeat = false;
    let total_steps = 0;
    let current = start;
    while(!found_repeat)
    {
        const which_step = total_steps % steps.length;
        const direction = steps[which_step];
        let direction_index = 0;
        // console.log("direction: " + direction);
        if(direction === 'R') {
            direction_index = 1;
        }    
        current= nodes[current][direction_index];
        total_steps++;
        if(current[2] === 'Z') {
            console.log("found Z at: " + total_steps)
            if(places[current] === undefined) {
                places[current] = [];
            }
            if(places[current].includes(which_step)) {
                found_repeat = true;
            }
            else
            {
                places[current].push(which_step);
            }
        }
    }
    console.log("repeats at: " + total_steps);
    console.log("current: " + current);
    // loop over places and print out each key and value
    const keys = Object.keys(places);
    for(let i = 0; i < keys.length; i++) {
        console.log(keys[i] + ": " + places[keys[i]]);
    }
    return total_steps / 2;
}

const findAllThatEndWith = (letter) => {
    const keys = Object.keys(nodes);
    const result = [];
    for(let i = 0; i < keys.length; i++) {
        if(keys[i][2] === letter) {
            result.push(keys[i]);
        }
    }
    return result;
}

const allEndWithZ = (values) => {
    for(let i = 0; i < values.length; i++) {
        if(values[i][2] !== 'Z') {
            return false;
        }
    }
    return true;
}

part2();