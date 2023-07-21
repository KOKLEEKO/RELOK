/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ScreenSizeManager.h"

#include <DeviceAccess.h>
#include <QAndroidJniObject>
#include <QtAndroid>

ScreenSizeManager::ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenSizeManagerBase{deviceAccess, parent}
{
    m_enabled = true;

    updateSafeAreaInsets();
}

void ScreenSizeManager::updateSafeAreaInsets()
{
    QAndroidJniObject activity = QtAndroid::androidActivity();
    QAndroidJniObject safeAreaInsets = activity.callObjectMethod("safeAreaInsets", "()Landroid/graphics/RectF;");
    m_safeInsetBottom = safeAreaInsets.getField<float>("bottom");
    m_safeInsetLeft = safeAreaInsets.getField<float>("left");
    m_safeInsetRight = safeAreaInsets.getField<float>("right");
    m_safeInsetTop = safeAreaInsets.getField<float>("top");
    m_statusBarHeight = activity.callMethod<jdouble>("statusBarHeight");
    m_navigationBarHeight = activity.callMethod<jdouble>("navigationBarHeight");
    emit safeInsetsChanged();
}
