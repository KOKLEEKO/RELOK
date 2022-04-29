#import <Foundation/NSNotification.h>
#import <UIKit/UIAccessibility.h>
#import <UIKit/UIDevice.h>
#import <UIKit/UIScreen.h>

#import <algorithm>

#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device")

@interface DeviceAccessInterface : NSObject {
  DeviceAccess* m_DeviceAccess;
}
@end

@implementation DeviceAccessInterface
- (id)initWithObject:(DeviceAccess*)DeviceAccess {
  self = [super init];
  if (self) {
    m_DeviceAccess = DeviceAccess;
    UIDevice* device = [UIDevice currentDevice];
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
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(receiveOrientationDidChangeNotification:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
  }
  return self;
}

- (void)receiveBatteryStateDidChangeNotification:(NSNotification*)notification {
  auto batteryState = [[notification object] batteryState];
  bool isPlugged =
      (batteryState == UIDeviceBatteryStateCharging || batteryState == UIDeviceBatteryStateFull);
  m_DeviceAccess->updateIsPlugged(isPlugged);
}

- (void)receiveBatteryLevelDidChangeNotification:(NSNotification*)notification {
  auto batteryLevel = [[notification object] batteryLevel];
  m_DeviceAccess->updateBatteryLevel(batteryLevel * 100);
}

- (void)receiveOrientationDidChangeNotification:(NSNotification*)notification {
  emit m_DeviceAccess->orientationChanged();
}
@end

DeviceAccess::DeviceAccess(QObject* parent)
    : QObject(parent), m_interface([[DeviceAccessInterface alloc] initWithObject:this]) {}

void DeviceAccess::requestGuidedAccessSession(bool enable) {
  UIAccessibilityRequestGuidedAccessSession(enable, ^(BOOL didSucceed) {
    qCDebug(lc) << "Request guided access " << (didSucceed ? "succeed" : "failed");
    if (didSucceed) {
      m_isGuidedAccessSession = enable;
      isGuidedAccessSessionChanged();
    }
  });
}

void DeviceAccess::setBrigthnessDelta(float brigthnessDelta) {
  float brightnessLevel = m_brigthnessLevel + brigthnessDelta;
  brightnessLevel = std::clamp<float>(brightnessLevel, 0, 1);
  qCDebug(lc) << "W brightnessLevel:" << brightnessLevel;
    [UIScreen mainScreen].brightness = brightnessLevel;
}

void DeviceAccess::requestAutoLock(bool isAutoLock) {
    [UIApplication sharedApplication].idleTimerDisabled = !isAutoLock;
}
