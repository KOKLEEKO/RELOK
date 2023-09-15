/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.MenuSection
{
    readonly property string default_on_color: "#F00"
    readonly property string default_off_color: "#888"
    readonly property string default_background_color: "#000"

    function applyColors()
    {
        activatedLetterColorPicker.extraControls[3].setColor(
                    DeviceAccess.managers.persistence.value("Colors/on_color", default_on_color))
        deactivatedLetterColorPicker.extraControls[3].setColor(
                    DeviceAccess.managers.persistence.value("Colors/off_color", default_off_color))

        if (backgroundColorPicker.active) {
            backgroundColorPicker.extraControls[3].setColor(
                        DeviceAccess.managers.persistence.value("Colors/background_color", default_background_color))
        }
    }

    title: qsTr("Colors") + DeviceAccess.managers.translation.emptyString

    QtQuick.Component.onCompleted: wordClock.applyColors.connect(applyColors)

    Controls.ColorPicker
    {
        id: activatedLetterColorPicker

        title: qsTr("Activated Letter Color") + DeviceAccess.managers.translation.emptyString
        name: "on_color"
        details: qsTr("The color can be set in HSL (Hue, Saturation, Lightness) or in hexadecimal format.") +
                 DeviceAccess.managers.translation.emptyString
    }
    Controls.ColorPicker
    {
        id: deactivatedLetterColorPicker

        title: qsTr("Deactivated Letter Color") + DeviceAccess.managers.translation.emptyString
        name: "off_color"
    }
    Controls.ColorPicker
    {
        id: backgroundColorPicker

        active: HelpersJS.isDesktop || HelpersJS.isWasm
        title: qsTr("Background Color") + DeviceAccess.managers.translation.emptyString
        name: "background_color"
    }
}
