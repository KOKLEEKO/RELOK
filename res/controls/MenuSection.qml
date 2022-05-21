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

ColumnLayout {
    property alias text: title.text
    property alias title: title
    property alias menuItems: menuItems
    default property alias contentItem: menuItems.children
    property url icon
    property bool isCollapsed: isCollapsable
    property bool isCollapsable: true
    Title {
        id: title
        horizontalAlignment: Title.AlignLeft
        heading: headings.h2
        mouseArea.enabled: isCollapsable
        mouseArea.onClicked: {
            if (isCollapsed) {
                collapsed ? collapsed.isCollapsed = true : { }
                collapsed = title.parent
            }
            isCollapsed ^= true
        }
    }
    GridLayout {
        id: menuItems
        flow: GridLayout.TopToBottom
        clip: true
        opacity: isCollapsed? .0 : 1.
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.maximumHeight: isCollapsed ? 0 : implicitHeight
        layer.enabled: true
        Behavior on Layout.maximumHeight { NumberAnimation { duration: 300 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }
}
