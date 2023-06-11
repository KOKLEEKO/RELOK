/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebView>

#include <memory>

#include "DeviceAccess.h"

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QtWebView::initialize();
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Kokleeko S.L.");
    app.setOrganizationDomain("kokleeko.io");
    app.setApplicationName(TARGET);
    app.setApplicationVersion(VERSION);
    QQmlApplicationEngine engine;

#ifdef QT_DEBUG
    engine.rootContext()->setContextProperty("isDebug", true);
#else
    engine.rootContext()->setContextProperty("isDebug", false);
#endif

    using namespace kokleeko::device;

    const QMetaEnum &systemFontMetaEnum = QMetaEnum::fromType<QFontDatabase::SystemFont>();
    const int systemFontKeyCount = systemFontMetaEnum.keyCount();
    for (int index = 0; index < systemFontKeyCount; ++index) {
        const QFontDatabase::SystemFont value = static_cast<QFontDatabase::SystemFont>(systemFontMetaEnum.value(index));
        const QFont font = QFontDatabase::systemFont(value);
        const QString systemFontName = systemFontMetaEnum.key(index);
        engine.rootContext()->setContextProperty(systemFontName, font);
        qDebug() << systemFontName << font;
    }

    engine.rootContext()->setContextProperty("DeviceAccess", &DeviceAccess::instance());
    /* Qt% limitation
     * QQmlApplicationEngine::retranslate()
     * This function refreshes all the engine's bindings, not only those that use strings marked for translation.
     */
    //QObject::connect(&DeviceAccess::instance(), &DeviceAccess::retranslate, &engine, &QQmlApplicationEngine::retranslate);
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl) QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
#ifdef Q_OS_WASM
    QObject::connect(&DeviceAccess::instance(), &DeviceAccess::settingsReady, &app, [url, &engine]() {
#endif
        engine.load(url);
#ifdef Q_OS_WASM
    });
#endif
    return app.exec();
}
