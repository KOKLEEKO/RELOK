/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ShareContentManager.h"

#include <QImage>

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::ShareContentManager{deviceAccess, parent}
{
    m_enabled = true;
}

void ShareContentManager::screenshot(QQuickItem *item)
{
    screenshotWithCallback(item, [](QImage screenshot) { Q_UNUSED(screenshot) });
}
