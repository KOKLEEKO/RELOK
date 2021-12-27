/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Label {
    property alias mouseArea: mouseArea
    required property int heading
    Layout.fillWidth: true
    elide: Text.ElideRight
    font { bold: true; pointSize: heading; family: TitleFont }
    maximumLineCount: 2
    wrapMode: Text.WordWrap
    verticalAlignment: Text.AlignVCenter
    MouseArea {
        id: mouseArea
        enabled: false
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: (hoverEnabled && containsMouse) ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
