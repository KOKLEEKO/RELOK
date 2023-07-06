/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
.pragma library

.import QtQuick.Window 2.15 as QtWindow

.import DeviceAccess 1.0 as Global

var isMobile = isWeaklyEqual(Qt.platform.os, "android", "ios")
var isDesktop = isWeaklyEqual(Qt.platform.os, "linux", "osx", "unix", "windows")
var isIos = Qt.platform.os === "ios"
var isAndroid = Qt.platform.os === "android"
var isWasm = Qt.platform.os === "wasm"
var isPurchasing = isWeaklyEqual(Qt.platform.os, "android", "ios", "osx", "windows")

function createStringArrayWithPadding (min, size, step, targetLength = 2, padString = '0')
{
    return new Array(size).fill().map((element, index) =>
                                      (index*step + min).toString().padStart(targetLength, padString))
}

function createUndefinedMethod(object, name, ...args)
{
    Object.defineProperty(object, name, { value: (args) => unimplementedMethodWarning(name) });
}

function unimplementedMethodWarning (name)
{
    console.warn(`[${name}] not implemented`)
}

function inRange (value, min, max)
{
    return (min <= value && value <= max)
}

function clamp(value, min, max)
{
    return Math.max(min, Math.min(value, max))
}

/*
    The following method is used only during development
    to detect which letter can be added to fill the gaps in a table
*/
function missingLetters(table)
{
    var missingLetters = new Array(26).fill().map((element, index) => String.fromCharCode(index+65))
    var availableSpot = 0
    const rows = table.length
    for (var row = 0; row < rows; ++row)
    {
        const columns = table[row].length
        for (var column = 0; column < columns; ++column)
        {
            const letter = table[row][column]
            if (letter === " ")
            {
                ++availableSpot
            }
            else
            {
                const index = missingLetters.indexOf(letter);
                if (index !== -1)
                {
                    missingLetters.splice(index, 1)
                }
            }
        }
    }
    console.log(missingLetters, availableSpot)
}

function toggle(object, propertyName, first, second)
{
    if (object.hasOwnProperty(propertyName))
    {
        object[propertyName] = (object[propertyName] === first ? second : first)
    }
    else
    {
        console.error(`${object} doesn't contain a property named "${propertyName}"`)
    }
}

function isWeaklyEqual(value, ...args)
{
    for (var arg of args)
    {
        if (value === arg)
        {
            return true
        }
    }
    return false
}

function isStrictlyEqual(value, ...args)
{
    for (var arg of args)
    {
        if (value !== arg)
        {
            return false
        }
    }
    return true
}

function listProperties(name, object) {
    for (var prop in object)
        console.info("%1[%2] =".arg(name).arg(prop), object[prop])
}

function updateVisibility(window)
{
    if (isIos)
    {
        Global.DeviceAccess.managers.screenSize.toggleFullScreen()
    }
    else
    {
        toggle(window, "visibility", QtWindow.Window.FullScreen, QtWindow.Window.AutomaticVisibility)
    }
}

function updateDisplayMode(window)
{
    const widgetFlag = (Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint)
    window.flags ^= widgetFlag
    window.isWidget = window.flags & widgetFlag
}
