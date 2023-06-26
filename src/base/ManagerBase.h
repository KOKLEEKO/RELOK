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

Q_DECLARE_LOGGING_CATEGORY(lc)

template<typename ManagerImpl>
class ManagerBase : public QObject
{
public:
    ManagerBase(QObject *parent = nullptr)
        : QObject(parent)
    {}

    static QString name() { return m_name; }

protected:
    static QString m_name; //CRTP
};
