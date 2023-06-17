#pragma once

class EnergySavingManagerInterface
{
public:
    virtual void minimumBatteryLevel() const = 0;
    virtual void saveEnergy() = 0;
    virtual void setMinimumBatteryLevel(int value) = 0;
};
