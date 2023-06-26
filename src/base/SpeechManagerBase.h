/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"
#include <PersistenceCapability.h>

#include <memory>

#include <QString>
#include <QStringList>
#include <QTextToSpeech>
#include <QVariantMap>

#include "ClockLanguageManagerBase.h"
#include "PersistenceManagerBase.h"

class SpeechManagerBase : public ManagerBase<SpeechManagerBase>, public PersistenceCapability
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap speechAvailableLocales MEMBER m_speechAvailableLocales NOTIFY speechAvailableLocalesChanged)
    Q_PROPERTY(QVariantMap speechAvailableVoices MEMBER m_speechAvailableVoices NOTIFY speechAvailableVoicesChanged)

public:
    SpeechManagerBase(const std::shared_ptr<ClockLanguageManagerBase> &clockLanguageManager,
                      const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                      QObject *parent = nullptr);

    Q_INVOKABLE virtual void say(QString text);
    Q_INVOKABLE virtual void setSpeechLanguage(QString iso);
    Q_INVOKABLE virtual void setSpeechVoice(int index);
    virtual void endOfSpeech() const;
    virtual void initSpeechLocales();

signals:
    void speechAvailableLocalesChanged();
    void speechAvailableVoicesChanged();

private:
    QVariantMap m_speechAvailableLocales{};
    QVariantMap m_speechAvailableVoices{};
    QStringList m_speechFilter{};
    QTextToSpeech m_speech{};
    std::shared_ptr<ClockLanguageManagerBase> m_clockLanguageManager;
};
