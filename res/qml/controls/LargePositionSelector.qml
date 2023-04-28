import QtQuick 2.15
import QtQuick.Controls 2.15

import "." as Controls

Controls.MenuItem {
    required property string name
    property var positions: [ QT_TR_NOOP("Top"), QT_TR_NOOP("Bottom"), QT_TR_NOOP("Hide")]
    Switch {}
    Repeater {
        onItemAdded: extras.push(item)
        Component.onCompleted: {
            if (name =="minute")
                positions.unshift(QT_TR_NOOP("Around"))
            model = positions
        }
        Button {
            readonly property bool isHide: index === model.length -1
            text: qsTr(modelData)
            autoExclusive: true
            checked: wordClock.accessories[Math.pow(4, index)] === name
            onClicked: {
                if (isHide) {
                    for (var pos in wordClock.accessories) {
                        if (wordClock.accessories[pos] === name)
                            wordClock.accessories[pos] = ""
                    }
                } else {
                    wordClock.accessories[Math.pow(4, index)] = name
                }
            }
        }
    }
}
