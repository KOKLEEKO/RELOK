/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

QtQuick.QtObject
{
    readonly property real h0: Math.round(p1 * 2.25)
    readonly property real h1: Math.round(p1 * 2.00)
    readonly property real h2: Math.round(p1 * 1.75)
    readonly property real h3: Math.round(p1 * 1.50)
    readonly property real h4: Math.round(p1 * 1.25)
    readonly property real p1: GeneralFont ? GeneralFont.pointSize : 12
    readonly property real p2: Math.round(p1 * 0.75)
}

