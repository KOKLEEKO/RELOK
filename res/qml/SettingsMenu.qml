/**************************************************************************************************
**    Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**    All rights reserved.
**    Licensed under the MIT license. See LICENSE file in the project root for
**    details.
**    Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qrc:/qml/controls" as Controls
import "qrc:/js/Helpers.js" as Helpers

Controls.Menu {
    function openUrl(url) {
        if (Helpers.isMobile)
            webView.openUrl(url)
        else
            Qt.openUrlExternally(url)
    }

    anchors { fill: parent; margins: 20 }
    text: qsTr("My preferences")
    footer: Controls.MenuSection {
        title.heading: headings.h3
        title.horizontalAlignment: Label.AlignHCenter
        title.text: qsTr("Tip me")
        Layout.alignment: Qt.AlignBottom
        menuItems.flow: GridLayout.LeftToRight

        Controls.IconButton {
            name: "mug-saucer-solid"
            tooltip: "Ko-fi"
            onClicked:  openUrl("https://ko-fi.com/johanremilien")
        }
        Controls.IconButton {
            name: "paypal-brands"
            tooltip: "PayPal"
            onClicked: openUrl("https://paypal.me/jrxxviij")
        }
        //TODO: This will required some work, this feature might be postponed to the next release
        //        Controls.IconButton {
        //            name: (Helpers.isIos ? "app-store-ios" : "google-play") + "-brands"
        //            tooltip: Helpers.isIos ? "App Store" : "Google Play"
        //        }
    }
    Controls.MenuSection {
        text: qsTr("Battery Saving")
        Controls.MenuItem {
            text: qsTr("Stay Awake")
            detailsComponent: Controls.Details {
                text: qsTr("\
If enabled the screen device will stay active, when the application is running.\
\nThink about activating 'Guided Access' if you might loose attention on your device\
")
            }
            Switch {
                checked: DeviceAccess.isAutoLockDisabled
                onToggled: DeviceAccess.isAutoLockRequested = checked
            }
        }
        Controls.MenuItem {
            text: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(control.value.toString())
            detailsComponent: Controls.Details {
                text: qsTr("\
'Stay Awake' feature will be automatically disabed when the battery level will reach this value,\
 unless the device is charging.\
")
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
            text: "%1 (%2%)".arg(qsTr("Brightness Level")).arg(Math.round(DeviceAccess.brightness*100))
            Slider {
                from: 0
                to: 1
                value:DeviceAccess.brightness
                onMoved: DeviceAccess.brightnessRequested = value
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("Security")
        Controls.MenuItem {
            text: qsTr("Guided Access")
            detailsComponent: Controls.Details {
                text: qsTr("\
Activating the 'Guided Access' feature will result in your device being locked when the application\
 is in 'Stay Awake' mode")
            }
            Switch {
                checked: DeviceAccess.isGuidedAccessRequested
                onToggled: DeviceAccess.isGuidedAccessRequested = checked
            }
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
        text: qsTr("Appearance")
        Component.onCompleted: wordClock.applyColors.connect(applyColors)
        Controls.MenuItem {
            id: backgroundColorPicker
            property color selected_color: extraControls[0].selected_color
            text: qsTr("Background Color")
            detailsComponent: Controls.Details { text: qsTr("\
The color can be set in HSL format (Hue, Saturation, Lightness) or in hexadecimal format ") }
            extras: [
                Controls.ColorPicker {},
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    lightness: parent.children[0].lightness
                    factor_type: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factor_type: Controls.Picker.Factors.Lightness
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
                    factor_type: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factor_type: Controls.Picker.Factors.Lightness
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
                    factor_type: Controls.Picker.Factors.Saturation
                    Component.onCompleted: {
                        onMoved.connect(() => parent.children[0].saturation = value)
                        moved()
                    }
                },
                Controls.ColorFactorPicker {
                    hue: parent.children[0].hue
                    saturation: parent.children[0].saturation
                    factor_type: Controls.Picker.Factors.Lightness
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
        Controls.MenuItem {
            text: qsTr("Clock Language")
            extras: [
                Repeater {
                    model: Object.values(wordClock.languages)
                    Button {
                        readonly property string language: modelData.toLowerCase()
                        text: qsTr(modelData)
                        highlighted: wordClock.selected_language === language
                        onClicked: wordClock.selectLanguage(language)
                    }
                },
                Button { text: qsTr("Reset"); onClicked: wordClock.detectAndUseDeviceLanguage() }
            ]
        }
        Controls.MenuItem {
            text: qsTr("Enable Special Message")
            detailsComponent: Controls.Details { text: qsTr("\
Each grid contains a special message that will be displayed instead of the time for a minute at the\
 following times 12:00 AM (00:00), 11:11 AM (11:11) and 10:22 PM (22:22). The minute indicator at\
 the bottom of the panel will show 0, 1 or 2 lights, which will allow user to distinguish between\
 these different states.") }
            Switch {
                checked: DeviceAccess.settingsValue("Appearance/specialMessage", true)
                onToggled: {
                    DeviceAccess.setSettingsValue("Appearance/specialMessage",
                                                  wordClock.enable_special_message = checked)
                }
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("About")
        Controls.MenuItem {
            text: qsTr("Totally Free")
            detailsComponent: Controls.Details {
                text: qsTr("Yes, it's totally free, without ads! So you can fully enjoy this app.")
            }
        }
        Controls.MenuItem {
            text: qsTr("Open source")
            detailsComponent: Controls.Details {
                text: qsTr("The source code is available on GitHub under the MIT license, see it")
            }
            Controls.IconButton {
                name: "github-brands"
                tooltip: "GitHub"
                onClicked: openUrl("https://github.com/kokleeko/WordClock")
            }
        }
        Controls.MenuItem {
            text: qsTr("Bug tracking")
            detailsComponent: Controls.Details {
                text: qsTr("\
We anonymously track the appearance of bugs in Firebase in order to correct them almost as soon as \
you encounter them. But you can disable this feature to enter submarine mode.\
")
            }
            Switch  {
                checked: DeviceAccess.isBugTracking
                onToggled: DeviceAccess.isBugTracking = checked
            }
        }
        Controls.MenuItem {
            text: qsTr("Review")
            detailsComponent: Controls.Details { text: qsTr("Rate us by clicking on the stars") }
            Row {
                spacing: 5
                property int rating: DeviceAccess.settingsValue("About/rating", 0)
                Repeater {
                    model: 5
                    Button {
                        property bool isSelected: index <= parent.rating
                        icon.source: "qrc:/assets/star-%1.svg".arg(isSelected ? "solid" : "regular")
                        background: null
                        onClicked: {
                            DeviceAccess.setSettingsValue("About/rating",
                                                          parent.rating = index)
                            if (index >= 3)
                                DeviceAccess.requestReview()
                            else
                                Qt.openUrlExternally("mailto:contact@kokleeko.io")
                        }
                    }
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Contact")
            detailsComponent: Controls.Details {
                text: qsTr("\
We would be very pleased to hear about your experience with this application")
            }
            extras: [
                Controls.IconButton {
                    name: "globe-solid"
                    tooltip: qsTr("Website")
                    onClicked: openUrl("https://kokleeko.io")
                },
                Controls.IconButton {
                    name: "twitter-brands"
                    tooltip: "Twitter"
                    onClicked: openUrl("https://twitter.com/kokleeko_io")
                },
                Controls.IconButton {
                    name: "instagram-brands"
                    tooltip: "Instagram"
                    onClicked: openUrl("https://instagram.com/kokleeko.io")
                },
                Controls.IconButton {
                    name: "youtube-brands"
                    tooltip: "YouTube"
                    onClicked: openUrl("https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w")
                },
                Controls.IconButton {
                    name: "linkedin-brands"
                    tooltip: "LinkedIn"
                    onClicked: openUrl("https://www.linkedin.com/in/johanremilien")
                },
                Controls.IconButton {
                    name: "at-solid"
                    tooltip: qsTr("Email")
                    onClicked: Qt.openUrlExternally("mailto:contact@kokleeko.io")
                }
            ]
        }
        Controls.MenuItem {
            text: qsTr("Credits")
            detailsComponent: Controls.Details {
                text: qsTr("Developed with love by Johan and published by Denver.")
            }
            extras: [
                Button {
                    text: qsTr("Built with Qt")
                    onClicked: openUrl("https://www.qt.io")
                },
                Button {
                    text: qsTr("Icons from FontAwesome")
                    onClicked: openUrl("https://fontawesome.com")
                }
            ]
        }
        Item { implicitHeight: 25 }
    }
}
