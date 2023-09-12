#pragma once

#include "src/default/AutoLockManager.h"

class AutoLockManager : public Default::AutoLockManager
{
public:
    explicit AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void disableAutoLock(bool disable) final override;
};

