/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "ReviewManager.h"

#import <AppKit/NSWorkspace.h>
#import <StoreKit/SKStoreReviewController.h>

ReviewManager::ReviewManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : ReviewManagerBase{deviceAccess, parent}
{
    m_enabled = true;
}

void ReviewManager::requestReview()
{
    if (@available(macOS 10.14, *))
        [SKStoreReviewController requestReview];
    else if (@available(macOS 10.0, *))
        [[NSWorkspace sharedWorkspace]
            openURL:[[[NSURL alloc] initWithString:@"https://apps.apple.com/app/"
                                                   @"id1626068981?action=write-review"]
                        autorelease]];
}
