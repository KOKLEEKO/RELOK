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

import "qrc:/js/Helpers.js" as Helpers

PositionSelector {
    delegate:
        Frame {
        readonly property int buttonIndex: index
        readonly property string text: qsTranslate("PositionSelector", modelData)
        Layout.fillHeight: true
        Layout.fillWidth: true
        contentItem: ColumnLayout {
            Text {
                color: (index === 2 && parent.parent.checked) ? palette.brightText : palette.buttonText
                text: parent.parent.text
                Layout.alignment: Qt.AlignCenter
            }
            RowLayout {
                Layout.fillWidth: true
                Repeater {
                    model: [ QT_TR_NOOP("Left"), QT_TR_NOOP("Center"), QT_TR_NOOP("Right") ]
                    RadioButton {
                        readonly property int positionIndex: index + 3 * buttonIndex
                        enabled: Helpers.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
                        text: qsTr(modelData)
                        checked: wordClock.accessories[positionIndex] === name
                        ButtonGroup.group: radioGroup
                        onClicked: activate(positionIndex)
                    }
                }
            }
        }
    }
}
