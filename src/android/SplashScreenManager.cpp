/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "SplashScreenManager.h"

#include <QtAndroid>

SplashScreenManager::SplashScreenManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : SplashScreenManagerBase{deviceAccess, parent}
{
    m_isActive = m_enabled = true;
}

void SplashScreenManager::hideSplashScreen()
{
    QtAndroid::hideSplashScreen();
    SplashScreenManagerBase::hideSplashScreen();
}
