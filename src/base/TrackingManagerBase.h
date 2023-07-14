/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

class TrackingManagerBase : public ManagerBase<TrackingManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(bool isBugTracking MEMBER m_isBugTracking WRITE requestBugTracking NOTIFY isBugTrackingChanged)
    Q_PROPERTY(bool isUsageTracking MEMBER m_isUsageTracking WRITE requestUsageTracking NOTIFY isUsageTrackingChanged)

public:
    explicit TrackingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual void requestBugTracking(bool /*value*/) {}
    Q_INVOKABLE virtual void requestUsageTracking(bool /*value*/) {}

signals:
    void isBugTrackingChanged();
    void isUsageTrackingChanged();

private:
    bool m_isBugTracking = false;
    bool m_isUsageTracking = false;
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<TrackingManagerBase>::m_name;
#endif
