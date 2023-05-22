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
    property Component detailsComponent: null
    property var details: null
    property alias label: label
    property string title
    property url icon
    default property alias contentItem: menuItems.children
    property alias menuItems: menuItems
    property bool is_collapsable: true
    property bool is_collapsed: is_collapsable
    property bool is_tipMe: false
    property bool show_detailsComponent: false

    spacing: 20
    Title {
        id: label
        text: (is_collapsed ? "▷": "▽") + " " + title
        horizontalAlignment: Title.AlignLeft
        heading: headings.h2
        mouseArea.enabled: is_collapsable
        mouseArea.onClicked: {
            if (is_collapsed) {
                collapsed ? collapsed.is_collapsed = true : { }
                collapsed = label.parent
            }
            is_collapsed ^= true
        }
    }
    GridLayout {
        id: menuItems
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.maximumHeight: is_collapsed ? 0 : implicitHeight
        clip: true  // @disable-check M16 @disable-check M31
        flow: GridLayout.TopToBottom
        layer.enabled: true  // @disable-check M16 @disable-check M31
        opacity: is_collapsed? .0 : 1.  // @disable-check M16 @disable-check M31
        Behavior on Layout.maximumHeight { NumberAnimation { duration: 300 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }  // @disable-check M16 @disable-check M31
    }
    Loader {
        active: show_detailsComponent
        Layout.fillWidth: true
        Layout.maximumHeight: is_collapsed ? 0 : implicitHeight
        layer.enabled: true  // @disable-check M16 @disable-check M31
        opacity: is_collapsed? .0 : 1.  // @disable-check M16 @disable-check M31
        sourceComponent: detailsComponent
        onLoaded: details = item
        Behavior on Layout.maximumHeight { NumberAnimation { duration: 300 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }  // @disable-check M16 @disable-check M31
    }
}
