#pragma once

#include <EnergySavingManagerBase.h>

class EnergySavingManager : public EnergySavingManagerBase
{
public:
    EnergySavingManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

public:
    void batterySaving() final override;

signals:
    void disableAutoLock(bool disable);
};

