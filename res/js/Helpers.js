/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
.pragma library
.import QtQuick.Window 2.15 as QtWindow

var isMobile = isWeaklyEqual(Qt.platform.os, "android", "ios")
var isDesktop = isWeaklyEqual(Qt.platform.os, "linux", "osx", "unix", "windows")
var isIos = Qt.platform.os === "ios"
var isAndroid = Qt.platform.os === "android"
var isWasm = Qt.platform.os === "wasm"
var isPurchasing = isWeaklyEqual(Qt.platform.os, "android", "ios", "osx", "windows")

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
                ++availableSpot
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

function isWeaklyEqual(value, ...args) {
    for (var arg of args) {
        if (value === arg) {
            return true
        }
    }
    return false
}

function isStrictlyEqual(value, ...args) {
    for (var arg of args) {
        if (value !== arg) {
            return false
        }
    }
    return true
}

function listProperties(name, object) {
    for (var prop in object)
        console.info("%1[%2] =".arg(name).arg(prop), object[prop])
}

function updateVisibility(window, DeviceAccess) {
    if (isIos) {
        DeviceAccess.toggleFullScreen()
    } else {
        toggle(window, "visibility", QtWindow.Window.FullScreen, QtWindow.Window.AutomaticVisibility)
    }
}

function updateDisplayMode(window) {
    const widgetFlag = (Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
    window.flags ^= widgetFlag
    window.isWidget = window.flags & widgetFlag
}
