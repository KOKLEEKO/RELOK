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
    title: qsTr("Accessories") + DeviceAccess.managers.translation.emptyString

    Controls.SmallPositionSelector
    {
        active: DeviceAccess.managers.speech.enabled
        name: "timeReminder"
        title: qsTr("Time Reminder status") + DeviceAccess.managers.translation.emptyString
    }
    Controls.SmallPositionSelector
    {
        active: DeviceAccess.managers.battery.enabled
        name: "batteryLevel"
        title: qsTr("Battery Level display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.LargePositionSelector
    {
        name: "timeZone"
        active: !HelpersJS.isWasm
        title: qsTr("Time Zone display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.SmallPositionSelector
    {
        name: "weekNumber"
        title: qsTr("Week Number display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.LargePositionSelector
    {
        name: "date"
        title: qsTr("Date display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.SmallPositionSelector
    {
        name: "ampm"
        title: qsTr("AM|PM display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.LargePositionSelector
    {
        name: "minutes"
        title: qsTr("4-Dot display mode") + DeviceAccess.managers.translation.emptyString
    }
    Controls.SmallPositionSelector
    {
        name: "seconds"
        title: qsTr("Seconds display mode") + DeviceAccess.managers.translation.emptyString
    }
}
