/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "PersistenceManager.h"

PersistenceManager::PersistenceManager(QObject *parent)
    : PersistenceManagerBase{parent}
{
    m_isEnabled = true;
}

QVariant PersistenceManager::value(QString key, QVariant defaultValue) const
{
    return m_settings.value(key, defaultValue);
}

void PersistenceManager::setValue(QString key, QVariant value)
{
    m_settings.setValue(key, value);
}
