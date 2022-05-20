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

import "controls" as Controls
import "Helpers.js" as Helpers

Controls.Menu {
    function openUrl(url) {
        if (Helpers.isMobile)
            webView.openUrl(url)
        else
            Qt.openUrlExternally(url)
    }

    anchors { fill: parent; margins: 20}
    text: qsTr("fa:fa-square-sliders %1").arg("My preferences")
    footer: Controls.MenuSection {
        title.heading: Controls.Title.Headings.H3
        title.horizontalAlignment: Label.AlignHCenter
        title.text: qsTr("fa:fa-coffee-beans %1").arg("Tip me")
        Layout.alignment: Qt.AlignBottom
        menuItems.flow: GridLayout.LeftToRight

        Button { text: "Store"; onClicked:  openUrl("https://store")}
        Button { text: "PayPal"; onClicked: openUrl("https://paypal.me/jrxxviij")}
        Button { text: "Ko-fi"; onClicked:  openUrl("https://ko-fi.com/johanremilien")}
    }
    Controls.MenuSection {
        text: qsTr("fa:fa-earth-africa %1").arg("Battery Saving")
        Controls.MenuItem {
            text: qsTr("Stay Awake")
            detailsComponent: Controls.Details {
                text: qsTr("\
If enabled the screen device will stay active, when the application is running.\
\nThink about activating 'Guided Access' if you might loose attention on your device\
")
            }
            Switch {
                checked: DeviceAccess.isAutoLockRequested
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
            text: "%1 (%2%)".arg(qsTr("Brightness Level")).arg(DeviceAccess.brightness*100)
            Slider {
                from: 0
                to: 1
                value:DeviceAccess.brightness
                onMoved: DeviceAccess.brightnessRequested = value
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("fa:fa-shield-dog %1").arg(qsTr("Security"))
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
        text: String("fa:fa-palette %1").arg(qsTr("Appearance"))
        Controls.MenuItem {
            id: backgroundColorPicker
            property color selectedColor: extraControls[0].selectedColor
            text: qsTr("Background Color")
            detailsComponent: Controls.Details { text: qsTr("\
The color can be set in HSL format (Hue, Saturation, Lightness) or in hexadecimal format ") }
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
                selectedColorChanged.
                connect(() => {
                            wordClock.background_color = selectedColor
                            DeviceAccess.setSettingsValue("Appearance/backgroundColor",
                                                          selectedColor.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            id: activatedLetterColorPicker
            property color selectedColor: extraControls[0].selectedColor
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
                selectedColorChanged.
                connect(() => {
                            wordClock.on_color = selectedColor
                            DeviceAccess.setSettingsValue("Appearance/activatedLetterColor",
                                                          selectedColor.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            id: deactivatedLetterColorPicker
            property color selectedColor: extraControls[0].selectedColor
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
                selectedColorChanged.
                connect(() => {
                            wordClock.off_color = selectedColor
                            DeviceAccess.setSettingsValue("Appearance/deactivatedLetterColor",
                                                          selectedColor.toString().toUpperCase())
                        })
            }
        }
        Controls.MenuItem {
            text: qsTr("Reset colors")
            Button {
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
                        highlighted: wordClock.selectedLanguage === language
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
        Component.onCompleted: {
            let bc  = DeviceAccess.settingsValue("Appearance/backgroundColor", "#000000")
            let alc = DeviceAccess.settingsValue("Appearance/activatedLetterColor", "#FF0000")
            let dlc = DeviceAccess.settingsValue("Appearance/deactivatedLetterColor", "#808080")
            backgroundColorPicker.extraControls[3].setColor(bc)
            activatedLetterColorPicker.extraControls[3].setColor(alc)
            deactivatedLetterColorPicker.extraControls[3].setColor(dlc)
        }
    }
    Controls.MenuSection {
        text: String("fa:fa-stars %1").arg(qsTr("About"))
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
            Button {
                text: "GitHub"
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
            detailsComponent: Controls.Details {
                text: qsTr("Rate us")
            }
            Row {
                spacing: 5
                property int rating: DeviceAccess.settingsValue("About/rating", 0)
                Repeater {
                    model: 5
                    Rectangle {
                        width: 20
                        height: width
                        color: index <= parent.rating ? "gold" : "transparent"
                        border.color: "black"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: DeviceAccess.setSettingsValue("About/rating",
                                                                     parent.parent.rating = index)
                        }
                    }
                }
            }
            // display 5 stars when user press the last one open app-review otherwise the user
            // and ask for improvement.
        }
        Controls.MenuItem {
            text: qsTr("Contact")
            detailsComponent: Controls.Details {
                text: qsTr("We would be very pleased to hear about your experience with this application")
            }
            extras: [
                Button {
                    text: "Kokleeko"
                    onClicked: openUrl("https://kokleeko.io")
                },
                Button {
                    text: "Twitter"
                    onClicked: openUrl("https://twitter.com/kokleeko_io")
                },
                Button {
                    text: "Instagram"
                    onClicked: openUrl("https://instagram.com/kokleeko.io")
                },
                Button {
                    text: "Youtube"
                    onClicked: openUrl("https://youtube.com/channel/UCJ0QPsxjk_mxdIQtEZsIA6w")
                },
                Button {
                    text: qsTr("Email")
                    onClicked: Qt.openUrlExternally("mailto:contact@kokleeko.io")
                }
            ]
        }
        Controls.MenuItem {
            text: qsTr("Credits")
            detailsComponent: Controls.Details {
                text: qsTr("Developed with Love by Johan and published by Denver.")
            }
        }
        Item { implicitHeight: 25 }
    }
}
