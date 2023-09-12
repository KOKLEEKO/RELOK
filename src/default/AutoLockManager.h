#pragma once

#include <AutoLockManagerBase.h>

namespace Default {

class AutoLockManager : public AutoLockManagerBase
{
public:
    explicit AutoLockManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);
};

} // namespace Default
