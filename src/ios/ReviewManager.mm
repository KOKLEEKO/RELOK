/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ReviewManager.h"

#import <StoreKit/SKStoreReviewController.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIWindowScene.h>

ReviewManager::ReviewManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ReviewManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ReviewManager::requestReview()
{
    if (@available(iOS 14.0, *)) {
        auto windowScene = [[[UIApplication sharedApplication] keyWindow] windowScene];
        if (windowScene)
            [SKStoreReviewController requestReviewInScene:windowScene];
    } else if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
}
