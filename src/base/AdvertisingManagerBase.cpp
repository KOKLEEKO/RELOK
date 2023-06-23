#include "AdvertisingManagerBase.h"

template<>
QString ManagerBase<AdvertisingManagerBase>::m_name{"advertising"};

AdvertisingManagerBase::AdvertisingManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                               QObject *parent)
    : ManagerBase<AdvertisingManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void AdvertisingManagerBase::requestAdvertising(bool isAdvertisingRequested)
{
    if (m_isAdvertisingRequested == isAdvertisingRequested)
        return;
    persistenceManager()->setValue("Advanced/isAdvertisingRequested", m_isAdvertisingRequested = isAdvertisingRequested);
    emit isAdvertisingRequestedChanged();
}

bool AdvertisingManagerBase::isAdvertisingEnabled() const
{
    return m_isAdvertisingEnabled;
}

bool AdvertisingManagerBase::isAdvertisingRequested() const
{
    return m_isAdvertisingRequested;
}

void AdvertisingManagerBase::enableAdvertising(bool /*enable*/) {}
