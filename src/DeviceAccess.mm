#import <Foundation/NSNotification.h>
#import <UIKit/UIKit.h>

#import <algorithm>

#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device")

using namespace kokleeko::device;

@interface QIOSViewController
@end

@interface QIOSViewController (ViewController)
@end

@implementation QIOSViewController (ViewController)
- (UIStatusBarStyle)preferredStatusBarStyle {
  return DeviceAccess::instance().isStatusBarHidden() ? UIStatusBarStyleLightContent
                                                      : UIStatusBarStyleDefault;
}
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  emit DeviceAccess::instance().orientationChanged();
}

- (void)viewDidLoad {
  UIDevice *device = [UIDevice currentDevice];
  [device setBatteryMonitoringEnabled:YES];
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
}

- (void)receiveBatteryStateDidChangeNotification:(NSNotification *)notification {
  auto batteryState = [[notification object] batteryState];
  bool isPlugged =
      (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull);
  DeviceAccess::instance().updateIsPlugged(isPlugged);
}

- (void)receiveBatteryLevelDidChangeNotification:(NSNotification *)notification {
  auto batteryLevel = [[notification object] batteryLevel];
  DeviceAccess::instance().updateBatteryLevel(batteryLevel * 100);
}
@end

void DeviceAccess::enableGuidedAccessSession(bool enable) {
  UIAccessibilityRequestGuidedAccessSession(enable, ^(BOOL didSucceed) {
    qCDebug(lc) << "Request guided access " << (didSucceed ? "succeed" : "failed");
    if (didSucceed) {
      m_isGuidedAccessSession = enable;
      isGuidedAccessSessionChanged();
    }
  });
}

void DeviceAccess::setBrigthnessDelta(float brigthnessDelta) {
  float brightnessLevel = [[UIScreen mainScreen] brightness] + brigthnessDelta;
  brightnessLevel = std::clamp<float>(brightnessLevel, 0, 1);
  qCDebug(lc) << "W brightnessLevel:" << brightnessLevel;
  [UIScreen mainScreen].brightness = brightnessLevel;
}

void DeviceAccess::disableAutoLock(bool disable) {
  qCDebug(lc) << "W autoLock" << !disable;
  [UIApplication sharedApplication].idleTimerDisabled = disable;
}

void DeviceAccess::toggleStatusBarVisibility() {
  m_isStatusBarHidden ^= true;
  qCDebug(lc) << "W statusBarVisibility" << m_isStatusBarHidden;
  [[[[UIApplication sharedApplication] keyWindow] rootViewController]
      setNeedsStatusBarAppearanceUpdate];
}
