#include "AutoLockManager.h"

#include <emscripten.h>

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase{deviceAccess, parent}
{
    emscripten_run_script(
        "if ('getBattery' in navigator) { navigator.getBattery().then(function(battery) { "
        "console.log(battery.level * 100 + '%'); }); }");
}

void AutoLockManager::disableAutoLock(bool disable)
{
    Q_UNUSED(disable)
}
