/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.MouseArea
{
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    anchors.fill: parent

    onClicked: (mouse) =>
               {
                   if (!HelpersJS.isDesktop || mouse.button === Qt.RightButton)
                   {
                       settingsPanel.open()
                   }
               }
    onPressAndHold: (mouse) =>
                    {
                        if (HelpersJS.isDesktop)
                        {
                            switch (mouse.button)
                            {
                                case Qt.RightButton:
                                HelpersJS.updateDisplayMode(root)
                                break;
                                case Qt.LeftButton:
                                HelpersJS.updateVisibility(root)
                                break;
                            }
                        }
                        else
                        {
                            HelpersJS.updateVisibility(root)
                        }
                    }
}
