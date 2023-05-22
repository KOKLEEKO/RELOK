/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/qml/controls" as Controls

Controls.MenuItem {
    function reset() { extraControls[3].setColor(parent.parent["default_%1".arg(name)]) }
    property color selected_color: extraControls[0].selected_color
    required property string name
    Button { text: qsTr("Reset") + DeviceAccess.emptyString }
    extras: [
        Controls.ColorHuePicker {},
        Controls.ColorFactorPicker {
            hue: parent.children[0].hue
            lightness: parent.children[0].lightness
            factorType: Controls.Picker.Factors.Saturation
            Component.onCompleted: { onMoved.connect(() => parent.children[0].saturation = value); moved() }
        },
        Controls.ColorFactorPicker {
            hue: parent.children[0].hue
            saturation: parent.children[0].saturation
            factorType: Controls.Picker.Factors.Lightness
            Component.onCompleted: { onMoved.connect(() => parent.children[0].lightness = value); moved() }
        },
        Controls.ColorHexField {
            huePicker: parent.children[0]
            saturationPicker: parent.children[1]
            lightnessPicker: parent.children[2]
        }
    ]
    Component.onCompleted: {
        control.clicked.connect(reset)
        selected_colorChanged.connect(() => {
                                          wordClock[name] = selected_color
                                          DeviceAccess.setSettingsValue("Appearance/%1".arg(name),
                                                                        selected_color.toString().toUpperCase())
                                      })
    }
}
