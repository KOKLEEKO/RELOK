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
    : Default::AutoLockManager{deviceAccess, parent}
{
    m_enabled = true;
}

void AutoLockManager::disableAutoLock(bool disable)
{
    if (isAutoLockDisabled() == disable)
        return;
    qCDebug(lc) << "[W] disabledAutoLock:" << disable;
    [[UIApplication sharedApplication] setIdleTimerDisabled:disable];
    setIsAutoLockDisabled([UIApplication sharedApplication].isIdleTimerDisabled);
}
