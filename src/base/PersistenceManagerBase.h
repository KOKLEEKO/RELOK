/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QString>
#include <QVariant>

class PersistenceManagerBase : public ManagerBase<PersistenceManagerBase>
{
    Q_OBJECT

public:
    explicit PersistenceManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    Q_INVOKABLE virtual QVariant value(QString /*key*/, QVariant /*defaultValue*/) const { return {QVariant::String}; }
    Q_INVOKABLE virtual void setValue(QString /*key*/, QVariant /*value*/) {}

signals:
    void settingsReady();
};

template<>
QString ManagerBase<PersistenceManagerBase>::m_name;
