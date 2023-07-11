/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "TrackingManagerBase.h"

template<>
QString ManagerBase<TrackingManagerBase>::m_name{"tracking"};

TrackingManagerBase::TrackingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}
