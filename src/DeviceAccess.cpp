#include "DeviceAccess.h"

DeviceAccess::DeviceAccess(QObject* parent)
    : QObject(parent), m_interface(nullptr) {}

void DeviceAccess::requestGuidedAccessSession(bool enable) { Q_UNUSED(enable) }

void DeviceAccess::setBrigthnessDelta(float brigthnessDelta) {
  Q_UNUSED(brigthnessDelta)
}
