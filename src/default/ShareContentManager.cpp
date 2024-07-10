/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ShareContentManager.h"

#include <QApplication>
#include <QBuffer>
#include <QByteArray>
#include <QFileDialog>
#include <QQuickItemGrabResult>

#include <functional>

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
using namespace Default;
#endif

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ShareContentManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ShareContentManager::screenshot(QQuickItem *item)
{
    screenshotWithCallback(item, [](QImage image) {
        QByteArray byteArray;
        QBuffer buffer(&byteArray);
        buffer.open(QIODevice::WriteOnly);
        image.save(&buffer, "JPEG");
        QFileDialog::saveFileContent(byteArray, "RELOK.jpeg");
    });
}

void ShareContentManager::screenshotWithCallback(QQuickItem *item,
                                                 const std::function<void(QImage)> &callback)
{
    auto image = item->grabToImage(qApp->devicePixelRatio() * QSize(item->width(), item->height()));
    connect(image.get(), &QQuickItemGrabResult::ready, this, [=] {
        if (callback)
            callback(image.get()->image());
    });
}
