/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AdvertisingManagerBase.h"

#include "PersistenceManagerBase.h"

template<>
QString ManagerBase<AdvertisingManagerBase>::m_name{"advertising"};

AdvertisingManagerBase::AdvertisingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}

void AdvertisingManagerBase::requestAdvertising(bool isAdvertisingRequested)
{
    if (m_isAdvertisingRequested == isAdvertisingRequested)
        return;
    deviceAccess()->manager<PersistenceManagerBase>()->setValue("Advanced/isAdvertisingRequested",
                                                                m_isAdvertisingRequested = isAdvertisingRequested);
    emit isAdvertisingRequestedChanged();
}
