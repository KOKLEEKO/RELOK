/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

using namespace kokleeko::device;

void DeviceAccess::enableGuidedAccessSession(bool enable) { Q_UNUSED(enable) }

void DeviceAccess::setBrigthnessDelta(float brigthnessDelta) {
  Q_UNUSED(brigthnessDelta)
}

void DeviceAccess::disableAutoLock(bool disable) { Q_UNUSED(disable) }

void DeviceAccess::toggleStatusBarVisibility() { emit toggleFullScreen(); }
