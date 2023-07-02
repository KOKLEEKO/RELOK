/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "EnergySavingManager.h"

EnergySavingManager::EnergySavingManager(const std::shared_ptr<AutoLockManagerBase> &autoLockManager,
                                         const std::shared_ptr<BatteryManagerBase> &batteryManager,
                                         const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : EnergySavingManagerBase{autoLockManager, batteryManager, persistenceManager, parent}
{

}