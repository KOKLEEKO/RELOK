/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#pragma once

#include <ShareContentManagerBase.h>

#include <QStandardPaths>

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
namespace Default {
#endif

class ShareContentManager : public ShareContentManagerBase
{
    Q_OBJECT

public:
    explicit ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent = nullptr);

    void screenshot(QQuickItem *item) override;

protected:
    void screenshotWithCallback(QQuickItem *item,
                                const std::function<void(QImage)> &callback = {}) final override;
};

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS) || defined(Q_OS_MACOS)
} //Default
#endif
