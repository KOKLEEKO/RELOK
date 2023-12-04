/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManager.h"

#include "EnergySavingManagerBase.h"

using namespace Default;

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase(deviceAccess, parent)
{
    connect(this, &AutoLockManagerBase::isAutoLockRequestedChanged, this, [=]() {
        auto energySavingManager = deviceAccess->manager<EnergySavingManagerBase>();
        if (energySavingManager->enabled())
            energySavingManager->batterySaving();
        else
            disableAutoLock(!isAutoLockRequested());
    });
}
