/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS
import "qrc:/js/WordClock.js" as WordClockJS

import "qrc:/qml/controls" as Controls
import "qrc:/qml/languages"

import DeviceAccess 1.0

QtQuick.Rectangle
{
    property var wordClockJS: null
    // User-facing Settings
    property string selected_language
    property bool speech_enabled: DeviceAccess.managers.persistence.value("Speech/enabled", true)
    property bool enable_special_message: DeviceAccess.managers.persistence.value("Appearance/specialMessage", true)
    property color background_color: "black"
    //property alias backgroud_image_source: backgroundImage.source
    property color on_color: "red"
    property color off_color: "grey"

    // Internal Settings
    property bool is_color_animation_enabled: true
    readonly property int animation_easing: QtQuick.Easing.Linear
    property var languages: Object.keys(DeviceAccess.managers.speech.speechAvailableLocales).length ?
                                DeviceAccess.managers.speech.speechAvailableLocales :
                                DeviceAccess.managers.clockLanguage.clockAvailableLocales
    property url language_url
    readonly property real table_width: Math.min(height, width)
    readonly property real cell_width: table_width/(rows+2)
    readonly property real dot_size: cell_width/4
    readonly property var speech_frequencies: // TODO: Replace by a slider
    {
        "1" : qsTr("every minute")     + DeviceAccess.managers.translation.emptyString,
        "5" : qsTr("every 5 minutes")  + DeviceAccess.managers.translation.emptyString,
        "10": qsTr("every 10 minutes") + DeviceAccess.managers.translation.emptyString,
        "15": qsTr("every 15 minutes") + DeviceAccess.managers.translation.emptyString,
        "20": qsTr("every 20 minutes") + DeviceAccess.managers.translation.emptyString,
        "30": qsTr("every 30 minutes") + DeviceAccess.managers.translation.emptyString,
        "60": qsTr("every hour")       + DeviceAccess.managers.translation.emptyString,
    }
    readonly property var supportedLanguages: Object.keys(DeviceAccess.managers.clockLanguage.clockAvailableLocales)
    property string speech_frequency: DeviceAccess.managers.persistence.value("Speech/frequency", "15")
    property Language language
    //onLanguageChanged: HelpersJS.missingLetters(language.table)
    property var currentDateTime
    property int deviceOffset: 0
    readonly property string deviceGMT: "GMT%1".arg(WordClockJS.offsetToGMT(deviceOffset))
    property int selectedOffset: 0
    readonly property string selectedGMT: "GMT%1".arg(WordClockJS.offsetToGMT(selectedOffset))
    property int deltaTime: 0
    property string written_time
    property string time
    property bool is_AM
    property bool was_AM
    property bool was_special: false
    property int onoff_dots: 0
    property string hours_value
    property string minutes_value
    property string seconds_value
    property int currentWeekNumber
    readonly property string currentDate: currentDateTime ?
                                              currentDateTime.toLocaleDateString(Qt.locale(selected_language)).
                                              toUpperCase() :
                                              ""
    property int previous_hours_array_index: -1
    property int hours_array_index: 0
    readonly property int hours_array_step: 1
    readonly property int hours_array_min: 0
    readonly property int hours_array_max: 11
    readonly property int hours_array_size: ((hours_array_max - hours_array_min) / hours_array_step) + 1
    readonly property var hours_array: HelpersJS.createStringArrayWithPadding(hours_array_min,
                                                                              hours_array_size,
                                                                              hours_array_step)
    property int previous_minutes_array_index: -1
    property int minutes_array_index: 0

    readonly property int minutes_array_step: 5
    readonly property int minutes_array_min: 0
    readonly property int minutes_array_max: 55
    readonly property int minutes_array_size: ((minutes_array_max - minutes_array_min)/
                                               minutes_array_step) + 1
    readonly property var minutes_array: HelpersJS.createStringArrayWithPadding(minutes_array_min,
                                                                                minutes_array_size,
                                                                                minutes_array_step)
    readonly property int columns: 11
    readonly property int rows: 10
    property var onoff_table: WordClockJS.createWelcomeTable()
    property var tmp_onoff_table: WordClockJS.createTable(rows, columns, false)

    readonly property var accessory: (index, isCorner = true) =>
                                     {
                                         switch(accessories[index])
                                         {
                                             case "ampm"        : return ampm
                                             case "batteryLevel": return batteryLevel
                                             case "date"        : return isCorner ? null : date
                                             case "minutes"     : return isCorner ? dot : dots
                                             case "seconds"     : return seconds
                                             case "timeZone"    : return isCorner ? null : timeZone
                                             case "weekNumber"  : return weekNumber
                                             default            : return null
                                         }
                                     }
    property var accessories: new Array(6).fill("")
    property real accessoriesOpacity: .0

    property alias timer: timer
    property alias startupTimer: startupTimer

    readonly property size availableSize: Qt.size(parent.width -
                                                  (DeviceAccess.managers.screenSize.safeInsetLeft +
                                                   DeviceAccess.managers.screenSize.safeInsetRight) -
                                                  (isLandScape ? settingsPanel.position *
                                                                 (settingsPanel.width -
                                                                  DeviceAccess.managers.screenSize.safeInsetRight)
                                                               : 0),
                                                  parent.height -
                                                  (isFullScreen
                                                   ? 0
                                                   : (Math.max(DeviceAccess.managers.screenSize.statusBarHeight,
                                                               DeviceAccess.managers.screenSize.safeInsetTop)
                                                      + Math.max(DeviceAccess.managers.screenSize.navigationBarHeight,
                                                                 DeviceAccess.managers.screenSize.safeInsetBottom))))

    signal applyColors()
    signal selectLanguage(string language)

    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.horizontalCenterOffset: (isLandScape ? settingsPanel.position *
                                                   (root.isLeftHanded ? 1 : -1) *
                                                   (DeviceAccess.managers.screenSize.safeInsetRight -
                                                    settingsPanel.width): 0)/2
    color: background_color
    layer.enabled: true
    width: Math.min(availableSize.width, availableSize.height)
    height: width

    x: DeviceAccess.managers.screenSize.safeInsetLeft

    QtQuick.Component.onCompleted: wordClockJS = new WordClockJS.Object(this, isDebug)

    QtQuick.Connections
    {
        target: DeviceAccess.managers.speech
        enabled: DeviceAccess.managers.speech.enabled
        function onSpeechAvailableLocalesChanged() {
            DeviceAccess.managers.speech.setSpeechVoice(DeviceAccess.managers.persistence.value("Speech/%1_voice"
                                                                                                .arg(selected_language),
                                                                                                0))
        }
    }

    QtQuick.Behavior on background_color
    {
        enabled: is_color_animation_enabled
        QtQuick.ColorAnimation { duration: 1000; easing.type: animation_easing }
    }
    QtQuick.Behavior on on_color
    {
        enabled: is_color_animation_enabled
        QtQuick.ColorAnimation {  duration: 1000; easing.type: animation_easing }
    }
    QtQuick.Behavior on off_color
    {
        enabled: is_color_animation_enabled
        QtQuick.ColorAnimation { duration: 1000; easing.type: animation_easing }
    }
    QtQuick.Behavior on accessoriesOpacity
    {
        QtQuick.PropertyAnimation { duration: 1000; easing.type: animation_easing }
    }

    QtQuick.Loader { source: language_url; onLoaded: language = item }
    QtQuick.Timer
    {
        id: startupTimer

        property bool color_transition_finished: false

        interval: 1000
        repeat: true
        running: true

        onTriggered: wordClockJS.startupSequence(color_transition_finished)
    }

    QtQuick.Timer
    {
        id: timer

        //public
        property bool is_debug: false
        property bool jump_by_5_minutes: false
        property bool jump_by_minute: false
        property bool jump_by_hour: false
        property int fake_counter: 0
        readonly property string time_reference: "00:00:00"
        //private
        readonly property int day_to_ms: 86400000
        readonly property int hour_to_ms: 3600000
        readonly property int minute_to_ms:60000
        readonly property int s_to_ms: 1000
        readonly property var time_reference_list: time_reference.split(':')
        readonly property int time_reference_ms: -3600000 + // January 1, 1970, 00:00:00
                                                 parseInt(time_reference_list[0], 10)*hour_to_ms +
                                                 parseInt(time_reference_list[1], 10)*minute_to_ms +
                                                 parseInt(time_reference_list[2], 10)*s_to_ms

        interval: is_debug ? 5000 : 200
        repeat: true
        running: false
        triggeredOnStart: true

        onTriggered: wordClockJS.updateTime()
    }

    //QtQuick.Image { id: backgroundImage; anchors.fill: parent }
    QtQuick.Column
    {
        id: column
        anchors.centerIn: parent
        height: width
        width: table_width
        QtQuick.Item
        {
            height: cell_width
            width: parent.width
            QtQuick.Loader
            {
                anchors { verticalCenter: parent.verticalCenter; left: parent.left }
                sourceComponent: accessory(0)

                onLoaded: if (accessories[0] === "minutes") item.index = 0
            }
            QtQuick.Loader { anchors.centerIn: parent; sourceComponent: accessory(1, false) }
            QtQuick.Loader
            {
                anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                sourceComponent: accessory(2)

                onLoaded: if (accessories[2] === "minutes") item.index = 1
            }
        }
        QtQuick.Repeater
        {
            model: language ? language.table : []
            QtQuick.Row
            {
                anchors.horizontalCenter: parent.horizontalCenter
                QtQuick.Repeater
                {
                    id: repeater

                    property int row_index: index

                    model: language.table[index]
                    QtQuick.Text
                    {
                        readonly property bool is_enabled: onoff_table[row_index][column_index]
                        readonly property int column_index: index
                        readonly property int row_index: repeater.row_index

                        color: is_enabled ? on_color : off_color
                        font { pointSize: 80; kerning: false; preferShaping: false; family: GeneralFont }
                        fontSizeMode: QtQuick.Text.Fit
                        height: width
                        horizontalAlignment : QtQuick.Text.AlignHCenter
                        minimumPointSize: 5
                        style: is_enabled ? QtQuick.Text.Outline : QtQuick.Text.Sunken
                        styleColor: is_enabled ? Qt.lighter(on_color, 1.1) : Qt.darker(background_color, 1.1)
                        text: modelData
                        verticalAlignment: QtQuick.Text.AlignVCenter
                        width: cell_width
                    }
                }
            }
        }
        QtQuick.Item
        {
            height: cell_width
            width: parent.width
            QtQuick.Loader
            {
                anchors { verticalCenter: parent.verticalCenter; left: parent.left }
                sourceComponent: accessory(3)

                onLoaded: if (accessories[3] === "minutes") item.index = 3
            }
            QtQuick.Loader { anchors.centerIn: parent; sourceComponent: accessory(4, false) }
            QtQuick.Loader
            {
                anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                sourceComponent: accessory(5)

                onLoaded: if (accessories[5] === "minutes") item.index = 2
            }
        }
    }
    QtQuick.Component
    {
        id: dots

        QtQuick.Row
        {
            spacing: cell_width - dot_size
            topPadding: spacing/2
            visible: ((language))
            QtQuick.Repeater { model: 4; delegate: dot }
        }
    }
    QtQuick.Component
    {
        id: dot

        QtQuick.Rectangle
        {
            property int index: model.index
            anchors.verticalCenter: parent ? parent.verticalCenter : undefined
            color: (index+1 <= onoff_dots) ? on_color : off_color
            height: width
            radius: width/2
            visible: ((language))
            width: dot_size
        }
    }
    QtQuick.Component
    {
        id: date

        Controls.AccessoryText
        {
            isOn: false
            opacity: accessoriesOpacity
            text: currentDate
        }
    }
    QtQuick.Component
    {
        id: timeZone

        Controls.AccessoryText
        {
            isOn: false
            opacity: accessoriesOpacity
            text: selectedGMT
        }
    }
    QtQuick.Component
    {
        id: ampm

        Controls.AccessoryText
        {
            isOn: true
            opacity: accessoriesOpacity
            text: is_AM  ? "AM" : "PM"
        }
    }
    QtQuick.Component
    {
        id: seconds

        Controls.AccessoryText
        {
            font.family: FixedFont
            isOn: true
            opacity: accessoriesOpacity
            text: ("0" + seconds_value).slice(-2)
        }
    }
    QtQuick.Component
    {
        id: weekNumber

        Controls.AccessoryText
        {
            isOn: false
            opacity: accessoriesOpacity
            text: currentWeekNumber
        }
    }
    QtQuick.Component
    {
        id: batteryLevel

        Controls.AccessoryText
        {
            font.family: FixedFont
            isOn: DeviceAccess.managers.battery.isPlugged
            opacity: accessoriesOpacity
            text: "%1 %".arg(DeviceAccess.managers.battery.batteryLevel)
        }
    }
}
