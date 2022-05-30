/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the MIT license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import <Foundation/NSNotification.h>
#import <StoreKit/StoreKit.h>
#import <AppKit/AppKit.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/graphics/IOGraphicsLib.h>

#import <algorithm>

#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device")

using namespace kokleeko::device;

void DeviceAccess::enableGuidedAccessSession(bool enable) {
    Q_UNUSED(enable)
}

void DeviceAccess::setBrigthnessDelta(float brightnessDelta) {
    float brightness = m_brightness + brightnessDelta;
    brightness = std::clamp<float>(brightness, 0, 1);
    setBrightness(brightness);
}
void DeviceAccess::setBrightness(float brightness) {
    io_iterator_t iterator;
     kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                         IOServiceMatching("IODisplayConnect"),
                                                         &iterator);
     if (result == kIOReturnSuccess) {
         io_object_t service;
         float currentBrightness;
         if ((service = IOIteratorNext(iterator))) {
             IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), brightness);
             IODisplayGetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), &currentBrightness);
             updateBrightness(currentBrightness);
             IOObjectRelease(service);
         }
     }
}

void DeviceAccess::disableAutoLock(bool disable) {
    Q_UNUSED(disable)
}

void DeviceAccess::toggleStatusBarVisibility() {

}

void DeviceAccess::batterySaving() {
    io_iterator_t iterator;
     kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                         IOServiceMatching("IODisplayConnect"),
                                                         &iterator);
     if (result == kIOReturnSuccess) {
         io_object_t service;
         float currentBrightness;
         if ((service = IOIteratorNext(iterator))) {
             IODisplayGetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), &currentBrightness);
             updateBrightness(currentBrightness);
             IOObjectRelease(service);
         }
     }
}

void DeviceAccess::security() {

}

void DeviceAccess::requestReview() {
    [SKStoreReviewController requestReview];
}
