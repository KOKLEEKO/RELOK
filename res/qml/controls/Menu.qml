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
    default property alias contentItem: menuSections.children
    property url icon
    property var collapsed: null
    property alias scrollView: scrollView
    property Component footer: null
    Title {
        id: title
        horizontalAlignment: Title.AlignHCenter
        heading: headings.h1
        Layout.alignment: Qt.AlignTop
        mouseArea.enabled: true
        mouseArea.onClicked: collapsed ? collapsed.is_collapsed = true : { }
    }
    ScrollView {
        id: scrollView
        Layout.fillHeight: true
        Layout.fillWidth: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true
        Item {
            width: scrollView.availableWidth
            height: scrollView.availableHeight
            implicitHeight: menuSections.implicitHeight
            ColumnLayout { id: menuSections; anchors.fill: parent }
        }
    }
    Loader { sourceComponent: footer; Layout.fillWidth: true }
}
