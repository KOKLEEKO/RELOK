/**************************************************************************************************
**    Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**    All rights reserved.
**    Licensed under the MIT license. See LICENSE file in the project root for
**    details.
**    Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtPurchasing 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qrc:/qml/controls" as Controls
import "qrc:/js/Helpers.js" as Helpers

Controls.Menu {
    function openUrl(url) {
        if (Helpers.isMobile && url.split(":")[0] !== "mailto")
            webView.openUrl(url)
        else
            Qt.openUrlExternally(url)
    }

    function greetings() {
        if (wordClock.is_AM)
            return QT_TR_NOOP("Good Morning!")
        else if (parseInt(wordClock.hours_value) < 18) // 6:00 PM
            return QT_TR_NOOP("Good Afternoon!")
        return QT_TR_NOOP("Good Evening!")
    }

    anchors.fill: parent  // @disable-check M16  @disable-check M31

    text: qsTr(greetings())
    footer: Controls.MenuSection {
        is_tipMe: true
        title.heading: headings.h3
        title.horizontalAlignment: Label.AlignHCenter
        title.text: (is_collapsed ? "☞" : "♥").concat(" ", qsTr("Tip me")).concat(" ", is_collapsed ? "☜":"♥")
        Layout.alignment: Qt.AlignBottom
        menuItems.flow: GridLayout.LeftToRight

        Controls.IconButton {
            name: "ko-fi"
            visible: !Helpers.isPurchasing
            tooltip: "Ko-fi"
            onClicked: openUrl("https://ko-fi.com/johanremilien")
        }
        Repeater {
            model: tipsModel
            Controls.IconButton {
                readonly property Product product: products[modelData.name]
                name: "tip-" + modelData.name
                Layout.fillWidth: true
                enabled: !store.purchasing && product.status === Product.Registered
                tooltip: qsTr(modelData.tooltip)
                visible: Helpers.isPurchasing
                onClicked: { store.purchasing = true; product.purchase() }
            }
        }
        show_detailsComponent: Helpers.isPurchasing
        detailsComponent: Controls.Details {
            horizontalAlignment: Label.Center
            font.bold: true
            text: qsTr("These preceding items are representative of a bonus paid to the development team, \
with no benefit to you.")
        }
    }
    Controls.MenuSection {
        visible: Helpers.isMobile  // @disable-check M16  @disable-check M31
        text: qsTr("Battery Saving")
        Controls.MenuItem {
            title: qsTr("Stay Awake")
            details: qsTr("If this option is enabled, the device's screen will remain active while the application is \
running.\nDon't forget to enable '%1' if you might lose attention on your device.")
            .arg(Helpers.isAndroid ? qsTr("App pinning") : qsTr("Guided Access"))
        }
        Switch {
            checked: !DeviceAccess.isAutoLockRequested
            onToggled: DeviceAccess.isAutoLockRequested = !checked
        }
        Controls.MenuItem {
            title: qsTr("App pinning")
            visible: Helpers.isAndroid  // @disable-check M16  @disable-check M31
            Switch { onToggled: DeviceAccess.security(checked) }
        }
        Controls.MenuItem {
            title: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(extraControls[0].value.toString())
            details: qsTr("'%1' feature will be automatically disabled when the battery level reaches this value unless\
 the device charges.").arg(qsTr("Stay Awake")) + (Helpers.isMobile ? "\n(%1: %2%)"
                                                                                .arg(qsTr("battery level"))
                                                                                .arg(DeviceAccess.batteryLevel) : "")
            extras: Slider {
                from: 20
                to: 50
                stepSize: 5
                value: DeviceAccess.minimumBatteryLevel
                onMoved: DeviceAccess.minimumBatteryLevel = value
            }
        }
        Controls.MenuItem {
            title: "%1 (%2%)".arg(qsTr("Brightness Level")).arg(DeviceAccess.brightness)
            extras: Slider {
                from: 0
                to: 100
                value: DeviceAccess.brightness
                onMoved: DeviceAccess.brightnessRequested = value/100
                Component.onCompleted: if (Helpers.isAndroid) DeviceAccess.requestBrightnessUpdate();
            }
            details: qsTr("High brightness levels cause the battery to discharge faster.")
        }
    }
    Controls.MenuSection {
        text: qsTr("Appearance")
        Controls.MenuItem {
            title: Helpers.isIos ? qsTr("Hide Status Bar") : qsTr("FullScreen")
            visible: Helpers.isDesktop || Helpers.isMobile  // @disable-check M16  @disable-check M31
            Switch {
                checked: root.isFullScreen
                onToggled: Helpers.updateVisibility(root, DeviceAccess)
                Component.onCompleted: {
                    if (root.isFullScreen !== DeviceAccess.settingsValue("Appearance/fullScreen", false))
                        toggled()
                }
            }
            details: qsTr("When the settings menu is closed, this can also be done by a long press on the clock.")
        }
        Controls.MenuItem {
            title: qsTr("Application Language")
            extras: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                model: Object.values(DeviceAccess.availableTranslations)
                onActivated: (index) => {
                                 const language = Object.keys(DeviceAccess.availableTranslations)[index]
                                 DeviceAccess.switchLanguage(language)
                                 DeviceAccess.setSettingsValue("Appearance/uiLanguage", language)
                             }
            }
        }
        Controls.MenuItem {
            title: qsTr("Clock Language")
            Button {
                text: qsTr("Reset")
                enabled: wordClock.selected_language !== Qt.locale().name
                onClicked: wordClock.detectAndUseDeviceLanguage()
            }
            extras: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                width: parent.width
                displayText: qsTr(currentText)
                currentIndex: Object.keys(wordClock.languages).indexOf(wordClock.selected_language)
                model: Object.values(wordClock.languages)
                onModelChanged: {
                    if (Helpers.isAndroid)
                        currentIndex = Qt.binding(() =>
                                                  Object.keys(wordClock.languages).indexOf(wordClock.selected_language))
                }
                onActivated: (index) => {
                                 const language = Object.keys(wordClock.languages)[index]
                                 wordClock.selectLanguage(language)
                                 DeviceAccess.setSettingsValue("Appearance/clockLanguage", language)
                             }
            }
        }
        Controls.MenuItem {
            title: qsTr("Speech")
            visible: Object.keys(DeviceAccess.speechAvailableLocales).length  // @disable-check M16  @disable-check M31
            Switch {
                checked: wordClock.enable_speech
                onToggled: DeviceAccess.setSettingsValue("Appearance/speech", wordClock.enable_speech = checked)
            }
            extras: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                width: parent.width
                displayText: qsTr(currentText)
                currentIndex: Object.keys(wordClock.speech_frequencies).indexOf(wordClock.speech_frequency)
                model: Object.values(wordClock.speech_frequencies)
                onActivated: (index) =>
                             {
                                 const speech_frequency = Object.keys(wordClock.speech_frequencies)[index]
                                 wordClock.speech_frequency = speech_frequency
                                 DeviceAccess.setSettingsValue("Appearance/speech_frequency", speech_frequency)
                             }
            }
        }
        Controls.MenuItem {
            title: qsTr("Voice")
            visible: Object.keys(DeviceAccess.speechAvailableVoices).length // @disable-check M16  @disable-check M31
            extras: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                function setSpeechVoice(index) {
                    DeviceAccess.setSpeechVoice(index)
                    if (wordClock.enable_speech)
                        DeviceAccess.say(wordClock.written_time)
                    DeviceAccess.setSettingsValue("Appearance/%1_voice".arg(wordClock.selected_language), index)
                }
                width: parent.width
                model: Helpers.isAndroid ? [] : DeviceAccess.speechAvailableVoices[wordClock.selected_language]
                onModelChanged: {
                    currentIndex = DeviceAccess.settingsValue("Appearance/%1_voice".arg(wordClock.selected_language), 0)
                    DeviceAccess.setSpeechVoice(currentIndex)
                }
                onActivated: (index) => setSpeechVoice(index)
            }
        }
        Controls.MenuItem {
            title: qsTr("Enable Special Message")
            details: qsTr("Each grid contains a special message displayed in place of the hour for one minute at the \
following times: 00:00 (12:00 AM), 11:11 (11:11 AM), and 22:22 (10:22 PM). The (4-dot) minute indicator will display \
0, 1, or 2 lights, allowing you to distinguish these different times.")
            Switch {
                checked: wordClock.enable_special_message
                onToggled: {
                    DeviceAccess.setSettingsValue("Appearance/specialMessage",
                                                  wordClock.enable_special_message = checked)
                    if(Helpers.isWeaklyEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm"))
                        wordClock.updateTable()
                }
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("Advanced")
        Controls.MenuItem {
            title: qsTr("Display as widget")
            visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
            Switch {
                checked: root.isWidget
                onToggled: Helpers.updateDisplayMode(root)
                Component.onCompleted: {
                    if (root.isWidget !== DeviceAccess.settingsValue("Appearance/widget", false))
                        toggled()
                }
            }
        }
        Controls.MenuItem {
            visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
            enabled: !root.isFullScreen  // @disable-check M16  @disable-check M31
            title: "%1 (%2%)".arg(qsTr("Opacity")).arg(Math.floor(control.value))
            Slider {
                from: 10
                to: 100
                value: DeviceAccess.settingsValue("Appearance/opacity", 1) * 100
                onMoved: {
                    root.opacity = value/100
                    DeviceAccess.setSettingsValue("Appearance/opacity", root.opacity)
                }
            }
        }
        Controls.MenuItem {
            title: qsTr("Display as watermark")
            visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
            Button {
                text: "Activate"
                onClicked: {
                    root.visibility = Window.Maximized
                    root.opacity = Math.min(root.opacity, .85)
                    root.flags = (Qt.WindowStaysOnTopHint | Qt.WindowTransparentForInput | Qt.FramelessWindowHint)
                    settingPanel.close()
                }
            }
        }
        Controls.MenuItem {
            function update() { wordClock.deltaTime = (wordClock.deviceOffset - extraControls[0].value) * 30 }
            title: qsTr("Time Zone (%1)").arg(wordClock.selectedGMT)
            Button {
                text: qsTr("Reset")
                enabled: wordClock.selectedGMT !== wordClock.deviceGMT
                onClicked: {
                    parent.parent.parent.extraControls[0].value = wordClock.deviceOffset
                    parent.parent.parent.update()
                }
            }
            extras:
                Slider {
                value: wordClock.deviceOffset
                from: -24
                to: 28
                stepSize: 1
                onPressedChanged: if (!pressed) parent.parent.parent.update()
                onValueChanged: wordClock.selectedGMT = "GMT%1".arg(wordClock.offsetToGMT(value))
            }
            details: qsTr("This setting is not persistent, the time zone of the device <b>(%1)</b> \
is used each time the application is launched".arg(wordClock.deviceGMT))
        }
        Controls.LargePositionSelector { title: qsTr("Time Zone display mode"); name: "timeZone" }
        Controls.LargePositionSelector { title: qsTr("Date display mode"); name: "date" }
        Controls.LargePositionSelector { title: qsTr("4-Dot display mode"); name: "minutes" }
        Controls.SmallPositionSelector { title: qsTr("Seconds display mode"); name: "seconds" }
        Controls.SmallPositionSelector { title: qsTr("AM|PM display mode"); name: "ampm" }
        Controls.SmallPositionSelector { title: qsTr("Week Number display mode"); name: "weekNumber" }
        Controls.SmallPositionSelector { title: qsTr("Battery Level display mode"); name: "batteryLevel"; visible: Helpers.isMobile }
        Controls.MenuItem {
            title: qsTr("Welcome popup")
            visible: !Helpers.isWasm  // @disable-check M16  @disable-check M31
            Switch {
                checked: root.showWelcome
                onCheckedChanged: DeviceAccess.setSettingsValue("Welcome/showPopup", checked)
            }
            details: qsTr("Display at startup.")
        }
    }
    Controls.MenuSection {
        readonly property string default_on_color: "#F00"
        readonly property string default_off_color: "#888"
        readonly property string default_background_color: "#000"

        function applyColors() {
            const on_color = DeviceAccess.settingsValue("Appearance/on_color",
                                                                default_on_color)
            const off_color = DeviceAccess.settingsValue("Appearance/off_color",
                                                                 default_off_color)
            const background_color  = DeviceAccess.settingsValue("Appearance/background_color",
                                                                         default_background_color)
            activatedLetterColorPicker.extraControls[3].setColor(on_color)
            deactivatedLetterColorPicker.extraControls[3].setColor(off_color)
            backgroundColorPicker.extraControls[3].setColor(background_color)
        }
        text: qsTr("Colors")
        Component.onCompleted: wordClock.applyColors.connect(applyColors)
        Controls.ColorPicker {
            id: activatedLetterColorPicker
            title: qsTr("Activated Letter Color")
            name: "on_color"
            details: qsTr("The color can be set in HSL (Hue, Saturation, Lightness) or in hexadecimal format.")
        }
        Controls.ColorPicker {
            id: deactivatedLetterColorPicker
            title: qsTr("Deactivated Letter Color")
            name: "off_color"
        }
        Controls.ColorPicker {
            id: backgroundColorPicker
            title: qsTr("Background Color")
            name: "background_color"
            visible: Helpers.isDesktop || Helpers.isWasm
        }
    }
    Controls.MenuSection {
        text: qsTr("About")
        Controls.MenuItem {
            title: qsTr("Open source")
            extras: Controls.IconButton { name: "github"; onClicked: openUrl("https://github.com/kokleeko/WordClock") }
            details: qsTr("The source code is available on GitHub under the MIT license.") }
        Controls.MenuItem {
            title: qsTr("Bug tracking")
            visible: false  // @disable-check M16  @disable-check M31
            Switch  { checked: DeviceAccess.isBugTracking; onToggled: DeviceAccess.isBugTracking = checked }
            details: qsTr("We anonymously track the appearance of bugs with Firebase in order to correct them almost as \
soon as you encounter them. But you can disable this feature to enter submarine mode.")
        }
        Controls.MenuItem {
            title: qsTr("Review")
            property int rating: DeviceAccess.settingsValue("About/rating", 0)
            model: 5
            delegate: Button {
                property bool isSelected: index <= parent.parent.parent.rating
                icon.source: "qrc:/assets/star-%1.svg".arg(isSelected ? "filled" : "empty")
                display: Button.IconOnly
                background: null
                onClicked: {
                    DeviceAccess.setSettingsValue("About/rating", parent.parent.parent.rating = index)
                    if (index >= 3)
                        DeviceAccess.requestReview()
                    else
                        badReviewPopup.open()
                }
            }
            details: qsTr("Rate us by clicking on the stars.")
        }
        Controls.MenuItem {
            title: qsTr("Also available on")
            model: [ { name: "webassembly", visbible: !Helpers.isWasm, link: "https://wordclock.kokleeko.io" },
                /**/ { name: "app-store", link: "https://testflight.apple.com/join/02s6IwG2" },
                /**/ { name: "google-play", visible: false, link: "" },
                /**/ { name: "lg-store", visible: false, link: "" },
                /**/ { name: "ms-store", visible: false, link: "" } ]
            delegate: Controls.IconButton {
                name: modelData.name
                visible: modelData.visible ?? true
                onClicked: openUrl(modelData.link)
            }
            details: qsTr("The application may be slightly different depending on the platform used.")
        }
        Controls.MenuItem {
            title: qsTr("Contact")
            model: [ { name: "twitter", link: "https://twitter.com/kokleeko_io" },
                /**/ { name: "youtube", link: "https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w" },
                /**/ { name: "linkedin", link: "https://www.linkedin.com/in/johanremilien" },
                /**/ { name: "instagram", link: "https://instagram.com/kokleeko.io" },
                /**/ { name: "email", link: "mailto:contact@kokleeko.io" },
                /**/ { name: "website", link: "https://www.kokleeko.io" } ]
            delegate: Controls.IconButton { name: modelData.name; onClicked: openUrl(modelData.link) }
            details: qsTr("We would be happy to receive your feedback.")
        }
        Controls.MenuItem {
            title: qsTr("Credits")
            model: [ { name: QT_TR_NOOP("Built with %1").arg("Qt"),link: "https://www.qt.io" },
                /**/ { name: QT_TR_NOOP("Released with %1").arg("Fastlane"), link: "https://fastlane.tools" },
                /**/ { name: QT_TR_NOOP("Icons from %1").arg("SVG Repo"), link: "https://www.svgrepo.com" },
                /**/ { name: QT_TR_NOOP("Localization with %1").arg("Crowdin"), link: "https://crowdin.com" } ]
            delegate: Button { text: qsTr(modelData.name); Layout.fillWidth: true; onClicked: openUrl(modelData.link) }
            details: qsTr("\nDeveloped with love by Johan and published by Denver.")
        }
    }
}
