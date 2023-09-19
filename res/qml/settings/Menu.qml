/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

Controls.Menu
{
    function greetings()
    {
        if (wordClock.is_AM)
        {
            return QT_TR_NOOP("Good Morning!");
        }
        else if (parseInt(wordClock.hours_value, 10) < 18) // 6:00 PM
        {
            return QT_TR_NOOP("Good Afternoon!");
        }
        return QT_TR_NOOP("Good Evening!");
    }

    function openUrl(url)
    {
        if (HelpersJS.isMobile && url.split(":")[0] !== "mailto")
        {
            webView.openUrl(url);
        }
        else
        {
            Qt.openUrlExternally(url);
        }
    }

    anchors.fill: parent  // @disable-check M16  @disable-check M31
    footer: TipJar { }
    title: qsTr(greetings()) + DeviceAccess.managers.translation.emptyString

    EnergySaving { }
    Appearance { }
    Speech { }
    Accessories { }
    Colors { }
    Advanced { }
    About { }
}
