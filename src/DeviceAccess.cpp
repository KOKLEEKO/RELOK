/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

using namespace kokleeko::device;

Q_LOGGING_CATEGORY(lc, "Device")

void DeviceAccess::enableGuidedAccessSession(bool enable) { Q_UNUSED(enable) }

void DeviceAccess::setBrigthnessDelta(float brigthnessDelta) {
  qDebug(lc) << "W brigthnessDelta:" << brigthnessDelta;
}

void DeviceAccess::disableAutoLock(bool disable) {
  qCDebug(lc) << "W disableAutoLock:" << disable;
}

void DeviceAccess::toggleStatusBarVisibility() { emit toggleFullScreen(); }
