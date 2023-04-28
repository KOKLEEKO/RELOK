import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "." as Controls

Controls.MenuItem {
    id: menuItem
    property string name
    Switch {}
    model: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
    delegate:
        Button {
        readonly property int buttonIndex: index
        readonly property bool isHide: buttonIndex === model.length -1
        text: qsTr(modelData)
        autoExclusive: false
        Layout.fillHeight: true
        Layout.fillWidth: true
        display: Button.TextOnly
        background: Rectangle {
            color: (index === 2 && parent.checked) ? palette.dark : palette.button
            implicitWidth: 100
            implicitHeight: 40
        }
        contentItem: ColumnLayout {
            Text {
                color: (index === 2 && parent.parent.checked) ? palette.brightText : palette.buttonText
                text: parent.parent.text
                Layout.alignment: Qt.AlignCenter
            }
            Loader {
                active: index !== 2
                Layout.fillWidth: true
                sourceComponent:
                    RowLayout {
                    Repeater {
                        model: [ QT_TR_NOOP("Left"), QT_TR_NOOP("Center"), QT_TR_NOOP("Right") ]
                        RadioButton {
                            //Layout.fillWidth: true
                            text: qsTr(modelData)
                            checked: (wordClock["%1DisplayMode".arg(name)] === buttonIndex &&
                                      wordClock["%1Alignment".arg(name)] === index)
                            onToggled: {
                                wordClock["%1DisplayMode".arg(name)] = buttonIndex
                                wordClock["%1Alignment".arg(name)] = index
                            }
                        }
                    }
                }
            }
        }
        checked: wordClock["%1DisplayMode".arg(name)] === buttonIndex
        onClicked: if (index === 2) { wordClock["%1DisplayMode".arg(name)] = buttonIndex }
    }
}
