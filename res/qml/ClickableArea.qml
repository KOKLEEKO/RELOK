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
import QtQuick.Extras.Private.CppUtils 1.0 as CppUtils

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
        onGrabChanged: (transition, point) =>
                       {
                           isFullCircle = (point.event.device.pointerType !== QtQuick.PointerDevice.Finger);
                       }
        onLongPressed:
        {
            if (welcomePopup.opened)
            {
                welcomePopup.close();
            }
            pieMenu.popup(point.position.x, point.position.y);
        }
    }

    QtExtras.PieMenu
    {
        id: pieMenu

        // This is a hack to fix an issue in wasm/safari
        readonly property real selectionAngle: -Math.atan2(width/2 - __protectedScope.selectionPos.x,
                                                           height/2 - __protectedScope.selectionPos.y)
        property int hoveredIndex

        function isMouseOver(itemIndex)
        {
            if (__style == null)
                return false;

            // Our mouse angle's origin is north naturally, but the section angles need to be
            // altered to have their origin north, so we need to remove the alteration here in order to compare properly.
            // For example, section 0 will start at -1.57, whereas we want it to start at 0.
            var sectionStart = __protectedScope.sectionStartAngle(itemIndex) + Math.PI / 2;
            var sectionEnd = __protectedScope.sectionEndAngle(itemIndex) + Math.PI / 2;

            var selAngle = selectionAngle;
            var isWithinOurAngle = false;

            if (sectionStart > CppUtils.MathUtils.pi2)
            {
                sectionStart %= CppUtils.MathUtils.pi2;
            }
            else if (sectionStart < -CppUtils.MathUtils.pi2)
            {
                sectionStart %= -CppUtils.MathUtils.pi2;
            }

            if (sectionEnd > CppUtils.MathUtils.pi2)
            {
                sectionEnd %= CppUtils.MathUtils.pi2;
            }
            else if (sectionEnd < -CppUtils.MathUtils.pi2)
            {
                sectionEnd %= -CppUtils.MathUtils.pi2;
            }

            // If the section crosses the -180 => 180 wrap-around point (from atan2),
            // temporarily rotate the section so it doesn't.
            if (sectionStart > Math.PI)
            {
                var difference = sectionStart - Math.PI;
                selAngle -= difference;
                sectionStart -= difference;
                sectionEnd -= difference;
            }
            else if (sectionStart < -Math.PI)
            {
                difference = Math.abs(sectionStart - (-Math.PI));
                selAngle += difference;
                sectionStart += difference;
                sectionEnd += difference;
            }

            if (sectionEnd > Math.PI)
            {
                difference = sectionEnd - Math.PI;
                selAngle -= difference;
                sectionStart -= difference;
                sectionEnd -= difference;
            }
            else if (sectionEnd < -Math.PI)
            {
                difference = Math.abs(sectionEnd - (-Math.PI));
                selAngle += difference;
                sectionStart += difference;
                sectionEnd += difference;
            }

            // If we moved the mouse past -180 or 180, we need to move it back within,
            // without changing its actual direction.
            if (selAngle > Math.PI)
            {
                selAngle = selAngle - CppUtils.MathUtils.pi2;
            }
            else if (selAngle < -Math.PI)
            {
                selAngle += CppUtils.MathUtils.pi2;
            }

            if (sectionStart > sectionEnd)
            {
                isWithinOurAngle = selAngle >= sectionEnd && selAngle < sectionStart;
            }
            else
            {
                isWithinOurAngle = selAngle >= sectionStart && selAngle < sectionEnd;
            }

            var x1 = width / 2;
            var y1 = height / 2;
            var x2 = __protectedScope.selectionPos.x;
            var y2 = __protectedScope.selectionPos.y;
            var distanceFromCenter = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2);
            var cancelRadiusSquared = __style.cancelRadius * __style.cancelRadius;
            var styleRadiusSquared = __style.radius * __style.radius;
            var isWithinOurRadius = distanceFromCenter >= cancelRadiusSquared
                    && distanceFromCenter < styleRadiusSquared;
            return isWithinOurAngle && isWithinOurRadius;
        }

        triggerMode: QtExtras.TriggerMode.TriggerOnRelease
        style: QtExtras.PieMenuStyle { startAngle: pieMenuStartAngle; endAngle: pieMenuEndAngle }

        onSelectionAngleChanged: {
            hoveredIndex = parseInt(-1, 10);
            for (var i = 0; i < __protectedScope.visibleItems.length; ++i)
            {
                if (isMouseOver(i))
                {
                    hoveredIndex = i;
                }
            }
            __protectedScope.currentIndex = hoveredIndex;
        }

        QtQuick.Component.onCompleted:
        {
            __protectedScope.currentIndex = parseInt(-1, 10)
            __protectedScope.currentIndexChanged.connect(() =>
                                                         {
                                                             if (__protectedScope.currentIndex !== hoveredIndex)
                                                             {
                                                                 __protectedScope.currentIndex = hoveredIndex;
                                                             }
                                                         })
        }

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
            onTriggered:
            {
                DeviceAccess.managers.persistence.setValue("Speech/enabled", wordClock.speech_enabled ^= true)
            }
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
