/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.MenuSection
{
    id: section

    title: qsTr("Appearance") + DeviceAccess.managers.translation.emptyString

    Controls.MenuItem
    {
        id: applicationLanguage

        readonly property string defaultLanguage: Qt.locale().name.substr(0,2)
        property string selectedLangage: DeviceAccess.managers.persistence.value("Appearance/uiLanguage",
                                                                                 applicationLanguage.defaultLanguage)
        function switchLanguage(language)
        {
            selectedLangage = language;
            DeviceAccess.managers.translation.switchLanguage(language);
            DeviceAccess.managers.persistence.setValue("Appearance/uiLanguage", language);
        }

        title: qsTr("Application Language") + DeviceAccess.managers.translation.emptyString

        QtQuick.Component.onCompleted: switchLanguage(selectedLangage)

        QtControls.Button
        {
            text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
            enabled: Object.keys(DeviceAccess.managers.translation.availableTranslations)
                     [applicationLanguage.extraControls[0].currentIndex] !== applicationLanguage.defaultLanguage

            onClicked: applicationLanguage.switchLanguage(applicationLanguage.defaultLanguage)
        }
        extras: QtQuick.ListView
        {
            id: applicationLanguageListView

            currentIndex: Object.keys(DeviceAccess.managers.translation.availableTranslations).indexOf(
                              applicationLanguage.selectedLangage)
            delegate: QtControls.Button
            {
                autoExclusive: true
                checkable: true
                checked: index === QtQuick.ListView.view.currentIndex
                text: DeviceAccess.managers.translation.availableTranslations[modelData]

                onClicked: applicationLanguage.switchLanguage(modelData)
            }
            height: contentItem.childrenRect.height
            model: Object.keys(DeviceAccess.managers.translation.availableTranslations)
            orientation: QtQuick.ListView.Horizontal
            spacing: 5
            width: parent.width

            QtQuick.Connections
            {
                target: section
                function onIs_collapsedChanged()
                {
                    if (!section.is_collapsed)
                    {
                        applicationLanguageListView.positionViewAtIndex(applicationLanguageListView.currentIndex,
                                                                        QtQuick.ListView.Center);
                    }
                }
            }
        }
    }
    Controls.MenuItem
    {
        title: qsTr("Handedness") + DeviceAccess.managers.translation.emptyString
        model: [ QT_TR_NOOP("Left-handed"), QT_TR_NOOP("Right-handed") ]
        delegate: QtControls.Button
        {
            autoExclusive: true
            checkable: true
            checked: index === parseInt(DeviceAccess.managers.persistence.value("Appearance/hand_preference", 0), 10)
            text: qsTr(modelData) + DeviceAccess.managers.translation.emptyString

            onClicked:
            {
                isLeftHanded = Boolean(index);
                DeviceAccess.managers.persistence.setValue("Appearance/hand_preference", index);
            }
        }
        details: qsTr("Optimize the application layout to suit your handedness")
        /**/        + DeviceAccess.managers.translation.emptyString
    }
    Controls.MenuItem
    {
        title: qsTr("Clock Language") + DeviceAccess.managers.translation.emptyString

        QtControls.Button
        {
            text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
            enabled: wordClock.selected_language !== (DeviceAccess.managers.speech.enabled
                                                      ? Qt.locale().name
                                                      : Qt.locale().name.substring(0,2))

            onClicked: wordClock.selectLanguage(Qt.locale().name)
        }
        extras: QtQuick.ListView
        {
            id: clockLanguageListView

            currentIndex: wordClock.languagesKeys.indexOf(wordClock.selected_language)
            delegate: QtControls.Button
            {
                autoExclusive: true
                checkable: true
                checked: index === QtQuick.ListView.view.currentIndex
                text: modelData

                onClicked: wordClock.selectLanguage(wordClock.languagesKeys[index])

                QtControls.Label
                {
                    anchors { right: parent.right; bottom: parent.bottom }
                    color: parent.icon.color
                    font.family: SmallestReadableFont.family
                    font.pointSize: HelpersJS.isWasm ? 9 : SmallestReadableFont.pointSize
                    text: "%1/%2".arg(index + 1).arg(parent.QtQuick.ListView.view.count)
                }
            }
            height: contentItem.childrenRect.height
            model: Object.values(wordClock.languages)
            orientation: QtQuick.ListView.Horizontal
            spacing: 5
            width: parent.width

            QtQuick.Connections
            {
                target: section
                function onIs_collapsedChanged()
                {
                    if (!section.is_collapsed)
                        clockLanguageListView.positionViewAtIndex(clockLanguageListView.currentIndex,
                                                                  QtQuick.ListView.Center);
                }
            }
        }
    }
    Controls.MenuItem
    {
        title: qsTr("Enable Special Message") + DeviceAccess.managers.translation.emptyString
        details: qsTr("Each grid contains a special message displayed in place of the hour for one minute at \
the following times: 00:00 (12:00 AM), 11:11 (11:11 AM), and 22:22 (10:22 PM). The (4-dot) minute indicator will \
display 0, 1, or 2 lights, allowing you to distinguish these different times.") +
                 DeviceAccess.managers.translation.emptyString

        QtControls.Switch
        {
            checked: wordClock.enable_special_message
            onToggled:
            {
                DeviceAccess.managers.persistence.setValue("Appearance/specialMessage",
                                                           wordClock.enable_special_message = checked);
                if (HelpersJS.isWeaklyEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm"))
                {
                    wordClock.updateTable();
                }
            }
        }
    }
    Controls.MenuItem
    {
        title: (HelpersJS.isIos ? qsTr("Hide Status Bar")
                                : qsTr("Full Screen")) + DeviceAccess.managers.translation.emptyString
        active: HelpersJS.isDesktop || HelpersJS.isMobile

        QtControls.Switch
        {
            checked: root.isFullScreen

            onToggled: HelpersJS.updateVisibility(root)
            QtQuick.Component.onCompleted:
            {
                if (root.isFullScreen !== DeviceAccess.managers.persistence.value("Appearance/fullScreen", false))
                {
                    toggled();
                }
            }
        }
        details: qsTr("When the settings menu is closed, this can also be done by a long press on the clock.")
        /**/       + DeviceAccess.managers.translation.emptyString
    }
}
