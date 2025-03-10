/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.Loader
{
    active: DeviceAccess.managers.speech.enabled
    QtLayouts.Layout.fillWidth: true
    sourceComponent: Controls.MenuSection
    {
        id: section

        title: qsTr("Speech") + DeviceAccess.managers.translation.emptyString

        Controls.MenuItem
        {
            title: qsTr("Enable Time Reminder") + DeviceAccess.managers.translation.emptyString

            QtControls.Switch
            {
                checked: wordClock.speech_enabled
                onToggled: DeviceAccess.managers.persistence.setValue("Speech/enabled",
                                                                      wordClock.speech_enabled = checked)
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Interval (%1)").arg(Object.values(wordClock.speech_intervals)[extraControls[0].value]) +
                   DeviceAccess.managers.translation.emptyString
            extras: QtControls.Slider
            {
                from: 0
                stepSize: 1
                to: Object.keys(wordClock.speech_intervals).length-1
                value: Object.keys(wordClock.speech_intervals).indexOf(String(wordClock.speech_interval))
                width: parent.width

                onMoved:
                {
                    wordClock.speech_interval = Object.keys(wordClock.speech_intervals)[value];
                    DeviceAccess.managers.persistence.setValue("Speech/interval", wordClock.speech_interval);
                }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Voice") + DeviceAccess.managers.translation.emptyString
            active: DeviceAccess.managers.speech.hasMultipleVoices// @disable-check M16  @disable-check M31
            extras: QtQuick.ListView
            {
                id: listView

                onModelChanged: currentIndex = parseInt(DeviceAccess.managers.persistence.value(
                                                            "Speech/%1_voice".arg(wordClock.selected_language), 0), 10);
                delegate: QtControls.Button
                {
                    autoExclusive: true
                    checkable: true
                    checked: index === parseInt(DeviceAccess.managers.persistence.value(
                                                    "Speech/%1_voice".arg(wordClock.selected_language), 0), 10);
                    text: modelData

                    onClicked:
                    {
                        QtQuick.ListView.view.currentIndex = index;
                        DeviceAccess.managers.speech.setSpeechVoice(index);
                        if (wordClock.speech_enabled)
                        {
                            DeviceAccess.managers.speech.say(wordClock.written_time);
                        }
                        DeviceAccess.managers.persistence.setValue("Speech/%1_voice".arg(wordClock.selected_language),
                                                                   index);
                    }

                    QtControls.Label
                    {
                        anchors { right: parent.right; bottom: parent.bottom }
                        color: parent.icon.color
                        font.family: SmallestReadableFont.family
                        font.pointSize: HelpersJS.isWasm ? 9 : SmallestReadableFont.pointSize
                        text: "%1/%2".arg(index+1).arg(parent.QtQuick.ListView.view.count)
                    }
                }
                height: contentItem.childrenRect.height
                model: DeviceAccess.managers.speech.speechAvailableVoices[wordClock.selected_language]
                orientation: QtQuick.ListView.Horizontal
                spacing: 5
                width: parent ? parent.width : 0

                QtQuick.Connections
                {
                    target: section
                    function onIs_collapsedChanged()
                    {
                        if (!section.is_collapsed)
                        {
                            listView.positionViewAtIndex(listView.currentIndex, QtQuick.ListView.Center);
                        }
                    }
                }
            }
        }
    }
}
