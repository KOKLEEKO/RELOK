/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <QLoggingCategory>
#include <QObject>
#include <memory>

Q_DECLARE_LOGGING_CATEGORY(lc)

namespace kokleeko::device {

class DeviceAccess : public QObject {
  Q_OBJECT

  Q_PROPERTY(float batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
  Q_PROPERTY(bool isPlugged READ isPlugged NOTIFY isPluggedChanged)

  Q_PROPERTY(bool isGuidedAccessSession READ isGuidedAccessSession NOTIFY
                 isGuidedAccessSessionChanged)

  Q_PROPERTY(bool isAutoLock READ isAutoLock NOTIFY isAutoLockChanged)

 public:
  static DeviceAccess& instance() {
    static DeviceAccess instance;
    return instance;
  }
  void updateIsPlugged(bool isPlugged) {
    m_isPlugged = isPlugged;
    qCDebug(lc) << "R isPlugged:" << m_isPlugged;
    emit isPluggedChanged();
  }
  void updateBatteryLevel(float batteryLevel) {
    m_batteryLevel = batteryLevel;
    qCDebug(lc) << "R batteryLevel:" << m_batteryLevel;
    emit batteryLevelChanged();
  }

  float batteryLevel() const { return m_batteryLevel; }
  bool isPlugged() const { return m_isPlugged; }
  bool isGuidedAccessSession() const { return m_isGuidedAccessSession; }
  bool isAutoLock() const { return m_isAutoLock; }
  bool isStatusBarHidden() const { return m_isStatusBarHidden; }

 public slots:
  void enableGuidedAccessSession(bool enable);
  void setBrigthnessDelta(float brigthnessDelta);
  void disableAutoLock(bool disable);
  void toggleStatusBarVisibility();

 signals:
  void batteryLevelChanged();
  void brigthnessLevelChanged();
  void isPluggedChanged();
  void isGuidedAccessSessionChanged();
  void orientationChanged();
  void isAutoLockChanged();
  void toggleFullScreen();

 private:
  DeviceAccess() = default;
  ~DeviceAccess() = default;
  DeviceAccess(const DeviceAccess&) = delete;
  DeviceAccess& operator=(const DeviceAccess&) = delete;

  float m_batteryLevel = 0.;
  bool m_isPlugged = false;
  bool m_isGuidedAccessSession = false;
  bool m_isAutoLock = false;
  bool m_isStatusBarHidden = false;
};
}  // namespace kokleeko::device
