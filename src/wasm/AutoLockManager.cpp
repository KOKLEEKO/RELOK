#include "AutoLockManager.h"

#include <emscripten.h>

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void AutoLockManager::disableAutoLock(bool disable)
{
    Q_UNUSED(disable)
}
