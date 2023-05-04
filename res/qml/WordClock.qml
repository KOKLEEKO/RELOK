import QtQuick 2.15

import "qrc:/qml/languages"
import "qrc:/js/Helpers.js" as Helpers

Rectangle {
    function selectLanguage(language, speech) {
        let fileBaseName = language
        if (!supportedLanguages.includes(fileBaseName)) {
            fileBaseName = (supportedLanguages.includes(fileBaseName.substring(0,2))) ? language.substring(0,2) : "en"
        }
        DeviceAccess.setSpeechLanguage(language)
        const tmp_language_url = "qrc:/qml/languages/%1.qml".arg(fileBaseName)
        if (isDebug)
            console.log(language, supportedLanguages, tmp_language_url)
        language_url = tmp_language_url
        selected_language = language
        if (enable_speech)
            DeviceAccess.say(written_time)
    }
    function detectAndUseDeviceLanguage() {
        selectLanguage(Qt.locale().name)
    }
    function updateTable() {
        const split_time = time.split(':')
        hours_value = split_time[0]
        const minutes_value = split_time[1]
        var isAM = is_AM = (split_time[2] === "am")
        const is_special = enable_special_message &&
                         (hours_value[0] === hours_value[1]) &&
                         (hours_value === minutes_value)
        if (minutes_value >= 35) {
            if (++hours_value % 12 == 0)
                isAM ^= true
        }
        hours_array_index = hours_value % 12
        minutes_array_index = Math.floor(minutes_value/5)
        const tmp_onoff_dots = minutes_value % 5
        written_time = language.written_time(hours_array_index, minutes_array_index, isAM)
                + (tmp_onoff_dots ? ", (+%1)".arg(tmp_onoff_dots) : "")
        if (isDebug)
            console.debug(time, written_time)
        if (enable_speech && (minutes_value % parseInt(speech_frequency) == 0)) {
            DeviceAccess.say(written_time.toLowerCase())
        }
        if (was_special)
            language.special_message(false)
        if (previous_hours_array_index !== hours_array_index || is_special || was_special) {
            if (previous_hours_array_index !== -1)
                language["hours_" + hours_array[previous_hours_array_index]](false, was_AM)
            was_AM = isAM
            if (!is_special) {
                language["hours_" + hours_array[hours_array_index]](true, isAM)
                previous_hours_array_index = hours_array_index
            }
        }
        if (previous_minutes_array_index !== minutes_array_index || is_special || was_special) {
            if (previous_minutes_array_index !== -1)
                language["minutes_" + minutes_array[previous_minutes_array_index]](false)
            if (!is_special) {
                language["minutes_" + minutes_array[minutes_array_index]](true)
                previous_minutes_array_index = minutes_array_index
            }
        }
        if (is_special)
            language.special_message(true)
        was_special = is_special

        //update table and dots at the same time
        onoff_table = tmp_onoff_table
        onoff_dots = tmp_onoff_dots
    }
    function offsetToGMT(value) {
        return String("%1%2:%3").arg(Math.sign(value) < 0 ? "-" : "+")
        /**/                    .arg(("0" + Math.abs(Math.trunc(value/2))).slice(-2))
        /**/                    .arg(value%2 ? "30" : "00")
    }

    signal applyColors()

    // User-facing Settings
    property string selected_language
    property bool enable_speech: DeviceAccess.settingsValue("Appearance/speech", true)
    property bool enable_special_message: DeviceAccess.settingsValue("Appearance/specialMessage", true)
    property color background_color: "black"
    property alias backgroud_image_source: backgroundImage.source
    property color on_color: "red"
    property color off_color: "grey"
    property var accessories: new Array(6).fill("")

    // Internal Settings
    property bool is_color_animation_enabled: true
    readonly property int animation_easing: Easing.Linear
    property var languages: Object.keys(DeviceAccess.speechAvailableLocales).length ? DeviceAccess.speechAvailableLocales
                                                                                    : DeviceAccess.availableLocales
    property url language_url
    readonly property real table_width: Math.min(height, width)
    readonly property real cell_width: table_width/(rows+2)
    readonly property real dot_size: cell_width/4
    readonly property var speech_frequencies: {
        "1" : QT_TR_NOOP("every minute"),
        "5" : QT_TR_NOOP("every 5 minutes"),
        "10": QT_TR_NOOP("every 10 minutes"),
        "15": QT_TR_NOOP("every 15 minutes"),
        "20": QT_TR_NOOP("every 20 minutes"),
        "30": QT_TR_NOOP("every 30 minutes"),
        "60": QT_TR_NOOP("every hour")
    }
    readonly property var supportedLanguages: DeviceAccess.supportedLanguages

    property string speech_frequency: DeviceAccess.settingsValue("Appearance/speech_frequency", "1")
    property Language language
    //onLanguageChanged: Helpers.missingLetters(language.table)
    property var currentDateTime
    property int deviceOffset: 0
    readonly property string deviceGMT: "GMT%1".arg(offsetToGMT(deviceOffset))
    property string selectedGMT: "GMT+00:00"
    property int deltaTime: 0
    property string written_time
    property string time
    property bool is_AM
    property bool was_AM
    property bool was_special: false
    property int onoff_dots: 0
    property string hours_value
    property int weekNumber_value: 0
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

    Behavior on background_color {
        enabled: is_color_animation_enabled
        ColorAnimation { duration: 1000; easing.type: animation_easing }
    }
    Behavior on on_color {
        enabled: is_color_animation_enabled
        ColorAnimation {  duration: 1000; easing.type: animation_easing }
    }
    Behavior on off_color {
        enabled: is_color_animation_enabled
        ColorAnimation { duration: 1000; easing.type: animation_easing }
    }

    color: background_color
    onLanguageChanged: { DeviceAccess.hideSplashScreen(); enabled = false }
    Component.onCompleted: {
        selected_language = DeviceAccess.settingsValue("Appearance/clockLanguage", "")
        language_urlChanged.connect(
                    () => { if (time) {
                            previous_hours_array_index = -1
                            previous_minutes_array_index = -1
                            tmp_onoff_table = Helpers.createTable(rows, columns, false)
                            timeChanged()
                        }
                    })
        timeChanged.connect(updateTable)
        if (selected_language === "")
            detectAndUseDeviceLanguage()
        else
            selectLanguage(selected_language)
    }

    Loader { source: language_url; onLoaded: language = item }
    Timer {
        property bool color_transition_finished: false
        interval: 1000
        running: true
        repeat: true
        onTriggered:
            if (color_transition_finished) {
                stop()
                is_color_animation_enabled = false
            } else {
                timer.start()
                applyColors()
                color_transition_finished = true
            }
    }
    Timer {
        id: timer
        //public
        property bool is_debug: false
        property int fake_counter: 0
        property bool jump_by_minute: false
        property bool jump_by_5_minutes: false
        property bool jump_by_hour: false
        readonly property string time_reference: "00:00:00"
        //private
        readonly property int hour_to_ms: 3600000
        readonly property int minute_to_ms:60000
        readonly property int s_to_ms: 1000
        readonly property var time_reference_list: time_reference.split(':')
        readonly property int time_reference_ms: -3600000 + // January 1, 1970, 00:00:00
                                                 parseInt(time_reference_list[0])*hour_to_ms +
                                                 parseInt(time_reference_list[1])*minute_to_ms +
                                                 parseInt(time_reference_list[2])*s_to_ms
        interval: 500
        repeat: true
        running: false
        triggeredOnStart: true
        onTriggered: {
            if (is_debug) {
                currentDateTime = new Date(time_reference_ms +
                                           (jump_by_minute + jump_by_5_minutes*5 + jump_by_hour*60)*
                                           fake_counter*minute_to_ms)
                ++fake_counter
            } else {
                const now = new Date()
                deviceOffset = Math.floor(-now.getTimezoneOffset() / 30)
                currentDateTime = new Date(now.getTime() - deltaTime*minute_to_ms)
            }
            let startDate = new Date(currentDateTime.getFullYear(), 0, 1)
            let days = Math.floor((currentDateTime - startDate) / (24 * 60 * 60 * 1000))
            weekNumber_value = Math.ceil(days / 7)

            time = currentDateTime.toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
        }
    }

    Image { id: backgroundImage; anchors.fill: parent }
    Column {
        id: column
        anchors.centerIn: parent
        width: table_width
        height: width
        Item {
            height: cell_width
            width: parent.width
            Loader {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                onLoaded: if (accessories[0] === "minutes") item.index = 0
                sourceComponent: {
                    switch(accessories[0]) {
                    case "minutes":
                        return dot
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
            Loader {
                anchors.centerIn: parent
                sourceComponent: {
                    switch(accessories[1]) {
                    case "timeZone":
                        return timeZone
                    case "date":
                        return date
                    case "minutes":
                        return dots
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
            Loader {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                onLoaded: if (accessories[2] === "minutes") item.index = 1
                sourceComponent: {
                    switch(accessories[2]) {
                    case "minutes":
                        return dot
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
        }
        Repeater {
            model: language ? language.table : []
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    id: repeater
                    property int row_index: index
                    model: language.table[index]
                    Text {
                        readonly property int row_index: repeater.row_index
                        readonly property int column_index: index
                        readonly property bool is_enabled: onoff_table[row_index][column_index]
                        width: cell_width
                        height: width
                        text: modelData
                        color: is_enabled ? on_color : off_color
                        style: is_enabled ? Text.Outline : Text.Sunken
                        styleColor: is_enabled ? Qt.lighter(on_color, 1.1)
                                               : Qt.darker(background_color, 1.1)
                        horizontalAlignment : Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        fontSizeMode: Text.Fit
                        minimumPointSize: 5
                        font { pointSize: 80; kerning: false; preferShaping: false }
                    }
                }
            }
        }
        Item {
            height: cell_width
            width: parent.width
            Loader {
                anchors { verticalCenter: parent.verticalCenter; left: parent.left }
                onLoaded: if (accessories[3] === "minutes") item.index = 3
                sourceComponent: {
                    switch(accessories[3]) {
                    case "minutes":
                        return dot
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
            Loader {
                anchors.centerIn: parent
                sourceComponent: {
                    switch(accessories[4]) {
                    case "timeZone":
                        return timeZone
                    case "date":
                        return date
                    case "minutes":
                        return dots
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
            Loader {
                anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                onLoaded: if (accessories[5] === "minutes") item.index = 2
                sourceComponent: {
                    switch(accessories[5]) {
                    case "minutes":
                        return dot
                    case "seconds":
                        return seconds
                    case "ampm":
                        return ampm
                    case "weekNumber":
                        return weekNumber
                    case "batteryLevel":
                        return batteryLevel
                    default:
                        return null
                    }
                }
            }
        }
    }
    Component {
        id: dots
        Row {
            spacing: cell_width - dot_size
            topPadding: spacing/2
            visible: ((language))
            Repeater { model: 4; delegate: dot }
        }
    }
    Component {
        id: dot
        Rectangle {
            property int index: model.index
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            color: (index+1 <= onoff_dots) ? on_color : off_color
            height: width
            radius: width/2
            visible: ((language))
            width: dot_size
        }
    }
    Component {
        id: date
        Text {
            text: currentDateTime.toLocaleDateString(Qt.locale(selected_language)).toUpperCase()
            height: cell_width*.4
            color: off_color
            style: Text.Sunken
            styleColor: Qt.darker(background_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
    Component {
        id: timeZone
        Text {
            text: selectedGMT
            height: cell_width*.4
            color: off_color
            style: Text.Sunken
            styleColor: Qt.darker(background_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
    Component {
        id: ampm
        Text {
            text: is_AM  ? "AM" : "PM"
            height: cell_width*.4
            color: off_color
            style: Text.Sunken
            styleColor: Qt.darker(background_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
    Component {
        id: seconds
        Text {
            text: ("0" + currentDateTime.getSeconds()).slice(-2)
            height: cell_width*.4
            color: on_color
            style: Text.Outline
            styleColor: Qt.lighter(on_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
    Component {
        id: weekNumber
        Text {
            text: weekNumber_value
            height: cell_width*.4
            color: off_color
            style: Text.Sunken
            styleColor: Qt.darker(background_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
    Component {
        id: batteryLevel
        Text {
            text: "%1%".arg(DeviceAccess.batteryLevel)
            height: cell_width*.4
            color: off_color
            style: Text.Sunken
            styleColor: Qt.darker(background_color, 1.1)
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            minimumPointSize: 2
            font { pointSize: 32; kerning: false; preferShaping: false }
        }
    }
}
