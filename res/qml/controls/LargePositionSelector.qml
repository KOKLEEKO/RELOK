/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15

import DeviceAccess 1.0

import "qrc:/js/Helpers.js" as HelpersJS

PositionSelector {
    delegate: RadioButton {
        readonly property int positionIndex: isMinutes ? Math.floor(Math.pow(4, index - 1)) : Math.pow(4, index)
        enabled: isMinutes && positionIndex == 0 ? HelpersJS.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
                                                   && HelpersJS.isStrictlyEqual(wordClock.accessories[positionIndex],
                                                                              wordClock.accessories[2],
                                                                              wordClock.accessories[3],
                                                                              wordClock.accessories[5])
                                                 : HelpersJS.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
        text: qsTranslate("PositionSelector", modelData) + DeviceAccess.managers.translation.emptyString
        checked: wordClock.accessories[positionIndex] === name
        ButtonGroup.group: radioGroup
        onClicked: activate(positionIndex)
    }
}
