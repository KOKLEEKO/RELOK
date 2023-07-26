/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ScreenBrightnessManager.h"

#include <QAndroidJniObject>

#include <DeviceAccess.h>

ScreenBrightnessManager::ScreenBrightnessManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenBrightnessManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ScreenBrightnessManager::setBrightnessRequested(float brightness)
{
    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess",
                                              "setBrightness",
                                              "(I)V",
                                              qRound(brightness * 255));
}

void ScreenBrightnessManager::requestBrightnessUpdate()
{
    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess", "getBrightness", "()V");
}
