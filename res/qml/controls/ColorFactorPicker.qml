/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS

Picker
{
    id: colorFactorPicker

    required property int factorType

    function getColor(hue, position)
    {
        switch (factorType) {
        case Picker.Factors.Saturation:
            return Qt.hsla(hue, position, lightness, 1)
        case Picker.Factors.Lightness:
            return Qt.hsla(hue, saturation, position, 1)
        default:
            return Qt.hsla(hue, saturation, lightness, 1)
        }
    }

    background: QtQuick.Rectangle
    {
        border.color: visualFocus ? palette.highlight
                                  : enabled ? palette.mid : palette.midlight
        gradient: QtQuick.Gradient
        {
            orientation: QtQuick.Gradient.Horizontal

            QtQuick.GradientStop { position: 0;     color: getColor(hue, 0)   }
            QtQuick.GradientStop { position: 0.25;  color: getColor(hue, .25) }
            QtQuick.GradientStop { position: 0.5;   color: getColor(hue, .5)  }
            QtQuick.GradientStop { position: 0.75;  color: getColor(hue, .75) }
            QtQuick.GradientStop { position: 1;     color: getColor(hue, 1)   }
        }
        height: implicitHeight
        implicitHeight: 8
        implicitWidth: 200
        radius: implicitWidth/2
        width: colorFactorPicker.availableWidth
        x: colorFactorPicker.leftPadding
        y: colorFactorPicker.topPadding + colorFactorPicker.availableHeight/2 - height/2
    }

    QtQuick.Component.onCompleted:
    {
        hueChanged.connect(valueChanged)
        if (factorType === Picker.Factors.Saturation)
            lightnessChanged.connect(valueChanged)
        else if (factorType === Picker.Factors.Lightness)
            saturationChanged.connect(valueChanged)
        valueChanged.connect(() => selected_color = getColor(hue, value))
        valueChanged()
    }
}
