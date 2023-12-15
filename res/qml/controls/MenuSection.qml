/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Layouts 1.15 as QtLayouts

import "." as Controls

QtLayouts.ColumnLayout
{
    default property alias contentItem: menuItems.children
    property QtQuick.Component detailsComponent: null
    property alias label: label
    property alias menuItems: menuItems
    property bool is_collapsable: true
    property bool is_collapsed: is_collapsable
    property bool is_tipMe: false
    property bool show_detailsComponent: false
    property string title
    property url icon
    property var details: null
    property bool subMenu: false

    Controls.Title
    {
        id: label

        text: (is_collapsed ? "▷": "▽") + " " + title
        horizontalAlignment: Controls.Title.AlignLeft
        heading: headings.h2
        mouseArea.enabled: is_collapsable
        mouseArea.onClicked:
        {
            if (is_collapsed && !subMenu)
            {
                collapsed ? collapsed.is_collapsed = true : { };
                collapsed = label.parent;
            }
            is_collapsed ^= true;
        }
    }
    QtLayouts.GridLayout
    {
        id: menuItems

        QtLayouts.Layout.alignment: Qt.AlignHCenter
        QtLayouts.Layout.fillWidth: true
        QtLayouts.Layout.maximumHeight: is_collapsed ? 0 : implicitHeight
        clip: true  // @disable-check M16 @disable-check M31
        flow: QtLayouts.GridLayout.TopToBottom
        layer.enabled: true  // @disable-check M16 @disable-check M31
        opacity: is_collapsed ? .0 : 1.  // @disable-check M16 @disable-check M31

        QtQuick.Behavior on QtLayouts.Layout.maximumHeight { QtQuick.NumberAnimation { duration: 300 } }
        QtQuick.Behavior on opacity { QtQuick.NumberAnimation { duration: 200 } }  // @disable-check M16 @disable-check M31
    }
    QtQuick.Loader
    {
        active: show_detailsComponent
        QtLayouts.Layout.fillWidth: true
        QtLayouts.Layout.maximumHeight: is_collapsed ? 0 : implicitHeight
        layer.enabled: true  // @disable-check M16 @disable-check M31
        opacity: is_collapsed ? .0 : 1.  // @disable-check M16 @disable-check M31
        sourceComponent: detailsComponent
        onLoaded: details = item

        QtQuick.Behavior on QtLayouts.Layout.maximumHeight { QtQuick.NumberAnimation { duration: 300 } }
        QtQuick.Behavior on opacity { QtQuick.NumberAnimation { duration: 200 } }  // @disable-check M16 @disable-check M31
    }
}
