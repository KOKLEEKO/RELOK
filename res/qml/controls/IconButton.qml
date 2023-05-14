/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15

Button {
    property string tooltip
    property string name: undefined
    display: Button.IconOnly
    flat: true
    icon.source: "qrc:/assets/%1.svg".arg(name)
    implicitWidth: implicitHeight
    ToolTip { visible: hovered && tooltip; text: tooltip }
}
