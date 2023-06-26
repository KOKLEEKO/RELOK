/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <AdvertisingManagerBase.h>

template<>
QString ManagerBase<AdvertisingManagerBase>::m_name{"advertising"};

AdvertisingManagerBase::AdvertisingManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                               QObject *parent)
    : ManagerBase<AdvertisingManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void AdvertisingManagerBase::requestAdvertising(bool isAdvertisingRequested)
{
    if (m_isAdvertisingRequested == isAdvertisingRequested)
        return;
    persistenceManager()->setValue("Advanced/isAdvertisingRequested", m_isAdvertisingRequested = isAdvertisingRequested);
    emit isAdvertisingRequestedChanged();
}

void AdvertisingManagerBase::enableAdvertising(bool /*enable*/) {}
