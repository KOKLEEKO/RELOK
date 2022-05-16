/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

import "../Helpers.js" as Helpers

Picker {
    id: control
    from: -2.3
    to: 4.9
    value: 1
    stepSize: .1
    Component.onCompleted: {
        baseColorChanged.connect(valueChanged)
        valueChanged.connect(() => selectedColor = Helpers.applyColorFactor(baseColor, value))
        valueChanged()
    }
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight/2 - height/2
        implicitWidth: 200
        implicitHeight: 8
        width: control.availableWidth
        height: implicitHeight
        radius: implicitWidth/2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0;   color: Helpers.applyColorFactor(baseColor,from) }
            GradientStop { position: 0.25;color: Helpers.applyColorFactor(baseColor,(3*from+to)/4) }
            GradientStop { position: 0.5; color: Helpers.applyColorFactor(baseColor,(from+to)/2) }
            GradientStop { position: 0.75;color: Helpers.applyColorFactor(baseColor,(from+3*to)/4) }
            GradientStop { position: 1;   color: Helpers.applyColorFactor(baseColor,to) }
        }
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
    }
}
