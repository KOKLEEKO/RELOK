/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <PersistenceManagerBase.h>

template<>
QString ManagerBase<PersistenceManagerBase>::m_name{"persistence"};

PersistenceManagerBase::PersistenceManagerBase(QObject *parent)
    : ManagerBase(parent)
{}

QVariant PersistenceManagerBase::value(QString /*key*/, QVariant /*defaultValue*/) const
{
    return {};
};

void PersistenceManagerBase::setValue(QString /*key*/, QVariant /*value*/){};
