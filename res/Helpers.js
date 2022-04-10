.pragma library

function createStringArrayWithPadding (min, size, step, targetLength = 2, padString = '0') {
    return new Array(size).fill()
    .map((element, index) => (index*step + min).toString().padStart(targetLength, padString))
}
function createTable(rows, columns, defaultValue) {
    return new Array(rows).fill().map(() => new Array(columns).fill(defaultValue))
}

function createUndefinedMethod(object, name, ...args) {
    Object.defineProperty(object, name, {value: (args) => unimplementedMethodWarning(name) });
}

function unimplementedMethodWarning (name) {
    console.warn(`[${name}] not implemented`)
}

function inRange (min, value, max) {
    return (min <= value && value <= max)
}

function missingLetters(table) {
    var missingLetters = new Array(26).fill().map((element, index) => String.fromCharCode(index+65))
    var availableSpot = 0;
    const rows = table.length
    for (var row = 0; row < rows; ++row) {
        const columns = table[row].length
        for (var column = 0; column < columns; ++column) {
            const letter = table[row][column]
            if (letter === " ") {
                availableSpot++;
            } else {
                const index = missingLetters.indexOf(letter);
                if (index !== -1) {
                  missingLetters.splice(index, 1);
                }
            }
        }
    }
    console.log(missingLetters, availableSpot)
}