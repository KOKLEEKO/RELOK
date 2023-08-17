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
        title: qsTr("Speech") + DeviceAccess.managers.translation.emptyString

        Controls.MenuItem
        {
            title: qsTr("Enable Time Reminder") + DeviceAccess.managers.translation.emptyString
            QtControls.Switch
            {
                checked: wordClock.enable_speech
                onToggled: DeviceAccess.managers.persistence.setValue("Appearance/speech",
                                                                      wordClock.enable_speech = checked)
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Interval (%1)").arg(Object.values(wordClock.speech_frequencies)[extraControls[0].value]) +
                   DeviceAccess.managers.translation.emptyString
            extras: QtControls.Slider
            {
                from: 0
                stepSize: 1
                to: Object.keys(wordClock.speech_frequencies).length-1
                value: Object.keys(wordClock.speech_frequencies).indexOf(wordClock.speech_frequency)
                width: parent.width

                onMoved:
                {
                    const speech_frequency = Object.keys(wordClock.speech_frequencies)[value]
                    wordClock.speech_frequency = speech_frequency
                    DeviceAccess.managers.persistence.setValue("Appearance/speech_frequency", speech_frequency)
                }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Voice") + DeviceAccess.managers.translation.emptyString
            active: DeviceAccess.managers.speech.hasMultipleVoices// @disable-check M16  @disable-check M31
            extras: QtQuick.ListView
            {
                delegate: QtControls.Button
                {
                    autoExclusive: true
                    checkable: true
                    checked: index === DeviceAccess.managers.persistence.value("Appearance/%1_voice"
                                                                               .arg(wordClock.selected_language), 0)
                    text: modelData

                    onClicked:
                    {
                        DeviceAccess.managers.speech.setSpeechVoice(index)
                        if (wordClock.enable_speech)
                            DeviceAccess.managers.speech.say(wordClock.written_time)
                        DeviceAccess.managers.persistence.setValue("Appearance/%1_voice"
                                                                   .arg(wordClock.selected_language), index)
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
            }
        }
    }
}
