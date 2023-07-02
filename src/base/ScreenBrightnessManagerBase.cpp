/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ScreenBrightnessManagerBase.h"

template<>
QString ManagerBase<ScreenBrightnessManagerBase>::m_name{"screenBrightness"};

ScreenBrightnessManagerBase::ScreenBrightnessManagerBase(
    const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent)
    : ManagerBase(parent)
    , PersistenceCapability(persistenceManager)
{}

void ScreenBrightnessManagerBase::updateBrightness(float brightness)
{
    m_brightness = qRound(brightness * 100);
    qCDebug(lc) << "[R] brightness:" << m_brightness;
    emit brightnessChanged();
}
