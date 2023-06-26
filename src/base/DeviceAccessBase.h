/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <memory>

#include <QHash>
#include <QLoggingCategory>
#include <QObject>
#include <QtQml/qqml.h>

Q_DECLARE_LOGGING_CATEGORY(lc)

class DeviceAccessBase : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap managers MEMBER m_managers CONSTANT)

    DeviceAccessBase(const DeviceAccessBase &) = delete;
    DeviceAccessBase &operator=(const DeviceAccessBase &) = delete;

public:
    static DeviceAccessBase &instance();
    inline bool isCompleted() const;

    virtual void complete();

    template<class ManagerImpl>
    ManagerImpl *manager(QString name) const
    {
        if (m_isCompleted && m_managers.contains(name) && m_managers[name].isValid())
            return qvariant_cast<ManagerImpl *>(m_managers[name]);
        return nullptr;
    }

protected:
    DeviceAccessBase(QObject *parent = nullptr);

    template<class ManagerImpl>
    void addManager(const std::shared_ptr<ManagerImpl> &manager)
    {
        m_managers.insert(manager.get()->name(), QVariant::fromValue(manager.get()));
    }

private:
    QVariantMap m_managers{};
    bool m_isCompleted = false;
};

QML_DECLARE_TYPE(DeviceAccessBase)
