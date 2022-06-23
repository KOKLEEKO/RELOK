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

void DeviceAccess::security() {}

void DeviceAccess::requestReview() {}

void DeviceAccess::disableAutoLock(bool disable) {
  qCDebug(lc) << "W disableAutoLock:" << disable;
}

void DeviceAccess::updateNotchHeight() {}

void DeviceAccess::setBrightnessRequested(float brightness) {
  QAndroidJniObject::callStaticMethod<void>(
      "io/kokleeko/wordclock/DeviceAccess", "setBrightness",
      "(Landroid/content/Context;I)V", QtAndroid::androidContext().object(),
      qRound(brightness * 255));
}

void DeviceAccess::moveTaskToBack() {
  QtAndroid::androidActivity().callMethod<jboolean>("moveTaskToBack", "(Z)Z",
                                                    true);
}
