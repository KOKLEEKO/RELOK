#pragma once

class BatteryManagerInterface
{
public:
    virtual bool isPlugged() const = 0;
    virtual float batteryLevel() = 0;
    virtual void updateBatteryLevel(float value) = 0;
};

