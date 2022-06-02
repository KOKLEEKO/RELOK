/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Label {
    Layout.fillWidth: true
    color: palette.windowText
    maximumLineCount: Number.POSITIVE_INFINITY
    wrapMode: Label.WordWrap
    font.pointSize:  headings.p1
}
