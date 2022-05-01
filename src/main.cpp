/**************************************************************************************************
**   Copyright (c) Kokleeko S.L. and contributors. All rights reserved.
**   Licensed under the MIT license. See LICENSE file in the project root for
**   details.
**   Author: https://github.com/johanremilien
**************************************************************************************************/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <memory>

#include "DeviceAccess.h"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  using namespace kokleeko::device;
  engine.rootContext()->setContextProperty("DeviceAccess",
                                           &DeviceAccess::instance());
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
