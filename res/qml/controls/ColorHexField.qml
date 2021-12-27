/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/js/Helpers.js" as Helpers

TextField {
    function setColor(text) {
        selectedColor = text
        huePicker.value = selectedColor.hslHue
        huePicker.moved()
        saturationPicker.value = selectedColor.hslSaturation
        saturationPicker.moved()
        lightnessPicker.value = selectedColor.hslLightness
        lightnessPicker.moved()
    }
    required property Picker huePicker
    required property Picker saturationPicker
    required property Picker lightnessPicker
    property color selectedColor
    implicitWidth: 200
    text: huePicker.selected_color.toString().toUpperCase()
    font.pointSize: headings.p1
    horizontalAlignment: TextField.AlignHCenter
    color: acceptableInput ? palette.text : "red"
    validator: RegExpValidator { regExp: /#(?:[0-9a-fA-F]{3}){1,2}$/ }  // @disable-check M16 @disable-check M31
    inputMethodHints: Qt.ImhPreferUppercase | Qt.ImhNoPredictiveText
    selectByMouse: true
    selectedTextColor: "white"
    Component.onCompleted: editingFinished.connect(() => { setColor(text); focus = false })
}
