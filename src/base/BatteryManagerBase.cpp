#include "BatteryManagerBase.h"

template<>
QString ManagerBase<BatteryManagerBase>::m_name{"battery"};

BatteryManagerBase::BatteryManagerBase(QObject *parent)
    : ManagerBase(parent)
{}

void BatteryManagerBase::updateBatteryLevel(float batteryLevel)
{
    m_batteryLevel = qRound(batteryLevel * 100);
    qCDebug(lc) << "[R] batteryLevel:" << m_batteryLevel;
    emit batteryLevelChanged();
}

void BatteryManagerBase::updateIsPlugged(bool isPlugged)
{
    if (m_isPlugged == isPlugged)
        return;
    m_isPlugged = isPlugged;
    qCDebug(lc) << "R isPlugged:" << m_isPlugged;
    emit isPluggedChanged();
}

bool BatteryManagerBase::isPlugged() const
{
    return m_isPlugged;
}

int BatteryManagerBase::batteryLevel() const
{
    return m_batteryLevel;
}
