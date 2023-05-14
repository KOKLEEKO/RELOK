/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15

import "qrc:/js/Helpers.js" as Helpers

PositionSelector {
    delegate: RadioButton {
        readonly property int positionIndex: isMinutes ? Math.floor(Math.pow(4, index - 1)) : Math.pow(4, index)
        enabled: isMinutes && positionIndex == 0 ? Helpers.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
                                                   && Helpers.isStrictlyEqual(wordClock.accessories[positionIndex],
                                                                              wordClock.accessories[2],
                                                                              wordClock.accessories[3],
                                                                              wordClock.accessories[5])
                                                 : Helpers.isWeaklyEqual(wordClock.accessories[positionIndex], "", name)
        text: qsTr(modelData)
        checked: wordClock.accessories[positionIndex] === name
        ButtonGroup.group: radioGroup
        onClicked: activate(positionIndex, isMinutes)
    }
}