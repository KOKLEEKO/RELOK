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

import "." as Controls

Controls.MenuItem
{
    property color selected_color: extraControls ? extraControls[0].selected_color : "black"
    required property string name

    extras: [
        Controls.ColorHuePicker {},
        Controls.ColorFactorPicker
        {
            factorType: Controls.ColorFactorPicker.Factors.Saturation
            hue: parent ? parent.children[0].hue : 0
            lightness: parent ? parent.children[0].lightness : 0

            QtQuick.Component.onCompleted:
            {
                onMoved.connect(() =>
                                {
                                    if (parent)
                                    {
                                        parent.children[0].saturation = value;
                                    }
                                });
                moved();
            }
        },
        Controls.ColorFactorPicker
        {
            factorType: Controls.ColorFactorPicker.Factors.Lightness
            hue: parent ? parent.children[0].hue : 0
            saturation: parent ? parent.children[0].saturation : 0

            QtQuick.Component.onCompleted:
            {
                onMoved.connect(() =>
                                {
                                    if (parent)
                                    {
                                        parent.children[0].lightness = value;
                                    }
                                });
                moved();
            }
        },
        Controls.ColorHexField
        {
            huePicker: parent ? parent.children[0] : null
            saturationPicker: parent ? parent.children[1] : null
            lightnessPicker: parent ? parent.children[2] : null
        }
    ]

    onLoaded:
    {
        control.clicked.connect(() => extraControls[3].setColor(parent.parent["default_%1".arg(name)]));
        selected_colorChanged.connect(
                    () =>
                    {
                        wordClock[name] = selected_color;
                        DeviceAccess.managers.persistence.setValue("Colors/%1".arg(name),
                                                                   selected_color.toString().toUpperCase());
                    });
    }

    QtControls.Button { text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString }
}
