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

Q_DECLARE_LOGGING_CATEGORY(lc)

class DeviceAccessBase : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVariantMap managers MEMBER m_managers CONSTANT)

    DeviceAccessBase(const DeviceAccessBase &) = delete;
    DeviceAccessBase &operator=(const DeviceAccessBase &) = delete;

public:
    template<class DeviceAccessImpl>
    static DeviceAccessImpl *instance()
    {
        static DeviceAccessImpl *deviceAccessImpl = new DeviceAccessImpl();
        return deviceAccessImpl;
    }

    template<class ManagerImpl>
    ManagerImpl *manager(QString name) const
    {
        if (m_managers.contains(name) && m_managers[name].isValid())
            return qvariant_cast<ManagerImpl *>(m_managers[name]);
        return nullptr;
    }

    template<class ManagerImpl>
    std::shared_ptr<ManagerImpl> addManager(const std::shared_ptr<ManagerImpl> &manager)
    {
        m_sharedPointers.insert(manager.get()->name(), manager);
        m_managers.insert(manager.get()->name(), QVariant::fromValue(manager.get()));
        return std::move(manager);
    }

protected:
    DeviceAccessBase(QObject *parent = nullptr);

private:
    QVariantMap m_managers{};
    QMap<QString, std::shared_ptr<void> > m_sharedPointers;
};
