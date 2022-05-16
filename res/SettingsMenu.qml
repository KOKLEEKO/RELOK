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
            Switch { onCheckedChanged: DeviceAccess.disableAutoLock(checked) }
        }
        Controls.MenuItem {
            text: String("%1 (%2%)").arg(qsTr("Minimum Battery Level")).arg(control.value.toString())
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
                onValueChanged: DeviceAccess.minimumBatteryLevel = value
            }
        }
    }
    Controls.MenuSection {
        text: qsTr("fa:fa-shield-dog %1").arg(qsTr("Security"))
        Controls.MenuItem {
            text: qsTr("Guided Access")
            detailsComponent: Controls.Details {
                text: qsTr("\
Enabling the Guided Access will lock your device, while the screen device will stay active\
")
            }
            Switch { onCheckedChanged: DeviceAccess.enableGuidedAccessSession(checked) }
        }
    }
    Controls.MenuSection {
        text: String("fa:fa-palette %1").arg(qsTr("Appearance"))
        Controls.MenuItem {
            id: backgroundColorPicker
            property color selectedColor: extraControls[0].selectedColor
            text: qsTr("Background Color")
            extras: [
                Controls.ColorPicker { factor:parent.children[1].value; value: 0 },
                Controls.ColorFactorPicker {  baseColor: parent.children[0].baseColor; value: 4.9 }
            ]
            Component.onCompleted: {
                selectedColorChanged.connect(() => wordClock.background_color = selectedColor)
            }
        }
        Controls.MenuItem {
            id: activatedLetterColorPicker
            property color selectedColor: extraControls[0].selectedColor
            text: qsTr("Activated Letter Color")
            extras: [
                Controls.ColorPicker { factor:parent.children[1].value; value: 1 },
                Controls.ColorFactorPicker {  baseColor: parent.children[0].baseColor; value: 1 }
            ]
            Component.onCompleted: {
                selectedColorChanged.connect(() => wordClock.on_color = selectedColor)
            }
        }
        Controls.MenuItem {
            id: deactivatedLetterColorPicker
            property color selectedColor: extraControls[0].selectedColor
            text: qsTr("Deactivated Letter Color")
            extras: [
                Controls.ColorPicker { factor:parent.children[1].value; value: 17 },
                Controls.ColorFactorPicker {  baseColor: parent.children[0].baseColor; value: 1 }
            ]
            Component.onCompleted: {
                selectedColorChanged.connect(() => wordClock.off_color = selectedColor)
            }
        }
        Controls.MenuItem {
            text: qsTr("Reset colors")
            Button {
                onClicked: {
                    backgroundColorPicker.extraControls[0].value = 0
                    backgroundColorPicker.extraControls[1].value = 4.9
                    activatedLetterColorPicker.extraControls[0].value = 1
                    activatedLetterColorPicker.extraControls[1].value = 1
                    deactivatedLetterColorPicker.extraControls[0].value = 17
                    deactivatedLetterColorPicker.extraControls[1].value = 1
                    wordClock.background_color = "black"
                    wordClock.on_color = "red"
                    wordClock.off_color = "grey"
                }
            }
        }
        Controls.MenuItem {
            text: qsTr("Enable Special Message")
            Switch { onCheckedChanged: wordClock.enable_special_message = checked }
        }
        Controls.MenuItem {
            text: qsTr("Language")
            detailsComponent: Controls.Details {
                text: qsTr("Select clock language")
            }
            extras: [
                Button { text: qsTr("English"); onClicked: wordClock.language_url = "qrc:/languages/english.qml"},
                Button { text: qsTr("French"); onClicked: wordClock.language_url = "qrc:/languages/french.qml" },
                Button { text: qsTr("Spanish"); onClicked:  wordClock.language_url = "qrc:/languages/spanish.qml" }
            ]
        }
    }
    Controls.MenuSection {
        text: String("fa:fa-stars %1").arg(qsTr("About"))
        Controls.MenuItem {
            text: qsTr("Totally Free")
            detailsComponent: Controls.Details {
                text: qsTr("Yes, it's totally free, without ads! So you can fully enjoy this app")
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
We anonymously track the appearance of bugs in Firebase in order to correct them almost as soon as you\
 encounter them. But you can disable this feature to enter submarine mode.\
")
            }
            Switch { }
        }
        Controls.MenuItem {
            text: qsTr("Review")
            detailsComponent: Controls.Details {
                text: qsTr("Rate us")
            }
            Row {
                id: starsRow
                spacing: 5
                property int mark: 0
                Repeater {
                    model: 5
                    Rectangle {
                        width: 20
                        height: width
                        color: index <= starsRow.mark ? "gold" : "transparent"
                        border.color: "black"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: starsRow.mark = index
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
