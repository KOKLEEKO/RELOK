/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

QtQuick.Rectangle
{
    id: notificationBar

    readonly property int easingType: QtQuick.Easing.InOutQuad

    function show(text = "")
    {
        label.text = text;
        showAnimation.start();
    }

    anchors.centerIn: root.contentItem
    height: 0
    width: 0

    QtControls.Label { id: label; anchors.centerIn: parent }

    QtQuick.SequentialAnimation
    {
        id: showAnimation

        QtQuick.ParallelAnimation
        {
            QtQuick.PropertyAction
            {
                target: label
                property: "opacity"
                value: 1
            }
            QtQuick.PropertyAction
            {
                target: notificationBar
                property: "width"
                value: parent.width
            }
            QtQuick.PropertyAction
            {
                target: notificationBar
                property: "height"
                value: 50
            }
        }
        QtQuick.PauseAnimation { duration: 1250 }
        QtQuick.ParallelAnimation
        {
            QtQuick.NumberAnimation
            {
                target: label
                property: "opacity"
                to: 0
                duration: 125
                easing.type: easingType
            }
            QtQuick.NumberAnimation
            {
                target: notificationBar
                property: "height"
                to: 1
                duration: 250
                easing.type: easingType
            }
        }
        QtQuick.ParallelAnimation
        {
            QtQuick.NumberAnimation
            {
                target: notificationBar
                property: "width"
                to: 0
                duration: 250
                easing.type: easingType
            }
            QtQuick.NumberAnimation
            {
                target: notificationBar
                property: "height"
                to: 0
                duration: 250
                easing.type: easingType
            }
        }
    }
}
