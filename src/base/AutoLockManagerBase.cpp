#include "AutoLockManagerBase.h"

template<>
QString ManagerBase<AutoLockManagerBase>::m_name{"autolock"};

void AutoLockManagerBase::disableAutoLock(bool /*disable*/) {}

void AutoLockManagerBase::requestAutoLock(bool isAutoLockRequested)
{
    if (m_isAutoLockRequested == isAutoLockRequested)
        return;
    persistenceManager()->setValue("BatterySaving/isAutoLockRequested", m_isAutoLockRequested = isAutoLockRequested);
    emit isAutoLockRequestedChanged();
};

void AutoLockManagerBase::security(bool /*value*/){};

bool AutoLockManagerBase::isAutoLockRequested() const
{
    return m_isAutoLockRequested;
}

AutoLockManagerBase::AutoLockManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                         QObject *parent)
    : ManagerBase<AutoLockManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

bool AutoLockManagerBase::isAutoLockDisabled() const
{
    return m_isAutoLockDisabled;
}
