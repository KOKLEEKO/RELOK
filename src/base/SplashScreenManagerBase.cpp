/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SplashScreenManagerBase.h"

template<>
QString ManagerBase<SplashScreenManagerBase>::m_name{"splashScreen"};

SplashScreenManagerBase::SplashScreenManagerBase(DeviceAccessBase *deviceAccess, QObject *parent)
    : ManagerBase(deviceAccess, parent)
{}
