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

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.MenuSection
    {
        QtLayouts.Layout.alignment: Qt.AlignBottom
        is_tipMe: true
        label.heading: headings.h3
        label.horizontalAlignment: QtControls.Label.AlignHCenter
        label.text: "♥ ".concat(qsTr("Support us")).concat(" ♥") + DeviceAccess.managers.translation.emptyString
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
            model: HelpersJS.isPurchasing ? tips.tipsModel : []
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
