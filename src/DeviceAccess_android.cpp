/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

using namespace kokleeko::device;

Q_LOGGING_CATEGORY(lc, "Device-android")

void DeviceAccess::security(bool value) {
    QtAndroid::androidActivity().callMethod<void>(value ? "startLockTask" : "stopLockTask", "()V");
}

void DeviceAccess::requestReview() {
    QtAndroid::androidActivity().callMethod<void>("requestReview");
}

void DeviceAccess::disableAutoLock(bool disable) {
    qCDebug(lc) << "W disableAutoLock:" << disable;
    QtAndroid::runOnAndroidThread([disable] {
        QAndroidJniObject activity = QtAndroid::androidActivity();
        if (activity.isValid()) {
            QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
            if (window.isValid()) {
                const int FLAG_KEEP_SCREEN_ON = QAndroidJniObject::getStaticField<jint>(
                    "android/view/WindowManager$LayoutParams", "FLAG_KEEP_SCREEN_ON");
                window.callMethod<void>(disable ? "addFlags" : "clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
                QAndroidJniObject layoutParams = window.callObjectMethod("getAttributes",
                                                                         "()Landroid/view/WindowManager$LayoutParams;");
                qDebug() << layoutParams.isValid();
                if (layoutParams.isValid()) {
                    const int flags = layoutParams.getField<jint>("flags");
                    qCDebug(lc) << "R autoLockDisabled:" << !!(flags & FLAG_KEEP_SCREEN_ON);
                }
            }
        }
        QAndroidJniEnvironment env;
        if (env->ExceptionCheck())
            env->ExceptionClear();
    });
}

void DeviceAccess::specificInitializationSteps() {
    qCDebug(lc) << "versionName:"
                << QAndroidJniObject::getStaticObjectField<jstring>("io/kokleeko/wordclock/BuildConfig",
                                                                    "VERSION_NAME").toString();
    registerListeners();
    updateSafeAreaInsets();
}

void DeviceAccess::setBrightnessRequested(float brightness) {
    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess",
                                              "setBrightness",
                                              "(I)V",
                                              qRound(brightness * 255));
}

void DeviceAccess::moveTaskToBack() {
    QtAndroid::androidActivity().callMethod<jboolean>("moveTaskToBack", "(Z)Z", true);
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

static void notifyViewConfigurationChanged() {
    DeviceAccess &deviceAccess = DeviceAccess::instance();
    emit deviceAccess.viewConfigurationChanged();
}

JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/) {
    jint jni_version = JNI_VERSION_1_6;
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), jni_version) != JNI_OK)
        return JNI_ERR;
    jclass activityObjectClass = env->GetObjectClass(QtAndroid::androidActivity().object<jobject>());
    jclass deviceAccessClass = env->FindClass("io/kokleeko/wordclock/DeviceAccess");
    if (!deviceAccessClass || !activityObjectClass)
        return JNI_ERR;
    JNINativeMethod activityObjectMethods[]{
        {"configurationChanged", "()V", reinterpret_cast<void *>(::notifyViewConfigurationChanged)}};
    JNINativeMethod deviceAccessMethods[] {
        {"updateBrightness", "(I)V", reinterpret_cast<void *>(::updateBrightness)},
        {"updateIsPlugged", "(Z)V", reinterpret_cast<void *>(::updateIsPlugged)},
        {"updateBatteryLevel", "(F)V", reinterpret_cast<void *>(::updateBatteryLevel)}
    };
    if(env->RegisterNatives(activityObjectClass, activityObjectMethods,
                             sizeof(activityObjectMethods) / sizeof(activityObjectMethods[0])) < 0) {
        env->DeleteLocalRef(activityObjectClass);
        return JNI_ERR;
    }
    if (env->RegisterNatives(deviceAccessClass, deviceAccessMethods,
                             sizeof(deviceAccessMethods) / sizeof(deviceAccessMethods[0])) < 0)
        return JNI_ERR;
    return jni_version;
}

void DeviceAccess::updateSafeAreaInsets() {
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

void DeviceAccess::registerListeners() {
    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess", "registerListeners",
                                              "(Landroid/content/Context;)V", QtAndroid::androidContext().object());
}

void DeviceAccess::requestBrightnessUpdate() {
    QAndroidJniObject::callStaticMethod<void>("io/kokleeko/wordclock/DeviceAccess", "getBrightness", "()V");
}

void DeviceAccess::requestAudioFocus() {
    QtAndroid::androidActivity().callMethod<void>("requestAudioFocus");
}

void DeviceAccess::endOfSpeech() {
    QtAndroid::androidActivity().callMethod<void>("abandonAudioFocus");
}

void DeviceAccess::hideSplashScreen() { QtAndroid::hideSplashScreen(); }
