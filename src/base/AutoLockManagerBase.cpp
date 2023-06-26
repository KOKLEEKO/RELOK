/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <AutoLockManagerBase.h>

template<>
QString ManagerBase<AutoLockManagerBase>::m_name{"autolock"};

void AutoLockManagerBase::disableAutoLock(bool /*disable*/) {}

void AutoLockManagerBase::requestAutoLock(bool isAutoLockRequested)
{
    if (m_isAutoLockRequested == isAutoLockRequested)
        return;
    persistenceManager()->setValue("BatterySaving/isAutoLockRequested", m_isAutoLockRequested = isAutoLockRequested);
    emit isAutoLockRequestedChanged();
};

void AutoLockManagerBase::security(bool /*value*/){};

AutoLockManagerBase::AutoLockManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : ManagerBase<AutoLockManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}
