/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
import QtQuick 2.15 as QtQuick
import QtQuick.Controls 2.15 as QtControls
import QtQuick.Layouts 1.15 as QtLayouts

import DeviceAccess 1.0

import "qrc:/qml/controls" as Controls

import "qrc:/js/Helpers.js" as HelpersJS

QtQuick.Loader
{
    active: DeviceAccess.managers.battery.enabled
    QtLayouts.Layout.fillWidth: true
    sourceComponent: Controls.MenuSection
    {
        title: qsTr("Energy Saving") + DeviceAccess.managers.translation.emptyString

        Controls.MenuItem
        {
            title: qsTr("Stay Awake") + DeviceAccess.managers.translation.emptyString
            details: qsTr("If this option is enabled, the device's screen will remain active while the application \
is running.\nDon't forget to enable '%1' if you might lose attention on your device.").arg(HelpersJS.isAndroid ?
                                                                                           qsTr("App pinning") :
                                                                                           qsTr("Guided Access")) +
                     DeviceAccess.managers.translation.emptyString
        }
        QtControls.Switch
        {
            checked: !DeviceAccess.managers.autoLock.isAutoLockRequested
            onToggled: DeviceAccess.managers.autoLock.isAutoLockRequested = !checked
        }
        Controls.MenuItem
        {
            title: qsTr("App pinning") + DeviceAccess.managers.translation.emptyString
            active: HelpersJS.isAndroid

            QtControls.Switch { onToggled: DeviceAccess.managers.autoLock.security(checked) }
        }
        Controls.MenuItem
        {
            title: "%1 (%2%)".arg(qsTr("Minimum Battery Level")).arg(extraControls[0].value.toString()) +
                   DeviceAccess.managers.translation.emptyString
            details: qsTr("'%1' feature will be automatically disabled when the battery level reaches this \
value unless the device charges.").arg(qsTr("Stay Awake")) +
                     (HelpersJS.isMobile ? "\n(%1: %2%)".arg(qsTr("battery level"))
                                           /**/         .arg(DeviceAccess.managers.battery.batteryLevel) : "") +
                     DeviceAccess.managers.translation.emptyString
            extras: QtControls.Slider
            {
                from: 20
                stepSize: 5
                to: 50
                value: DeviceAccess.managers.energySaving.minimumBatteryLevel

                onMoved: DeviceAccess.managers.energySaving.minimumBatteryLevel = value
            }
        }
        Controls.MenuItem
        {
            title: "%1 (%2%)".arg(qsTr("Brightness Level"))
            /**/             .arg(DeviceAccess.managers.screenBrightness.brightness) +
            DeviceAccess.managers.translation.emptyString
            extras: QtControls.Slider
            {
                from: 0
                to: 100
                value: DeviceAccess.managers.screenBrightness.brightness

                onMoved: DeviceAccess.managers.screenBrightness.brightnessRequested = value/100
                QtQuick.Component.onCompleted:
                {
                    if (HelpersJS.isAndroid)
                        DeviceAccess.managers.screenBrightness.requestBrightnessUpdate()
                }
            }
            details: qsTr("High brightness levels cause the battery to discharge faster.") +
                     DeviceAccess.managers.translation.emptyString
        }
    }
}
