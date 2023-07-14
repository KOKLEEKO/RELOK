/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <memory>

class EnergySavingManagerBase : public ManagerBase<EnergySavingManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(int minimumBatteryLevel MEMBER m_minimumBatteryLevel WRITE setMinimumBatteryLevel NOTIFY
                   minimumBatteryLevelChanged)

public:
    explicit EnergySavingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);
    void setMinimumBatteryLevel(int value);
    virtual void batterySaving() {}

signals:
    void minimumBatteryLevelChanged();

protected:
    int m_minimumBatteryLevel = 50;
};

template<>
QString ManagerBase<EnergySavingManagerBase>::m_name;
