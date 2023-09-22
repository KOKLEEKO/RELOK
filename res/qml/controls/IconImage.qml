/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtGraphicalEffects 1.12 as QtGraphicalEffects
import QtQuick 2.15 as QtQuick

QtQuick.Item
{
    property alias source: image.source
    property alias color: colorOverlay.color

    height: width

    QtQuick.Image
    {
        id: image

        smooth: true
        sourceSize: Qt.size(parent.width, parent.height)
        visible: false
    }

    QtGraphicalEffects.ColorOverlay
    {
        id: colorOverlay

        anchors.fill: image
        source: image
    }
}
