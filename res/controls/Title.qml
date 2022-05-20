/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Label {
    enum Headings { H0= 40, H1 = 32, H2 = 26, H3 = 22, H4=20, P1=13, P2 = 11 }
    property alias mouseArea: mouseArea
    required property int heading
    Layout.fillWidth: true
    Layout.minimumWidth: 200
    elide: Text.ElideRight
    font { bold: true; pointSize: heading }
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
