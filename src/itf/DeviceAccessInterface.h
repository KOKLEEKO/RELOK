#pragma once

class QString;
class QVariant;
class QTimerEvent;

class DeviceAccessInterface
{
public:
    virtual DeviceAccessInterface &instance() = 0;
    virtual void hideSplashScreen() = 0;
    virtual void requestReview() = 0;
    virtual void switchLanguage(QString language) = 0;
    virtual void updateSafeAreaInsets() = 0;
    virtual QString emptyString() const = 0;
    virtual bool prefersStatusBarHidden() const = 0;
    virtual void batterySaving() = 0;
    virtual int minimumBatteryLevel() const = 0;
    virtual bool isPlugged() const = 0;
    virtual bool isAutoLockRequested() const = 0;
    virtual bool isAutoLockDisabled() const = 0;
    virtual float brightness() const = 0;
    virtual void updateIsPlugged(bool isPlugged) = 0;
    virtual void updateBatteryLevel(float batteryLevel) = 0;
    virtual int batteryLevel() const = 0;
    virtual void updateBrightness(float brightness) = 0;
    virtual void disableAutoLock(bool disable) = 0;
    virtual void security(bool value) = 0;
    // Settings
    virtual void setSettingsValue(QString key, QVariant &value) = 0;
    virtual QVariant settingsValue(QString key, QVariant defaultValue) = 0;
    // Speech
    virtual void say(QString text) = 0;
    virtual void setSpeechVoice(int index) = 0;
    virtual void setSpeechLanguage(QString iso) = 0;
    virtual void initlocales() = 0;
    virtual void endOfSpeech() = 0;
    virtual void setIsBugTracking(bool isBugTracking) = 0;
    // BatterySaving
    virtual void requestAutoLock(bool isAutoLockRequested) = 0;
    virtual void setMinimumBatteryLevel(int minimumBatteryLevel) = 0;
    virtual void setBrightnessRequested(float brightness) = 0;

private:
    virtual void specificInitializationSteps() = 0;
    virtual void timerEvent(QTimerEvent *event) = 0;
};
