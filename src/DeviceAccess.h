#pragma once

#include <QLoggingCategory>
#include <QObject>
#include <memory>

Q_DECLARE_LOGGING_CATEGORY(lc)

class DeviceAccess : public QObject {
  Q_OBJECT

  Q_PROPERTY(float batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
  Q_PROPERTY(
      float brigthnessLevel READ brigthnessLevel NOTIFY brigthnessLevelChanged)
  Q_PROPERTY(bool isGuidedAccessSession READ isGuidedAccessSession WRITE
                 requestGuidedAccessSession NOTIFY isGuidedAccessSessionChanged)
  Q_PROPERTY(bool isPlugged READ isPlugged NOTIFY isPluggedChanged)
  Q_PROPERTY(bool isAutoLock READ isAutoLock WRITE requestAutoLock NOTIFY
                 isAutoLockChanged)

 public:
  explicit DeviceAccess(QObject* parent = nullptr);
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
  void updateBrigthnessLevel(float brightnessLevel) {
    m_brigthnessLevel = brightnessLevel;
    qCDebug(lc) << "R brightnessLevel:" << m_brigthnessLevel;
    emit brigthnessLevelChanged();
  }

  float batteryLevel() const { return m_batteryLevel; }
  float brigthnessLevel() const { return m_brigthnessLevel; }
  bool isPlugged() const { return m_isPlugged; }
  bool isGuidedAccessSession() const { return m_isGuidedAccessSession; }
  bool isAutoLock() const { return m_isAutoLock; }

 public slots:
  void requestGuidedAccessSession(bool enable);
  void setBrigthnessDelta(float brigthnessDelta);
  void requestAutoLock(bool isAutoLock);

 signals:
  void batteryLevelChanged();
  void brigthnessLevelChanged();
  void isPluggedChanged();
  void isGuidedAccessSessionChanged();
  void orientationChanged();
  void isAutoLockChanged();

 private:
  void* m_interface;
  float m_batteryLevel;
  float m_brigthnessLevel;
  bool m_isPlugged;
  bool m_isGuidedAccessSession;
  bool m_isAutoLock;
};
