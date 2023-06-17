#pragma once

class AutoLockManagerInterface
{
public:
    virtual bool isAutoLockDisabled() const = 0;
    virtual bool isAutoLockRequested() const = 0;
    virtual void disableAutoLock(bool value) = 0;
    virtual void requestAutoLock(bool value) = 0;
};

