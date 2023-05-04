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

import "." as Controls

ColumnLayout {
    id: gridLayout
    default property Component controlComponent: null
    property Component delegate: null
    property list<Item> extras
    property string details: ""
    property string title: ""
    property var model: []
    readonly property bool isModelValid: Number.isInteger(model) ? model : !!model.length

    property var control: null
    property var extraControls: extraGrid ? extraGrid.children : null
    property var extraGrid: null
    property bool withRadioGroup: false
    property var radioGroup: null

    Layout.fillWidth: true
    Layout.rightMargin: 25
    spacing: 0

    Loader { active: withRadioGroup; onLoaded: radioGroup = item; sourceComponent: ButtonGroup {} }

    GridLayout {
        property real inLineWidth: 0
        flow: (inLineWidth + parent.Layout.rightMargin > scrollView.availableWidth) ? GridLayout.TopToBottom
                                                                                    : GridLayout.LeftToRight
        Layout.fillHeight: true
        Layout.fillWidth: true
        Title { id: label; text: title; Layout.fillWidth: true; heading: headings.h3 }
        Loader { sourceComponent: controlComponent; onLoaded: control = item }
        Component.onCompleted: inLineWidth = label.implicitWidth + rowSpacing + (control ? control.implicitWidth: 0)
    }
    Loader {
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width
        active: isModelValid || !!extras.length
        onLoaded: extraGrid = item
        sourceComponent: Flow {
            spacing: 5
            Component.onCompleted: children = extras
            Loader {
                active: isModelValid
                sourceComponent: Repeater {
                    model: gridLayout.model
                    delegate: gridLayout.delegate
                    onItemAdded: extras.push(item)
                }
            }
        }
    }
    Loader { active: !!details.length; Layout.fillWidth: true; sourceComponent: Controls.Details { text: details } }
}
