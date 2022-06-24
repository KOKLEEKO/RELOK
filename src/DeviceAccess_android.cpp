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

Q_LOGGING_CATEGORY(lc, "Device_android")

void DeviceAccess::batterySaving() {}

void DeviceAccess::security(bool value) {
  if (value)
    QtAndroid::androidActivity().callMethod<void>("startLockTask", "()V");
  else
    QtAndroid::androidActivity().callMethod<void>("stopLockTask", "()V");
}

void DeviceAccess::requestReview() {}

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
        if (disable) {
          window.callMethod<void>("addFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
        } else {
          window.callMethod<void>("clearFlags", "(I)V", FLAG_KEEP_SCREEN_ON);
        }
      }
    }
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck()) {
      env->ExceptionClear();
    }
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

void DeviceAccess::registerListeners() {
  QAndroidJniObject::callStaticMethod<void>(
      "io/kokleeko/wordclock/DeviceAccess", "registerListeners",
      "(Landroid/content/Context;)V", QtAndroid::androidContext().object());
  JNINativeMethod methods[]{{"updateBrightness", "(I)V",
                             reinterpret_cast<void *>(::updateBrightness)}};
  QAndroidJniObject javaClass("io/kokleeko/wordclock/DeviceAccess");
  QAndroidJniEnvironment env;
  jclass objectClass = env->GetObjectClass(javaClass.object<jobject>());
  env->RegisterNatives(objectClass, methods,
                       sizeof(methods) / sizeof(methods[0]));
  env->DeleteLocalRef(objectClass);
  QAndroidJniObject::callStaticMethod<void>(
      "io/kokleeko/wordclock/DeviceAccess", "registerListeners",
      "(Landroid/content/Context;)V", QtAndroid::androidContext().object());
}

void DeviceAccess::requestBrightnessUpdate() {
  QAndroidJniObject::callStaticMethod<void>(
      "io/kokleeko/wordclock/DeviceAccess", "getBrightness", "()V");
}
