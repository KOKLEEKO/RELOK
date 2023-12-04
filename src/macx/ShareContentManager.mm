/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "ShareContentManager.h"

#import <QImage>

#import <AppKit/NSImage.h>
#import <AppKit/NSSharingService.h>
#import <AppKit/NSView.h>

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::ShareContentManager{deviceAccess, parent}
{}

void ShareContentManager::screenshot(QQuickItem *item)
{
    screenshotWithCallback(item, [](QImage screenshot) {
        CGImageRef screenshotCGI = screenshot.toCGImage();
        NSImage *image = [[[NSImage alloc] initWithCGImage:screenshotCGI
                                                      size:screenshot.size().toCGSize()]
            autorelease];
        CGImageRelease(screenshotCGI);
        NSSharingServicePicker *picker = [[[NSSharingServicePicker alloc] initWithItems:@[image]]
            autorelease];
        NSView *view = [[[NSApplication sharedApplication] mainWindow] contentView];
        if (view)
            [picker showRelativeToRect:NSZeroRect ofView:view preferredEdge:NSMinXEdge];
    });
}
