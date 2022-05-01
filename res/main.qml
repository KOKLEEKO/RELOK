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
                break
            case "fr":
                language_url = "qrc:/french.qml"
                break
            default:
            case "en":
                language_url = "qrc:/english.qml"
                break
            }
        }
    }

    function updateTable() {
        const split_time = time.split(':')
        var hours_value = split_time[0]
        const minutes_value = split_time[1]
        var is_AM = (split_time[2] === "am")
        const is_special = enable_special_message &&
                         (hours_value[0] === hours_value[1]) &&
                         (hours_value === minutes_value)
        if (minutes_value >= 35) {
            if (++hours_value >= 24)
                is_AM ^= true
        }
        hours_array_index = hours_value % 12
        minutes_array_index = Math.floor(minutes_value/5)
        const tmp_onoff_dots = minutes_value % 5
        console.debug(time,
                      language.written_time(hours_array_index, minutes_array_index, is_AM),
                      tmp_onoff_dots)
        if (was_special)
            language.special_message(false)
        if (is_special)
            language.special_message(true)
        if (previous_hours_array_index !== hours_array_index) {
            if (previous_hours_array_index !== -1)
                language["hours_" + hours_array[previous_hours_array_index]](false, was_AM)
            was_AM = is_AM
            if (!is_special) {
                language["hours_" + hours_array[hours_array_index]](true, is_AM)
                previous_hours_array_index = hours_array_index
            }
        }
        if (previous_minutes_array_index !== minutes_array_index) {
            if (previous_minutes_array_index !== -1)
                language["minutes_" + minutes_array[previous_minutes_array_index]](false)
            if (!is_special) {
                language["minutes_" + minutes_array[minutes_array_index]](true)
                previous_minutes_array_index = minutes_array_index
            }
        }
        was_special = is_special

        //update table and dots at the same time
        onoff_table = tmp_onoff_table
        onoff_dots = tmp_onoff_dots
    }

    property url language_url
    property Language language
    readonly property color background_color: "black"
    readonly property color on_color: "red"
    readonly property color off_color: "grey"
    readonly property real tableWidth: Math.min(height, width)*9/10
    readonly property real cellWidth: tableWidth/columns
    readonly property real dot_size: cellWidth/4
    property bool enable_special_message: true

    property string time
    property bool was_AM
    property bool was_special: false
    property int onoff_dots: 0
    property int previous_hours_array_index: -1
    property int hours_array_index: 0
    readonly property int hours_array_step: 1
    readonly property int hours_array_min: 0
    readonly property int hours_array_max: 11
    readonly property int hours_array_size: ((hours_array_max - hours_array_min)/
                                             hours_array_step) + 1
    readonly property var hours_array: Helpers.createStringArrayWithPadding(hours_array_min,
                                                                            hours_array_size,
                                                                            hours_array_step)
    property int previous_minutes_array_index: -1
    property int minutes_array_index: 0
    readonly property int minutes_array_step: 5
    readonly property int minutes_array_min: 0
    readonly property int minutes_array_max: 55
    readonly property int minutes_array_size: ((minutes_array_max - minutes_array_min)/
                                               minutes_array_step) + 1
    readonly property var minutes_array: Helpers.createStringArrayWithPadding(minutes_array_min,
                                                                              minutes_array_size,
                                                                              minutes_array_step)
    readonly property int columns: 11
    readonly property int rows: 10
    property var onoff_table: Helpers.createWelcomeTable(rows, columns, false)
    property var tmp_onoff_table: Helpers.createTable(rows, columns, false)

    width: 640
    height: 480
    minimumWidth: 180
    minimumHeight: minimumWidth
    visible: true
    visibility: Window.AutomaticVisibility
    color: background_color
    Component.onCompleted: { timeChanged.connect(updateTable); detectAndUseDeviceLanguage() }

    Loader { source: language_url; onLoaded: language = item }
    Timer {
        interval: 1000
        running: true
        repeat: false
        onTriggered: timer.start()
    }
    Timer {
        id: timer
        property bool isDebug: false
        property int fake_counter: 0
        property bool jumpToMinute: false
        property bool jumpTo5Minutes: false
        property bool jumpToHour: false
        readonly property int dayToMs: 86400000
        readonly property int minuteToMs:60000
        readonly property int reference: new Date().setTime(Math.random()*dayToMs)
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            if (isDebug) {
                time = new Date(reference +
                                (jumpToMinute + jumpTo5Minutes*5 + jumpToHour*60)*
                                fake_counter*minuteToMs)
                .toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
                fake_counter++;
            } else {
                time = new Date().toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
            }
        }
    }

    Connections {
        target: DeviceAccess
        function onOrientationChanged() { orientationChangedSequence.start() }
    }
    MouseArea {
        property point pressedPoint
        anchors.fill: parent
        onPressed: pressedPoint = Qt.point(mouseX, mouseY)
        onReleased:{
            if (mouseX === pressedPoint.x && mouseY === pressedPoint.y)
                DeviceAccess.toggleStatusBarVisibility()
        }
        onPositionChanged: {
            DeviceAccess.setBrigthnessDelta(2*(pressedPoint.y - mouseY)/root.height)
        }
    }

    Column {
        id: column
        anchors.centerIn: parent
        width: tableWidth
        height: width
        SequentialAnimation {
            id: orientationChangedSequence
            PropertyAction { target: column; property:"opacity"; value: 0 }
            PauseAnimation { duration: 500 }
            OpacityAnimator { target: column; duration: 500; from: 0; to: 1 }
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
                        width: cellWidth
                        height: width
                        text: modelData
                        color: isEnabled ? on_color : off_color
                        style: isEnabled ? Text.Outline : Text.Normal
                        styleColor: Qt.lighter(color, 4/3)
                        horizontalAlignment : Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        minimumPointSize: 8
                        font {
                            pointSize: 72
                            kerning: false
                            preferShaping: false
                        }
                    }
                }
            }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: cellWidth - dot_size
            topPadding: spacing/2
            Repeater {
                model: 4
                Rectangle {
                    readonly property bool isEnabled: (index+1 <= onoff_dots)
                    color: isEnabled ? on_color : off_color
                    width: dot_size
                    height: width
                    radius: width/2
                }
            }
        }
    }
}
