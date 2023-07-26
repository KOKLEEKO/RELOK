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

QtQuick.Loader
{
    id: menuItem

    default property QtQuick.Component controlComponent: null
    property QtControls.ButtonGroup radioGroup: null
    property QtQuick.Component delegate: null
    property QtQuick.Flow extraGrid: null
    property bool withRadioGroup: false
    property list<QtQuick.Item> extras
    property string details
    property string title
    property var control: null
    property var extraControls: extraGrid ? extraGrid.children : null
    property var model: []
    readonly property bool isModelValid: Number.isInteger(model) ? model : !!model.length

    QtLayouts.Layout.fillWidth: true
    QtLayouts.Layout.rightMargin: 25
    sourceComponent: QtLayouts.ColumnLayout
    {
        spacing: 0

        QtQuick.Loader
        {
            active: withRadioGroup
            sourceComponent: QtControls.ButtonGroup { }

            onLoaded: radioGroup = item
        }
        QtLayouts.GridLayout
        {
            property real inLineWidth: 0

            QtLayouts.Layout.fillHeight: true
            QtLayouts.Layout.fillWidth: true
            flow: (inLineWidth + parent.QtLayouts.Layout.rightMargin > scrollView.availableWidth)
                  ? QtLayouts.GridLayout.TopToBottom
                  : QtLayouts.GridLayout.LeftToRight


            QtQuick.Component.onCompleted: inLineWidth = label.implicitWidth + rowSpacing +
                                           (control ? control.implicitWidth: 0)

            Title { id: label; QtLayouts.Layout.fillWidth: true; heading: headings.h3; text: title }
            QtQuick.Loader { sourceComponent: controlComponent; onLoaded: control = item }
        }
        QtQuick.Loader
        {
            QtLayouts.Layout.fillWidth: true
            QtLayouts.Layout.preferredWidth: parent.width
            active: isModelValid || !!extras.length
            sourceComponent: QtQuick.Flow
            {
                spacing: 5

                QtQuick.Loader
                {
                    active: isModelValid
                    sourceComponent: QtQuick.Repeater
                    {
                        delegate: menuItem.delegate
                        model: menuItem.model

                        onItemAdded: extras.push(item)
                    }
                }

                QtQuick.Component.onCompleted: children = extras
            }
            onLoaded: extraGrid = item
        }
        QtQuick.Loader
        {
            QtLayouts.Layout.fillWidth: true
            active: !!details.length
            sourceComponent: Details { text: details }
        }
    }
}
