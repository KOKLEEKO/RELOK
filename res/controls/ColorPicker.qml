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

import "../Helpers.js" as Helpers

Picker {
    id: control
    property ListModel colors: MaterialColors { }
    readonly property int steps: colors.count
    property var stops: []
    property real factor: 1
    from: 0
    to: steps-1
    value: 0
    stepSize: 1
    Component.onCompleted: {
        factorChanged.connect(valueChanged)
        valueChanged.connect(() => {
                                 baseColor = colors.get(value).color;
                                 selectedColor = Helpers.applyColorFactor(baseColor, factor)
                             })
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
        model: control.colors
        delegate: GradientStop { position: index/(control.steps-1) }
        onObjectAdded: { object.color = model.get(index).color; control.stops.push(object) }
    }
}
