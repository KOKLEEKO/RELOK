/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

class AdvertisingManagerBase : public ManagerBase<AdvertisingManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(bool isAdvertisingEnabled READ isAdvertisingEnabled NOTIFY isAdvertisingEnableChanged)
    Q_PROPERTY(bool isAdvertisingRequested READ isAdvertisingRequested WRITE requestAdvertising NOTIFY
                   isAdvertisingRequestedChanged)

public:
    explicit AdvertisingManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    bool isAdvertisingEnabled() const { return m_isAdvertisingEnabled; }
    bool isAdvertisingRequested() const { return m_isAdvertisingRequested; }

    virtual void enableAdvertising(bool /*enable*/) {}
    Q_INVOKABLE virtual void requestAdvertising(bool isAdvertisingRequested);

signals:
    void isAdvertisingEnableChanged();
    void isAdvertisingRequestedChanged();

private:
    bool m_isAdvertisingEnabled = false;
    bool m_isAdvertisingRequested = false;
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<AdvertisingManagerBase>::m_name;
#endif
