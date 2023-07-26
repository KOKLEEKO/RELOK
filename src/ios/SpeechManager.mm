/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
#import "SpeechManager.h"

#import <AVFoundation/AVAudioSession.h>

SpeechManager::SpeechManager(DeviceAccessBase *deviceAccess, QObject *parent)
    : Default::SpeechManager{deviceAccess, parent}
{
    m_enabled = true;

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                            mode:AVAudioSessionModeVoicePrompt
                                         options:AVAudioSessionCategoryOptionDuckOthers
                                                 | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers
                                           error:nil];
}

void SpeechManager::endOfSpeech() const
{
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}
