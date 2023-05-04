import QtQuick 2.15
import QtQuick.Controls 2.15

import "." as Controls
import "qrc:/js/Helpers.js" as Helpers

Controls.MenuItem {
    function hide(notify = true) {
        if (activatedPositionIndex !== -1 && wordClock.accessories[activatedPositionIndex] === name) {
            wordClock.accessories[activatedPositionIndex] = ""
            if (isMinutes && activatedPositionIndex === 0) {
                wordClock.accessories[2] = ""
                wordClock.accessories[3] = ""
                wordClock.accessories[5] = ""
            }
            if (notify) {
                wordClock.accessoriesChanged()
                activatedPositionIndex = -1
            }
        }
    }
    function activate(positionIndex, isMinutes) {
        if (activatedPositionIndex !== positionIndex) {
            hide(false)
            wordClock.accessories[positionIndex] = name
            if (isMinutes && positionIndex === 0) {
                wordClock.accessories[2] = name
                wordClock.accessories[3] = name
                wordClock.accessories[5] = name
            }
            wordClock.accessoriesChanged()
            activatedPositionIndex = positionIndex
        }
    }
    readonly property bool isMinutes: name === "minutes"
    required property string name
    property int activatedPositionIndex: -1
    property var positions: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom") ]
    withRadioGroup: true
    RadioButton {
        text: qsTr("Hide")
        checked: activatedPositionIndex == -1
        ButtonGroup.group: radioGroup
        onClicked: hide()
    }
    Component.onCompleted: {
        if (isMinutes)
            positions.unshift(QT_TR_NOOP("Around"))
        model = positions
    }
    delegate:
        RadioButton {
        readonly property int positionIndex: isMinutes ? Math.floor(Math.pow(4, index - 1)) : Math.pow(4, index)
        enabled: isMinutes && positionIndex == 0 ? Helpers.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
                                                  && Helpers.isStrictlyEqual(wordClock.accessories[positionIndex],
                                                                             wordClock.accessories[2],
                                                                             wordClock.accessories[3],
                                                                             wordClock.accessories[5])
                                                : Helpers.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
        text: qsTr(modelData)
        checked: wordClock.accessories[positionIndex] === name
        ButtonGroup.group: radioGroup
        onClicked: activate(positionIndex, isMinutes)
    }
}
