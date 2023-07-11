/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ReviewManager.h"

ReviewManager::ReviewManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ReviewManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ReviewManager::requestReview() {}
