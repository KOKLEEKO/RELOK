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
    PersistenceManagerBase(QObject *parent = nullptr);

    Q_INVOKABLE QVariant value(QString key, QVariant defaultValue) const;
    Q_INVOKABLE void setValue(QString key, QVariant value);
};
