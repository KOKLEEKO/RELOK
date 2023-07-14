/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

class BatteryManagerBase : public ManagerBase<BatteryManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(bool isPlugged READ isPlugged NOTIFY isPluggedChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)

public:
    BatteryManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    bool isPlugged() const { return m_isPlugged; }
    int batteryLevel() const { return m_batteryLevel; }
    void updateIsPlugged(bool isPlugged);
    void updateBatteryLevel(float batteryLevel);

signals:
    void isPluggedChanged();
    void batteryLevelChanged();

private:
    bool m_isPlugged = false;
    int m_batteryLevel = 0; // [0 .. 100] %
};

template<>
QString ManagerBase<BatteryManagerBase>::m_name;
