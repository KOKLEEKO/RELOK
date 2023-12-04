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

import "qrc:/js/Helpers.js" as HelpersJS
import "qrc:/js/PositionSelector.js" as PositionSelectorJS

Controls.MenuItem
{
    property var positionSelectorJS: null

    property int activatedPositionIndex: -1
    readonly property bool isMinutes: name === "minutes"
    required property string name
    property var positions: [
        QT_TRANSLATE_NOOP("PositionSelector","Top"),
        QT_TRANSLATE_NOOP("PositionSelector","Bottom")
    ]

    withRadioGroup: true

    QtQuick.Component.onCompleted: positionSelectorJS = new PositionSelectorJS.Object(this, wordClock, isDebug)

    QtControls.RadioButton
    {
        QtControls.ButtonGroup.group: radioGroup
        checked: true
        text: qsTr("Hide") + DeviceAccess.managers.translation.emptyString

        onClicked: positionSelectorJS.hide()
    }
}
