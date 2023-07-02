/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "TranslationManager.h"

#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>

TranslationManager::TranslationManager(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                       QObject *parent)
    : TranslationManagerBase{persistenceManager, parent}
{
    m_isEnabled = true;
    getAvailableTransalations();
}

void TranslationManager::getAvailableTransalations()
{
    QFileInfoList applicationLanguages = QDir(":/i18n").entryInfoList({"*.qm"});
    m_availableTranslations.insert("en", "English");
    for (const auto &fileInfo : applicationLanguages) {
        const QString baseName(fileInfo.baseName().split("_")[1]);
        m_availableTranslations.insert(baseName, QLocale::languageToString(QLocale(baseName).language()));
    }
}

void TranslationManager::switchLanguage(QString language)
{
    if (language != m_translator.language()) {
        qGuiApp->removeTranslator(&m_translator);
        //qGuiApp->removeTranslator(&m_translatorQt);
        if (language != QLatin1String("en") && m_availableTranslations.contains(language)) {
            if (m_translator.load(QLocale(language),
                                  QLatin1String("wordclock"),
                                  QLatin1String("_"),
                                  QLatin1String(":/i18n")))
                qGuiApp->installTranslator(&m_translator);
            //http://code.qt.io/cgit/qt/qttranslations.git/tree/translations
            //if (m_translatorQt.load(QLocale(language),
            //                        QLatin1String("qtbase"),
            //                        QLatin1String("_"),
            //                        QLibraryInfo::location(QLibraryInfo::TranslationsPath)))
            //    qGuiApp->installTranslator(&m_translatorQt);
        }
        emit retranslate();
    }
}
