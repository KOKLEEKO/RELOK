/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ShareContentManager.h"

#include <QApplication>
#include <QPixmap>
#include <QQuickItemGrabResult>
#include <QScreen>
#include <QStandardPaths>

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
using namespace Default;
#endif

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ShareContentManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ShareContentManager::screenshot(QQuickItem *item)
{
    auto image = item->grabToImage();
    connect(image.get(), &QQuickItemGrabResult::ready, this, [image] {
        QString filePath = QStandardPaths::writableLocation(QStandardPaths::DesktopLocation)
                           + QLatin1String("/WordClock++.png");
        bool result = const_cast<const QQuickItemGrabResult *>(image.get())->saveToFile(filePath);
        qCDebug(lc) << "[screenshot]" << (result ? filePath : QLatin1String("failed"));
    });
}
