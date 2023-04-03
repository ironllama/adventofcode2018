const { MinMaxHeap } = require('./MinMaxHeap');

// const DEBUG = true;
const DEBUG = false

// const depth = 510;
// const target = [10, 10];
depth = 7740
target = [12, 763]

const grid = {};
const grid_size = [target[0] + 1, target[1] + 1];

class Region {
    constructor(pos) {
        this.pos = pos;
        this.geo_idx = geologic_index(pos[0], pos[1]);
        this.ero_lvl = erosion_level(this.geo_idx);
        this.type = this.ero_lvl % 3;

        // this.from = null;
    }
}

function geologic_index(x, y) {
    if (y == target[1] && x == target[0]) return 0;
    if (y == 0) return x * 16807;
    if (x == 0) return y * 48271;

    return grid[[x - 1, y]].ero_lvl * grid[[x, y - 1]].ero_lvl;
}

function erosion_level(gi) {
    return (gi + depth) % 20183;
}

function add_row() {
    grid_size[1] += 1;  // Keeping track, just like .size
    for (let x = 0; x < grid_size[0]; x++)
        grid[[x, grid_size[1] - 1]] = new Region([x, grid_size[1] - 1]);
}

function add_col() {
    grid_size[0] += 1;  // Keeping track, just like .size
    for (let y = 0; y < grid_size[1]; y++)
        grid[[grid_size[0] - 1, y]] = new Region([grid_size[0] - 1, y]);
}

const region = [".", "=", "|"]

// Generate the map!
// let total = 0;
grid_size[1] = 0;
for (let y = 0; y <= target[1] + 0; y++) {
    // for (let y = 0; y <= target[1] + 800; y++) {
    add_row();
    // for (let x = 0; x <= target[0] + 0; x++) {
    // for (let x = 0; x <= target[0] + 800; x++) {
    //     grid[[x, y]] = new Region([x, y])
    //     total += grid[[x, y]].type

    //     // if (y == 0 && x == 0) process.stdout.write("M");
    //     // else if (y == target[1] && x == target[0]) process.stdout.write("T");
    //     // else process.stdout.write(region[grid[[x, y]].type]);
    // }
    // console.log();
}
// console.log(`TOTAL: ${total}`);
// console.log(`GRID SIZE: ${grid_size}`);
// console.log(grid);

DIRS = [[0, 1], [-1, 0], [1, 0], [0, -1]]  // Uses [x,y]
TOOL_COMPAT = [[1, 2], [0, 1], [0, 2]]  // 0 = neither, 1 = climbing, 2 = torch

function h(c, n) {
    return Math.abs(c[0] - n[0]) + Math.abs(c[1] - n[1]);  // Manhattan distance.
}

class QState {
    constructor(pos, tool) {
        this.pos = pos;
        this.tool = tool;
    }
}

const openSet = [];

// function openSet_has(pos) {
//     for (let i = 0; i < openSet.length; i++) {
//         if (openSet[i].pos == pos) return true;
//     }
//     return false;
// }

const start_pos = [0, 0];

// This needs more in the state, other than just pos, since tools are relevant.
MinMaxHeap.push(openSet, [0, new QState(start_pos, 2)]);

// grid[start_pos].tool = 2;
// grid[target].tool = 2;

const gScore = {}
// gScore[start_pos] = 0;
gScore[[start_pos[0], start_pos[1], 2]] = 0;
const fScore = {}
// fScore[start_pos] = h(start_pos, target);
fScore[[start_pos[0], start_pos[1], 2]] = h(start_pos, target);

let pri = 0;
while (openSet.length > 0) {
    const next_curr = MinMaxHeap.pop(openSet);
    pri = next_curr[0];
    const curr = next_curr[1];
    const c_key = [curr.pos[0], curr.pos[1], curr.tool];  // For the gScore and fScore key.

    console.log(`LOOP[${pri}] POS[${curr.pos}] TOOL[${curr.tool}] Q.SIZE[${openSet.length}]`)

    // if (curr.pos[0] == target[0] && curr.pos[1] == target[1]) {
    //     let curr_min = pri;
    //     if (curr.tool !== 2) curr_min += 7;
    //     console.log(`FINISHED??? DIST[${pri}] FSC[${fScore[c_key]}] GSC[${gScore[c_key]}] POS[${curr.pos}] TAR[${target}] TOOL[${curr.tool}]`);
    //     // break;
    // }
    if (curr.pos[0] == target[0] && curr.pos[1] == target[1] && curr.tool == 2) {
        // console.log("FINISHED:", pri, curr);
        break;
    }

    for (let dir of DIRS) {
        const n_pos = [curr.pos[0] + dir[0], curr.pos[1] + dir[1]];
        if (n_pos[0] < 0 || n_pos[1] < 0) continue;

        // Create neighbor, if they don't exist already...
        if (!grid.hasOwnProperty([n_pos[0], 0])) add_col();
        if (!grid.hasOwnProperty([0, n_pos[1]])) add_row();
        if (DEBUG) console.log(`\tNEIGHBOR: ${n_pos} ${JSON.stringify(grid[n_pos])}`);

        let new_tool = curr.tool;
        let distance = 1
        // Check region type against current equipment to augment distance, if required
        // Do I need to also check path with alternate tool, even if we have the right one?
        if (!TOOL_COMPAT[grid[n_pos].type].includes(curr.tool)) {
            distance += 7;
            new_tool = TOOL_COMPAT[grid[n_pos].type][0];
            if (!TOOL_COMPAT[grid[curr.pos].type].includes(new_tool)) new_tool = TOOL_COMPAT[grid[n_pos].type][1];
        }

        const n_key = [n_pos[0], n_pos[1], new_tool];

        let tentative_gScore = gScore[c_key] + distance;

        if (DEBUG) console.log(`\tGSCORES: ${tentative_gScore} vs ${gScore[n_key]}`);
        if (!gScore.hasOwnProperty(n_key) || tentative_gScore < gScore[n_key]) {
            // grid[n_pos].from = curr.pos;

            gScore[n_key] = tentative_gScore;
            fScore[n_key] = tentative_gScore + h(n_pos, target);

            let new_state = new QState(n_pos, new_tool);
            if (DEBUG) console.log(`\tADDING: ${JSON.stringify(new_state)}`);
            // MinMaxHeap.push(openSet, [gScore[n_key], new_state]);
            MinMaxHeap.push(openSet, [fScore[n_key], new_state]);
        }
    }
}

// let path_pos = target;
// console.log("PATH:");
// while (path_pos != start_pos) {
//     console.log(grid[path_pos]);
//     path_pos = grid[path_pos].from;
// }

console.log(`TOTAL: ${pri}`);