/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "PersistenceManagerBase.h"

template<>
QString ManagerBase<PersistenceManagerBase>::m_name{QStringLiteral("persistence")};

PersistenceManagerBase::PersistenceManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{
    connect(this,
            &PersistenceManagerBase::settingsReady,
            this,
            &PersistenceManagerBase::processAtSettingsReady);
}
