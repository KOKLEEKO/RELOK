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
    readonly property real h0: Math.round(h4 * 2.00)
    readonly property real h1: Math.round(h4 * 1.60)
    readonly property real h2: Math.round(h4 * 1.30)
    readonly property real h3: Math.round(h4 * 1.10)
    readonly property real h4: GeneralFont ? GeneralFont.pointSize : 12
    readonly property real p1: Math.round(h4 * 0.65)
    readonly property real p2: Math.round(h4 * 0.55)
}
