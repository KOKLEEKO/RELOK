/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <EnergySavingManagerBase.h>

class EnergySavingManager : public EnergySavingManagerBase
{
    Q_OBJECT

public:
    EnergySavingManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

public:
    void batterySaving() final override;

signals:
    void disableAutoLock(bool disable);
};

