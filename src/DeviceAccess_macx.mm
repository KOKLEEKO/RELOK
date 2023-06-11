/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import <AppKit/AppKit.h>
#import <Foundation/NSNotification.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/graphics/IOGraphicsLib.h>
#import <StoreKit/StoreKit.h>

#import "DeviceAccess.h"

Q_LOGGING_CATEGORY(lc, "Device-macx")

using namespace kokleeko::device;

void DeviceAccess::setBrightnessRequested(float brightness) {
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(
                kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator);
    if (result == kIOReturnSuccess) {
        io_object_t service;
        float currentBrightness;
        if ((service = IOIteratorNext(iterator))) {
            IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), brightness);
            IODisplayGetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey),
                                       &currentBrightness);
            updateBrightness(currentBrightness);
            IOObjectRelease(service);
        }
    }
}

void DeviceAccess::disableAutoLock(bool disable) { Q_UNUSED(disable) }

void DeviceAccess::security(bool /*value*/) {}

void DeviceAccess::requestReview() {
    if (@available(macOS 10.14, *)) {
        [SKStoreReviewController requestReview];
    } else {
        // Fallback on earlier versions
    }
}
void DeviceAccess::specificInitializationSteps() {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    qCDebug(lc) << "versionName" << [infoDict objectForKey:@"CFBundleVersion"];
}

void DeviceAccess::endOfSpeech(){}

void DeviceAccess::hideSplashScreen() {}

void DeviceAccess::updateSafeAreaInsets() {}
