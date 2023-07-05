/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import "qrc:/js/Helpers.js" as HelpersJS

QtControls.TextField
{
    property color selectedColor
    required property Picker huePicker
    required property Picker lightnessPicker
    required property Picker saturationPicker

    function setColor(text)
    {
        selectedColor = text
        huePicker.value = selectedColor.hslHue
        huePicker.moved()
        saturationPicker.value = selectedColor.hslSaturation
        saturationPicker.moved()
        lightnessPicker.value = selectedColor.hslLightness
        lightnessPicker.moved()
    }

    color: acceptableInput ? palette.text : "red"
    font.pointSize: headings.p1
    horizontalAlignment: QtControls.TextField.AlignHCenter
    implicitWidth: 200
    inputMethodHints: Qt.ImhPreferUppercase | Qt.ImhNoPredictiveText
    selectByMouse: true
    selectedTextColor: "white"
    text: huePicker.selected_color.toString().toUpperCase()
    validator: QtQuick.RegExpValidator { regExp: /#(?:[0-9a-fA-F]{3}){1,2}$/ }  // @disable-check M16 @disable-check M31

    QtQuick.Component.onCompleted: editingFinished.connect(() => { setColor(text); focus = false })
}
