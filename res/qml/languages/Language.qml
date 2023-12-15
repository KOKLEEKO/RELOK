/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.QtObject
{
    required property var table
    required property var written_hours_array
    required property var written_minutes_array

    QtQuick.Component.onCompleted:
    {
        HelpersJS.createUndefinedMethod(this, "written_time", "hours_array_index", "minutes_array_index", "isAM");
        HelpersJS.createUndefinedMethod(this, "special_message","enable");
        for (var hours of hours_array)
        {
            HelpersJS.createUndefinedMethod(this, "hours_" + hours, "enable", "isAM");
        }
        for (var minutes of minutes_array)
        {
            HelpersJS.createUndefinedMethod(this, "minutes_" + minutes, "enable", "hours_array_index");
        }
    }
}
