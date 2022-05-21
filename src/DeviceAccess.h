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
#include <QSettings>
#include <memory>

Q_DECLARE_LOGGING_CATEGORY(lc)

namespace kokleeko::device {

class DeviceAccess : public QObject {
  Q_OBJECT

  // About
  Q_PROPERTY(bool isBugTracking READ isBugTracking WRITE setIsBugTracking NOTIFY
                 isBugTrackingChanged)
  // BatterySaving
  Q_PROPERTY(float brightness READ brightness NOTIFY brightnessChanged)
  Q_PROPERTY(float brightnessRequested READ brightnessRequested WRITE
                 setBrightness NOTIFY brightnessRequestedChanged)
  Q_PROPERTY(int minimumBatteryLevel READ minimumBatteryLevel WRITE
                 setMinimumBatteryLevel NOTIFY minimumBatteryLevelChanged)
  Q_PROPERTY(bool isAutoLockRequested READ isAutoLockRequested WRITE
                 requestAutoLock NOTIFY isAutoLockRequestedChanged)
  Q_PROPERTY(bool isAutoLockDisabled READ isAutoLockDisabled NOTIFY
                 isAutoLockDisabledChanged)
  // Security
  Q_PROPERTY(bool isGuidedAccessRequested READ isGuidedAccessRequested WRITE
                 requestGuidedAccess NOTIFY isGuidedAccessRequestedChanged)
  Q_PROPERTY(bool isGuidedAccessEnabled READ isGuidedAccessEnabled NOTIFY
                 isGuidedAccessEnabledChanged)

 public:
  static DeviceAccess& instance() {
    static DeviceAccess instance;
    return instance;
  }

  // About
  bool isBugTracking() const { return m_isBugTracking; }
  // Appearance
  bool isStatusBarHidden() const { return m_isStatusBarHidden; }
  // Battery Saving
  int minimumBatteryLevel() const { return m_minimumBatteryLevel; }
  bool isPlugged() const { return m_isPlugged; }
  bool isAutoLockRequested() const { return m_isAutoLockRequested; }
  bool isAutoLockDisabled() const { return m_isAutoLockDisabled; }
  float brightnessRequested() const { return m_brightnessRequested; }
  float brightness() const { return m_brightness; }
  void updateIsPlugged(bool isPlugged) {
    if (m_isPlugged == isPlugged) return;
    m_isPlugged = isPlugged;
    qCDebug(lc) << "R isPlugged:" << m_isPlugged;
    emit isPluggedChanged();
  }
  void updateBatteryLevel(float batteryLevel) {
    m_batteryLevel = batteryLevel;
    qCDebug(lc) << "R batteryLevel:" << m_batteryLevel;
    emit batteryLevelChanged();
  }
  void updateBrightness(float brightness) {
    m_brightness = brightness;
    qCDebug(lc) << "R brightness:" << m_brightness;
    emit brightnessChanged();
  }
  void disableAutoLock(bool disable);
  // Security
  bool isGuidedAccessRequested() const { return m_isGuidedAccessRequested; }
  bool isGuidedAccessEnabled() const { return m_isGuidedAccessEnabled; }
  void enableGuidedAccessSession(bool enable);
  // Settings
  Q_INVOKABLE void setSettingsValue(const QString& key, const QVariant& value) {
    m_settings.setValue(key, value);
  }
  Q_INVOKABLE QVariant
  settingsValue(const QString& key, const QVariant& defaultValue = QVariant()) {
    QVariant value = m_settings.value(key, defaultValue);
    if (value == "true") {
      return true;
    } else if (value == "false") {
      return false;
    } else {
      return m_settings.value(key, defaultValue);
    }
  }

 public slots:
  // About
  void setIsBugTracking(bool isBugTracking) {
    if (m_isBugTracking == isBugTracking) return;
    m_settings.setValue("About/isBugTracking", m_isBugTracking = isBugTracking);
    emit isBugTrackingChanged();
  }
  // Appearance
  void toggleStatusBarVisibility();
  // BatterySaving
  void requestAutoLock(bool isAutoLockRequested) {
    if (m_isAutoLockRequested == isAutoLockRequested) return;
    m_settings.setValue("BatterySaving/isAutoLockRequested",
                        m_isAutoLockRequested = isAutoLockRequested);

    emit isAutoLockRequestedChanged();
  }
  void setMinimumBatteryLevel(int minimumBatteryLevel) {
    if (m_minimumBatteryLevel == minimumBatteryLevel) return;
    m_settings.setValue("BatterySaving/minimumBatteryLevel",
                        m_minimumBatteryLevel = minimumBatteryLevel);
    emit minimumBatteryLevelChanged();
  }
  void setBrigthnessDelta(float brightnessDelta);
  void setBrightness(float brightness);
  // Security
  void requestGuidedAccess(bool isGuidedAccessRequested) {
    if (m_isGuidedAccessRequested == isGuidedAccessRequested) return;
    m_settings.setValue("BatterySaving/isGuidedAccessRequested",
                        m_isGuidedAccessRequested = isGuidedAccessRequested);
    emit isGuidedAccessRequestedChanged();
  }

 signals:
  // About
  void isBugTrackingChanged();
  // Appearance
  void orientationChanged();
  void toggleFullScreen();
  // BatterySaving
  void batteryLevelChanged();
  void minimumBatteryLevelChanged();
  void isPluggedChanged();
  void isAutoLockRequestedChanged();
  void isAutoLockDisabledChanged();
  void brightnessRequestedChanged();
  void brightnessChanged();
  // Security
  void isGuidedAccessEnabledChanged();
  void isGuidedAccessRequestedChanged();

 private:
  DeviceAccess(QObject* parent = nullptr) : QObject(parent) {
    connect(this, &DeviceAccess::batteryLevelChanged,
            &DeviceAccess::batterySaving);
    connect(this, &DeviceAccess::isPluggedChanged,
            &DeviceAccess::batterySaving);
    connect(this, &DeviceAccess::isAutoLockRequestedChanged,
            &DeviceAccess::batterySaving);
    batterySaving();
    qCDebug(lc) << m_settings.fileName();
  };
  ~DeviceAccess() = default;
  DeviceAccess(const DeviceAccess&) = delete;
  DeviceAccess& operator=(const DeviceAccess&) = delete;
  void batterySaving();

  QSettings m_settings = QSettings("wordclock.ini", QSettings::IniFormat);
  float m_batteryLevel = 0;
  float m_brightness = -1;
  float m_brightnessRequested =
      m_settings.value("BatterySaving/brightnessRequested", .5).toFloat();
  int m_minimumBatteryLevel =
      m_settings.value("BatterySaving/minimumBatteryLevel", 50).toInt();
  bool m_isPlugged = false;

  bool m_isAutoLockRequested =
      m_settings.value("BatterySaving/isAutoLockRequested", true).toBool();
  bool m_isAutoLockDisabled = false;
  bool m_isGuidedAccessRequested =
      m_settings.value("BatterySaving/isGuidedAccessRequested", true).toBool();
  bool m_isGuidedAccessEnabled = false;
  bool m_isStatusBarHidden = false;
  bool m_isBugTracking = m_settings.value("About/isBugTracking", true).toBool();
};
}  // namespace kokleeko::device
