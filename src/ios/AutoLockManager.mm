/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "AutoLockManager.h"

#import <UIKit/UIApplication.h>

#import <EnergySavingManagerBase.h>

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase{deviceAccess, parent}
{
    m_enabled = true;

    connect(this, &AutoLockManagerBase::isAutoLockRequestedChanged, this, [=]() {
        auto energySavingManager = deviceAccess->manager<EnergySavingManagerBase>();
        if (energySavingManager->enabled())
            energySavingManager->batterySaving();
        else
            disableAutoLock(!isAutoLockRequested());
    });
}

void AutoLockManager::disableAutoLock(bool disable)
{
    if (isAutoLockDisabled() == disable)
        return;
    qCDebug(lc) << "[W] disabledAutoLock:" << disable;
    [[UIApplication sharedApplication] setIdleTimerDisabled:disable];
    setIsAutoLockDisabled([UIApplication sharedApplication].isIdleTimerDisabled);
}
