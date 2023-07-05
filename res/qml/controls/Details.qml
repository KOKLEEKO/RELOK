/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick.Controls 2.15 as QtControls

QtControls.Label
{
    color: palette.windowText
    font { family: SmallestReadableFont; pointSize: headings.p1 }
    maximumLineCount: Number.POSITIVE_INFINITY
    wrapMode: QtControls.Label.WordWrap
}
