/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

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

        active: !HelpersJS.isWasm
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
            { name: "webassembly", visbible: !HelpersJS.isWasm, link: "https://relok.kokleeko.io"          },
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
            { name: "email", link: "mailto:johan.remilien+RELOK@gmail.com"            },
            { name: "website", active: false, link: "https://www.kokleeko.io"               }
        ]
        delegate: Controls.IconButton
        {
            name: modelData.name
            active: modelData.active ?? true

            onClicked: openUrl(modelData.link)
        }
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
    Controls.MenuItem
    {
        title: qsTr("Version")
        QtControls.Label
        {
            font: GeneralFont
            text: "<b>%1<b>".arg(Qt.application.version)
            textFormat: QtControls.Label.RichText
        }
    }
}
