/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
pragma Singleton

import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.QtObject {

    readonly property var instructions: [
        {
            title: QT_TRANSLATE_NOOP("MenuUsage", "Open menu"),
            content: [
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Long press</b> on the clock, then release on the gear icon"),
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Swipe left</b> or right from the edge of the screen, based on the \
selected handedness<br><i>(left for right-handed [<u>default</u>] and right for left-handed)</i>"),
            ]
        },
        {
            title: QT_TRANSLATE_NOOP("MenuUsage", "Open section"),
            content: [
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Press</b> on a section<br><i>(the section will remain open until \
you close it)</i>")
            ]
        },
        {
            title: QT_TRANSLATE_NOOP("MenuUsage", "Close section"),
            content: [
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Press</b> the greetings<br><i>(top-centered text)</i>"),
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Press</b> on the title of the open section"),
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Open</b> another section")
            ]
        },
        {
            title: QT_TRANSLATE_NOOP("MenuUsage", "Close menu"),
            content: [
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Press</b> the clock, if visible"),
                QT_TRANSLATE_NOOP("MenuUsage", "<b>Drag the menu to the right</b> or left, based on the selected \
handedness <br><i>(right for right-handed [<u>default</u>] and left for left-handed)</i>")
            ]
        }
    ]

    function contentAsListItem(index)
    {
        return HelpersJS.processListOrStringAndAppendAsListItem(instructions[index].content, "MenuUsage");
    }
}
