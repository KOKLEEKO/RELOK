/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"
#include <PersistenceCapability.h>

#include <memory>

#include "AutoLockManagerBase.h"
#include "BatteryManagerBase.h"

class EnergySavingManagerBase : public ManagerBase<EnergySavingManagerBase>, public PersistenceCapability
{
    Q_OBJECT

    Q_PROPERTY(int minimumBatteryLevel MEMBER m_minimumBatteryLevel WRITE setMinimumBatteryLevel NOTIFY
                   minimumBatteryLevelChanged)

public:
    explicit EnergySavingManagerBase(const std::shared_ptr<AutoLockManagerBase> &autoLockManager,
                                     const std::shared_ptr<BatteryManagerBase> &batteryManager,
                                     const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                     QObject *parent = nullptr);
    void setMinimumBatteryLevel(int value);

private:
    virtual void batterySaving() {}

signals:
    void minimumBatteryLevelChanged();

protected:
    int m_minimumBatteryLevel = 50;
    std::shared_ptr<AutoLockManagerBase> m_autoLockManager;
    std::shared_ptr<BatteryManagerBase> m_batteryManager;
};
