/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import <Foundation/NSNotification.h>
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device-ios")

using namespace kokleeko::device;

@interface QIOSViewController
@end

@interface QIOSViewController (ViewController)
@end

@implementation QIOSViewController (ViewController)
- (void)viewWillTransitionToSize:(CGSize)size
  withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    emit DeviceAccess::instance().orientationChanged();
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return DeviceAccess::instance().isStatusBarHidden() ? UIStatusBarStyleLightContent
                                                        : UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    [device setBatteryMonitoringEnabled:YES];
    [self updateBatteryLevel:(float)[device batteryLevel]];
    [self updateIsPlugged:(UIDeviceBatteryState)[device batteryState]];
    [self updateBrightness:(float)[screen brightness]];
    [[NSNotificationCenter defaultCenter]
            addObserver:self
                        selector:@selector(receiveBatteryStateDidChangeNotification:)
      name:UIDeviceBatteryStateDidChangeNotification
      object:device];
    [[NSNotificationCenter defaultCenter]
            addObserver:self
                        selector:@selector(receiveBatteryLevelDidChangeNotification:)
      name:UIDeviceBatteryLevelDidChangeNotification
      object:device];
    [[NSNotificationCenter defaultCenter]
            addObserver:self
                        selector:@selector(receiveBrightnessDidChangeNotification:)
      name:UIScreenBrightnessDidChangeNotification
      object:screen];
}

- (void)updateBatteryLevel:(float)batteryLevel {
                                      DeviceAccess::instance().updateBatteryLevel(batteryLevel);
}
- (void)updateIsPlugged:(UIDeviceBatteryState)batteryState {
    bool isPlugged =
            (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull);
    DeviceAccess::instance().updateIsPlugged(isPlugged);
}
- (void)updateBrightness:(float)brightness {
                                    DeviceAccess::instance().updateBrightness(brightness);
}
- (void)receiveBatteryStateDidChangeNotification:(NSNotification *)notification {
    auto batteryState = [[notification object] batteryState];
    [self updateIsPlugged:(UIDeviceBatteryState)batteryState];
}

- (void)receiveBatteryLevelDidChangeNotification:(NSNotification *)notification {
    auto batteryLevel = [[notification object] batteryLevel];
    [self updateBatteryLevel:(float)batteryLevel];
}

- (void)receiveBrightnessDidChangeNotification:(NSNotification *)notification {
    auto brightness = [[notification object] brightness];
    qCDebug(lc) << "brightness:" << brightness;
    [self updateBrightness:(float)brightness];
}
@end

void DeviceAccess::setBrightnessRequested(float brightness) {
    qCDebug(lc) << "W brightness:" << brightness;
    m_settings.setValue("BatterySaving/battery", [UIScreen mainScreen].brightness = brightness);
    updateBrightness([UIScreen mainScreen].brightness);
}

void DeviceAccess::disableAutoLock(bool disable) {
    qCDebug(lc) << "W disabledAutoLock:" << disable;
    [[UIApplication sharedApplication] setIdleTimerDisabled:disable];
    m_isAutoLockDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    qCDebug(lc) << "R autoLockDisabled:" << m_isAutoLockDisabled;
}

void DeviceAccess::requestReview() {
    if (@available(iOS 14.0, *)) {
        auto windowScene = [[[UIApplication sharedApplication] keyWindow] windowScene];
        if (windowScene)
            [SKStoreReviewController requestReviewInScene:windowScene];
    } else if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    }
}

void DeviceAccess::toggleFullScreen() {
//    m_isStatusBarHidden = value;
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController]
//            setNeedsStatusBarAppearanceUpdate];
}

void DeviceAccess::security(bool /*value*/) {}

void DeviceAccess::specificInitializationSteps() {
    // get notch height
    if (@available(iOS 11.0, *)) {
        m_notchHeight = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.top;
    }
    qCDebug(lc) << "notch height:" << m_notchHeight;

     // enable speech in silent mode
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}
