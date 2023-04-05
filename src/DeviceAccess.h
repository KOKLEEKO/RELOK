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
#include <QTimerEvent>
#include <QtTextToSpeech>

#ifdef Q_OS_ANDROID
#include <QtAndroidExtras>
#endif

#include <memory>

Q_DECLARE_LOGGING_CATEGORY(lc)

namespace kokleeko::device {

class DeviceAccess : public QObject {
    Q_OBJECT

    // About
    Q_PROPERTY(bool isBugTracking
               READ isBugTracking
               WRITE setIsBugTracking
               NOTIFY isBugTrackingChanged)
    // Appearance
    Q_PROPERTY(float safeInsetBottom
               MEMBER m_safeInsetBottom
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetLeft
               MEMBER m_safeInsetLeft
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetRight
               MEMBER m_safeInsetRight
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(float safeInsetTop
               MEMBER m_safeInsetTop
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(float statusBarHeight
               MEMBER m_statusBarHeight
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(float navigationBarHeight
               MEMBER m_navigationBarHeight
               NOTIFY safeInsetsChanged)
    Q_PROPERTY(bool prefersStatusBarHidden
               READ prefersStatusBarHidden
               NOTIFY prefersStatusBarHiddenChanged)
    // BatterySaving
    Q_PROPERTY(float brightness
               READ brightness
               NOTIFY brightnessChanged)
    Q_PROPERTY(float brightnessRequested
               WRITE setBrightnessRequested
               MEMBER m_brightnessRequested)
    Q_PROPERTY(int minimumBatteryLevel
               READ minimumBatteryLevel
               WRITE setMinimumBatteryLevel
               NOTIFY minimumBatteryLevelChanged)
    Q_PROPERTY(int batteryLevel
               READ batteryLevel
               NOTIFY batteryLevelChanged)
    Q_PROPERTY(bool isAutoLockRequested
               READ isAutoLockRequested
               WRITE requestAutoLock
               NOTIFY isAutoLockRequestedChanged)
    Q_PROPERTY(bool isAutoLockDisabled
               READ isAutoLockDisabled
               NOTIFY isAutoLockDisabledChanged)
#ifdef Q_OS_ANDROID
    Q_PROPERTY(QVariantMap speechAvailableLocales
               MEMBER m_speechAvailableLocales
               NOTIFY speechAvailableLocalesChanged)
#else
    Q_PROPERTY(QVariantMap speechAvailableLocales
               MEMBER m_speechAvailableLocales
               CONSTANT)
    Q_PROPERTY(QVariantMap speechAvailableVoices
               MEMBER m_speechAvailableVoices
               NOTIFY speechAvailableVoicesChanged)
#endif

public:
    static DeviceAccess& instance() {
        static DeviceAccess instance;
        return instance;
    }

    Q_INVOKABLE void hideSplashScreen();

#ifdef Q_OS_ANDROID
    Q_INVOKABLE void moveTaskToBack();
    Q_INVOKABLE void requestBrightnessUpdate();
#endif

    Q_INVOKABLE void toggleFullScreen();

    // About
    bool isBugTracking() const { return m_isBugTracking; }
    Q_INVOKABLE void requestReview();
    // Appearance
    Q_INVOKABLE void updateSafeAreaInsets();
    bool prefersStatusBarHidden() const { return m_prefersStatusBarHidden; }
    // Battery Saving
    void batterySaving() {
        qCDebug(lc) << __func__ << m_isAutoLockRequested << m_isPlugged
                    << m_batteryLevel << m_minimumBatteryLevel;
        bool disable = !m_isAutoLockRequested &&
                (m_isPlugged || m_batteryLevel > m_minimumBatteryLevel);
        disableAutoLock(disable);
    }
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
    int batteryLevel() const { return m_batteryLevel; }
    void updateBrightness(float brightness) {
        m_brightness = qRound(brightness * 100);
        qCDebug(lc) << "R brightness:" << m_brightness;
        emit brightnessChanged();
    }
    void disableAutoLock(bool disable);
    Q_INVOKABLE void security(bool value);
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
    // Speech
    Q_INVOKABLE void say(QString text)
    {
#ifdef Q_OS_ANDROID
        requestAudioFocus();
#endif
        m_speech.stop();
        m_speech.say(text.toLower());
    }
    Q_INVOKABLE void setSpeechVoice(int index) {
        m_speech.setVoice(m_speech.availableVoices().at(index));
    }
    Q_INVOKABLE void setSpeechLanguage(QString iso)
    {
        m_speech.setLocale({iso});
#ifdef Q_OS_ANDROID
        if (m_speechAvailableLocales.empty())
            initlocales();
#else
        if (!m_speechAvailableVoices.contains(iso)) {
            const QVector<QVoice> availableVoices = m_speech.availableVoices();
            QStringList voicesNames;
            for (const auto& voice : availableVoices)
                voicesNames << voice.name().split(" ")[0];
            m_speechAvailableVoices.insert(iso, voicesNames);
            int defaultIndex = voicesNames.indexOf(m_speech.voice().name().split(" ")[0]);
            if (iso == "fr_FR" && m_speechAvailableVoices[iso].toStringList().size() > 9)
                defaultIndex = 9;
            setSettingsValue(QString("Appearance/%1_voice").arg(iso), defaultIndex == -1 ? 0 : defaultIndex);
            emit speechAvailableVoicesChanged();
        }
#endif
    }

#ifdef Q_OS_ANDROID
    Q_INVOKABLE void initlocales(){
        const auto locales = m_speech.availableLocales();
        for (const auto &locale : locales) {
            if (m_supportedLanguages.contains(locale.name().left(2))) {
                QString iso = locale.name();
                const QString name = QString("%1 (%2)")
                        .arg(QLocale::languageToString(locale.language()),
                             QLocale::countryToString(locale.country()));
                m_speechAvailableLocales.insert(iso, name);
            }
        }
        emit speechAvailableLocalesChanged();
    }
    void requestAudioFocus();
#endif
    void endOfSpeech();

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
    void safeInsetsChanged();
    void viewConfigurationChanged();
    void prefersStatusBarHiddenChanged();
    // BatterySaving
    void batteryLevelChanged();
    void minimumBatteryLevelChanged();
    void isPluggedChanged();
    void isAutoLockRequestedChanged();
    void isAutoLockDisabledChanged();
    void brightnessChanged();
    void settingsReady();
#ifdef Q_OS_ANDROID
    void speechAvailableLocalesChanged();
#else
    void speechAvailableVoicesChanged();
#endif

private:
    DeviceAccess(QObject* parent = nullptr) : QObject(parent) {
        connect(this, &DeviceAccess::batteryLevelChanged, this, &DeviceAccess::batterySaving);
        connect(this, &DeviceAccess::isPluggedChanged, this, &DeviceAccess::batterySaving);
        connect(this, &DeviceAccess::isAutoLockRequestedChanged, this, &DeviceAccess::batterySaving);
        connect(&m_speech, &QTextToSpeech::stateChanged, this, [=](QTextToSpeech::State state){
            if (state == QTextToSpeech::Ready) {
                endOfSpeech();
            }
        });

        specificInitializationSteps();
        qCDebug(lc) << m_settings.fileName();

#ifndef Q_OS_ANDROID
        const QVector<QLocale> locales = m_speech.availableLocales();
        for (const QLocale &locale : locales)
        {
            if (m_supportedLanguages.contains(locale.bcp47Name().left(2))) {
                QString iso;
                const QList uiLanguages{locale.uiLanguages()};
                const QString name = QString("%1 (%2)")
                        .arg(QLocale::languageToString(locale.language()),
                             QLocale::countryToString(locale.country()));
                for(const auto &uiLanguage : uiLanguages)
                {
                    if (uiLanguage.split("-").count() == 2)
                        iso = QString(uiLanguage).replace("-","_");
                }
                m_speechAvailableLocales.insert(iso, QT_TR_NOOP(name));
            }
        };
#endif
#ifdef Q_OS_WASM
        startTimer(10);
#elif defined(Q_OS_ANDROID)
        registerListeners();
#endif
    }
#ifdef Q_OS_ANDROID
    void registerListeners();
#endif
    ~DeviceAccess() = default;
    DeviceAccess(const DeviceAccess&) = delete;
    DeviceAccess& operator=(const DeviceAccess&) = delete;
    void specificInitializationSteps();
    void timerEvent(QTimerEvent* event) {
        if (m_settings.status() != QSettings::AccessError) {
            killTimer(event->timerId());
            qCDebug(lc) << "settings ready";
            emit settingsReady();
        }
    }

    QVariantMap m_speechAvailableLocales;
#ifndef Q_OS_ANDROID
    QVariantMap m_speechAvailableVoices;
#endif
    QTextToSpeech m_speech = QTextToSpeech();
    QSettings m_settings = QSettings();
    QStringList m_supportedLanguages{"en", "es", "fr"};
    float m_brightness = .0;
    float m_safeInsetBottom = .0;
    float m_safeInsetLeft = .0;
    float m_safeInsetRight = .0;
    float m_safeInsetTop = .0;
    float m_statusBarHeight = .0;
    float m_navigationBarHeight = .0;
    float m_brightnessRequested = .0;
    int m_minimumBatteryLevel = m_settings.value("BatterySaving/minimumBatteryLevel", 50).toInt();
    int m_batteryLevel = 0;
    bool m_isPlugged = false;
    bool m_isAutoLockRequested = m_settings.value("BatterySaving/isAutoLockRequested", true).toBool();
    bool m_isAutoLockDisabled = false;
    bool m_isBugTracking = m_settings.value("About/isBugTracking", true).toBool();
    bool m_prefersStatusBarHidden = m_settings.value("Appearance/fullScreen", true).toBool();
};
}  // namespace kokleeko::device
