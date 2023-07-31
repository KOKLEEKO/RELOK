/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "ShareContentManager.h"

#include <QImage>

#import <UIKit/UIActivityViewController.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIPopoverPresentationController.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIWindow.h>

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::ShareContentManager{deviceAccess, parent}
{}

void ShareContentManager::screenshot(QQuickItem *item)
{
    Default::ShareContentManager::screenshotWithCallback(item, [](QImage screenshot) {
        CGImageRef screenshotCGI = screenshot.toCGImage();
        UIImage *image = [[[UIImage alloc] initWithCGImage:screenshotCGI
                                                     scale:1.0
                                               orientation:UIImageOrientationUp] autorelease];
        CGImageRelease(screenshotCGI);
        UIViewController *qtUIViewController = [[[UIApplication sharedApplication] keyWindow]
            rootViewController];
        UIActivityViewController *activityController = [[UIActivityViewController alloc]
            initWithActivityItems:@[image]
            applicationActivities:nil];
        if ([activityController respondsToSelector:@selector(popoverPresentationController)])
            activityController.popoverPresentationController.sourceView = qtUIViewController.view;
        [qtUIViewController presentViewController:activityController animated:YES completion:nil];
    });
}
