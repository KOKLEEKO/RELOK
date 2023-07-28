/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 1.4 as QtExtras
import QtQuick.Controls.Styles 1.4 as QtExtras
import QtQuick.Extras 1.4 as QtExtras

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.MouseArea
{
    property bool isLeftHanded: false
    property bool isFullCircle: HelpersJS.isDesktop || HelpersJS.isWasm
    readonly property int pieMenuStartAngle: isFullCircle ? 180 : (isLeftHanded ? 1 : -1) * 195
    readonly property int pieMenuEndAngle: isFullCircle ? -180 : (isLeftHanded ? -1 : 1) * 105

    anchors.fill: parent

    onPressed: pressAndHoldTimer.start()
    onReleased: pressAndHoldTimer.stop()

    QtQuick.Timer
    {
        id: pressAndHoldTimer
        interval: 300
        onTriggered: pieMenu.popup(parent.mouseX, parent.mouseY)
    }
    QtExtras.PieMenu
    {
        id: pieMenu

        triggerMode: QtExtras.TriggerMode.TriggerOnRelease
        style: QtExtras.PieMenuStyle { startAngle: pieMenuStartAngle; endAngle: pieMenuEndAngle }

        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/share.svg"
            visible: DeviceAccess.managers.shareContent.enabled
            onTriggered: shareTimer.start()
        }
        QtExtras.MenuItem { iconSource: "qrc:/assets/settings.svg"; onTriggered: settingsPanel.open() }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/notify_%1.svg".arg(wordClock.enable_speech ? "off" : "on")
            visible: DeviceAccess.managers.speech.enabled
            onTriggered: DeviceAccess.managers.persistence.setValue("Appearance/speech", wordClock.enable_speech ^= true)
        }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/speech.svg"
            visible: DeviceAccess.managers.speech.enabled
            onTriggered: DeviceAccess.managers.speech.say(wordClock.written_time)
        }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/focus_%1.svg".arg(wordClock.true ? "off" : "on")
            visible: HelpersJS.isMobile
            onTriggered: {}
        }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/fullscreen_%1.svg".arg(isFullScreen ? "off" : "on")
            visible: !HelpersJS.isWasm
            onTriggered: HelpersJS.updateVisibility(root)
        }
    }
    QtQuick.Timer
    {
        id: shareTimer
        interval: 300
        onTriggered: DeviceAccess.managers.shareContent.screenshot(wordClock)
    }
}
