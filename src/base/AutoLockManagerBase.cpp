/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManagerBase.h"

#include "PersistenceManagerBase.h"

template<>
QString ManagerBase<AutoLockManagerBase>::m_name{QStringLiteral("autoLock")};

AutoLockManagerBase::AutoLockManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{
    connect(deviceAccess->manager<PersistenceManagerBase>(),
            &PersistenceManagerBase::settingsReady,
            this,
            [=] {
                m_isAutoLockRequested = deviceAccess->manager<PersistenceManagerBase>()
                                            ->value("BatterySaving/isAutoLockRequested", false)
                                            .toBool();
            });
}

void AutoLockManagerBase::requestAutoLock(bool isAutoLockRequested)
{
    if (m_isAutoLockRequested == isAutoLockRequested)
        return;
    qCDebug(lc) << "[R] autoLockRequested:" << isAutoLockRequested;
    deviceAccess()->manager<PersistenceManagerBase>()->setValue("BatterySaving/isAutoLockRequested",
                                                                m_isAutoLockRequested
                                                                = isAutoLockRequested);
    emit isAutoLockRequestedChanged();
}

void AutoLockManagerBase::setIsAutoLockDisabled(bool newIsAutoLockDisabled)
{
    if (m_isAutoLockDisabled == newIsAutoLockDisabled)
        return;
    m_isAutoLockDisabled = newIsAutoLockDisabled;
    qCDebug(lc) << "[R] isAutoLockDisabled:" << m_isAutoLockDisabled;
    emit isAutoLockDisabledChanged();
}
