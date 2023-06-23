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
