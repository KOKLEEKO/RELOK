/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <memory>

#include <QString>
#include <QStringList>
#include <QTextToSpeech>
#include <QVariantMap>

class SpeechManagerBase : public ManagerBase<SpeechManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(QVariantMap speechAvailableLocales MEMBER m_speechAvailableLocales NOTIFY speechAvailableLocalesChanged)
    Q_PROPERTY(QVariantMap speechAvailableVoices MEMBER m_speechAvailableVoices NOTIFY speechAvailableVoicesChanged)
    Q_PROPERTY(bool hasMutipleVoices READ hasMutipleVoices NOTIFY hasMutipleVoicesChanged)

public:
    explicit SpeechManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    bool hasMutipleVoices() const { return m_hasMutipleVoices; }
    void setHasMutipleVoices(bool newHasMutipleVoices);

    Q_INVOKABLE virtual void say(QString /*text*/) {}
    Q_INVOKABLE virtual void setSpeechLanguage(QString /*iso*/) {}
    Q_INVOKABLE virtual void setSpeechVoice(int /*index*/){};

protected:
    virtual void requestAudioFocus() {}
    virtual void initSpeechLocales() {}
    virtual void endOfSpeech() const {}

signals:
    void speechAvailableLocalesChanged();
    void speechAvailableVoicesChanged();

    void hasMutipleVoicesChanged();

protected:
    QVariantMap m_speechAvailableLocales{};
    QVariantMap m_speechAvailableVoices{};
    QStringList m_speechFilter{};
    QTextToSpeech m_speech{};
    bool m_hasMutipleVoices = false;
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<SpeechManagerBase>::m_name;
#endif
