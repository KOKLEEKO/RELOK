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

    DeviceAccessBase(QObject *parent = nullptr);

    DeviceAccessBase(const DeviceAccessBase &) = delete;
    DeviceAccessBase &operator=(const DeviceAccessBase &) = delete;
    virtual void specificInitializationSteps();

public:
    static DeviceAccessBase &instance();

    template<class ManagerImpl>
    void addManager(const std::shared_ptr<ManagerImpl> &manager)
    {
        QString name = manager.get()->name();
        m_managers.insert(name, QVariant::fromValue(manager.get()));
    }

    template<class ManagerImpl>
    ManagerImpl *manager(QString name) const
    {
        if (!m_managers.contains(name) || !m_managers[name].isValid())
            return nullptr;
        return qvariant_cast<ManagerImpl *>(m_managers[name]);
    }

private:
    QVariantMap m_managers;
};

QML_DECLARE_TYPE(DeviceAccessBase)
