import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "." as Controls
import "qrc:/js/Helpers.js" as Helpers

Controls.MenuItem {
    function hide(notify = true) {
        if (activatedPositionIndex !== -1 && wordClock.accessories[activatedPositionIndex] === name) {
            wordClock.accessories[activatedPositionIndex] = ""
            if (notify) {
                wordClock.accessoriesChanged()
                activatedPositionIndex = -1
            }
        }
    }
    function activate(positionIndex) {
        if (activatedPositionIndex !== positionIndex) {
            hide(false)
            wordClock.accessories[positionIndex] = name
            wordClock.accessoriesChanged()
            activatedPositionIndex = positionIndex
        }
    }

    required property string name
    property int activatedPositionIndex: -1
    withRadioGroup: true
    RadioButton { text: qsTr("Hide"); checked: true; ButtonGroup.group: radioGroup; onClicked: hide() }
    model: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom") ]
    delegate:
        Frame {
        readonly property int buttonIndex: index
        readonly property string text: qsTr(modelData)
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
