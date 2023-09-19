/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls

QtQuick.Loader
{
    property bool enabled: true
    property string name: undefined
    property string tooltip

    signal clicked()

    sourceComponent: QtControls.Button
    {
        display: QtControls.Button.IconOnly
        flat: true
        icon.source: "qrc:/assets/%1.svg".arg(name)
        implicitWidth: implicitHeight

        QtControls.ToolTip { visible: hovered && tooltip; text: tooltip }
    }

    onLoaded: { item.clicked.connect(clicked); item.enabled = Qt.binding(() => enabled); }
}
