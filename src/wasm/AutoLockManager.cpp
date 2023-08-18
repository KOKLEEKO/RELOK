#include "AutoLockManager.h"

#include <emscripten.h>

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase{deviceAccess, parent}
{
    emscripten_run_script("console.log('does this working?')");
}

void AutoLockManager::disableAutoLock(bool disable)
{
    Q_UNUSED(disable)
}
