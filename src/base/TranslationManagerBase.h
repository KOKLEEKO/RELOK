/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include "ManagerBase.h"

#include <QString>
#include <QTranslator>
#include <QVariantMap>

class TranslationManagerBase : public ManagerBase<TranslationManagerBase>
{
    Q_OBJECT

    Q_PROPERTY(bool enabled READ enabled CONSTANT)
    Q_PROPERTY(QVariantMap availableTranslations MEMBER m_availableTranslations CONSTANT)
    Q_PROPERTY(QString emptyString MEMBER m_emptyString NOTIFY retranslate)

public:
    explicit TranslationManagerBase(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    virtual void getAvailableTransalations() {}

    Q_INVOKABLE virtual void switchLanguage(QString /*language*/) {}

signals:
    void retranslate();

protected:
    QVariantMap m_availableTranslations;
    //QTranslator m_translatorQt;
    QTranslator m_translator;

private:
    QString m_emptyString{};
};

#ifndef Q_OS_WIN
template<>
QString ManagerBase<TranslationManagerBase>::m_name;
#endif
