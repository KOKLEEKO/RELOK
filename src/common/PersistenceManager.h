/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <PersistenceManagerBase.h>

#include <QSettings>

class PersistenceManager : public PersistenceManagerBase
{
    Q_OBJECT

public:
    explicit PersistenceManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    QVariant value(QString key, QVariant defaultValue) const final override;
    void setValue(QString key, QVariant value) final override;
    void timerEvent(QTimerEvent *event) final override;
    void clear() final override;

private:
    QSettings m_settings;
};
