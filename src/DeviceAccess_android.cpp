/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <QtAndroidExtras>

#include "DeviceAccess.h"

using namespace kokleeko::device;

Q_LOGGING_CATEGORY(lc, "Device-android")

void DeviceAccess::security(bool value) {
    QtAndroid::androidActivity().callMethod<void>(
                value ? "startLockTask" : "stopLockTask", "()V");
}

void DeviceAccess::requestReview() {
    QAndroidJniObject::callStaticMethod<void>(
                "io/kokleeko/wordclock/DeviceAccess", "requestReview", "()V");
}

void DeviceAccess::disableAutoLock(bool disable) {
    qCDebug(lc) << "W disableAutoLock:" << disable;
    QtAndroid::runOnAndroidThread([disable] {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject window =
                    activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON = QAndroidJniObject::getStaticField<jint>(
                            "android/view/WindowManager$LayoutParams", "FLAG_KEEP_SCREEN_ON");
                window.callMethod<void>(disable ? "addFlags" : "clearFlags", "(I)V",
                                        FLAG_KEEP_SCREEN_ON);
                QAndroidJniObject layoutParams = window.callObjectMethod(
                            "getAttributes", "()Landroid/view/WindowManager$LayoutParams;");
                qDebug() << layoutParams.isValid();
                if (layoutParams.isValid()) {
                    const int flags = layoutParams.getField<jint>("flags");
                    qCDebug(lc) << "R autoLockDisabled:"
                                << !!(flags & FLAG_KEEP_SCREEN_ON);
                }
            }
        }
        QAndroidJniEnvironment env;
        if (env->ExceptionCheck()) env->ExceptionClear();
    });
}

void DeviceAccess::updateNotchHeight() {}

void DeviceAccess::setBrightnessRequested(float brightness) {
    QAndroidJniObject::callStaticMethod<void>(
                "io/kokleeko/wordclock/DeviceAccess", "setBrightness", "(I)V",
                qRound(brightness * 255));
}

void DeviceAccess::moveTaskToBack() {
    QtAndroid::androidActivity().callMethod<jboolean>("moveTaskToBack", "(Z)Z",
                                                      true);
}

static void updateBrightness(JNIEnv *, jobject, jint value) {
    DeviceAccess::instance().updateBrightness(value / 255.0);
}
static void updateIsPlugged(JNIEnv *, jobject, jboolean value) {
    DeviceAccess::instance().updateIsPlugged(value);
}
static void updateBatteryLevel(JNIEnv *, jobject, jfloat value) {
    DeviceAccess::instance().updateBatteryLevel(value);
}

void DeviceAccess::registerListeners() {
    QAndroidJniObject::callStaticMethod<void>(
                "io/kokleeko/wordclock/DeviceAccess", "registerListeners",
                "(Landroid/content/Context;)V", QtAndroid::androidContext().object());
    JNINativeMethod methods[]{
        {"updateBrightness", "(I)V",
            reinterpret_cast<void *>(::updateBrightness)},
        {"updateIsPlugged", "(Z)V", reinterpret_cast<void *>(::updateIsPlugged)},
        {"updateBatteryLevel", "(F)V",
            reinterpret_cast<void *>(::updateBatteryLevel)},
    };
    QAndroidJniObject javaClass("io/kokleeko/wordclock/DeviceAccess");
    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
    env->RegisterNatives(objectClass, methods,
                         sizeof(methods) / sizeof(methods[0]));
    env->DeleteLocalRef(objectClass);
}

void DeviceAccess::requestBrightnessUpdate() {
    QAndroidJniObject::callStaticMethod<void>(
                "io/kokleeko/wordclock/DeviceAccess", "getBrightness", "()V");
}
