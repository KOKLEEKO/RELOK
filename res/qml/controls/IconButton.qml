import QtQuick.Controls 2.15

Button {
    property string tooltip
    property string name: undefined
    display: Button.IconOnly
    flat: true
    icon.source: "qrc:/assets/%1.svg".arg(name)
    implicitWidth: implicitHeight
    ToolTip.visible: hovered && tooltip
    ToolTip.text: tooltip
}
