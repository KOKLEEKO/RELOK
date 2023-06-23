#pragma once

#include "ManagerBase.h"
#include "PersistenceCapability.h"

class AdvertisingManagerBase : public ManagerBase<AdvertisingManagerBase>, public PersistenceCapability
{
    Q_OBJECT
    Q_PROPERTY(bool isAdvertisingEnabled READ isAdvertisingEnabled NOTIFY isAdvertisingEnableChanged)
    Q_PROPERTY(bool isAdvertisingRequested READ isAdvertisingRequested WRITE requestAdvertising NOTIFY
                   isAdvertisingRequestedChanged)

public:
    AdvertisingManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent = nullptr);

    bool isAdvertisingEnabled() const;
    bool isAdvertisingRequested() const;
    virtual void enableAdvertising(bool enable);
    Q_INVOKABLE virtual void requestAdvertising(bool isAdvertisingRequested);

signals:
    void isAdvertisingEnableChanged();
    void isAdvertisingRequestedChanged();

private:
    bool m_isAdvertisingEnabled = false;
    bool m_isAdvertisingRequested = false;
};
