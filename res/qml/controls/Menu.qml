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

import "qrc:/qml/controls" as Controls

ColumnLayout {
    property alias label: label
    property string title
    default property alias contentItem: menuSections.children
    property url icon
    property MenuSection collapsed: null
    property alias scrollView: scrollView
    property Component footer: null
    RowLayout {
        Layout.rightMargin: 20
        Title {
            id: label
            text: title
            horizontalAlignment: Title.AlignHCenter
            heading: headings.h1
            Layout.alignment: Qt.AlignTop
            mouseArea.enabled: true
            mouseArea.onClicked: collapsed ? collapsed.is_collapsed = true : { }
        }
        IconButton { name: "close"; onClicked: settingPanel.close() }
    }
    ScrollView {
        id: scrollView
        Layout.fillHeight: true
        Layout.fillWidth: true
        ScrollBar.vertical.policy: (collapsed && !collapsed.is_collapsed && !collapsed.is_tipMe) ? ScrollBar.AlwaysOn
                                                                                                 : ScrollBar.AsNeeded
        clip: true
        //palette {
        //  /* tribute to Qt (https://brand.qt.io/design)*/
        //  midlight: "#cecfd5"
        //  dark: "#41cd52"
        //  button: "#cecfd5"
        //}

        Item {
            width: scrollView.availableWidth
            height: scrollView.availableHeight
            implicitHeight: menuSections.implicitHeight
            ColumnLayout { id: menuSections; anchors.fill: parent }  // @disable-check M16  @disable-check M31
        }
    }
    Loader { sourceComponent: footer; Layout.fillWidth: true }
}
