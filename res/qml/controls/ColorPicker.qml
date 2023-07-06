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

MenuItem
{
    property color selected_color: extraControls[0].selected_color
    required property string name

    extras: [
        ColorHuePicker {},
        ColorFactorPicker
        {
            factorType: Picker.Factors.Saturation
            hue: parent.children[0].hue
            lightness: parent.children[0].lightness

            QtQuick.Component.onCompleted: { onMoved.connect(() => parent.children[0].saturation = value); moved() }
        },
        ColorFactorPicker
        {
            factorType: Picker.Factors.Lightness
            hue: parent.children[0].hue
            saturation: parent.children[0].saturation

            QtQuick.Component.onCompleted: { onMoved.connect(() => parent.children[0].lightness = value); moved() }
        },
        ColorHexField
        {
            huePicker: parent.children[0]
            saturationPicker: parent.children[1]
            lightnessPicker: parent.children[2]
        }
    ]

    QtQuick.Component.onCompleted:
    {
        control.clicked.connect(() => extraControls[3].setColor(parent.parent["default_%1".arg(name)]))
        selected_colorChanged.connect(
                    () => {
                        wordClock[name] = selected_color
                        DeviceAccess.managers.persistence.setValue("Appearance/%1".arg(name),
                                                                   selected_color.toString().toUpperCase())
                    })
    }

    QtControls.Button { text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString }
}
