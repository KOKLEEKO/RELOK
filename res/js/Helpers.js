/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
.pragma library

var isMobile = isEqual(Qt.platform.os, "android", "ios")
var isIos = Qt.platform.os === "ios"
var isAndroid = Qt.platform.os === "android"
var isWebAssembly = Qt.platform.os === "wasm"

function createStringArrayWithPadding (min, size, step, targetLength = 2, padString = '0') {
    return new Array(size).fill()
    .map((element, index) => (index*step + min).toString().padStart(targetLength, padString))
}

function createTable(rows, columns, defaultValue) {
    return new Array(rows).fill().map(() => new Array(columns).fill(defaultValue))
}

var welcomeTable = null;
function createWelcomeTable() {
    if (welcomeTable === null) {
        welcomeTable = createTable(10, 11, false)
        welcomeTable[0][0] = true
        welcomeTable[0][1] = true
        welcomeTable[0][2] = true
        welcomeTable[0][3] = true
        welcomeTable[0][4] = true
        welcomeTable[0][6] = true
        welcomeTable[0][7] = true
        welcomeTable[0][8] = true
        welcomeTable[0][9] = true
        welcomeTable[0][10] = true

        welcomeTable[1][0] = true
        welcomeTable[1][1] = true
        welcomeTable[1][9] = true
        welcomeTable[1][10] = true

        welcomeTable[2][0] = true
        welcomeTable[2][1] = true
        welcomeTable[2][9] = true
        welcomeTable[2][10] = true

        welcomeTable[2][0] = true
        welcomeTable[2][1] = true
        welcomeTable[2][9] = true
        welcomeTable[2][10] = true

        welcomeTable[3][0] = true
        welcomeTable[3][1] = true
        welcomeTable[3][9] = true
        welcomeTable[3][10] = true

        welcomeTable[4][0] = true
        welcomeTable[4][1] = true
        welcomeTable[4][3] = true
        welcomeTable[4][4] = true
        welcomeTable[4][5] = true
        welcomeTable[4][6] = true
        welcomeTable[4][7] = true
        welcomeTable[4][9] = true
        welcomeTable[4][10] = true

        welcomeTable[5][0] = true
        welcomeTable[5][1] = true
        welcomeTable[5][3] = true
        welcomeTable[5][4] = true
        welcomeTable[5][5] = true
        welcomeTable[5][6] = true
        welcomeTable[5][7] = true
        welcomeTable[5][9] = true
        welcomeTable[5][10] = true

        welcomeTable[6][0] = true
        welcomeTable[6][1] = true
        welcomeTable[6][9] = true
        welcomeTable[6][10] = true

        welcomeTable[7][0] = true
        welcomeTable[7][1] = true
        welcomeTable[7][9] = true
        welcomeTable[7][10] = true

        welcomeTable[8][0] = true
        welcomeTable[8][1] = true
        welcomeTable[8][9] = true
        welcomeTable[8][10] = true

        welcomeTable[9][0] = true
        welcomeTable[9][1] = true
        welcomeTable[9][2] = true
        welcomeTable[9][3] = true
        welcomeTable[9][4] = true
        welcomeTable[9][6] = true
        welcomeTable[9][7] = true
        welcomeTable[9][8] = true
        welcomeTable[9][9] = true
        welcomeTable[9][10] = true
    }
    return welcomeTable;
}

function createUndefinedMethod(object, name, ...args) {
    Object.defineProperty(object, name, { value: (args) => unimplementedMethodWarning(name) });
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

function isEqual(value, ...args) {
    for (var arg of args) {
        if (value === arg) {
            return true
        }
    }
    return false
}

//from https://css-tricks.com/converting-color-spaces-in-javascript/
function hexToHSL(H) {
  // Convert hex to RGB first
  let r = 0, g = 0, b = 0;
  if (H.length === 4) {
    r = "0x" + H[1] + H[1];
    g = "0x" + H[2] + H[2];
    b = "0x" + H[3] + H[3];
  } else if (H.length === 7) {
    r = "0x" + H[1] + H[2];
    g = "0x" + H[3] + H[4];
    b = "0x" + H[5] + H[6];
  }
  // Then to HSL
  r /= 255;
  g /= 255;
  b /= 255;
  let cmin = Math.min(r,g,b),
      cmax = Math.max(r,g,b),
      delta = cmax - cmin,
      h = 0,
      s = 0,
      l = 0;

  if (delta === 0)
    h = 0;
  else if (cmax === r)
    h = ((g - b) / delta) % 6;
  else if (cmax === g)
    h = (b - r) / delta + 2;
  else
    h = (r - g) / delta + 4;

  h = Math.round(h * 60)/360;

  if (h < 0)
    h += 1;

  l = (cmax + cmin) / 2;
  s = delta === 0 ? 0 : delta / (1 - Math.abs(2 * l - 1));

  return {"hue": h, "saturation" :s, "lightness": l}
}

