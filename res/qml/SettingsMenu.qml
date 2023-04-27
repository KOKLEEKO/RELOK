/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
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

    title: qsTr(greetings()) + DeviceAccess.emptyString
    footer: Controls.MenuSection {
        is_tipMe: true
        label.heading: headings.h3
        label.horizontalAlignment: Label.AlignHCenter
        label.text: (is_collapsed ? "☞" : "♥").concat(" ", qsTr("Tip me")).concat(" ", is_collapsed ? "☜":"♥")
        /**/            + DeviceAccess.emptyString
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
                tooltip: qsTranslate("Tips", modelData.tooltip) + DeviceAccess.emptyString
                visible: Helpers.isPurchasing
                onClicked: { store.purchasing = true; product.purchase() }
            }
        }
        show_detailsComponent: Helpers.isPurchasing
        detailsComponent: Controls.Details {
            horizontalAlignment: Label.Center
            font.bold: true
            text: qsTr("These preceding items are representative of a bonus paid to the development team, with no \
benefit to you.") + DeviceAccess.emptyString
        }
    }
    Controls.MenuSection {
        visible: Helpers.isMobile  // @disable-check M16  @disable-check M31
        title: qsTr("Battery Saving") + DeviceAccess.emptyString
        Controls.MenuItem {
            title: qsTr("Stay Awake") + DeviceAccess.emptyString
            details: qsTr("If this option is enabled, the device's screen will remain active while the application is \
running.\nDon't forget to enable '%1' if you might lose attention on your device.")
            .arg(Helpers.isAndroid ? qsTr("App pinning") : qsTr("Guided Access")) + DeviceAccess.emptyString
        }
            Switch {
                checked: !DeviceAccess.isAutoLockRequested
                onToggled: DeviceAccess.isAutoLockRequested = !checked
            }
            Controls.MenuItem {
                title: qsTr("App pinning") + DeviceAccess.emptyString
                visible: Helpers.isAndroid  // @disable-check M16  @disable-check M31
                Switch { onToggled: DeviceAccess.security(checked) }
            }
            Controls.MenuItem {
                title: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(extraControls[0].value.toString())
                       + DeviceAccess.emptyString
                details: qsTr("'%1' feature will be automatically disabled when the battery level reaches this value \
unless the device charges.").arg(qsTr("Stay Awake")) + (Helpers.isMobile ? "\n(%1: %2%)"
                                                                           .arg(qsTr("battery level"))
                                                                           .arg(DeviceAccess.batteryLevel) : "")
                /**/       + DeviceAccess.emptyString
                extras: Slider {
                    from: 20
                    to: 50
                    stepSize: 5
                    value: DeviceAccess.minimumBatteryLevel
                    onMoved: DeviceAccess.minimumBatteryLevel = value
                }
            }
            Controls.MenuItem {
                title: "%1 (%2%)".arg(qsTr("Brightness Level")).arg(DeviceAccess.brightness) + DeviceAccess.emptyString
                extras: Slider {
                    from: 0
                    to: 100
                    value: DeviceAccess.brightness
                    onMoved: DeviceAccess.brightnessRequested = value/100
                    Component.onCompleted: if (Helpers.isAndroid) DeviceAccess.requestBrightnessUpdate();
                }
                details: qsTr("High brightness levels cause the battery to discharge faster.") + DeviceAccess.emptyString
            }
        }
        Controls.MenuSection {
            title: qsTr("Appearance") + DeviceAccess.emptyString
            Controls.MenuItem {
                title: (Helpers.isIos ? qsTr("Hide Status Bar") : qsTr("FullScreen")) + DeviceAccess.emptyString
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
                /**/       + DeviceAccess.emptyString
            }
            Controls.MenuItem {
                title: qsTr("Application Language") + DeviceAccess.emptyString
                readonly property string defaultLanguage: Qt.locale().name.substr(0,2)
                function switchLanguage(language) {
                    DeviceAccess.switchLanguage(language)
                    DeviceAccess.setSettingsValue("Appearance/uiLanguage", language)
                }

                Button {
                    text: qsTr("Reset") + DeviceAccess.emptyString
                    enabled: Object.keys(DeviceAccess.availableTranslations)[parent.parent.parent.extraControls[0].currentIndex] !== parent.parent.parent.defaultLanguage
                    onClicked: {
                        parent.parent.parent.switchLanguage(parent.parent.parent.defaultLanguage)
                        parent.parent.parent.extraControls[0].currentIndex = Object.keys(DeviceAccess.availableTranslations).indexOf(parent.parent.parent.defaultLanguage)
                    }
                }
                extras: ComboBox {
                    //palette.dark: systemPalette.text
                    //palette.text: systemPalette.text
                    width: parent.width
                    model: Object.values(DeviceAccess.availableTranslations)
                    onActivated: (index) => {
                                     parent.parent.parent.switchLanguage(Object.keys(DeviceAccess.availableTranslations)[index])
                                 }
                    Component.onCompleted: {
                        currentIndex = Object.keys(DeviceAccess.availableTranslations)
                        .indexOf(DeviceAccess.settingsValue("Appearance/uiLanguage", parent.parent.parent.defaultLanguage))
                    }
                }
            }
            Controls.MenuItem {
                title: qsTr("Clock Language") + DeviceAccess.emptyString
                Button {
                    text: qsTr("Reset") + DeviceAccess.emptyString
                    enabled: wordClock.selected_language !== Qt.locale().name
                    onClicked: wordClock.detectAndUseDeviceLanguage()
                }
                extras: ComboBox {
                    //palette.dark: systemPalette.text
                    //palette.text: systemPalette.text
                    width: parent.width
                    currentIndex: Object.keys(wordClock.languages).indexOf(wordClock.selected_language)
                    model: Object.values(wordClock.languages)
                    onModelChanged: {
                        if (Helpers.isAndroid)
                            currentIndex = Qt.binding(() => Object.keys(wordClock.languages)
                                                      .indexOf(wordClock.selected_language))
                    }
                    onActivated: (index) => {
                                     const language = Object.keys(wordClock.languages)[index]
                                     wordClock.selectLanguage(language)
                                     DeviceAccess.setSettingsValue("Appearance/clockLanguage", language)
                                 }
                }
            }
            Controls.MenuItem {
                title: qsTr("Speech") + DeviceAccess.emptyString
                visible: Object.keys(DeviceAccess.speechAvailableLocales).length  // @disable-check M16  @disable-check M31
                Switch {
                    checked: wordClock.enable_speech
                    onToggled: DeviceAccess.setSettingsValue("Appearance/speech", wordClock.enable_speech = checked)
                }
                extras: ComboBox {
                    //palette.dark: systemPalette.text
                    //palette.text: systemPalette.text
                    width: parent.width
                    currentIndex: Object.keys(wordClock.speech_frequencies).indexOf(wordClock.speech_frequency)
                    model: Object.values(wordClock.speech_frequencies)
                    onActivated: (index) => {
                                     const speech_frequency = Object.keys(wordClock.speech_frequencies)[index]
                                     wordClock.speech_frequency = speech_frequency
                                     DeviceAccess.setSettingsValue("Appearance/speech_frequency", speech_frequency)
                                 }
                }
            }
            Controls.MenuItem {
                title: qsTr("Voice") + DeviceAccess.emptyString
                visible: Object.keys(DeviceAccess.speechAvailableVoices).length // @disable-check M16  @disable-check M31
                extras: ComboBox {
                    //palette.dark: systemPalette.text
                    //palette.text: systemPalette.text
                    function setSpeechVoice(index) {
                        DeviceAccess.setSpeechVoice(index)
                        if (wordClock.enable_speech) DeviceAccess.say(wordClock.written_time)
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
                title: qsTr("Enable Special Message") + DeviceAccess.emptyString
                details: qsTr("Each grid contains a special message displayed in place of the hour for one minute at the \
following times: 00:00 (12:00 AM), 11:11 (11:11 AM), and 22:22 (10:22 PM). The (4-dot) minute indicator will display \
0, 1, or 2 lights, allowing you to distinguish these different times.") + DeviceAccess.emptyString
                Switch {
                    checked: wordClock.enable_special_message
                    onToggled: {
                        DeviceAccess.setSettingsValue("Appearance/specialMessage", wordClock.enable_special_message = checked)
                        if(Helpers.isWeaklyEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm")) wordClock.updateTable()
                    }
                }
            }
        }
        Controls.MenuSection {
            title: qsTr("Advanced") + DeviceAccess.emptyString
            Controls.MenuItem {
                title: qsTr("Display as widget") + DeviceAccess.emptyString
                visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
                Switch {
                    checked: root.isWidget
                    onToggled: Helpers.updateDisplayMode(root)
                    Component.onCompleted: {
                        if (root.isWidget !== DeviceAccess.settingsValue("Appearance/widget", false)) toggled()
                    }
                }
            }
            Controls.MenuItem {
                visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
                enabled: !root.isFullScreen  // @disable-check M16  @disable-check M31
                title: "%1 (%2%)".arg(qsTr("Opacity")).arg(Math.floor(control.value)) + DeviceAccess.emptyString
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
                title: qsTr("Display as watermark") + DeviceAccess.emptyString
                visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
                Button {
                    text: qsTr("Activate") + DeviceAccess.emptyString
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
                title: qsTr("Time Zone (%1)").arg(wordClock.selectedGMT) + DeviceAccess.emptyString
                Button {
                    text: qsTr("Reset") + DeviceAccess.emptyString
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
is used each time the application is launched".arg(wordClock.deviceGMT)) + DeviceAccess.emptyString
            }
            Controls.LargePositionSelector {
                title: qsTr("Time Zone display mode") + DeviceAccess.emptyString
                name: "timeZone"
            }
            Controls.LargePositionSelector {
                title: qsTr("Date display mode") + DeviceAccess.emptyString
                name: "date"
            }
            Controls.LargePositionSelector {
                title: qsTr("4-Dot display mode") + DeviceAccess.emptyString
                name: "minutes"
            }
            Controls.SmallPositionSelector {
                title: qsTr("Seconds display mode") + DeviceAccess.emptyString
                name: "seconds"
            }
            Controls.SmallPositionSelector {
                title: qsTr("AM|PM display mode") + DeviceAccess.emptyString
                name: "ampm"
            }
            Controls.SmallPositionSelector {
                title: qsTr("Week Number display mode") + DeviceAccess.emptyString
                name: "weekNumber"
            }
            Controls.SmallPositionSelector {
                title: qsTr("Battery Level display mode") + DeviceAccess.emptyString
                name: "batteryLevel"
                visible: Helpers.isMobile
            }
            Controls.MenuItem {
                title: qsTr("Welcome popup") + DeviceAccess.emptyString
                visible: !Helpers.isWasm  // @disable-check M16  @disable-check M31
                Switch {
                    checked: root.showWelcome
                    onCheckedChanged: DeviceAccess.setSettingsValue("Welcome/showPopup", checked)
                }
                details: qsTr("Display at startup.") + DeviceAccess.emptyString
            }
        }
        Controls.MenuSection {
            readonly property string default_on_color: "#F00"
            readonly property string default_off_color: "#888"
            readonly property string default_background_color: "#000"

            function applyColors() {
                const on_color = DeviceAccess.settingsValue("Appearance/on_color", default_on_color)
                const off_color = DeviceAccess.settingsValue("Appearance/off_color", default_off_color)
                const background_color = DeviceAccess.settingsValue("Appearance/background_color", default_background_color)
                activatedLetterColorPicker.extraControls[3].setColor(on_color)
                deactivatedLetterColorPicker.extraControls[3].setColor(off_color)
                backgroundColorPicker.extraControls[3].setColor(background_color)
            }
            title: qsTr("Colors") + DeviceAccess.emptyString
            Component.onCompleted: wordClock.applyColors.connect(applyColors)
            Controls.ColorPicker {
                id: activatedLetterColorPicker
                title: qsTr("Activated Letter Color") + DeviceAccess.emptyString
                name: "on_color"
                details: qsTr("The color can be set in HSL (Hue, Saturation, Lightness) or in hexadecimal format.")
                /**/       + DeviceAccess.emptyString
            }
            Controls.ColorPicker {
                id: deactivatedLetterColorPicker
                title: qsTr("Deactivated Letter Color") + DeviceAccess.emptyString
                name: "off_color"
            }
            Controls.ColorPicker {
                id: backgroundColorPicker
                title: qsTr("Background Color") + DeviceAccess.emptyString
                name: "background_color"
                visible: Helpers.isDesktop || Helpers.isWasm
            }
        }
        Controls.MenuSection {
            title: qsTr("About") + DeviceAccess.emptyString
            Controls.MenuItem {
                title: qsTr("Open source") + DeviceAccess.emptyString
                extras:
                    Controls.IconButton { name: "github"; onClicked: openUrl("https://github.com/kokleeko/WordClock") }
                details: qsTr("The source code is available on GitHub under the LGPL license.")
                /**/+ DeviceAccess.emptyString }
            Controls.MenuItem {
                title: qsTr("Bug tracking") + DeviceAccess.emptyString
                visible: false  // @disable-check M16  @disable-check M31
                Switch  { checked: DeviceAccess.isBugTracking; onToggled: DeviceAccess.isBugTracking = checked }
                details: qsTr("We anonymously track the appearance of bugs with Firebase in order to correct them almost as \
soon as you encounter them. But you can disable this feature to enter submarine mode.") + DeviceAccess.emptyString
            }
            Controls.MenuItem {
                title: qsTr("Review") + DeviceAccess.emptyString
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
                details: qsTr("Rate us by clicking on the stars.") + DeviceAccess.emptyString
            }
            Controls.MenuItem {
                title: qsTr("Also available on") + DeviceAccess.emptyString
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
                /**/+ DeviceAccess.emptyString
            }
            Controls.MenuItem {
                title: qsTr("Contact") + DeviceAccess.emptyString
                model: [ { name: "twitter", link: "https://twitter.com/kokleeko_io" },
                    /**/ { name: "youtube", link: "https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w" },
                    /**/ { name: "linkedin", link: "https://www.linkedin.com/in/johanremilien" },
                    /**/ { name: "instagram", link: "https://instagram.com/kokleeko.io" },
                    /**/ { name: "email", link: "mailto:contact@kokleeko.io" },
                    /**/ { name: "website", link: "https://www.kokleeko.io" } ]
                delegate: Controls.IconButton { name: modelData.name; onClicked: openUrl(modelData.link) }
                details: qsTr("We would be happy to receive your feedback.") + DeviceAccess.emptyString
            }
            Controls.MenuItem {
                title: qsTr("Credits") + DeviceAccess.emptyString
                model: [ { name: QT_TR_NOOP("Built with Qt"), link: "https://www.qt.io" },
                    /**/ { name: QT_TR_NOOP("Released with Fastlane"), link: "https://fastlane.tools" },
                    /**/ { name: QT_TR_NOOP("Icons from SVG Repo"), link: "https://www.svgrepo.com" },
                    /**/ { name: QT_TR_NOOP("Localization with Crowdin"), link: "https://crowdin.com" } ]
                delegate: Button {
                    text: qsTr(modelData.name) + DeviceAccess.emptyString
                    Layout.fillWidth: true
                    onClicked: openUrl(modelData.link)
                }
                details: qsTr("\nDeveloped with love by Johan and published by Denver.") + DeviceAccess.emptyString
            }
        }
    }
