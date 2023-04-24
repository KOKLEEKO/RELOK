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
            text: qsTr("These preceding items are representative of a bonus paid to the development team, \
with no benefit to you.")
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
            detailsComponent:
                Controls.Details { text: qsTr("High brightness levels cause the battery to discharge more faster.") }
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
            text: qsTr("Speech")
            visible: Object.keys(DeviceAccess.speechAvailableLocales).length  // @disable-check M16  @disable-check M31
            Switch {
                checked: wordClock.enable_speech
                onToggled: DeviceAccess.setSettingsValue("Appearance/speech", wordClock.enable_speech = checked)
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
            visible: !Helpers.isWasm  // @disable-check M16  @disable-check M31
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
            detailsComponent: Controls.Details {
                text: qsTr("")
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
            detailsComponent: Controls.Details {
                text: qsTr("")
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
            detailsComponent: Controls.Details {
                text: qsTr("")
            }
        }
        Controls.MenuItem {
            text: qsTr("Week number display mode")
            Repeater {
                model: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    readonly property int buttonIndex: index
                    text: qsTr(modelData)
                    autoExclusive: false
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    background: Rectangle {
                        color: (index == 2 && parent.checked) ? palette.dark : palette.button
                        implicitWidth: 100
                        implicitHeight: 40
                    }
                    contentItem: ColumnLayout {
                        Text {
                            color: (index == 2 && parent.parent.checked) ? palette.brightText : palette.buttonText
                            text: parent.parent.text
                            Layout.alignment: Qt.AlignHCenter
                        }
                        Loader {
                            active: index !== 2
                            Layout.fillWidth: true
                            sourceComponent:
                                RowLayout {
                                Repeater {
                                    model: [ QT_TR_NOOP("Left"), QT_TR_NOOP("Center"), QT_TR_NOOP("Right")]
                                    RadioButton {
                                        Layout.fillWidth: true
                                        text: qsTr(modelData)
                                        checked: (wordClock.weekNumberDisplayMode === buttonIndex &&
                                                  wordClock.weekNumberAlignment === index)
                                        onToggled: {
                                            wordClock.weekNumberDisplayMode = buttonIndex
                                            wordClock.weekNumberAlignment = index
                                        }
                                    }
                                }
                            }
                        }
                    }
                    checked: wordClock.weekNumberDisplayMode === buttonIndex
                    onClicked: { if (index == 2) wordClock.weekNumberDisplayMode = buttonIndex }
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("AM|PM indicator display mode")
            Repeater {
                model: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    text: qsTr(modelData)
                    autoExclusive: true
                    checked: wordClock.ampmDisplayMode === index
                    onClicked: wordClock.ampmDisplayMode = index
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Minutes indicator display mode")
            Repeater {
                model: [ QT_TR_NOOP("Around"), QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    text: qsTr(modelData)
                    autoExclusive: true
                    enabled: index === 3 || !Helpers.isEqual(index,
                                                             wordClock.timeZoneDisplayMode+1,
                                                             wordClock.dateDisplayMode+1)
                    checked: wordClock.minuteIndicatorDisplayMode === index
                    onClicked: wordClock.minuteIndicatorDisplayMode = index
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Seconds display mode")
            Repeater {
                model: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    text: qsTr(modelData)
                    autoExclusive: true
                    checked: wordClock.secondsDisplayMode === index
                    onClicked: wordClock.secondsDisplayMode = index
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Date display mode")
            Repeater {
                model: [QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    text: qsTr(modelData)
                    autoExclusive: true
                    enabled: index === 2 || !Helpers.isEqual(index,
                                                             wordClock.minuteIndicatorDisplayMode-1,
                                                             wordClock.timeZoneDisplayMode)
                    checked: wordClock.dateDisplayMode === index
                    onClicked: wordClock.dateDisplayMode = index
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Time zone display mode")
            Repeater {
                model: [QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
                onItemAdded: parent.parent.extras.push(item)
                Button {
                    text: qsTr(modelData)
                    autoExclusive: true
                    enabled: index === 2 || !Helpers.isEqual(index,
                                                             wordClock.minuteIndicatorDisplayMode-1,
                                                             wordClock.dateDisplayMode)
                    checked: wordClock.timeZoneDisplayMode === index
                    onClicked: wordClock.timeZoneDisplayMode = index
                }
            }
        }
        Controls.MenuItem {
            function update() { wordClock.deltaTime = (wordClock.deviceOffset - control.value) * 30 }
            text: qsTr("Selected time zone (%1)").arg(wordClock.selectedGMT)
            Slider {
                value: wordClock.deviceOffset
                from: -24
                to: 28
                stepSize: 1
                onPressedChanged: if (!pressed) parent.parent.update()
                onValueChanged: wordClock.selectedGMT = "GMT%1".arg(wordClock.offsetToGMT(value))
            }
            detailsComponent:
                Controls.Details { text: qsTr("This setting is not persistent, the time zone of the device <b>(%1)</b> \
is used each time the application is launched".arg(wordClock.deviceGMT)) }
        }
    }
    Controls.MenuSection {
        function applyColors() {
            let backgroundColor  = DeviceAccess.settingsValue("Appearance/backgroundColor", "#000000")
            let activatedLetterColor = DeviceAccess.settingsValue("Appearance/activatedLetterColor", "#FF0000")
            let deactivatedLetterColor = DeviceAccess.settingsValue("Appearance/deactivatedLetterColor", "#808080")
            backgroundColorPicker.extraControls[3].setColor(backgroundColor)
            activatedLetterColorPicker.extraControls[3].setColor(activatedLetterColor)
            deactivatedLetterColorPicker.extraControls[3].setColor(deactivatedLetterColor)
        }
        text: qsTr("Colors")
        visible: Helpers.isDesktop || Helpers.isWasm
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
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].saturation = value); moved() }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].lightness = value); moved() }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => { wordClock.background_color = selected_color
                            /**/DeviceAccess.setSettingsValue("Appearance/backgroundColor",
                                                              selected_color.toString().toUpperCase()) })
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
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].saturation = value); moved() }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].lightness = value); moved() }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => { wordClock.on_color = selected_color
                            /**/DeviceAccess.setSettingsValue("Appearance/activatedLetterColor",
                                                              selected_color.toString().toUpperCase()) })
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
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].saturation = value); moved() }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factorType: Controls.Picker.Factors.Lightness
                    Component.onCompleted: { onMoved.connect(() => parent.children[0].lightness = value); moved() }
                },
                Controls.ColorHexField {
                    huePicker: parent.children[0]
                    saturationPicker: parent.children[1]
                    lightnessPicker: parent.children[2]
                }
            ]
            Component.onCompleted: {
                selected_colorChanged.
                connect(() => { wordClock.off_color = selected_color
                            /**/DeviceAccess.setSettingsValue("Appearance/deactivatedLetterColor",
                                                              selected_color.toString().toUpperCase()) })
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
            Controls.IconButton { name: "github"; onClicked: openUrl("https://github.com/kokleeko/WordClock") }
        }
        Controls.MenuItem {
            text: qsTr("Bug tracking")
            visible: false  // @disable-check M16  @disable-check M31
            detailsComponent: Controls.Details {
                text: qsTr("\
We anonymously track the appearance of bugs in Firebase in order to correct them almost as soon as \
you encounter them. But you can disable this feature to enter submarine mode.")
            }
            Switch  { checked: DeviceAccess.isBugTracking; onToggled: DeviceAccess.isBugTracking = checked }
        }
        Controls.MenuItem {
            text: qsTr("Review")
            detailsComponent: Controls.Details { text: qsTr("Rate us by clicking on the stars.") }
            Row {
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
                            DeviceAccess.setSettingsValue("About/rating", parent.rating = index)
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
            Repeater {
                model: [ { name: "webassembly", visbible: !Helpers.isWasm, link: "https://wordclock.kokleeko.io" },
                    /**/ { name: "app-store", link: "https://testflight.apple.com/join/02s6IwG2" },
                    /**/ { name: "google-play", visible: false, link: "" },
                    /**/ { name: "lg-store", visible: false, link: "" },
                    /**/ { name: "ms-store", visible: false, link: "" } ]
                onItemAdded: parent.parent.extras.push(item)
                Controls.IconButton {
                    name: modelData.name
                    visible: modelData.visible ?? true
                    onClicked: openUrl(modelData.link)
                }
            }
            detailsComponent: Controls.Details {
                text: qsTr("The application may be slightly different depending on the platform used.")
            }
        }
        Controls.MenuItem {
            text: qsTr("Contact")
            Repeater {
                model: [ { name: "twitter", link: "https://twitter.com/kokleeko_io" },
                    /**/ { name: "youtube", link: "https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w" },
                    /**/ { name: "linkedin", link: "https://www.linkedin.com/in/johanremilien" },
                    /**/ { name: "instagram", link: "https://instagram.com/kokleeko.io" },
                    /**/ { name: "email", link: "mailto:contact@kokleeko.io" },
                    /**/ { name: "website", link: "https://www.kokleeko.io" } ]
                onItemAdded: parent.parent.extras.push(item)
                Controls.IconButton { name: modelData.name; onClicked: openUrl(modelData.link) }
            }
            detailsComponent: Controls.Details { text: qsTr("We would be happy to receive your feedback.") }
        }
        Controls.MenuItem {
            text: qsTr("Credits")
            Repeater {
                model: [ { name: QT_TR_NOOP("Built with %1").arg("Qt"),link: "https://www.qt.io" },
                    /**/ { name: QT_TR_NOOP("Released with %1").arg("Fastlane"), link: "https://fastlane.tools" },
                    /**/ { name: QT_TR_NOOP("Icons from %1").arg("SVG Repo"), link: "https://www.svgrepo.com" },
                    /**/ { name: QT_TR_NOOP("Localization with %1").arg("Crowdin"), link: "https://crowdin.com" } ]
                onItemAdded: parent.parent.extras.push(item)
                Button { text: qsTr(modelData.name); Layout.fillWidth: true; onClicked: openUrl(modelData.link) }
            }
            detailsComponent: Controls.Details {
                text: qsTr("\nDeveloped with love by Johan Remilien and published by Denver.")
            }
        }
    }
}
