/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <QObject>

#include <QLoggingCategory>
#include <QString>

#include "DeviceAccessBase.h"

Q_DECLARE_LOGGING_CATEGORY(lc)

template<typename ManagerImpl>
class ManagerBase : public QObject
{
    Q_PROPERTY(bool enabled READ enabled CONSTANT)
public:
    explicit ManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr)
        : QObject(parent)
        , m_deviceAccess(deviceAccess)
    {}

    static QString name() { return m_name; }
    bool enabled() const { return m_enabled; }

    DeviceAccessBase *deviceAccess() const { return m_deviceAccess; }

protected:
    static QString m_name; //CRTP
    DeviceAccessBase *m_deviceAccess;
    bool m_enabled = false;
};
