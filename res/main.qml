import QtQml 2.15
import QtQuick 2.15
import QtQuick.Window 2.15

import "Helpers.js" as Helpers

Window {
    id: root

    function detectAndUseDeviceLanguage() {
        if (language_url == "") {
            switch (Qt.locale().name.substring(0,2)) {
            case "es":
                language_url = "qrc:/spanish.qml"
                break;
            default:
            case "en":
                language_url = "qrc:/english.qml"
                break;
            }
        }
    }

    function updateTable() {
        var splitted_time = time.split(':')
        var hours_value = splitted_time[0]
        const minutes_value = splitted_time[1]
        const tmp_isSpecial = (hours_value === minutes_value)
        if (minutes_value >= 35)
            hours_value++
        hours_array_index = hours_value % 12
        minutes_array_index = Math.floor(minutes_value/5)
        const tmp_onoff_dots = minutes_value % 5
        console.debug(time,
                      language.written_time(hours_array_index, minutes_array_index),
                      tmp_onoff_dots)
        if (tmp_isSpecial) {
            language.special_message(true)
        } else {
            if (previous_hours_array_index !== hours_array_index) {
                if (previous_hours_array_index !== -1)
                    language["hours_" + hours_array[previous_hours_array_index]](false)
                if (!tmp_isSpecial) {
                    language["hours_" + hours_array[hours_array_index]](true)
                    previous_hours_array_index = hours_array_index
                }
            }
            if (previous_minutes_array_index !== minutes_array_index) {
                if (previous_minutes_array_index !== -1)
                    language["minutes_" + minutes_array[previous_minutes_array_index]](false)
                if (!tmp_isSpecial) {
                    language["minutes_" + minutes_array[minutes_array_index]](true)
                    previous_minutes_array_index = minutes_array_index
                }
            }
        }
        if (wasSpecial)
            language.special_message(false)
        wasSpecial = tmp_isSpecial

        //update table and dots at the same time
        onoff_table = tmp_enable_table
        onoff_dots = tmp_onoff_dots
    }

    property url language_url
    property Language language
    readonly property color background_color: "black"
    readonly property color on_color: "red"
    readonly property color off_color: "grey"
    readonly property real dot_size: 10

    property string time
    property bool wasSpecial: false
    property int onoff_dots: 4
    property int previous_hours_array_index: -1
    property int hours_array_index: 0
    readonly property int hours_array_step: 1
    readonly property int hours_array_min: 0
    readonly property int hours_array_max: 11
    readonly property int hours_array_size: ((hours_array_max-hours_array_min)/hours_array_step) + 1
    readonly property var hours_array: Helpers.createStringArrayWithPadding(hours_array_min,
                                                                            hours_array_size,
                                                                            hours_array_step)
    property int previous_minutes_array_index: -1
    property int minutes_array_index: 0
    readonly property int minutes_array_step: 5
    readonly property int minutes_array_min: 0
    readonly property int minutes_array_max: 55
    readonly property int minutes_array_size: ((minutes_array_max-minutes_array_min)/minutes_array_step) + 1
    readonly property var minutes_array: Helpers.createStringArrayWithPadding(minutes_array_min,
                                                                              minutes_array_size,
                                                                              minutes_array_step)
    readonly property int columns: 11
    readonly property int rows: 10
    property var onoff_table: Helpers.createTable(rows, columns, true)
    property var tmp_enable_table: Helpers.createTable(rows, columns, false)

    width: 640
    height: 480
    visible: true
    color: background_color
    Component.onCompleted: {
        timeChanged.connect(updateTable)
        detectAndUseDeviceLanguage()
    }

    Loader {
        active: true
        source: language_url
        onLoaded: language = item
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: time = new Date().toLocaleTimeString(Qt.locale("en_US"), "hh:mm:a")
    }
    Column {
        id: table
        readonly property real horizontalMargin: root.width/4
        readonly property real verticalMargin: root.height/4
        anchors {
            fill: parent
            leftMargin: horizontalMargin
            rightMargin: horizontalMargin
            topMargin: verticalMargin
            bottomMargin: verticalMargin
        }
        Repeater {
            model: language.table
            Row {
                Repeater {
                    id: repeater
                    property int rowIndex: index
                    model: language.table[index]
                    Text {
                        readonly property int rowIndex: repeater.rowIndex
                        readonly property int columnIndex: index
                        readonly property bool isEnabled: onoff_table[rowIndex][columnIndex]
                        width: table.width/columns
                        height: spacer.height
                        text: modelData
                        color: isEnabled ? on_color : off_color
                        style: isEnabled ? Text.Outline : Text.Normal
                        styleColor: Qt.lighter(color, 4/3)
                    }
                }
            }
        }
        Item {id: spacer; height: table.height/(rows+2); width: 1 }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: dot_size
            Repeater {
                model: 4
                Rectangle {
                    readonly property bool isEnabled: index+1 <= onoff_dots
                    color: isEnabled ? on_color : off_color
                    width: dot_size
                    height: width
                    radius: width/2
                }
            }
        }
    }
}
