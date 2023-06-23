#pragma once

#include "ManagerBase.h"
#include "PersistenceCapability.h"

class AutoLockManagerBase : public ManagerBase<AutoLockManagerBase>, public PersistenceCapability
{
    Q_OBJECT
    Q_PROPERTY(bool isAutoLockDisabled READ isAutoLockDisabled NOTIFY isAutoLockDisabledChanged)
    Q_PROPERTY(bool isAutoLockRequested READ isAutoLockRequested WRITE requestAutoLock NOTIFY isAutoLockRequestedChanged)

public:
    AutoLockManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent = nullptr);

    bool isAutoLockDisabled() const;
    bool isAutoLockRequested() const;
    Q_INVOKABLE void requestAutoLock(bool isAutoLockRequested);
    Q_INVOKABLE virtual void security(bool value);
    virtual void disableAutoLock(bool disable);

signals:
    void isAutoLockDisabledChanged();
    void isAutoLockRequestedChanged();

private:
    bool m_isAutoLockDisabled = false;
    bool m_isAutoLockRequested = false;
};
