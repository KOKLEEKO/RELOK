/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "PersistenceManager.h"

#include <QTimerEvent>

PersistenceManager::PersistenceManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : PersistenceManagerBase{deviceAccess, parent}
{
    m_enabled = true;
    startTimer(0);
    qCDebug(lc) << m_settings.fileName();
}

QVariant PersistenceManager::value(QString key, QVariant defaultValue) const
{
    return m_settings.value(key, defaultValue);
}

void PersistenceManager::setValue(QString key, QVariant value)
{
    m_settings.setValue(key, value);
}

void PersistenceManager::timerEvent(QTimerEvent *event)
{
    if (m_settings.status() != QSettings::AccessError) {
        killTimer(event->timerId());
        qCDebug(lc) << "settings ready";
        emit settingsReady();
    }
}
