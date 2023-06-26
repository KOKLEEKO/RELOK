/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ScreenBrightnessManager.h"

ScreenBrightnessManager::ScreenBrightnessManager(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                                 QObject *parent)
    : ScreenBrightnessManagerBase{persistenceManager, parent}
{
}
