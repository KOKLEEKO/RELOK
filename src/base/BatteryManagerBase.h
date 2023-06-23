#pragma once

#include "ManagerBase.h"

class BatteryManagerBase : public ManagerBase<BatteryManagerBase>
{
    Q_OBJECT
    Q_PROPERTY(bool isPlugged READ isPlugged NOTIFY isPluggedChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)

public:
    BatteryManagerBase(QObject *parent = nullptr);

    bool isPlugged() const;
    int batteryLevel() const;
    void updateIsPlugged(bool isPlugged);
    void updateBatteryLevel(float batteryLevel);

signals:
    void isPluggedChanged();
    void batteryLevelChanged();

private:
    bool m_isPlugged = false;
    int m_batteryLevel = 0; // [0 .. 100] %
};
