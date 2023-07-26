/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#include "DeviceAccess.h"

#import <Foundation/NSBundle.h>

Q_LOGGING_CATEGORY(lc, "Device-macx")

void DeviceAccess::specificInitializationSteps()
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    qCDebug(lc) << "[R] versionName:" << [infoDict objectForKey:@"CFBundleVersion"];
}
