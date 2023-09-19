/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import "." as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.Picker
{
    id: colorHuePicker

    property var stops: []
    readonly property int steps: 15

    background: QtQuick.Rectangle
    {
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
        gradient: QtQuick.Gradient { orientation: QtQuick.Gradient.Horizontal; stops: colorHuePicker.stops }
        height: implicitHeight
        implicitHeight: 8
        implicitWidth: 200
        radius: implicitWidth/2
        width: colorHuePicker.availableWidth
        x: colorHuePicker.leftPadding
        y: colorHuePicker.topPadding + colorHuePicker.availableHeight/2 - height/2
    }

    QtQuick.Component.onCompleted:
    {
        saturationChanged.connect(valueChanged);
        lightnessChanged.connect(valueChanged);
        valueChanged.connect(() =>
                             {
                                 hue = value;
                                 selected_color = Qt.hsla(hue, saturation, lightness, 1);
                             });
    }

    QtQuick.Instantiator
    {
        delegate: QtQuick.GradientStop { position: index/(colorHuePicker.steps-1) }
        model: steps

        onObjectAdded: { object.color = Qt.hsla(object.position,1,.5,1); colorHuePicker.stops.push(object); }
    }
}
