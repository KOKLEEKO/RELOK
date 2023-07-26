/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

QtControls.Label
{
    property alias mouseArea: mouseArea
    required property int heading

    QtLayouts.Layout.fillWidth: true
    elide: QtControls.Label.ElideRight
    font { bold: true; pointSize: heading }
    maximumLineCount: 2
    verticalAlignment: QtControls.Label.AlignVCenter
    wrapMode: QtControls.Label.WordWrap

    QtQuick.MouseArea
    {
        id: mouseArea

        anchors.fill: parent
        cursorShape: (hoverEnabled && containsMouse) ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: false
        hoverEnabled: true
    }
}
