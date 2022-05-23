import QtQuick.Controls 2.15

Button {
    property string tooltip
    required property string name
    display: Button.IconOnly
    flat: true
    icon.source: "qrc:/assets/%1.svg".arg(name)
    implicitWidth: implicitHeight
    ToolTip.visible: hovered && tooltip
    ToolTip.text: tooltip
}
