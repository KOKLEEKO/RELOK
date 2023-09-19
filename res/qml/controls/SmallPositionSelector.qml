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

import DeviceAccess 1.0

import "." as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.PositionSelector
{
    delegate: QtControls.Frame
    {
        readonly property int buttonIndex: index
        readonly property string text: qsTranslate("PositionSelector", modelData) +
                                       DeviceAccess.managers.translation.emptyString

        QtLayouts.Layout.fillHeight: true
        QtLayouts.Layout.fillWidth: true
        contentItem: QtLayouts.ColumnLayout
        {
            QtLayouts.Layout.fillWidth: true

            QtQuick.Text
            {
                QtLayouts.Layout.alignment: Qt.AlignCenter
                color: (index === 2 && parent.parent.checked) ? palette.brightText : palette.buttonText
                text: parent.parent.text
            }
            QtQuick.Flow
            {
                width: parent.parent.parent.width

                QtQuick.Repeater
                {
                    model: [ QT_TR_NOOP("Left"), QT_TR_NOOP("Center"), QT_TR_NOOP("Right") ]

                    QtControls.RadioButton
                    {
                        readonly property int positionIndex: index + 3 * buttonIndex

                        QtControls.ButtonGroup.group: radioGroup
                        checked: wordClock.accessories[positionIndex] === name
                        enabled: HelpersJS.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
                        text: qsTr(modelData) + DeviceAccess.managers.translation.emptyString

                        onClicked: positionSelectorJS.activate(positionIndex)
                    }
                }
            }
        }
    }
}
