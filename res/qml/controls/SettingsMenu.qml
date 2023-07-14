/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtPurchasing 1.15 as QtPurchasing
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts
import QtQuick.Window 2.15 as QtWindows

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls
import "qrc:/js/Helpers.js" as HelpersJS

Controls.Menu
{
    function greetings()
    {
        if (wordClock.is_AM)
            return QT_TR_NOOP("Good Morning!")
        else if (parseInt(wordClock.hours_value, 10) < 18) // 6:00 PM
            return QT_TR_NOOP("Good Afternoon!")
        return QT_TR_NOOP("Good Evening!")
    }

    function openUrl(url)
    {
        if (HelpersJS.isMobile && url.split(":")[0] !== "mailto")
            webView.openUrl(url)
        else
            Qt.openUrlExternally(url)
    }

    anchors.fill: parent  // @disable-check M16  @disable-check M31
    title: qsTr(greetings()) + DeviceAccess.managers.translation.emptyString
    footer: Controls.MenuSection
    {
        QtLayouts.Layout.alignment: Qt.AlignBottom
        is_tipMe: true
        label.heading: headings.h3
        label.horizontalAlignment: QtControls.Label.AlignHCenter
        label.text: (is_collapsed ? "☞" : "♥").concat(" ", qsTr("Tip Jar")).concat(" ", is_collapsed ? "☜":"♥") +
                    DeviceAccess.managers.translation.emptyString
        menuItems.flow: QtLayouts.GridLayout.LeftToRight

        Controls.IconButton
        {
            name: "ko-fi"
            active: !HelpersJS.isPurchasing
            tooltip: "Ko-fi"

            onClicked: openUrl("https://ko-fi.com/johanremilien")
        }
        QtQuick.Repeater
        {
            model: tips.tipsModel
            Controls.IconButton
            {
                readonly property QtPurchasing.Product product: tips.products[modelData.name]

                QtLayouts.Layout.fillWidth: true
                active: HelpersJS.isPurchasing
                enabled: !tips.store.purchasing && product.status === QtPurchasing.Product.Registered
                name: "tip-" + modelData.name
                tooltip: qsTranslate("Tips", modelData.tooltip) + DeviceAccess.managers.translation.emptyString

                onClicked: { tips.store.purchasing = true; product.purchase() }
            }
        }
        show_detailsComponent: HelpersJS.isPurchasing
        detailsComponent: Controls.Details
        {
            horizontalAlignment: QtControls.Label.Center
            font.bold: true
            text: qsTr("These preceding items are representative of a bonus paid to the development team, with no \
benefit to you.") + DeviceAccess.managers.translation.emptyString
        }
    }
    QtQuick.Loader
    {
        active: DeviceAccess.managers.battery.enabled
        QtLayouts.Layout.fillWidth: true
        sourceComponent: Controls.MenuSection
        {
            title: qsTr("Battery Saving") + DeviceAccess.managers.translation.emptyString

            Controls.MenuItem
            {
                title: qsTr("Stay Awake") + DeviceAccess.managers.translation.emptyString
                details: qsTr("If this option is enabled, the device's screen will remain active while the application \
is running.\nDon't forget to enable '%1' if you might lose attention on your device.").arg(HelpersJS.isAndroid ?
                                                                                               qsTr("App pinning") :
                                                                                               qsTr("Guided Access")) +
                         DeviceAccess.managers.translation.emptyString
            }
            QtControls.Switch
            {
                checked: !DeviceAccess.managers.autoLock.isAutoLockRequested
                onToggled: DeviceAccess.managers.autoLock.isAutoLockRequested = !checked
            }
            Controls.MenuItem
            {
                title: qsTr("App pinning") + DeviceAccess.managers.translation.emptyString
                active: HelpersJS.isAndroid

                QtControls.Switch { onToggled: DeviceAccess.managers.autoLock.security(checked) }
            }
            Controls.MenuItem
            {
                title: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(extraControls[0].value.toString()) +
                       DeviceAccess.managers.translation.emptyString
                details: qsTr("'%1' feature will be automatically disabled when the battery level reaches this \
value unless the device charges.").arg(qsTr("Stay Awake")) +
                         (HelpersJS.isMobile ? "\n(%1: %2%)".arg(qsTr("battery level"))
                                               /**/         .arg(DeviceAccess.managers.battery.batteryLevel) : "") +
                         DeviceAccess.managers.translation.emptyString
                extras: QtControls.Slider
                {
                    from: 20
                    stepSize: 5
                    to: 50
                    value: DeviceAccess.managers.energySaving.minimumBatteryLevel

                    onMoved: DeviceAccess.managers.energySaving.minimumBatteryLevel = value
                }
            }
            Controls.MenuItem
            {
                title: "%1 (%2%)".arg(qsTr("Brightness Level"))
                /**/             .arg(DeviceAccess.managers.screenBrightness.brightness) +
                DeviceAccess.managers.translation.emptyString
                extras: QtControls.Slider
                {
                    from: 0
                    to: 100
                    value: DeviceAccess.managers.screenBrightness.brightness

                    onMoved: DeviceAccess.managers.screenBrightness.brightnessRequested = value/100
                    QtQuick.Component.onCompleted:
                    {
                        if (HelpersJS.isAndroid)
                            DeviceAccess.managers.screenBrightness.requestBrightnessUpdate()
                    }
                }
                details: qsTr("High brightness levels cause the battery to discharge faster.") +
                         DeviceAccess.managers.translation.emptyString
            }
        }
    }
    Controls.MenuSection
    {
        title: qsTr("Appearance") + DeviceAccess.managers.translation.emptyString
        Controls.MenuItem
        {
            title: (HelpersJS.isIos ? qsTr("Hide Status Bar")
                                    : qsTr("FullScreen")) + DeviceAccess.managers.translation.emptyString
            active: HelpersJS.isDesktop || HelpersJS.isMobile

            QtControls.Switch
            {
                checked: root.isFullScreen

                onToggled: HelpersJS.updateVisibility(root)
                QtQuick.Component.onCompleted:
                {
                    if (root.isFullScreen !== DeviceAccess.managers.persistence.value("Appearance/fullScreen", false))
                        toggled()
                }
            }
            details: qsTr("When the settings menu is closed, this can also be done by a long press on the clock.")
            /**/       + DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            id: applicationLanguage

            readonly property string defaultLanguage: Qt.locale().name.substr(0,2)

            function switchLanguage(language)
            {
                DeviceAccess.managers.translation.switchLanguage(language)
                DeviceAccess.managers.persistence.setValue("Appearance/uiLanguage", language)
            }

            title: qsTr("Application Language") + DeviceAccess.managers.translation.emptyString

            QtControls.Button
            {
                text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
                enabled: Object.keys(DeviceAccess.managers.translation.availableTranslations)
                         [applicationLanguage.extraControls[0].currentIndex] !== applicationLanguage.defaultLanguage

                onClicked:
                {
                    applicationLanguage.switchLanguage(applicationLanguage.defaultLanguage)
                    applicationLanguage.extraControls[0].currentIndex = Object
                    .keys(DeviceAccess.managers.translation.availableTranslations)
                    .indexOf(applicationLanguage.defaultLanguage)
                }
            }
            extras: QtControls.ComboBox
            {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                width: parent.width
                model: Object.values(DeviceAccess.managers.translation.availableTranslations)

                onActivated: (index) =>
                             {
                                 applicationLanguage.switchLanguage(
                                     Object.keys(DeviceAccess.managers.translation.availableTranslations)[index])
                             }
                QtQuick.Component.onCompleted:
                {
                    currentIndex = Object.keys(DeviceAccess.managers.translation.availableTranslations)
                    .indexOf(DeviceAccess.managers.persistence.value("Appearance/uiLanguage",
                                                                     applicationLanguage.defaultLanguage))
                }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Clock Language") + DeviceAccess.managers.translation.emptyString

            QtControls.Button
            {
                text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
                enabled: wordClock.selected_language !== Qt.locale().name

                onClicked: wordClock.detectAndUseDeviceLanguage()
            }
            extras: QtControls.ComboBox
            {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                width: parent.width
                currentIndex: Object.keys(wordClock.languages).indexOf(wordClock.selected_language)
                model: Object.values(wordClock.languages)
                onModelChanged:
                {
                    if (HelpersJS.isAndroid)
                        currentIndex = Qt.binding(() => Object.keys(wordClock.languages)
                                                  .indexOf(wordClock.selected_language))
                }
                onActivated: (index) => {
                                 const language = Object.keys(wordClock.languages)[index]
                                 wordClock.selectLanguage(language)
                                 DeviceAccess.managers.persistence.setValue("Appearance/clockLanguage", language)
                             }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Speech") + DeviceAccess.managers.translation.emptyString
            QtControls.Switch
            {
                checked: wordClock.enable_speech
                onToggled: DeviceAccess.managers.persistence.setValue("Appearance/speech",
                                                                      wordClock.enable_speech = checked)
            }
            extras: QtControls.ComboBox
            {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                function updateCurrentIndex ()
                {
                    currentIndex = Object.keys(wordClock.speech_frequencies).indexOf(wordClock.speech_frequency)
                }

                width: parent.width
                model: Object.values(wordClock.speech_frequencies)

                onActivated: (index) =>
                             {
                                 const speech_frequency = Object.keys(wordClock.speech_frequencies)[index]
                                 wordClock.speech_frequency = speech_frequency
                                 DeviceAccess.managers.persistence.setValue("Appearance/speech_frequency",
                                                                            speech_frequency)
                             }
                QtQuick.Component.onCompleted:
                {
                    updateCurrentIndex()
                    modelChanged.connect(updateCurrentIndex)
                }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Voice") + DeviceAccess.managers.translation.emptyString
            active: Object.keys(DeviceAccess.managers.speech.speechAvailableVoices).length // @disable-check M16  @disable-check M31
            extras: QtControls.ComboBox
            {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                function setSpeechVoice(index)
                {
                    DeviceAccess.managers.speech.setSpeechVoice(index)
                    if (wordClock.enable_speech)
                        DeviceAccess.managers.speech.say(wordClock.written_time)
                    DeviceAccess.managers.persistence.setValue("Appearance/%1_voice"
                                                               .arg(wordClock.selected_language), index)
                }

                width: parent ? parent.width : 0
                model: DeviceAccess.managers.speech.speechAvailableVoices[wordClock.selected_language]

                onModelChanged:
                {
                    currentIndex = DeviceAccess.managers.persistence.value("Appearance/%1_voice"
                                                                           .arg(wordClock.selected_language), 0)
                    DeviceAccess.managers.speech.setSpeechVoice(currentIndex)
                }
                onActivated: (index) => setSpeechVoice(index)
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
                                                               wordClock.enable_special_message = checked)
                    if (HelpersJS.isWeaklyEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm"))
                        wordClock.updateTable()
                }
            }
        }
    }
    Controls.MenuSection
    {
        title: qsTr("Advanced") + DeviceAccess.managers.translation.emptyString

        Controls.MenuItem
        {
            title: qsTr("Display as widget") + DeviceAccess.managers.translation.emptyString
            active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31

            QtControls.Switch
            {
                checked: root.isWidget

                onToggled: HelpersJS.updateDisplayMode(root)
                QtQuick.Component.onCompleted:
                {
                    if (root.isWidget !== DeviceAccess.managers.persistence.value("Appearance/widget", false))
                        toggled()
                }
            }
        }
        Controls.MenuItem
        {
            title: "%1 (%2%)".arg(qsTr("Opacity")).arg(Math.floor(control ? control.value : 0)) +
                   DeviceAccess.managers.translation.emptyString
            active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31
            enabled: !root.isFullScreen  // @disable-check M16  @disable-check M31

            QtControls.Slider
            {
                from: 10
                to: 100
                value: DeviceAccess.managers.persistence.value("Appearance/opacity", 1) * 100

                onMoved:
                {
                    root.opacity = value/100
                    DeviceAccess.managers.persistence.setValue("Appearance/opacity", root.opacity)
                }
            }
        }
        Controls.MenuItem
        {
            title: qsTr("Display as watermark") + DeviceAccess.managers.translation.emptyString
            active: HelpersJS.isDesktop  // @disable-check M16  @disable-check M31

            QtControls.Button
            {
                text: qsTr("Activate") + DeviceAccess.managers.translation.emptyString
                onClicked:
                {
                    root.visibility = Window.Maximized
                    root.opacity = Math.min(root.opacity, .85)
                    root.flags = (Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput | Qt.FramelessWindowHint)
                    settingsPanel.close()
                }
            }
        }
        Controls.MenuItem
        {
            id: timeZone

            function update()
            {
                wordClock.deltaTime = (wordClock.deviceOffset - extraControls[0].value) * 30
            }

            title: qsTr("Time Zone (%1)").arg(wordClock.selectedGMT) + DeviceAccess.managers.translation.emptyString
            extras: QtControls.Slider
            {
                from: -24
                stepSize: 1
                to: 28
                value: wordClock.deviceOffset

                onPressedChanged: if (!pressed) timeZone.update()
                onValueChanged: wordClock.selectedOffset = value
            }
            details: qsTr("This setting is not persistent, the time zone of the device <b>(%1)</b> is used each \
time the application is launched").arg(wordClock.deviceGMT) + DeviceAccess.managers.translation.emptyString

            QtControls.Button
            {
                text: qsTr("Reset") + DeviceAccess.managers.translation.emptyString
                enabled: wordClock.selectedGMT !== wordClock.deviceGMT

                onClicked:
                {
                    timeZone.extraControls[0].value = wordClock.deviceOffset
                    timeZone.update()
                }
            }
        }
        Controls.LargePositionSelector
        {
            name: "timeZone"
            title: qsTr("Time Zone display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.LargePositionSelector
        {
            name: "date"
            title: qsTr("Date display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.LargePositionSelector
        {
            name: "minutes"
            title: qsTr("4-Dot display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.SmallPositionSelector
        {
            name: "seconds"
            title: qsTr("Seconds display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.SmallPositionSelector
        {
            name: "ampm"
            title: qsTr("AM|PM display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.SmallPositionSelector
        {
            name: "weekNumber"
            title: qsTr("Week Number display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.SmallPositionSelector
        {
            active: DeviceAccess.managers.battery.enabled
            name: "batteryLevel"
            title: qsTr("Battery Level display mode") + DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            active: !HelpersJS.isWasm
            title: qsTr("Welcome popup") + DeviceAccess.managers.translation.emptyString

            QtControls.Switch
            {
                checked: root.showWelcome
                onCheckedChanged: DeviceAccess.managers.persistence.setValue("Welcome/showPopup", checked)
            }
            details: qsTr("Display at startup.") + DeviceAccess.managers.translation.emptyString
        }
    }
    Controls.MenuSection
    {
        readonly property string default_on_color: "#F00"
        readonly property string default_off_color: "#888"
        readonly property string default_background_color: "#000"

        function applyColors()
        {
            activatedLetterColorPicker.extraControls[3].setColor(
                        DeviceAccess.managers.persistence.value("Appearance/on_color", default_on_color))
            deactivatedLetterColorPicker.extraControls[3].setColor(
                        DeviceAccess.managers.persistence.value("Appearance/off_color", default_off_color))

            if (backgroundColorPicker.active)
                backgroundColorPicker.extraControls[3].setColor(
                            DeviceAccess.managers.persistence.value("Appearance/background_color",
                                                                    default_background_color))
        }

        title: qsTr("Colors") + DeviceAccess.managers.translation.emptyString

        QtQuick.Component.onCompleted: wordClock.applyColors.connect(applyColors)

        Controls.ColorPicker
        {
            id: activatedLetterColorPicker

            title: qsTr("Activated Letter Color") + DeviceAccess.managers.translation.emptyString
            name: "on_color"
            details: qsTr("The color can be set in HSL (Hue, Saturation, Lightness) or in hexadecimal format.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.ColorPicker
        {
            id: deactivatedLetterColorPicker

            title: qsTr("Deactivated Letter Color") + DeviceAccess.managers.translation.emptyString
            name: "off_color"
        }
        Controls.ColorPicker
        {
            id: backgroundColorPicker

            active: HelpersJS.isDesktop || HelpersJS.isWasm
            title: qsTr("Background Color") + DeviceAccess.managers.translation.emptyString
            name: "background_color"
        }
    }
    Controls.MenuSection
    {
        title: qsTr("About") + DeviceAccess.managers.translation.emptyString

        Controls.MenuItem
        {
            title: qsTr("Open source") + DeviceAccess.managers.translation.emptyString
            extras: Controls.IconButton
            {
                name: "github"
                onClicked: openUrl("https://github.com/kokleeko/WordClock")
            }
            details: qsTr("The source code is available on GitHub under the LGPL license.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            active: DeviceAccess.managers.tracking.enabled
            title: qsTr("Bug tracking") + DeviceAccess.managers.translation.emptyString

            QtControls.Switch
            {
                checked: DeviceAccess.managers.tracking.isBugTracking
                onToggled: DeviceAccess.managers.tracking.isBugTracking = checked
            }
            details: qsTr("We anonymously track the appearance of bugs with Firebase in order to correct them \
almost as soon as you encounter them. But you can disable this feature to enter submarine mode.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            id: review

            property int rating: DeviceAccess.managers.persistence.value("About/rating", -1)

            title: qsTr("Review") + DeviceAccess.managers.translation.emptyString
            model: 5
            delegate: QtControls.Button
            {
                property bool isSelected: index <= review.rating

                background: null
                display: QtControls.Button.IconOnly
                icon.source: "qrc:/assets/star-%1.svg".arg(isSelected ? "filled" : "empty")

                onClicked:
                {
                    DeviceAccess.managers.persistence.setValue("About/rating", review.rating = index)
                    if (index >= 3)
                        DeviceAccess.managers.review.requestReview()
                    else
                        badReviewPopup.open()
                }
            }
            details: qsTr("Rate us by clicking on the stars.") + DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            title: qsTr("Also available on") + DeviceAccess.managers.translation.emptyString
            model: [
                { name: "webassembly", visbible: !HelpersJS.isWasm, link: "https://wordclock.kokleeko.io"          },
                { name: "app-store", link: "https://apps.apple.com/app/wordclock/id1626068981"                     },
                { name: "google-play", link: "https://play.google.com/store/apps/details?id=io.kokleeko.wordclock" },
                { name: "lg-store", active: false, link: ""                                                        },
                { name: "ms-store", active: false, link: ""                                                        }
            ]
            delegate: Controls.IconButton
            {
                active: modelData.active ?? true
                name: modelData.name

                onClicked: openUrl(modelData.link)
            }
            details: qsTr("The application may be slightly different depending on the platform used.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            title: qsTr("Contact") + DeviceAccess.managers.translation.emptyString
            model: [
                { name: "twitter", link: "https://twitter.com/kokleeko_io"                      },
                { name: "youtube", link: "https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w" },
                { name: "linkedin", link: "https://www.linkedin.com/in/johanremilien"           },
                { name: "instagram", link: "https://instagram.com/kokleeko.io"                  },
                { name: "email", link: "mailto:contact@kokleeko.io"                             },
                { name: "website", link: "https://www.kokleeko.io"                              }
            ]
            delegate: Controls.IconButton { name: modelData.name; onClicked: openUrl(modelData.link) }
            details: qsTr("We would be happy to receive your feedback.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem
        {
            title: qsTr("Credits") + DeviceAccess.managers.translation.emptyString
            model: [
                { name: QT_TR_NOOP("Built with Qt"), link: "https://www.qt.io"               },
                { name: QT_TR_NOOP("Released with Fastlane"), link: "https://fastlane.tools" },
                { name: QT_TR_NOOP("Icons from SVG Repo"), link: "https://www.svgrepo.com"   },
                { name: QT_TR_NOOP("Localization with Crowdin"), link: "https://crowdin.com" }
            ]
            delegate: QtControls.Button
            {
                QtLayouts.Layout.fillWidth: true
                text: qsTr(modelData.name) + DeviceAccess.managers.translation.emptyString

                onClicked: openUrl(modelData.link)
            }
            details: qsTr("\nDeveloped with love by Johan and published by Denver.") +
                     DeviceAccess.managers.translation.emptyString
        }
        Controls.MenuItem { title: qsTr("Version"); QtControls.Label { text: Qt.application.version } }
    }
}
