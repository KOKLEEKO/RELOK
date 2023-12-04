/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ShareContentManager.h"

#include <QAndroidJniObject>
#include <QDir>
#include <QImage>
#include <QStandardPaths>
#include <QtAndroid>

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::ShareContentManager{deviceAccess, parent}
{
    m_enabled = true;
}

void ShareContentManager::screenshot(QQuickItem *item)
{
    screenshotWithCallback(item, [](QImage screenshot) {
        QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QDir dir = QDir(filePath);
        if (!dir.exists("images"))
            dir.mkdir("images");
        const QString mimeType = QStringLiteral("image/jpeg");
        filePath += QStringLiteral("/images/wordclock++.jpeg");
        screenshot.save(filePath);
        QFileInfo fileInfo(filePath);
        if (fileInfo.exists()) {
            QAndroidJniObject::callStaticMethod<void>(
                "io/kokleeko/wordclock/DeviceAccess",
                "share",
                "(Ljava/lang/String;Ljava/lang/String;)V",
                QAndroidJniObject::fromString(mimeType).object<jstring>(),
                QAndroidJniObject::fromString(filePath).object<jstring>());
        }
    });
}
