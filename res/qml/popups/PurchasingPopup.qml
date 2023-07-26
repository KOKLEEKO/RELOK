/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15 as QtControls

QtControls.Popup
{
    background: null
    closePolicy: QtControls.Popup.NoAutoClose
    modal: true
    visible: tips.store.purchasing
    z: 1
}
