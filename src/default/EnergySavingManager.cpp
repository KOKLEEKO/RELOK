#include "EnergySavingManager.h"

EnergySavingManager::EnergySavingManager(const std::shared_ptr<AutoLockManagerBase> &autoLockManager,
                                         const std::shared_ptr<BatteryManagerBase> &batteryManager,
                                         const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : EnergySavingManagerBase(autoLockManager, batteryManager, persistenceManager, parent)
{
    m_enabled = true;

    connect(m_batteryManager.get(), &BatteryManagerBase::batteryLevelChanged, this, &EnergySavingManager::batterySaving);
    connect(m_batteryManager.get(), &BatteryManagerBase::isPluggedChanged, this, &EnergySavingManager::batterySaving);
    connect(m_autoLockManager.get(),
            &AutoLockManagerBase::isAutoLockRequestedChanged,
            this,
            &EnergySavingManager::batterySaving);
}

void EnergySavingManager::batterySaving()
{
    qCDebug(lc) << __func__ << m_autoLockManager->isAutoLockRequested() << m_batteryManager->isPlugged()
                << m_batteryManager->batteryLevel() << m_minimumBatteryLevel;
    bool disable = !m_autoLockManager->isAutoLockRequested()
                   && (m_batteryManager->isPlugged() || m_batteryManager->batteryLevel() > m_minimumBatteryLevel);
    m_autoLockManager->disableAutoLock(disable);
}
