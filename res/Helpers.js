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

function inRange (value, min, max) {
    return (min <= value && value <= max)
}

function clamp(value, min, max) {
    return Math.max(min, Math.min(value, max))
}

/*
    The following method is used only during development
    to detect which letter can be added to fill the gaps in a table
*/
function missingLetters(table) {
    var missingLetters = new Array(26).fill().map((element, index) => String.fromCharCode(index+65))
    var availableSpot = 0
    const rows = table.length
    for (var row = 0; row < rows; ++row) {
        const columns = table[row].length
        for (var column = 0; column < columns; ++column) {
            const letter = table[row][column]
            if (letter === " ") {
                availableSpot++
            } else {
                const index = missingLetters.indexOf(letter);
                if (index !== -1) {
                    missingLetters.splice(index, 1)
                }
            }
        }
    }
    console.log(missingLetters, availableSpot)
}

function toggle(object, propertyName, first, second) {
    if (object.hasOwnProperty(propertyName))
        object[propertyName] = (object[propertyName] === first ? second : first)
    else
        console.error(`${object} doesn't contain a property named "${propertyName}"`)
}
