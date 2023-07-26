/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

QtQuick.Text
{
    property bool isOn

    color: isOn ? on_color : off_color
    font { pointSize: 32; kerning: false; preferShaping: false }
    font.family: SmallestReadableFont
    fontSizeMode: QtQuick.Text.VerticalFit
    height: cell_width*.4
    horizontalAlignment: QtQuick.Text.AlignHCenter
    minimumPointSize: 1
    style: isOn ? QtQuick.Text.Outline : QtQuick.Text.Sunken
    styleColor: isOn ? Qt.lighter(on_color, 1.1) : Qt.darker(background_color, 1.1)
    verticalAlignment: QtQuick.Text.AlignVCenter
    width: contentWidth
}
