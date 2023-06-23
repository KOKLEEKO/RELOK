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
    Q_INVOKABLE void test() { qDebug() << "test"; }
};
