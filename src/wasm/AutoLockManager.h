/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "src/default/AutoLockManager.h"

class AutoLockManager : public Default::AutoLockManager
{
public:
    explicit AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void disableAutoLock(bool disable) final override;
};

