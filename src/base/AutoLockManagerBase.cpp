/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManagerBase.h"

#include "PersistenceManager.h"

template<>
QString ManagerBase<AutoLockManagerBase>::m_name{"autoLock"};

AutoLockManagerBase::AutoLockManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}

void AutoLockManagerBase::requestAutoLock(bool isAutoLockRequested)
{
    if (m_isAutoLockRequested == isAutoLockRequested)
        return;
    deviceAccess()
        ->manager<PersistenceManager>(PersistenceManager::name())
        ->setValue("BatterySaving/isAutoLockRequested", m_isAutoLockRequested = isAutoLockRequested);
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
