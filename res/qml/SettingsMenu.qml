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
        if (Helpers.isMobile)
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
            enabled: !store.purchasing && productTipCoffee.status === Product.Registered
            visible: !Helpers.isPurchasing
            tooltip: "Ko-fi"
            onClicked: openUrl("https://ko-fi.com/johanremilien")
        }

        Controls.IconButton {
            name: "tip-bone"
            enabled: !store.purchasing && productTipBone.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Bone (for Denver)")
            onClicked: {
                store.purchasing = true
                productTipBone.purchase()
            }
        }
        Controls.IconButton {
            name: "tip-latte"
            enabled: !store.purchasing && productTipCoffee.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Latte")
            onClicked: {
                if (Helpers.isPurchasing) {
                    store.purchasing = true
                    productTipCoffee.purchase()
                }
            }
        }
        Controls.IconButton {
            name: "tip-cookie"
            enabled: !store.purchasing && productTipCookie.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Cookie")
            onClicked: {
                store.purchasing = true
                productTipCookie.purchase()
            }
        }
        Controls.IconButton {
            name: "tip-ice-cream"
            enabled: !store.purchasing && productTipIceCream.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Ice Cream")
            onClicked: {
                store.purchasing = true
                productTipIceCream.purchase()
            }
        }
        Controls.IconButton {
            name: "tip-beer"
            enabled: !store.purchasing && productTipBeer.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Beer")
            onClicked: {
                store.purchasing = true
                productTipBeer.purchase()
            }
        }
        Controls.IconButton {
            name: "tip-burger"
            enabled: !store.purchasing && productTipBurger.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Burger")
            onClicked: {
                store.purchasing = true
                productTipBurger.purchase()
            }
        }
        Controls.IconButton {
            name: "tip-wine"
            enabled: !store.purchasing && productTipWine.status === Product.Registered
            visible: Helpers.isPurchasing
            tooltip: qsTr("Wine Bottle")
            onClicked: {
                store.purchasing = true
                productTipWine.purchase()
            }
        }
        show_detailsComponent: Helpers.isPurchasing
        detailsComponent: Controls.Details {
            horizontalAlignment: Label.Center
            font.bold: true
            text: qsTr("These preceding items are representative of a bonus paid to the development team, with no benefit to you.")
        }
    }

    Controls.MenuSection {
        visible: Helpers.isMobile  // @disable-check M16  @disable-check M31
        text: qsTr("Battery Saving")
        Controls.MenuItem {
            text: qsTr("Stay Awake")
            detailsComponent: Controls.Details {
                text: qsTr("\
If this option is enabled, the device's screen will remain active while the application is running.\
\nDon't forget to enable '%1' if you might lose attention on your device.\
").arg(Helpers.isAndroid ? qsTr("App pinning") : qsTr("Guided Access"))
            }
            Switch {
                checked: !DeviceAccess.isAutoLockRequested
                onToggled: DeviceAccess.isAutoLockRequested = !checked
            }
        }
        Controls.MenuItem {
            text: qsTr("App pinning")
            visible: Helpers.isAndroid  // @disable-check M16  @disable-check M31
            Switch { onToggled: DeviceAccess.security(checked) }
        }
        Controls.MenuItem {
            text: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(control.value.toString())
            detailsComponent: Controls.Details {
                text: qsTr("\
'%1' feature will be automatically disabled when the battery level will reach this value,\
 unless the device is charging.").arg(qsTr("Stay Awake")) +
                      (Helpers.isMobile ? "\n(%1: %2%)"
                                          .arg(qsTr("current battery level"))
                                          .arg(DeviceAccess.batteryLevel)
                                        : "")
            }
            Slider {
                from: 20
                to: 50
                stepSize: 5
                value: DeviceAccess.minimumBatteryLevel
                onMoved: DeviceAccess.minimumBatteryLevel = value
            }
        }
        Controls.MenuItem {
            text: "%1 (%2%)".arg(qsTr("Brightness Level")).arg(DeviceAccess.brightness)
            Slider {
                from: 0
                to: 100
                value: DeviceAccess.brightness
                onMoved: DeviceAccess.brightnessRequested = value/100
                Component.onCompleted: {
                    if (Helpers.isAndroid)
                        DeviceAccess.requestBrightnessUpdate();
                }
            }
            detailsComponent: Controls.Details {
                text: qsTr("High brightness levels cause the battery to discharge more faster.")
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("Appearance")
        Controls.MenuItem {
            text: qsTr("Language")
            visible: false
            detailsComponent: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
            }
        }
        Controls.MenuItem {
            text: Helpers.isIos ? qsTr("Hide Status Bar") : qsTr("FullScreen")
            visible: Helpers.isDesktop || Helpers.isMobile  // @disable-check M16  @disable-check M31
            Switch {
                checked: root.isFullScreen
                onToggled: Helpers.updateVisibility(root, DeviceAccess)
                Component.onCompleted: {
                    if (root.isFullScreen !== DeviceAccess.settingsValue("Appearance/fullScreen", false))
                        toggled()
                }
            }
            detailsComponent: Controls.Details {
                text: qsTr("This can also be done by a long press on the clock, when the settings menu is closed.")
            }
        }
        Controls.MenuItem {
            text: qsTr("Clock Language")
            Button {
                text: qsTr("Reset")
                enabled: wordClock.selected_language !== Qt.locale().name
                onClicked: wordClock.detectAndUseDeviceLanguage()
            }
            detailsComponent: ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                displayText: qsTr(currentText)
                currentIndex: Object.keys(wordClock.languages).indexOf(wordClock.selected_language)
                model: Object.values(wordClock.languages)
                onModelChanged: {
                    if (Helpers.isAndroid)
                        currentIndex = Qt.binding(() => Object.keys(wordClock.languages).indexOf(wordClock.selected_language))
                }
                onActivated: (index) => {
                                 const language = Object.keys(wordClock.languages)[index]
                                 wordClock.selectLanguage(language)
                                 DeviceAccess.setSettingsValue("Appearance/clockLanguage", language)
                             }
            }
        }
        Controls.MenuItem {
            text: qsTr("Speech")
            visible: Object.keys(DeviceAccess.speechAvailableLocales).length  // @disable-check M16  @disable-check M31
            Switch {
                checked: wordClock.enable_speech
                onToggled: DeviceAccess.setSettingsValue("Appearance/speech",
                                                         wordClock.enable_speech = checked)
            }
            detailsComponent:
                ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
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
            text: qsTr("Voice")
            visible: Object.keys(DeviceAccess.speechAvailableVoices).length // @disable-check M16  @disable-check M31
            detailsComponent:
                ComboBox {
                //palette.dark: systemPalette.text
                //palette.text: systemPalette.text
                function setSpeechVoice(index) {
                    DeviceAccess.setSpeechVoice(index)
                    if (wordClock.enable_speech)
                        DeviceAccess.say(wordClock.written_time)
                    DeviceAccess.setSettingsValue("Appearance/%1_voice".arg(wordClock.selected_language), index)
                }
                model: Helpers.isAndroid ? [] : DeviceAccess.speechAvailableVoices[wordClock.selected_language]
                onModelChanged: {
                    currentIndex = DeviceAccess.settingsValue("Appearance/%1_voice".arg(wordClock.selected_language), 0)
                    DeviceAccess.setSpeechVoice(currentIndex)
                }
                onActivated: (index) => setSpeechVoice(index)
            }
        }
        Controls.MenuItem {
            text: qsTr("Enable Special Message")
            detailsComponent: Controls.Details { text: qsTr("\
Each grid contains a special message displayed in place of the hour for one minute at the \
following times: 00:00 (12:00 AM), 11:11 (11:11 AM), and 22:22 (10:22 PM). \
The minute indicator at the bottom of the panel will display 0, 1, or 2 lights, \
allowing you to distinguish these different states.") }
            Switch {
                checked: wordClock.enable_special_message
                onToggled: {
                    DeviceAccess.setSettingsValue("Appearance/specialMessage",
                                                  wordClock.enable_special_message = checked)
                    if(Helpers.isEqual(wordClock.time, "00:00:am", "11:11:am", "22:22:pm"))
                        wordClock.updateTable()
                }
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("Advanced")
        Controls.MenuItem {
            text: qsTr("Welcome popup")
            visible: !Helpers.isWebAssembly  // @disable-check M16  @disable-check M31
            Switch {
                checked: root.showWelcome
                onCheckedChanged: DeviceAccess.setSettingsValue("Welcome/showPopup", checked)
            }
            detailsComponent: Controls.Details { text: qsTr("Display at startup.") }
        }
        Controls.MenuItem {
            text: qsTr("Display as widget")
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
            text: "%1 (%2%)".arg(qsTr("Opacity")).arg(Math.floor(control.value))
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
            text: qsTr("Display as watermark")
            visible: Helpers.isDesktop  // @disable-check M16  @disable-check M31
            Button {
                text: "Activate"
                onClicked: {
                    root.visibility = Window.Maximized
                    root.opacity = Math.min(root.opacity, .85)
                    root.flags = (Qt.WindowStaysOnTopHint |
                                  Qt.WindowTransparentForInput |
                                  Qt.FramelessWindowHint)
                    settingPanel.close()
                }
            }
        }
        Controls.MenuItem {
            function halfHoursOffsetToUTC(value) {
                return String("%1%2:%3").arg(Math.sign(value) < 0 ? "-" : "+")
                /**/                    .arg(("0" + Math.abs(Math.trunc(value/2))).slice(-2))
                /**/                    .arg(value%2 ? "30" : "00")
            }

            readonly property int halfHoursDeviceOffset: Math.floor(-wordClock.date.getTimezoneOffset() / 30)
            readonly property string deviceUTC: halfHoursOffsetToUTC(halfHoursDeviceOffset)
            text: qsTr("Time Zone (UTC%1)").arg(details.utc)
            Button {
                text: qsTr("Reset")
                enabled: parent.parent.details.value !== parent.parent.halfHoursDeviceOffset
                onClicked: { parent.parent.details.value = parent.parent.halfHoursDeviceOffset; parent.parent.details.update() }
            }
            detailsComponent: Slider {
                function update() {
                    wordClock.deltaTime = (parent.parent.halfHoursDeviceOffset - value) * 30
                }

                value: parent.parent.halfHoursDeviceOffset
                readonly property string utc: parent.parent.halfHoursOffsetToUTC(value)
                from: -24
                to: 28
                stepSize: 1
                onPressedChanged: if (!pressed) update()
            }
            //            detailsComponent: Controls.Details { text: qsTr("\
            //This setting is not persistent, the time zone of the device is used each time the application is launched.\
            //") }
        }
    }
    Controls.MenuSection {
        function applyColors() {
            let bc  = DeviceAccess.settingsValue("Appearance/backgroundColor", "#000000")
            let alc = DeviceAccess.settingsValue("Appearance/activatedLetterColor", "#FF0000")
            let dlc = DeviceAccess.settingsValue("Appearance/deactivatedLetterColor", "#808080")
            backgroundColorPicker.extraControls[3].setColor(bc)
            activatedLetterColorPicker.extraControls[3].setColor(alc)
            deactivatedLetterColorPicker.extraControls[3].setColor(dlc)
        }
        text: qsTr("Colors")
        visible: Helpers.isDesktop || Helpers.isWebAssembly
        Component.onCompleted: wordClock.applyColors.connect(applyColors)

        Controls.MenuItem {
            id: backgroundColorPicker
            property color selected_color: extraControls[0].selected_color
            text: qsTr("Background Color")
            detailsComponent: Controls.Details { text: qsTr("\
The color can be set in HSL format (Hue, Saturation, Lightness) or in hexadecimal format.") }
            extras: [
                Controls.ColorPicker {},
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    lightness: parent.children[0].lightness
                    factorType: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].lightness = value)
                        moved()
                    }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => {
                            wordClock.background_color = selected_color
                            DeviceAccess.setSettingsValue("Appearance/backgroundColor",
                                                          selected_color.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            id: activatedLetterColorPicker
            property color selected_color: extraControls[0].selected_color
            text: qsTr("Activated Letter Color")
            extras: [
                Controls.ColorPicker {},
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    lightness: parent.children[0].lightness
                    factorType: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].lightness = value)
                        moved()
                    }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => {
                            wordClock.on_color = selected_color
                            DeviceAccess.setSettingsValue("Appearance/activatedLetterColor",
                                                          selected_color.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            id: deactivatedLetterColorPicker
            property color selected_color: extraControls[0].selected_color
            text: qsTr("Deactivated Letter Color")
            extras: [
                Controls.ColorPicker {},
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    lightness: parent.children[0].lightness
                    factorType: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].lightness = value)
                        moved()
                    }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => {
                            wordClock.off_color = selected_color
                            DeviceAccess.setSettingsValue("Appearance/deactivatedLetterColor",
                                                          selected_color.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            text: qsTr("Reset colors")
            Button {
                text: qsTr("Reset")
                onClicked: {
                    backgroundColorPicker.extraControls[3].setColor("#000000")
                    activatedLetterColorPicker.extraControls[3].setColor("#FF0000")
                    deactivatedLetterColorPicker.extraControls[3].setColor("#808080")
                }
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("About")
        Controls.MenuItem {
            text: qsTr("Open source")
            detailsComponent: Controls.Details {
                text: qsTr("The source code is available on GitHub under the MIT license.")
            }
            Controls.IconButton {
                name: "github"
                tooltip: "GitHub"
                onClicked: openUrl("https://github.com/kokleeko/WordClock")
            }
        }
        Controls.MenuItem {
            text: qsTr("Bug tracking")
            visible: false  // @disable-check M16  @disable-check M31
            detailsComponent: Controls.Details {
                text: qsTr("\
We anonymously track the appearance of bugs in Firebase in order to correct them almost as soon as \
you encounter them. But you can disable this feature to enter submarine mode.")
            }
            Switch  {
                checked: DeviceAccess.isBugTracking
                onToggled: DeviceAccess.isBugTracking = checked
            }
        }
        Controls.MenuItem {
            text: qsTr("Review")
            detailsComponent: Controls.Details { text: qsTr("Rate us by clicking on the stars.") }
            Row {
                spacing: 5
                property int rating: DeviceAccess.settingsValue("About/rating", 0)

                Repeater {
                    model: 5
                    Button {
                        property bool isSelected: index <= parent.rating
                        icon.source: "qrc:/assets/star-%1.svg".arg(isSelected ? "filled" : "empty")
                        //icon.color: systemPalette.windowText
                        display: Button.IconOnly
                        background: null
                        onClicked: {
                            DeviceAccess.setSettingsValue("About/rating",
                                                          parent.rating = index)
                            if (index >= 3)
                                DeviceAccess.requestReview()
                            else
                                badReviewPopup.open()
                        }
                    }
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Also available on")
            extras: [
                Controls.IconButton {
                    name: "webassembly"
                    visible: !Helpers.isWebAssembly
                    tooltip: qsTr("WebAssembly")
                    onClicked: openUrl("https://wordclock.kokleeko.io")
                },
                Controls.IconButton {
                    name: "app-store"
                    tooltip: "App Store"
                    onClicked: openUrl("https://testflight.apple.com/join/02s6IwG2")
                },
                Controls.IconButton {
                    name: "google-play"
                    tooltip: "Google Play"
                },
                Controls.IconButton {
                    name: "lg-store"
                    visible: false
                    tooltip: "LG Content store"
                },
                Controls.IconButton {
                    name: "ms-store"
                    visible: false
                    tooltip: "Microsoft Store"
                }
            ]
            detailsComponent: Controls.Details {
                text: qsTr("The functionalities can be different depending on the platform used.")
            }
        }
        Controls.MenuItem {
            text: qsTr("Contact")
            detailsComponent: Controls.Details {
                text: qsTr("We would be happy to receive your feedback.")
            }
            extras: [
                Controls.IconButton {
                    name: "twitter"
                    tooltip: "Twitter"
                    onClicked: openUrl("https://twitter.com/kokleeko_io")
                },
                Controls.IconButton {
                    name: "youtube"
                    tooltip: "YouTube"
                    onClicked: openUrl("https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w")
                },
                Controls.IconButton {
                    name: "linkedin"
                    tooltip: "LinkedIn"
                    onClicked: openUrl("https://www.linkedin.com/in/johanremilien")
                },
                Controls.IconButton {
                    name: "instagram"
                    tooltip: "Instagram"
                    onClicked: openUrl("https://instagram.com/kokleeko.io")
                },
                Controls.IconButton {
                    name: "email"
                    tooltip: qsTr("Email")
                    onClicked: Qt.openUrlExternally("mailto:contact@kokleeko.io")
                },
                Controls.IconButton {
                    name: "website"
                    tooltip: qsTr("Website")
                    onClicked: openUrl("https://www.kokleeko.io")
                }
            ]
        }
        Controls.MenuItem {
            text: qsTr("Credits")
            detailsComponent: Controls.Details {
                text: qsTr("\nDeveloped with love by Johan Remilien and published by Denver.")
            }
            extras: [
                Button {
                    text: qsTr("Built with %1").arg("Qt")
                    Layout.fillWidth: true
                    onClicked: openUrl("https://www.qt.io")
                },
                Button {
                    text: qsTr("Released with %1").arg("Fastlane")
                    Layout.fillWidth: true
                    onClicked: openUrl("https://fastlane.tools")
                },
                Button {
                    text: qsTr("Icons from %1").arg("SVG Repo")
                    Layout.fillWidth: true
                    onClicked: openUrl("https://www.svgrepo.com")
                },
                Button {
                    text: qsTr("Localization with %1").arg("Crowdin")
                    Layout.fillWidth: true
                    onClicked: openUrl("https://crowdin.com")
                }
            ]
        }
        Item { implicitHeight: 25 }
    }
}
