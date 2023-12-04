/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "EnergySavingManagerBase.h"

#include "PersistenceManagerBase.h"

template<>
QString ManagerBase<EnergySavingManagerBase>::m_name{QStringLiteral("energySaving")};

EnergySavingManagerBase::EnergySavingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{
    connect(deviceAccess->manager<PersistenceManagerBase>(),
            &PersistenceManagerBase::settingsReady,
            this,
            [=] {
                m_minimumBatteryLevel = deviceAccess->manager<PersistenceManagerBase>()
                                            ->value("BatterySaving/minimumBatteryLevel", 50)
                                            .toInt();
            });
}

void EnergySavingManagerBase::setMinimumBatteryLevel(int minimumBatteryLevel)
{
    if (m_minimumBatteryLevel == minimumBatteryLevel)
        return;
    deviceAccess()->manager<PersistenceManagerBase>()->setValue("BatterySaving/minimumBatteryLevel",
                                                                m_minimumBatteryLevel
                                                                = minimumBatteryLevel);
    emit minimumBatteryLevelChanged();
}
