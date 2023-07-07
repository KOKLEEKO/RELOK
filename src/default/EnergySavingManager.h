#pragma once

#include <EnergySavingManagerBase.h>

class EnergySavingManager : public EnergySavingManagerBase
{
public:
    EnergySavingManager(const std::shared_ptr<AutoLockManagerBase> &autoLockManager,
                        const std::shared_ptr<BatteryManagerBase> &batteryManager,
                        const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                        QObject *parent = nullptr);

private:
    void batterySaving() override final;
};

