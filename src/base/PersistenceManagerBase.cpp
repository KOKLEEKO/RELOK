#include "PersistenceManagerBase.h"

template<>
QString ManagerBase<PersistenceManagerBase>::m_name{"persistence"};

PersistenceManagerBase::PersistenceManagerBase(QObject *parent)
    : ManagerBase(parent)
{}

QVariant PersistenceManagerBase::value(QString /*key*/, QVariant /*defaultValue*/) const
{
    return {};
};

void PersistenceManagerBase::setValue(QString key, QVariant value)
{
    qDebug() << __func__ << key << value;
};
