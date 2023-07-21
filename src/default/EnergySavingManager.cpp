#include "EnergySavingManager.h"

#include <AutoLockManagerBase.h>
#include <BatteryManagerBase.h>

EnergySavingManager::EnergySavingManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : EnergySavingManagerBase(deviceAccess, parent)
{
    m_enabled = true;

    auto batteryManager = deviceAccess->manager<BatteryManagerBase>();
    connect(batteryManager, &BatteryManagerBase::batteryLevelChanged, this, &EnergySavingManager::batterySaving);
    connect(batteryManager, &BatteryManagerBase::isPluggedChanged, this, &EnergySavingManager::batterySaving);
}

void EnergySavingManager::batterySaving()
{
    auto autoLockManager = deviceAccess()->manager<AutoLockManagerBase>();
    auto batteryManager = deviceAccess()->manager<BatteryManagerBase>();

    bool disable = !autoLockManager->isAutoLockRequested()
                   && (batteryManager->isPlugged() || batteryManager->batteryLevel() > m_minimumBatteryLevel);

    autoLockManager->disableAutoLock(disable);
}
