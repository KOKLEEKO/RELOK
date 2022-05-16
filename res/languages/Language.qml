/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import "../Helpers.js" as Helpers

QtObject {

    required property var table
    required property var written_hours_array
    required property var written_minutes_array

    Component.onCompleted: {
        Helpers.createUndefinedMethod(this,
                                      "written_time",
                                      "hours_array_index",
                                      "minutes_array_index",
                                      "isAM")
        Helpers.createUndefinedMethod(this, "special_message","enable")
        for (var hours of hours_array) {
            let method_name = "hours_" + hours
            Helpers.createUndefinedMethod(this, method_name, "enable", "isAM")
        }
        for (var minutes of minutes_array) {
            let method_name = "minutes_" + minutes
            Helpers.createUndefinedMethod(this, method_name, "enable")
        }
    }
}
