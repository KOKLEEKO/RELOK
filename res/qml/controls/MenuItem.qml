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

GridLayout {
    id: gridLayout
    property list<Item> extras
    default property Component controlComponent: null
    property Component detailsComponent: null
    property var control: null
    property var details: null
    property var extraControls: extraGrid ? extraGrid.children : null
    property var extraGrid: null
    property alias text: label.text
    property real in_line_implicit_width: 0

    rowSpacing: 0
    Layout.rightMargin: 25
    columnSpacing: 0
    flow: (in_line_implicit_width > scrollView.availableWidth) ? GridLayout.TopToBottom
                                                               : GridLayout.LeftToRight
    Title {
        id: label
        horizontalAlignment: Title.AlignLeft
        heading: headings.h3
    }
    Component {
        id: extrasGrid
        GridLayout {
            property real maximumWidth: 0
            children: extras  // @disable-check M16 @disable-check M31
            onChildrenChanged: {  // @disable-check M16 @disable-check M31
                for (var index in children) {
                    var childWidth = children[index].width
                    if (maximumWidth < childWidth)
                        maximumWidth = childWidth
                }
            }
            columns: parent.parent.flow === GridLayout.TopToBottom ?
                         Math.max(Math.floor(parent.parent.width/maximumWidth), 1) : -1
        }
    }
    Loader {
        active: extras.length > 0
        Layout.fillWidth: parent.flow === GridLayout.TopToBottom
        Layout.alignment: parent.flow === GridLayout.LeftToRight ? Qt.AlignRight : Qt.AlignLeft
        sourceComponent: extrasGrid
        onLoaded: extraGrid = item
    }
    Loader { sourceComponent: controlComponent; onLoaded: control = item }
    Loader {
        sourceComponent: detailsComponent
        Layout.fillWidth: true
        Layout.row: controlComponent && flow === GridLayout.LeftToRight ? 1 : 3
        Layout.columnSpan: 2
        onLoaded: details = item
    }
    Component.onCompleted: {
        in_line_implicit_width = Math.max(label.implicitWidth, label.Layout.minimumWidth) +
                ( control ? control.implicitWidth : extraGrid ? extraGrid.implicitWidth : 0 )
    }
}
