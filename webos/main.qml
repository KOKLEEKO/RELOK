/*
 * Copyright (c) 2020 LG Electronics Inc.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import QtQuick 2.6

import WebOSServices 1.0
import Eos.Window 0.1
import PmLog 1.0

import "languages"

WebOSWindow {
    id: root
    property var launchParams: params
    width: 1920
    height: 1080
    visible: true
    appId: "io.kokleeko.wordclock"
    title: "WordClock"
    color: wordClock.backgroundColor
    displayAffinity: params["displayAffinity"]

    onLaunchParamsChanged: pmLog.info("LAUNCH_PARAMS", {"params": launchParams})
    onWindowStateChanged: pmLog.info("WINDOW_CHANGED", {"status": windowState})

    PmLog { id: pmLog; context: "QMLApp" }

    WordClock { id: wordClock }
}
