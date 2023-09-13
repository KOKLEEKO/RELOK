/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "AutoLockManager.h"

#include <emscripten.h>

extern "C" {
EMSCRIPTEN_KEEPALIVE
void setIsAutoLockDisabled(bool newIsAutoLockDisabled)
{
    DeviceAccessBase::instance()->manager<AutoLockManagerBase>()->setIsAutoLockDisabled(
        newIsAutoLockDisabled);
}
}

/* clang-format off */
EM_JS(bool, isWakeLockSupported, (),
{
    return ("wakeLock" in navigator);
});

EM_JS(void, enableAutoLock, (),
{
    if (Module.wakeLock)
        Module.wakeLock.release().then(() => {
            Module.wakeLock = null;
            Module._setIsAutoLockDisabled(false);
        });
});

EM_JS(void, disableAutoLock, (),
{
    Module.wakeLock = null;
    navigator.wakeLock.request('screen').then((wakeLock) => {
        Module.wakeLock = wakeLock;
        Module._setIsAutoLockDisabled(true);
    });
});
/* clang-format on */

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::AutoLockManager{deviceAccess, parent}
{
    m_enabled = ::isWakeLockSupported();

    if (m_enabled) {
        /* clang-format off */
        EM_ASM({
            document.addEventListener('visibilitychange', () => {
                if (Module.wakeLock && document.visibilityState === 'visible')
                    disableAutoLock();
            });
        });
        /* clang-format on */
    }
}

void AutoLockManager::disableAutoLock(bool disable)
{
    if (disable)
        ::disableAutoLock();
    else
        ::enableAutoLock();
}
