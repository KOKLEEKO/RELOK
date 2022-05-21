import QtQuick 2.15

import "languages"
import "Helpers.js" as Helpers

Rectangle {
    function selectLanguage(language){
        if (language !== "") {
            language_url = "qrc:/languages/%1.qml".arg(language)
            selectedLanguage = language
            if (DeviceAccess.settingsValue("Appearance/language") !== language)
                DeviceAccess.setSettingsValue("Appearance/language", language)
        }
    }
    function detectAndUseDeviceLanguage() {
        let iso = Qt.locale().name.substring(0,2)
        let language = languages[iso].toLowerCase()
        selectLanguage(language)
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
    property var languages: {"en": "English", "fr": "French", "es": "Spanish"}
    property string selectedLanguage
    // User-facing Settings
    property url language_url

    property bool enable_special_message: true
    property bool enable_stay_awake: false
    property bool enable_guided_access: false
    property int minimum_battery_level: 50

    property color background_color: "black"
    property color on_color: "red"
    property color off_color: "grey"

    // Internal Settings
    readonly property real tableWidth: Math.min(height, width)*.9
    readonly property real cellWidth: tableWidth/columns
    readonly property real dot_size: cellWidth/4
    property Language language
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
    property var onoff_table: Helpers.createWelcomeTable()
    property var tmp_onoff_table: Helpers.createTable(rows, columns, false)

    color: background_color
    anchors.fill: parent
    Component.onCompleted: {
        selectLanguage(DeviceAccess.settingsValue("Appearance/language", ""))
        language_urlChanged.connect(() => {
                                        if (time) {
                                            previous_hours_array_index= -1
                                            previous_minutes_array_index= -1
                                            tmp_onoff_table = Helpers.createTable(rows, columns, false)
                                            timeChanged()
                                        }
                                    })
        timeChanged.connect(updateTable)
        if (language_url == "")
            detectAndUseDeviceLanguage()
    }
    Connections {
        target: DeviceAccess
        function onOrientationChanged() { orientationChangedSequence.start() }
    }
    Loader { source: language_url; onLoaded: language = item }
    Timer { interval: 1000; running: true; repeat: false; onTriggered: timer.start() }
    Timer {
        id: timer
        property bool isDebug: false
        property int fake_counter: 0
        property bool jumpToMinute: false
        property bool jumpTo5Minutes: false
        property bool jumpToHour: false
        readonly property int dayToMs: 86400000
        readonly property int minuteToMs:60000
        property int timeReference
        interval: 1000
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            if (isDebug) {
                if (!timeReference) {
                    timeReference = new Date().setTime(Math.random()*dayToMs)
                }
                time = new Date(timeReference +
                                (jumpToMinute + jumpTo5Minutes*5 + jumpToHour*60)*
                                fake_counter*minuteToMs)
                .toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
                fake_counter++;
            } else {
                time = new Date().toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
            }
        }
    }
    Image { id: backgroundImage; anchors.fill: parent }
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
                        style: isEnabled ? Text.Outline : Text.Sunken
                        styleColor: isEnabled ? Qt.lighter(on_color, 1.1)
                                              : Qt.darker(background_color, 1.5)
                        horizontalAlignment : Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        minimumPointSize: 8
                        font { pointSize: 72; kerning: false; preferShaping: false }
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
