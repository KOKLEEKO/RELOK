/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "EnergySavingManagerBase.h"

template<>
QString ManagerBase<EnergySavingManagerBase>::m_name{"energySaving"};

EnergySavingManagerBase::EnergySavingManagerBase(const std::shared_ptr<AutoLockManagerBase> &autoLockManager,
                                                 const std::shared_ptr<BatteryManagerBase> &batteryManager,
                                                 const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                                 QObject *parent)
    : ManagerBase(parent)
    , PersistenceCapability(persistenceManager)
    , m_autoLockManager(autoLockManager)
    , m_batteryManager(batteryManager)
{
}

void EnergySavingManagerBase::setMinimumBatteryLevel(int minimumBatteryLevel)
{
    if (m_minimumBatteryLevel == minimumBatteryLevel)
        return;
    persistenceManager()->setValue("BatterySaving/minimumBatteryLevel", m_minimumBatteryLevel = minimumBatteryLevel);
    emit minimumBatteryLevelChanged();
}
