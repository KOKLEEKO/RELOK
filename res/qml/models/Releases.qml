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

    readonly property var notes:
    {
        "1.2.2" :
        {
            common : [
                QT_TRANSLATE_NOOP("Releases", "Various Fixes and Improvements")
            ]
        },
        "1.2.1" :
        {
            common : [
                QT_TRANSLATE_NOOP("Releases", "Introducing a new clock language: German!"),
                QT_TRANSLATE_NOOP("Releases", "Various Fixes and Improvements")
            ]
        },
        "1.2.0" :
        {
            common : [
                QT_TRANSLATE_NOOP("Releases", "Introduce PieMenu with Handedness Management"),
                QT_TRANSLATE_NOOP("Releases", "Add Screenshot Export feature"),
                QT_TRANSLATE_NOOP("Releases", "Improve User Experience in Settings Panel"),
                QT_TRANSLATE_NOOP("Releases", "'Tip Me' becomes 'Support Us'"),
                QT_TRANSLATE_NOOP("Releases", "Various Fixes and Improvements")
            ],
            wasm   : QT_TRANSLATE_NOOP("Releases", "Enable TTS, Battery, and Autolock features"),
        },
        "1.1.0" :
        {
            common  : [
                QT_TRANSLATE_NOOP("Releases", "Fix unreachable links in the 'About' section"),
                QT_TRANSLATE_NOOP("Releases", "Set default speech frequency to every 15 minutes instead of every minute")
            ],
        }
    }

    function releaseNote(version, platform = "")
    {
        var note = "<ul>";
        if (notes.hasOwnProperty(version))
        {
            var versionNote = notes[version];
            note += HelpersJS.processListOrStringAndAppendAsListItem(versionNote.common, "Releases");
            if (platform !== "common" && versionNote.hasOwnProperty(platform))
            {
                note += HelpersJS.processListOrStringAndAppendAsListItem(versionNote[platform], "Releases");
            }
        }
        return note += "</ul>";
    }
}
