/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15
import QtQuick.Controls 2.15

Loader {
    property bool enabled: true
    property string tooltip
    property string name: undefined
    signal clicked()
    onLoaded: { item.clicked.connect(clicked); item.enabled = Qt.binding(() => enabled) }
    sourceComponent:
        Button {
        display: Button.IconOnly
        flat: true
        icon.source: "qrc:/assets/%1.svg".arg(name)
        implicitWidth: implicitHeight
        ToolTip { visible: hovered && tooltip; text: tooltip }
    }
}
