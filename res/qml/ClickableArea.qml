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

QtQuick.Item
{
    property bool isFullCircle: true
    readonly property int pieMenuEndAngle: isFullCircle ? -180 : (isLeftHanded ? 1 : -1) * 105
    readonly property int pieMenuStartAngle: isFullCircle ? 180 : (isLeftHanded ? -1 : 1) * 195

    anchors.fill: parent

    QtQuick.TapHandler
    {
        longPressThreshold: 0.3 //s

        onDoubleTapped: HelpersJS.updateVisibility(root)
        onGrabChanged: (transition, point) => {
                           isFullCircle = (point.event.device.pointerType !== QtQuick.PointerDevice.Finger)
                       }
        onLongPressed: pieMenu.popup(point.position.x, point.position.y)
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
            iconSource: "qrc:/assets/speech.svg"
            visible: DeviceAccess.managers.speech.enabled
            onTriggered: DeviceAccess.managers.speech.say(wordClock.written_time)
        }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/notify_%1.svg".arg(wordClock.speech_enabled ? "off" : "on")
            visible: DeviceAccess.managers.speech.enabled
            onTriggered: DeviceAccess.managers.persistence.setValue("Speech/enabled", wordClock.speech_enabled ^= true)
        }
        QtExtras.MenuItem
        {
            iconSource: "qrc:/assets/fullscreen_%1.svg".arg(isFullScreen ? "off" : "on")
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
