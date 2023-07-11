/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "BatteryManager.h"

BatteryManager::BatteryManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : BatteryManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}
