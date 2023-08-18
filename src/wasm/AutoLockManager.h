#pragma once

#include <AutoLockManagerBase.h>

class AutoLockManager : public AutoLockManagerBase
{
public:
    explicit AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void disableAutoLock(bool disable) final override;
};

