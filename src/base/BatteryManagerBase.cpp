/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "BatteryManagerBase.h"

template<>
QString ManagerBase<BatteryManagerBase>::m_name{"battery"};

BatteryManagerBase::BatteryManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}

void BatteryManagerBase::updateBatteryLevel(float batteryLevel)
{
    m_batteryLevel = qRound(batteryLevel * 100);
    qCDebug(lc) << "[R] batteryLevel:" << m_batteryLevel;
    emit batteryLevelChanged();
}

void BatteryManagerBase::updateIsPlugged(bool isPlugged)
{
    if (m_isPlugged == isPlugged)
        return;
    m_isPlugged = isPlugged;
    qCDebug(lc) << "[R] isPlugged:" << m_isPlugged;
    emit isPluggedChanged();
}
