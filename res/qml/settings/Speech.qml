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
            title: qsTr("Frequency") + DeviceAccess.managers.translation.emptyString
            extras: QtQuick.ListView
            {
                delegate: QtControls.Button
                {
                    autoExclusive: true
                    checkable: true
                    checked: index === Object.keys(wordClock.speech_frequencies).indexOf(wordClock.speech_frequency)
                    text: modelData

                    onClicked:
                    {
                        const speech_frequency = Object.keys(wordClock.speech_frequencies)[index]
                        wordClock.speech_frequency = speech_frequency
                        DeviceAccess.managers.persistence.setValue("Appearance/speech_frequency", speech_frequency)
                    }
                }
                height: contentItem.childrenRect.height
                model: Object.values(wordClock.speech_frequencies)
                orientation: QtQuick.ListView.Horizontal
                spacing: 5
                width: parent.width
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
                        HelpersJS.listProperties("contentItem", contentItem)
                    }
                    QtControls.Label
                    {
                        color: parent.icon.color
                        anchors { right: parent.right; bottom: parent.bottom; margins: 2 }
                        font: SmallestReadableFont
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
