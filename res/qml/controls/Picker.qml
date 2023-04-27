/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

Slider {
    id: control
    property real hue
    property real saturation
    property real lightness
    property color selected_color
    enum Factors { Saturation, Lightness }
    ToolTip {
        visible: pressed
        text: qsTr("%L1 %").arg((Math.round(value*1000)/10).toFixed(1)) + DeviceAccess.emptyString
    }
    from: 0
    to: 1
    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: palette.toolTipBase
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
        Rectangle {
            width: parent.width*.6
            height: width
            color: selected_color
            radius: width/2
            anchors.centerIn: parent
            border.color: parent.border.color
        }
    }
}
