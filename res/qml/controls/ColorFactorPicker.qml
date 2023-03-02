/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/js/Helpers.js" as Helpers

Picker {
    id: control
    function getColor(hue, position) {
        switch (factorType) {
        case Picker.Factors.Saturation:
            return Qt.hsla(hue, position, lightness, 1)
        case Picker.Factors.Lightness:
            return Qt.hsla(hue, saturation, position, 1)
        default:
            return Qt.hsla(hue, saturation, lightness, 1)
        }
    }

    required property int factorType
    Component.onCompleted: {
        hueChanged.connect(valueChanged)
        if (factorType === Picker.Factors.Saturation) {
            lightnessChanged.connect(valueChanged)
        } else if (factorType === Picker.Factors.Lightness) {
            saturationChanged.connect(valueChanged)
        }

        valueChanged.connect(() => selected_color = getColor(hue, value))
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
            GradientStop { position: 0;     color: getColor(hue, 0) }
            GradientStop { position: 0.25;  color: getColor(hue, .25) }
            GradientStop { position: 0.5;   color: getColor(hue, .5) }
            GradientStop { position: 0.75;  color: getColor(hue, .75) }
            GradientStop { position: 1;     color: getColor(hue, 1) }
        }
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
    }
}
