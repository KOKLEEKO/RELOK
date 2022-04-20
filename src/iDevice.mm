#import "iDevice.h"
#import <UIKit/UIAccessibility.h>
#import <UIKit/UIDevice.h>

void iDevice::request() {
    UIAccessibilityRequestGuidedAccessSession(true, ^(BOOL didSucceed) {
            qDebug() << "Request guided access:" << didSucceed;
    });
    
    UIDevice* device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];

    auto state = device.batteryState;
    if (state == UIDeviceBatteryStateCharging
 || state == UIDeviceBatteryStateFull) {
        qDebug() << "battery is charging";
    } else {
        qDebug() << "not plugged";
    }
  }

// use UIDeviceBatteryStateDidChangeNotification to be notified
