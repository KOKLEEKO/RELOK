#include "TranslationManagerBase.h"

#include <QDir>
#include <QFileInfo>
#include <QGuiApplication>

template<>
QString ManagerBase<TranslationManagerBase>::m_name{"translation"};

TranslationManagerBase::TranslationManagerBase(const std::shared_ptr<PersistenceManagerBase> &persistenceManager,
                                               QObject *parent)
    : ManagerBase<TranslationManagerBase>(parent)
    , PersistenceCapability(persistenceManager)
{}

void TranslationManagerBase::getAvailableTransalations()
{
    QFileInfoList applicationLanguages = QDir(":/i18n").entryInfoList({"*.qm"});
    m_availableTranslations.insert("en", "English");
    for (const auto &fileInfo : applicationLanguages) {
        const QString baseName(fileInfo.baseName().split("_")[1]);
        m_availableTranslations.insert(baseName, QLocale::languageToString(QLocale(baseName).language()));
    }
};

void TranslationManagerBase::switchLanguage(QString language)
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
};
