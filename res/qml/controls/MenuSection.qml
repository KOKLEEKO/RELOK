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
    property string text
    property alias title: title
    property alias menuItems: menuItems
    default property alias contentItem: menuItems.children
    property url icon
    property bool is_collapsed: is_collapsable
    property bool is_collapsable: true
    spacing: 20
        Title {
        id: title
        text: (is_collapsed ? "▶︎": "▼") + " " + parent.text
        horizontalAlignment: Title.AlignLeft
        heading: headings.h2
        mouseArea.enabled: is_collapsable
        mouseArea.onClicked: {
            if (is_collapsed) {
                collapsed ? collapsed.is_collapsed = true : { }
                collapsed = title.parent
            }
            is_collapsed ^= true
        }
    }
    GridLayout {
        id: menuItems
        flow: GridLayout.TopToBottom
        clip: true
        opacity: is_collapsed? .0 : 1.
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.maximumHeight: is_collapsed ? 0 : implicitHeight
        layer.enabled: true
        Behavior on Layout.maximumHeight { NumberAnimation { duration: 300 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }
}
