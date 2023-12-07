// read file line by line in node.js

const { open } = require('node:fs/promises');

const maps = {};
let seeds = [];
const mapKeysInOrder = [];
let runs = 0;
let workMap = null;
let workrow = null;
let currentId = null;

const readFile = async () => {
  const file = await open('input.txt');

  for await (const line of file.readLines()) {
    if(line.includes('seeds:')) 
    {
        seeds = line.split(':')[1].trim().split(' ').map(item => Number(item));
    }
    else if(line.includes('map:'))
    {
        currentMap = line.split(' ')[0].trim();
    }
    else if(line.length === 0)
    {
        // skip it
    }
    else
    {
        if(!maps[currentMap]) 
        {
            mapKeysInOrder.push(currentMap);
            maps[currentMap] = [];
        }
        const vals = line.split(' ').map(item => Number(item));
        vals.push(vals[1] + vals[2] - 1);
        vals.push(vals[0] - vals[1]);
        vals.push(vals[0] + vals[2] - 1);
        // 0: dest start, 1: source start, 2: length, 3: sorce end, 4: offset, 5: dest end
        maps[currentMap].push(vals);
        
    }

  }

  mapKeysInOrder.forEach((key) => {
    maps[key].sort((a, b) => {
        if(a[1] < b[1]) return -1;
        if(a[1] > b[1]) return 1;
        return 0;
    });
  });
}

let nextIdIterator = null;
const getNextId = (mapName, id) => {
    workMap = maps[mapName];
    for(nextIdIterator = 0; nextIdIterator < workMap.length; nextIdIterator++)
    {
        workrow = workMap[nextIdIterator];
        if(workrow[1] <= id && workrow[3] >= id)
        {
            return workrow[4] + id;
        }
    }
    return id;
}

let backwardoIdIterator = null;
const getBackwardoId = (mapName, id) => {
    workMap = maps[mapName];
    for(backwardoIdIterator = 0; backwardoIdIterator < workMap.length; backwardoIdIterator++)
    {
        workrow = workMap[backwardoIdIterator];
        if(workrow[0] <= id && workrow[5] >= id)
        {
            return id - workrow[4];
        }
    }
    return id;
}

let finalIdIterator = null;
const getFinalId = (id) => {
    currentId = id;
    runs++;
    for(finalIdIterator = 0; finalIdIterator < mapKeysInOrder.length; finalIdIterator++)
    {
        currentId = getNextId(mapKeysInOrder[finalIdIterator], currentId);
    }
    return currentId;
}

let finalBackwardIdIterator = null;
const getFinalBackwardId = (id) => {
    currentId = id;
    runs++;
    for(finalBackwardIdIterator = mapKeysInOrder.length - 1; finalBackwardIdIterator >= 0; finalBackwardIdIterator--)
    {
        currentId = getBackwardoId(mapKeysInOrder[finalBackwardIdIterator], currentId);
    }
    return currentId;
}

const isSeed = (id) => {
    for(let i = 0; i < seeds.length; i+=2)
    {
        if(id >= seeds[i] && id <= seeds[i] + seeds[i+1]) return true;
    }
    return false;
}

const run = async () => {
    await readFile();

    run = 1;
    let lowest = getFinalId(seeds[0]);
    let finalId = null;
    let lowestSeed = seeds[0];

    for(let i = 0; i < seeds.length; i+=2)
    {
        console.log("starting run ", runs);
        const start = seeds[i];
        const end = start + seeds[i+1];
        console.log(`start: ${start}, end: ${end}`);
        for(let j = start; j <= end; j++)
        {
            finalId = getFinalId(j);
            if(finalId < lowest)
            {
                lowest = finalId;
                lowestSeed = j;
            }
            //console.log(currentId);
        }
        console.log(`lowest: ${lowest}, seed: ${lowestSeed}`);
    }

    console.log(lowest);
    console.log("runs", runs);
}

const runbackwards = async () => {
    await readFile();

    let startLocation=0;
    let startSeed = getFinalBackwardId(startLocation);
    while(!isSeed(startSeed)) 
    {
        startLocation++;
        startSeed = getFinalBackwardId(startLocation);
    }

    console.log("start seed", startSeed);
    console.log("start location", startLocation);
}

const runtest = async () => {
    await readFile();

    console.log("run of 3283824077", getFinalId(3283824077));
    console.log("run of 3283824076", getFinalId(3283824076));
    console.log("run of 15880237", getFinalBackwardId(15880237));
    console.log("run of 15880236", getFinalBackwardId(15880236));
}

runtest(); // was used to fix the bug in the code
runbackwards(); // the fast way
run(); // the slow way