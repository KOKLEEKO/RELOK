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

Controls.MenuItem
{
    property int activatedPositionIndex: -1
    readonly property bool isMinutes: name === "minutes"
    required property string name
    property var positions: [
        QT_TRANSLATE_NOOP("PositionSelector","Top"),
        QT_TRANSLATE_NOOP("PositionSelector","Bottom")
    ]

    function activate(positionIndex)
    {
        if (activatedPositionIndex !== positionIndex)
        {
            hide(false)
            wordClock.accessories[positionIndex] = name
            if (isMinutes && positionIndex === 0)
            {
                wordClock.accessories[2] = name
                wordClock.accessories[3] = name
                wordClock.accessories[5] = name
            }
            notify(positionIndex)
        }
    }
    function hide(shouldNotify = true)
    {
        if (activatedPositionIndex !== -1 && wordClock.accessories[activatedPositionIndex] === name)
        {
            wordClock.accessories[activatedPositionIndex] = ""
            if (isMinutes && activatedPositionIndex === 0)
            {
                wordClock.accessories[2] = ""
                wordClock.accessories[3] = ""
                wordClock.accessories[5] = ""
            }
            if (shouldNotify)
                notify(-1)
        }
    }
    function notify(positionIndex)
    {
        wordClock.accessoriesChanged()
        activatedPositionIndex = positionIndex
        DeviceAccess.managers.persistence.setValue("Accessories/%1".arg(name), positionIndex)
    }

    withRadioGroup: true

    QtQuick.Component.onCompleted:
    {
        if (isMinutes) positions.unshift(QT_TRANSLATE_NOOP("PositionSelector","Around"))
        model = positions
        const positionIndex = DeviceAccess.managers.persistence.value("Accessories/%1".arg(name), isMinutes ? 4 : -1)
        if (positionIndex !== -1) activate(positionIndex)
    }

    QtControls.RadioButton
    {
        QtControls.ButtonGroup.group: radioGroup
        checked: true
        text: qsTr("Hide") + DeviceAccess.managers.translation.emptyString

        onClicked: hide()
    }
}
