/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManager.h"

#include <QAndroidJniEnvironment>
#include <QtAndroid>

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void AutoLockManager::security(bool value)
{
    QtAndroid::androidActivity().callMethod<void>(value ? "startLockTask" : "stopLockTask", "()V");
}

void AutoLockManager::disableAutoLock(bool disable)
{
    qCDebug(lc) << "[W] disableAutoLock:" << disable;
    QtAndroid::runOnAndroidThread([disable] {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON
                    = QAndroidJniObject::getStaticField<jint>("android/view/WindowManager$LayoutParams",
                                                              "FLAG_KEEP_SCREEN_ON");
                window.callMethod<void>(disable ? "addFlags" : "clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                QAndroidJniObject layoutParams = window.callObjectMethod("getAttributes",
                                                                         "()Landroid/view/WindowManager$LayoutParams;");
                if (layoutParams.isValid()) {
                    const int flags = layoutParams.getField<jint>("flags");
                    qCDebug(lc) << "[R] autoLockDisabled:" << !!(flags & FLAG_KEEP_SCREEN_ON);
                }
            }
        }
        QAndroidJniEnvironment env;
        if (env->ExceptionCheck())
            env->ExceptionClear();
    });
}
