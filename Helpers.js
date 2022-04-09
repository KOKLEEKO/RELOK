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
