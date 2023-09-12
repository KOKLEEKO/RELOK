#include "AutoLockManager.h"

#include "EnergySavingManagerBase.h"

using namespace Default;

AutoLockManager::AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : AutoLockManagerBase(deviceAccess, parent)
{
    connect(this, &AutoLockManagerBase::isAutoLockRequestedChanged, this, [=]() {
        auto energySavingManager = deviceAccess->manager<EnergySavingManagerBase>();
        if (energySavingManager->enabled())
            energySavingManager->batterySaving();
        else
            disableAutoLock(!isAutoLockRequested());
    });
}
