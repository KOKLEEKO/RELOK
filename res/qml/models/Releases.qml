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

QtQuick.QtObject
{

    /* Possible values are:
     *
     * "android" - Android
     * "ios" - iOS
     * "linux" - Linux
     * "osx" - macOS
     * "qnx" - QNX (since Qt 5.9.3)
     * "tvos" - tvOS
     * "unix" - Other Unix-based OS
     * "wasm" - WebAssembly
     * "windows" - Windows
     *
    */

    /*
common:
    "Introduce PieMenu with handeness management"
    "Add notification icon"
    "Export screenshot"
    "improve language selection"
    "Replace the frequency buttons with an interval slider"
    "Rename "Tip Me" to "Support us"
    "Fix translations"
    "Introduce ReleaseNotes model and fix MenuUsagePopup"

wasm:
    "Enable welcome popup wasm"
    "Introduce TTS wasm, battery (when supported) , autolock"

  */
    readonly property var notes:
    {
        "1.2.0" :
        {
            common : [
                QT_TR_NOOP("Introduce Pie Menu")
            ],

            android : [
                QT_TR_NOOP("")
            ],
            ios    : [
                QT_TR_NOOP("")
            ],
            wasm   : [
                QT_TR_NOOP("")
            ],
            osx    : [
                QT_TR_NOOP("")
            ]
        },
        "1.1.0" :
        {
            common  : [
                QT_TR_NOOP("Fix unreachable links in the About section"),
                QT_TR_NOOP("Set default speech frequency to every 15 minutes instead of every minute")
            ],
        }
    }
    readonly property string currentReleaseNote: releaseNote(Qt.application.version, Qt.platform.os)

    function releaseNote(version, platform = "")
    {
        var note = "<ul>";
        if (notes.hasOwnProperty(version))
        {
            var versionNote = notes[version];
            note += HelpersJS.processListOrStringAndAppendAsListItem(versionNote.common);
            if (platform !== "common" && versionNote.hasOwnProperty(platform))
            {
                note += HelpersJS.processListOrStringAndAppendAsListItem(versionNote[platform]);
            }
        }
        return note += "</ul>";
    }
}
