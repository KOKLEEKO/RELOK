/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15

Text {
    property bool isOn
    height: cell_width*.4
    color: isOn ? on_color : off_color
    style: isOn ? Text.Outline : Text.Sunken
    styleColor: isOn ? Qt.lighter(on_color, 1.1) : Qt.darker(background_color, 1.1)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    fontSizeMode: Text.Fit
    minimumPointSize: 2
    font { pointSize: 32; kerning: false; preferShaping: false }
}
