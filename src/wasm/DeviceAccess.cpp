/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

#include <emscripten.h>

#include "BatteryManagerBase.h"
#include "EnergySavingManagerBase.h"

Q_LOGGING_CATEGORY(lc, "Device-wasm")

extern "C" {
EMSCRIPTEN_KEEPALIVE
void updateBatteryLevel(float batteryLevel)
{
    DeviceAccessBase::instance()->manager<BatteryManagerBase>()->updateBatteryLevel(batteryLevel);
}

EMSCRIPTEN_KEEPALIVE
void updateIsPlugged(bool isPlugged)
{
    DeviceAccessBase::instance()->manager<BatteryManagerBase>()->updateIsPlugged(isPlugged);
}

EMSCRIPTEN_KEEPALIVE
void disableBatteryAndEnergySavingManagers()
{
    DeviceAccessBase::instance()->manager<BatteryManagerBase>()->disable();
    DeviceAccessBase::instance()->manager<EnergySavingManagerBase>()->disable();
}
}

void DeviceAccess::specificInitializationSteps()
{
    auto batteryManager = DeviceAccess::instance()->manager<BatteryManagerBase>();
    if (batteryManager->enabled()) {
        /* clang-format off */
        EM_ASM({
            if ('getBattery' in navigator) {
                navigator.getBattery().then((battery) => {
                    //BatteryLevel
                    Module._updateBatteryLevel(battery.level);
                    battery.addEventListener("levelchange", () => {
                        Module._updateBatteryLevel(battery.level)
                    });
                    //IsPlugged
                    Module._updateIsPlugged(battery.charging);
                    battery.addEventListener("chargingchange", () => {
                        Module._updateIsPlugged(battery.charging)
                    });
                })
            } else {
                Module._disableBatteryAndEnergySavingManagers()
            }
        });
        /* clang-format on */
    }
}
