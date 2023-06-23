#pragma once

#include "ManagerBase.h"
#include "PersistenceCapability.h"

#include <QString>
#include <QTranslator>
#include <QVariantMap>

class TranslationManagerBase : public ManagerBase<TranslationManagerBase>, public PersistenceCapability
{
    Q_OBJECT
    Q_PROPERTY(QString emptyString MEMBER m_emptyString NOTIFY retranslate)

public:
    TranslationManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager, QObject *parent = nullptr);

    void getAvailableTransalations();
    Q_INVOKABLE void switchLanguage(QString language);

signals:
    void retranslate();

private:
    QVariantMap m_availableTranslations;
    //QTranslator m_translatorQt;
    QTranslator m_translator;
    QString m_emptyString{};
};
