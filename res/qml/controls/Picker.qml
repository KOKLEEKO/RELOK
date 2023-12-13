/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

QtControls.Slider
{
    id: control

    property real hue
    property real saturation
    property real lightness
    property color selected_color

    enum Factors { Saturation, Lightness }

    from: 0
    to: 1
    handle: QtQuick.Rectangle
    {
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
        color: palette.toolTipBase
        implicitHeight: 26
        implicitWidth: 26
        radius: 13
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        QtQuick.Rectangle
        {
            anchors.centerIn: parent
            border.color: parent.border.color
            color: selected_color
            height: width
            radius: width/2
            width: parent.width*.6
        }
    }

    QtControls.ToolTip
    {
        text: qsTr("%L1 %").arg((Math.round(value*1000)/10).toFixed(1)) + DeviceAccess.managers.translation.emptyString
        visible: pressed
        y: -control.height + height/2
    }
}
