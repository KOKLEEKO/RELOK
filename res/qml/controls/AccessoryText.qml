import QtQuick 2.15

Text {
    property bool isOn
    height: cell_width*.4
    color: isOn ? on_color : off_color
    style: isOn ? Text.Outline : Text.Sunken
    styleColor: isOn ? Qt.lighter(on_color, 1.1) : Qt.darker(background_color, 1.1)
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    fontSizeMode: Text.Fit
    minimumPointSize: 2
    font { pointSize: 32; kerning: false; preferShaping: false }
}
