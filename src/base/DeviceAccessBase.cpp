#include "DeviceAccessBase.h"

DeviceAccessBase::DeviceAccessBase(QObject *parent)
    : QObject(parent)
{}

DeviceAccessBase &DeviceAccessBase::instance()
{
    static DeviceAccessBase deviceAccessBase;
    return deviceAccessBase;
}

void DeviceAccessBase::specificInitializationSteps() {}
