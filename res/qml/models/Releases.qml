/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
pragma Singleton

import QtQuick 2.15 as QtQuick

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
        "1.2.0" :
        {
            common  : QT_TR_NOOP("1.2.0"),

            android : QT_TR_NOOP("android"),
            ios     : QT_TR_NOOP("iOS"),
            wasm    : QT_TR_NOOP("wasm")
        },
        "1.1.0" :
        {
            common  : QT_TR_NOOP("1.1.0"),

            android : QT_TR_NOOP("android"),
            ios     : QT_TR_NOOP("ios"),
            wasm    : QT_TR_NOOP("wasm")
        }
    }
    readonly property string currentReleaseNote: releaseNote(Qt.application.version, Qt.platform.os)

    function releaseNote(version, platform = "")
    {
        var note = "";
        if (notes.hasOwnProperty(version))
        {
            var versionNote = notes[version];
            note = versionNote.common;
            if (platform !== "common" && versionNote.hasOwnProperty(platform))
            {
                note += "<br>" + versionNote[platform];
            }
        }
        return note;
    }
}
