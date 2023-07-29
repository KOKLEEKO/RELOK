#import "ShareContentManager.h"

#import <AppKit/NSImage.h>
#import <AppKit/NSSharingService.h>
#import <AppKit/NSView.h>

ShareContentManager::ShareContentManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::ShareContentManager{deviceAccess, parent}
{}

void ShareContentManager::screenshot(QQuickItem *item)
{
    Default::ShareContentManager::screenshot(item);
    NSImage *image = [[[NSImage alloc] initByReferencingFile:m_screenshotPath.toNSString()] autorelease];
    NSSharingServicePicker *picker = [[[NSSharingServicePicker alloc] initWithItems:@[image]] autorelease];
    NSView *view = [[[NSApplication sharedApplication] mainWindow] contentView];
    if (view)
        [picker showRelativeToRect:NSZeroRect ofView:view preferredEdge:NSMinXEdge];
}
