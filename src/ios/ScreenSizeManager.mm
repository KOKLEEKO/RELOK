/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "ScreenSizeManager.h"

#import <UIKit/UIApplication.h>
#import <UIKit/UIStatusBarManager.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIWindowScene.h>

ScreenSizeManager::ScreenSizeManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ScreenSizeManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}
void ScreenSizeManager::toggleFullScreen()
{
    m_prefersStatusBarHidden ^= true;
    m_shouldNotifyViewConfigurationChanged = NO;
    emit prefersStatusBarHiddenChanged();
    [[[[UIApplication sharedApplication] keyWindow] rootViewController]
        setNeedsStatusBarAppearanceUpdate];
}

void ScreenSizeManager::updateSafeAreaInsets()
{
    // get notch height
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        m_safeInsetBottom = safeAreaInsets.bottom;
        m_safeInsetLeft = safeAreaInsets.left;
        m_safeInsetRight = safeAreaInsets.right;
        m_safeInsetTop = safeAreaInsets.top;
        if (@available(iOS 13.0, *))
            m_statusBarHeight = [[[UIApplication sharedApplication] keyWindow] windowScene]
                                    .statusBarManager.statusBarFrame.size.height;
        else
            m_statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        qCDebug(lc) << "statusBarHeight:" << m_statusBarHeight;
        emit safeInsetsChanged();
        if (m_shouldNotifyViewConfigurationChanged)
            emit viewConfigurationChanged();
        m_shouldNotifyViewConfigurationChanged = YES;
    }
}
