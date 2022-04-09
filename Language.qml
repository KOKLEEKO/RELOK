import QtQuick 2.15
import "Helpers.js" as Helpers

QtObject {
    function createUndefinedMethod(name, ...args) {
        Object.defineProperty(this, name, {value: (args) => Helpers.unimplemented(name) });
    }
    function written_time(hours_array_index, minutes_array_index) {
        Helpers.unimplemented(written_time.name)
    }

    required property var table
    required property var written_hours_array
    required property var written_minutes_array


    Component.onCompleted: {

        for (var hours of hours_array) {
            let method_name = "hours_" + hours
            Object.defineProperty(this, method_name, {value: (enable) => Helpers.unimplemented(method_name) });
        }
        for (var minutes of minutes_array) {
            let method_name = "minutes_" + minutes
            Object.defineProperty(this, method_name, {value: (enable) => Helpers.unimplemented(method_name) });
        }
    }
}
