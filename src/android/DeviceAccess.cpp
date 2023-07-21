/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

#include <QAndroidJniObject>
#include <QtAndroid>

#include <BatteryManagerBase.h>
#include <ScreenBrightnessManagerBase.h>
#include <ScreenSizeManagerBase.h>

Q_LOGGING_CATEGORY(lc, "Device-android")

DeviceAccess::DeviceAccess(QObject *parent)
    : DeviceAccessBase{parent}
{
    qCDebug(lc) << "[R] versionName:"
                << QAndroidJniObject::getStaticObjectField<jstring>("io/kokleeko/wordclock/BuildConfig", "VERSION_NAME")
                       .toString();

    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess",
                                              "registerListeners",
                                              "(Landroid/content/Context;)V",
                                              QtAndroid::androidContext().object());
}

void DeviceAccess::DeviceAccess::moveTaskToBack()
{
    QtAndroid::androidActivity().callMethod<jboolean>("moveTaskToBack", "(Z)Z", true);
}

#pragma region staticMethods {
static void updateBrightness(JNIEnv *, jobject, jint value)
{
    DeviceAccess::instance()->manager<ScreenBrightnessManagerBase>()->updateBrightness(value / 255.0);
}

static void updateIsPlugged(JNIEnv *, jobject, jboolean value)
{
    DeviceAccess::instance()->manager<BatteryManagerBase>()->updateIsPlugged(value);
}

static void updateBatteryLevel(JNIEnv *, jobject, jfloat value)
{
    DeviceAccess::instance()->manager<BatteryManagerBase>()->updateBatteryLevel(value);
}

static void notifyViewConfigurationChanged()
{
    emit DeviceAccess::instance()->manager<ScreenSizeManagerBase>()->viewConfigurationChanged();
}

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void * /*reserved*/)
{
    jint jni_version = JNI_VERSION_1_6;
    JNIEnv *env;
    if (vm->GetEnv(reinterpret_cast<void **>(&env), jni_version) != JNI_OK)
        return JNI_ERR;
    jclass activityObjectClass = env->GetObjectClass(QtAndroid::androidActivity().object<jobject>());
    jclass deviceAccessClass = env->FindClass("io/kokleeko/wordclock/DeviceAccess");
    if (!deviceAccessClass || !activityObjectClass)
        return JNI_ERR;
    JNINativeMethod activityObjectMethods[]{
        {"configurationChanged", "()V", reinterpret_cast<void *>(::notifyViewConfigurationChanged)}};
    JNINativeMethod deviceAccessMethods[]{{"updateBrightness", "(I)V", reinterpret_cast<void *>(::updateBrightness)},
                                          {"updateIsPlugged", "(Z)V", reinterpret_cast<void *>(::updateIsPlugged)},
                                          {"updateBatteryLevel",
                                           "(F)V",
                                           reinterpret_cast<void *>(::updateBatteryLevel)}};
    if (env->RegisterNatives(activityObjectClass,
                             activityObjectMethods,
                             sizeof(activityObjectMethods) / sizeof(activityObjectMethods[0]))
        < 0) {
        env->DeleteLocalRef(activityObjectClass);
        return JNI_ERR;
    }
    if (env->RegisterNatives(deviceAccessClass,
                             deviceAccessMethods,
                             sizeof(deviceAccessMethods) / sizeof(deviceAccessMethods[0]))
        < 0)
        return JNI_ERR;
    return jni_version;
}
#pragma endregion }
