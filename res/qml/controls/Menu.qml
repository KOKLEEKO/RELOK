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

import "qrc:/qml/controls" as Controls

QtLayouts.ColumnLayout
{
    default property alias contentItem: menuSections.children
    property MenuSection collapsed: null
    property QtQuick.Component footer: null
    property alias label: label
    property alias scrollView: scrollView
    property string title
    property url icon

    QtLayouts.RowLayout
    {
        QtLayouts.Layout.rightMargin: 20

        Title
        {
            id: label

            QtLayouts.Layout.alignment: Qt.AlignTop
            QtLayouts.Layout.fillWidth: true
            fontSizeMode: Title.HorizontalFit
            heading: headings.h1
            horizontalAlignment: Title.AlignHCenter
            minimumPointSize: heading.h2 + 1
            mouseArea.enabled: true
            mouseArea.onClicked: collapsed ? collapsed.is_collapsed = true : { }
            text: title
        }
        IconButton { name: "close"; onClicked: settingsPanel.close() }
    }
    QtControls.ScrollView
    {
        id: scrollView

        QtControls.ScrollBar.vertical.policy: (collapsed && !collapsed.is_collapsed && !collapsed.is_tipMe)
                                              ? QtControls.ScrollBar.AlwaysOn
                                              : QtControls.ScrollBar.AsNeeded
        QtLayouts.Layout.fillHeight: true
        QtLayouts.Layout.fillWidth: true
        clip: true
        //palette {
        //  /* tribute to Qt (https://brand.qt.io/design)*/
        //  midlight: "#cecfd5"
        //  dark: "#41cd52"
        //  button: "#cecfd5"
        //}

        QtQuick.Item
        {
            width: scrollView.availableWidth
            height: scrollView.availableHeight
            implicitHeight: menuSections.implicitHeight
            QtLayouts.ColumnLayout { id: menuSections; anchors.fill: parent }  // @disable-check M16  @disable-check M31
        }
    }
    QtQuick.Loader { sourceComponent: footer; QtLayouts.Layout.fillWidth: true }
}
