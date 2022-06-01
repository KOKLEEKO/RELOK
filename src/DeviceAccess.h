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
  // Appearance
  Q_PROPERTY(float notchHeight READ notchHeight CONSTANT)
  // BatterySaving
  Q_PROPERTY(float brightness READ brightness NOTIFY brightnessChanged)
  Q_PROPERTY(float brightnessRequested WRITE setBrightnessRequested MEMBER
                 m_brightnessRequested)
  Q_PROPERTY(int minimumBatteryLevel READ minimumBatteryLevel WRITE
                 setMinimumBatteryLevel NOTIFY minimumBatteryLevelChanged)
  Q_PROPERTY(bool isAutoLockRequested READ isAutoLockRequested WRITE
                 requestAutoLock NOTIFY isAutoLockRequestedChanged)
  Q_PROPERTY(bool isAutoLockDisabled READ isAutoLockDisabled NOTIFY
                 isAutoLockDisabledChanged)

 public:
  static DeviceAccess& instance() {
    static DeviceAccess instance;
    return instance;
  }

  // About
  bool isBugTracking() const { return m_isBugTracking; }
  Q_INVOKABLE void requestReview();
  // Appearance
  float notchHeight() const { return m_notchHeight; }
  // Battery Saving
  void batterySaving();
  int minimumBatteryLevel() const { return m_minimumBatteryLevel; }
  bool isPlugged() const { return m_isPlugged; }
  bool isAutoLockRequested() const { return m_isAutoLockRequested; }
  bool isAutoLockDisabled() const { return m_isAutoLockDisabled; }
  float brightness() const { return m_brightness; }
  void updateIsPlugged(bool isPlugged) {
    if (m_isPlugged == isPlugged) return;
    m_isPlugged = isPlugged;
    qCDebug(lc) << "R isPlugged:" << m_isPlugged;
    emit isPluggedChanged();
  }
  void updateBatteryLevel(float batteryLevel) {
    m_batteryLevel = qRound(batteryLevel * 100);
    qCDebug(lc) << "R batteryLevel:" << m_batteryLevel;
    emit batteryLevelChanged();
  }
  void updateBrightness(float brightness) {
    m_brightness = qRound(brightness * 100);
    qCDebug(lc) << "R brightness:" << m_brightness;
    emit brightnessChanged();
  }
  void disableAutoLock(bool disable);
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
  void setBrightnessRequested(float brightness);

 signals:
  // About
  void isBugTrackingChanged();
  // Appearance
  void orientationChanged();
  // BatterySaving
  void batteryLevelChanged();
  void minimumBatteryLevelChanged();
  void isPluggedChanged();
  void isAutoLockRequestedChanged();
  void isAutoLockDisabledChanged();
  void brightnessChanged();

 private:
  DeviceAccess(QObject* parent = nullptr) : QObject(parent) {
    connect(this, &DeviceAccess::batteryLevelChanged,
            &DeviceAccess::batterySaving);
    connect(this, &DeviceAccess::isPluggedChanged,
            &DeviceAccess::batterySaving);
    connect(this, &DeviceAccess::isAutoLockRequestedChanged,
            &DeviceAccess::batterySaving);
    updateNotchHeight();
    isAutoLockRequestedChanged();
    qCDebug(lc) << m_settings.fileName();
  }
  ~DeviceAccess() = default;
  DeviceAccess(const DeviceAccess&) = delete;
  DeviceAccess& operator=(const DeviceAccess&) = delete;
  void security();
  void updateNotchHeight();

  QSettings m_settings = QSettings();
  float m_batteryLevel = .0;
  float m_brightness = .0;
  float m_notchHeight = .0;
  float m_brightnessRequested = .0;
  int m_minimumBatteryLevel =
      m_settings.value("BatterySaving/minimumBatteryLevel", 50).toInt();
  bool m_isPlugged = false;
  bool m_isAutoLockRequested =
      m_settings.value("BatterySaving/isAutoLockRequested", true).toBool();
  bool m_isAutoLockDisabled = false;
  bool m_isBugTracking = m_settings.value("About/isBugTracking", true).toBool();
};
}  // namespace kokleeko::device
