/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
pragma Singleton

import QtQuick 2.15 as QtQuick

QtQuick.QtObject {

    readonly property var instructions: [
        {
            title: QT_TR_NOOP("Open menu"),
            content: [
                QT_TR_NOOP("<b>Long press</b> on the clock, then release on the gear icon"),
                QT_TR_NOOP("<b>Swipe left</b> or right from the edge of the screen, based on the selected handeness<br>\
<i>(left for right-handed [<u>default</u>] and right for left-handed)</i>"),
            ]
        },
        {
            title: QT_TR_NOOP("Open section"),
            content: [
                QT_TR_NOOP("<b>Press</b> on a section<br><i>(the section will remain open until you close it)</i>")
            ]
        },
        {
            title: QT_TR_NOOP("Close section"),
            content: [
                QT_TR_NOOP("<b>Press</b> the greetings<br><i>(top-centered text)</i>"),
                QT_TR_NOOP("<b>Open</b> another section")
            ]
        },
        {
            title: QT_TR_NOOP("Close menu"),
            content: [
                QT_TR_NOOP("<b>Press</b> the clock, if visible"),
                QT_TR_NOOP("<b>Drag the menu to the right</b> or left, based on the selected handeness \
<br><i>(right for right-handed [<u>default</u>] and left for left-handed)</i>")
            ]
        }
    ]
}
