/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/js/Helpers.js" as Helpers

Picker {
    id: control
    readonly property int steps: 15
    property var stops: []
    Component.onCompleted: {
        saturationChanged.connect(valueChanged)
        lightnessChanged.connect(valueChanged)
        valueChanged.connect(() => { hue = value
                                 /**/selected_color = Qt.hsla(hue, saturation, lightness, 1) })
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
        border.color: visualFocus ? palette.highlight : enabled ? palette.mid : palette.midlight
        gradient: Gradient { orientation: Gradient.Horizontal; stops: control.stops }
    }
    Instantiator {
        model: steps
        delegate: GradientStop { position: index/(control.steps-1) }
        onObjectAdded: { object.color = Qt.hsla(object.position,1,.5,1); control.stops.push(object) }
    }
}
