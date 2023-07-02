/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManagerBase.h"

template<>
QString ManagerBase<AutoLockManagerBase>::m_name{"autoLock"};

AutoLockManagerBase::AutoLockManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : ManagerBase(parent)
    , PersistenceCapability(persistenceManager)
{}

void AutoLockManagerBase::requestAutoLock(bool isAutoLockRequested)
{
    if (m_isAutoLockRequested == isAutoLockRequested)
        return;
    persistenceManager()->setValue("BatterySaving/isAutoLockRequested", m_isAutoLockRequested = isAutoLockRequested);
    emit isAutoLockRequestedChanged();
}
