/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQml 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
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

    flags: Qt.Window | Qt.WindowStaysOnTopHint
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

    Connections {
        target: DeviceAccess

        function onOrientationChanged() { orientationChangedSequence.start() }
        function onToggleFullScreen() {
            Helpers.toggle(root, "visibility", Window.FullScreen, Window.AutomaticVisibility)
        }
    }
    MouseArea {

        property point pressedPoint
        property bool isPressAndHold: false

        anchors.fill: parent
        onPressed: {
            isPressAndHold = false
            pressedPoint = Qt.point(mouseX, mouseY)
        }
        onPressAndHold: {
            isPressAndHold = true
            //settingPanel.open()
        }
        onPositionChanged: {
            if (Math.abs(pressedPoint.y - mouseY) >= 1)
                DeviceAccess.setBrigthnessDelta(2*(pressedPoint.y - mouseY)/root.height)
        }
        onReleased:{
            if (!isPressAndHold && Math.abs(pressedPoint.x - mouseX) < 1 && Math.abs(pressedPoint.y - mouseY) < 1)
                DeviceAccess.toggleStatusBarVisibility()
        }
    }
/*
    Drawer {
        id: settingPanel
        y: (parent.height - height) / 2
        width: root.width*.95
        height: root.height*.99
        edge: Qt.RightEdge
        background: Item {
            clip: true
            opacity: 0.8
            Rectangle {
                anchors { fill: parent; rightMargin: -radius }
                radius: Math.min(parent.height, parent.width)*.02
                color: "#232323"
            }
        }
        //use a menu instead here, and set title bar for desktop
        ColumnLayout {
            id: menu
            anchors { fill: parent; margins: 20 }
            spacing: 0
            Label {
                Layout.alignment: Qt.AlignTop
                Layout.fillWidth: true
                horizontalAlignment: Label.AlignHCenter
                text: qsTr("fa:fa-square-sliders %1").arg("My preferences")
                font { bold: true; pointSize: 26 }
                color: "white"
                elide: Label.ElideRight
            }
            ScrollView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Label.AlignLeft
                        font { bold: true; pointSize: 22 }
                        elide: Label.ElideRight
                        color: "white"
                        text: qsTr("fa:fa-earth-africa %1").arg("Battery Saving")
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            text: qsTr("Stay awake")
                            elide: Label.ElideRight
                            Layout.fillWidth: true
                        }
                        Switch { onCheckedChanged: DeviceAccess.disableAutoLock(checked) }
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            text: String("%1 (%2 %)").arg(
                                      qsTr("Minimum Battery Level")).arg(slider.value.toString())
                            elide: Label.ElideLeft
                            Layout.fillWidth: true
                        }
                        Slider { id: slider; from: 20; to: 50; stepSize: 5 }
                    }
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Label.AlignLeft
                        font { bold: true; pointSize: 22 }
                        elide: Label.ElideRight
                        color: "white"
                        text: qsTr("fa:fa-shield-dog %1").arg(qsTr("Security"))
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            text: qsTr("Enable Guided Access")
                            elide: Label.ElideRight
                            Layout.fillWidth: true
                        }
                        Switch { onCheckedChanged: DeviceAccess.enableGuidedAccessSession(checked) }
                    }
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Label.AlignLeft
                        font { bold: true; pointSize: 22 }
                        elide: Label.ElideRight
                        color: "white"
                        text: String("fa:fa-palette %1").arg(qsTr("Appearance"))
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            Layout.fillWidth: true
                            text: qsTr("Background Color")
                        }
                        TextField {
                            text: root.background_color
                            onEditingFinished: root.background_color = text
                        }
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            Layout.fillWidth: true
                            text: qsTr("Enabled Letter Color")
                        }
                        TextField {
                            text: root.on_color
                            onEditingFinished: root.on_color = text
                        }
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            Layout.fillWidth: true
                            text: qsTr("Deactivated Letter Color")
                        }
                        TextField {
                            text: root.off_color
                            onEditingFinished: root.off_color = text
                        }
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            Layout.fillWidth: true
                            text: qsTr("Letter Font")
                        }
                        ComboBox { model: 20 }
                    }
                    RowLayout {
                        Label {
                            font { bold: true; pointSize: 16 }
                            color: "white"
                            text: qsTr("Enable Special Message")
                            Layout.fillWidth: true
                            elide: Label.ElideRight
                        }
                        Switch { onCheckedChanged: root.enable_special_message = checked }
                    }
                    Label {
                        Layout.fillWidth: true
                        horizontalAlignment: Label.AlignLeft
                        font { bold: true; pointSize: 22 }
                        elide: Label.ElideRight
                        color: "white"
                        text: String("fa:fa-stars %1").arg(qsTr("About"))
                    }
                    RowLayout {
                        // - Free: without advertisement
                        // - Open source: code available on github under MIT license
                        // - Bug tracking: in indor to improve the Application
                        // - Suggestion Box: new languages, features
                        // - Review the app: let other know about this app (share it)
                        // - Twitter: Share your experience here.
                        // - Credits: Developed with Love by Johan and published by Denver.
                    }
                }
            }
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("fa:fa-coffee-beans %1").arg("Tip me")
                font { bold: true; pointSize: 20 }
                color: "white"
                elide: Label.ElideRight
                MouseArea {
                    anchors.fill: parent;
                    onClicked: Qt.openUrlExternally("https://ko-fi.com/johanremilien")
                }
            }
        }
    }
    */

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
