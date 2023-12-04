/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device-ios")

#import <BatteryManagerBase.h>
#import <ScreenBrightnessManagerBase.h>
#import <ScreenSizeManagerBase.h>

#pragma region native {
#import <Foundation/NSBundle.h>
#import <Foundation/NSNotification.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIScreen.h>
#import <UIKit/UIViewControllerTransitionCoordinator.h>

@interface QIOSViewController
@end

@interface QIOSViewController (ViewController)
@end

@implementation QIOSViewController (ViewController)

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    auto screenSizeManager = DeviceAccess::instance()->manager<ScreenSizeManagerBase>();
    if (screenSizeManager && screenSizeManager->enabled())
        emit screenSizeManager->viewConfigurationChanged();
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    auto screenSizeManager = DeviceAccess::instance()->manager<ScreenSizeManagerBase>();
    if (screenSizeManager && screenSizeManager->enabled())
        return screenSizeManager->prefersStatusBarHidden();
    else
        return NO;
}

- (void)viewDidLoad
{
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    [device setBatteryMonitoringEnabled:YES];
    [self updateBatteryLevel:(float) [device batteryLevel]];
    [self updateIsPlugged:(UIDeviceBatteryState)[device batteryState]];
    [self updateBrightness:(float) [screen brightness]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBatteryStateDidChangeNotification:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:device];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBatteryLevelDidChangeNotification:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification
                                               object:device];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBrightnessDidChangeNotification:)
                                                 name:UIScreenBrightnessDidChangeNotification
                                               object:screen];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveBrightnessDidChangeNotification:)
                                                 name:UIScreenBrightnessDidChangeNotification
                                               object:screen];
}

- (void)viewSafeAreaInsetsDidChange
{
    auto screenSizeManager = DeviceAccess::instance()->manager<ScreenSizeManagerBase>();
    if (screenSizeManager && screenSizeManager->enabled())
        screenSizeManager->updateSafeAreaInsets();
}

- (void)updateBatteryLevel:(float)batteryLevel
{
    auto batteryManager = DeviceAccess::instance()->manager<BatteryManagerBase>();
    if (batteryManager->enabled())
        batteryManager->updateBatteryLevel(batteryLevel);
}
- (void)updateIsPlugged:(UIDeviceBatteryState)batteryState
{
    auto batteryManager = DeviceAccess::instance()->manager<BatteryManagerBase>();
    if (batteryManager->enabled()) {
        batteryManager->updateIsPlugged(batteryState == UIDeviceBatteryStateCharging
                                        || batteryState == UIDeviceBatteryStateFull);
    }
}
- (void)updateBrightness:(float)brightness
{
    auto screenBrightnessManager = DeviceAccess::instance()->manager<ScreenBrightnessManagerBase>();
    if (screenBrightnessManager && screenBrightnessManager->enabled())
        screenBrightnessManager->updateBrightness(brightness);
}
- (void)receiveBatteryStateDidChangeNotification:(NSNotification *)notification
{
    auto batteryState = [[notification object] batteryState];
    [self updateIsPlugged:(UIDeviceBatteryState) batteryState];
}

- (void)receiveBatteryLevelDidChangeNotification:(NSNotification *)notification
{
    auto batteryLevel = [[notification object] batteryLevel];
    [self updateBatteryLevel:(float) batteryLevel];
}

- (void)receiveBrightnessDidChangeNotification:(NSNotification *)notification
{
    auto brightness = [[notification object] brightness];
    qCDebug(lc) << "[R] brightness:" << brightness;
    [self updateBrightness:(float) brightness];
}
@end
#pragma endregion }

void DeviceAccess::specificInitializationSteps()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    qCDebug(lc) << "[R] versionName:" << [infoDict objectForKey:@"CFBundleVersion"];
}
