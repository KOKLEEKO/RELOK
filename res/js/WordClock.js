/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
.import DeviceAccess 1.0 as Global

var DeviceAccess = Global.DeviceAccess
var instance = null
var isDebug = undefined
var firstTime = true

class Object
{
    constructor(_instance, _isDebug)
    {
        instance = _instance
        isDebug = _isDebug
        instance.accessoriesChanged()
        instance.selected_language = DeviceAccess.managers.persistence.value("Appearance/clockLanguage",
                                                                             Qt.locale().name)
        instance.language_urlChanged.connect(() => {
                                                 if (instance.time)
                                                 {
                                                     instance.previous_hours_array_index = -1
                                                     instance.previous_minutes_array_index = -1
                                                     instance.tmp_onoff_table = createTable(rows, columns, false)
                                                     instance.timeChanged()
                                                 }
                                             })
        instance.timeChanged.connect(this.updateTable)
        instance.selectLanguage.connect(this.selectLanguage)
        instance.onLanguageChanged.connect(this.languageChanged)

        this.selectLanguage(instance.selected_language)
    }

    startupSequence()
    {
        if (instance.startupTimer.color_transition_finished)
        {
            instance.startupTimer.stop()
            instance.is_color_animation_enabled = false
        }
        else
        {
            instance.timer.start()
            instance.applyColors()
            this.showAccessories()
            instance.startupTimer.color_transition_finished = true
        }
    }

    updateTime()
    {
        if (instance.timer.is_debug)
        {
            instance.currentDateTime = new Date(instance.timer.time_reference_ms
                                                + (instance.timer.jump_by_minute
                                                   + instance.timer.jump_by_5_minutes*5
                                                   + instance.timer.jump_by_hour*60 )
                                                * instance.timer.fake_counter
                                                * instance.timer.minute_to_ms)
            ++instance.timer.fake_counter
        }
        else
        {
            const now = new Date()
            instance.deviceOffset = Math.floor(-now.getTimezoneOffset() / 30)
            instance.currentDateTime = new Date(now.getTime() - instance.deltaTime*instance.timer.minute_to_ms)
        }
        instance.seconds_value = instance.currentDateTime.getSeconds()
        instance.time = instance.currentDateTime.toLocaleTimeString(Qt.locale("en_US"), "HH:mm:a")
    }

    selectLanguage(language)
    {
        var fileBaseName = language
        if (!instance.supportedLanguages.includes(fileBaseName))
        fileBaseName = (instance.supportedLanguages.includes(fileBaseName.substring(0,2))) ? language.substring(0,2)
                                                                                           : "en"
        const tmp_language_url = "qrc:/qml/languages/%1.qml".arg(fileBaseName)

        if (isDebug)
        {
            console.debug(language, instance.supportedLanguages, tmp_language_url)
        }

        instance.language_url = tmp_language_url
        instance.selected_language = DeviceAccess.managers.speech.enabled ? language : fileBaseName

        if (DeviceAccess.managers.speech.enabled)
        {
            DeviceAccess.managers.speech.setSpeechLanguage(language)
            const voiceIndex = DeviceAccess.managers.persistence.value("Appearance/%1_voice"
                                                                       .arg(instance.selected_language), 0)
            DeviceAccess.managers.speech.setSpeechVoice(voiceIndex)

            if (instance.written_time && instance.enable_speech)
            {
                DeviceAccess.managers.speech.say(instance.written_time)
            }
        }

        DeviceAccess.managers.persistence.setValue("Appearance/clockLanguage", language)
    }

    languageChanged()
    {
        if (DeviceAccess.managers.splashScreen.isActive)
        {
            DeviceAccess.managers.splashScreen.hideSplashScreen()
        }
    }

    updateTable()
    {
        const startDate = new Date(instance.currentDateTime.getFullYear(), 0, 1)
        instance.currentWeekNumber = Math.ceil(Math.floor((instance.currentDateTime - startDate)
                                                          / instance.timer.day_to_ms) / 7)

        const split_time = instance.time.split(':')
        instance.hours_value = split_time[0]
        instance.minutes_value = split_time[1]
        var isAM = instance.is_AM = (split_time[2] === "am")

        const is_special = instance.enable_special_message &&
        (instance.hours_value[0] === instance.hours_value[1]) &&
        (instance.hours_value === instance.minutes_value)

        if (instance.minutes_value >= 35)
        {
            ++instance.hours_value
            if (instance.hours_value % 12 === 0)
            isAM ^= true
        }

        instance.hours_array_index = instance.hours_value % 12
        instance.minutes_array_index = Math.floor(instance.minutes_value/5)
        const tmp_onoff_dots = instance.minutes_value%5

        instance.written_time = instance.language.written_time(instance.hours_array_index,
                                                               instance.minutes_array_index,
                                                               isAM) + (tmp_onoff_dots ? ", (+%1)".arg(tmp_onoff_dots)
                                                                                       : "")
        if (isDebug)
        {
            console.debug(instance.time, instance.written_time)
        }

        if (instance.enable_speech && (
                (instance.minutes_value % parseInt(instance.speech_frequency, 10) === 0) || firstTime))
        {
            DeviceAccess.managers.speech.say(instance.written_time.toLowerCase())
        }

        firstTime = false

        if (instance.was_special)
        {
            instance.language.special_message(false)
        }

        if (instance.previous_hours_array_index !== instance.hours_array_index || is_special || instance.was_special)
        {
            if (instance.previous_hours_array_index !== -1)
            {
                instance.language["hours_"
                                  + instance.hours_array[instance.previous_hours_array_index]](false, instance.was_AM)
            }
            instance.was_AM = isAM

            if (!is_special)
            {
                instance.language["hours_" + instance.hours_array[instance.hours_array_index]](true, isAM)
                instance.previous_hours_array_index = instance.hours_array_index
            }
        }

        if (instance.previous_minutes_array_index !== instance.minutes_array_index || is_special || instance.was_special)
        {
            if (instance.previous_minutes_array_index !== -1)
            instance.language["minutes_" + instance.minutes_array[instance.previous_minutes_array_index]](false)

            if (!is_special)
            {
                instance.language["minutes_" + instance.minutes_array[instance.minutes_array_index]](true)
                instance.previous_minutes_array_index = instance.minutes_array_index
            }
        }

        if (is_special)
        instance.language.special_message(true)

        instance.was_special = is_special

        //update table and dots at the same time
        instance.onoff_table = instance.tmp_onoff_table
        instance.onoff_dots = tmp_onoff_dots
    }

    showAccessories()
    {
        instance.accessoriesOpacity = 1
    }
}

function createTable(rows, columns, defaultValue)
{
    return new Array(rows).fill().map(() => new Array(columns).fill(defaultValue))
}

function createWelcomeTable()
{
    var welcomeTable = createTable(10, 11, false)

    welcomeTable[0][0]  = true
    welcomeTable[0][1]  = true
    welcomeTable[0][2]  = true
    welcomeTable[0][3]  = true
    welcomeTable[0][4]  = true
    welcomeTable[0][6]  = true
    welcomeTable[0][7]  = true
    welcomeTable[0][8]  = true
    welcomeTable[0][9]  = true
    welcomeTable[0][10] = true

    welcomeTable[1][0]  = true
    welcomeTable[1][1]  = true
    welcomeTable[1][9]  = true
    welcomeTable[1][10] = true

    welcomeTable[2][0]  = true
    welcomeTable[2][1]  = true
    welcomeTable[2][9]  = true
    welcomeTable[2][10] = true

    welcomeTable[2][0]  = true
    welcomeTable[2][1]  = true
    welcomeTable[2][9]  = true
    welcomeTable[2][10] = true

    welcomeTable[3][0]  = true
    welcomeTable[3][1]  = true
    welcomeTable[3][9]  = true
    welcomeTable[3][10] = true

    welcomeTable[4][0]  = true
    welcomeTable[4][1]  = true
    welcomeTable[4][3]  = true
    welcomeTable[4][4]  = true
    welcomeTable[4][5]  = true
    welcomeTable[4][6]  = true
    welcomeTable[4][7]  = true
    welcomeTable[4][9]  = true
    welcomeTable[4][10] = true

    welcomeTable[5][0]  = true
    welcomeTable[5][1]  = true
    welcomeTable[5][3]  = true
    welcomeTable[5][4]  = true
    welcomeTable[5][5]  = true
    welcomeTable[5][6]  = true
    welcomeTable[5][7]  = true
    welcomeTable[5][9]  = true
    welcomeTable[5][10] = true

    welcomeTable[6][0]  = true
    welcomeTable[6][1]  = true
    welcomeTable[6][9]  = true
    welcomeTable[6][10] = true

    welcomeTable[7][0]  = true
    welcomeTable[7][1]  = true
    welcomeTable[7][9]  = true
    welcomeTable[7][10] = true

    welcomeTable[8][0]  = true
    welcomeTable[8][1]  = true
    welcomeTable[8][9]  = true
    welcomeTable[8][10] = true

    welcomeTable[9][0]  = true
    welcomeTable[9][1]  = true
    welcomeTable[9][2]  = true
    welcomeTable[9][3]  = true
    welcomeTable[9][4]  = true
    welcomeTable[9][6]  = true
    welcomeTable[9][7]  = true
    welcomeTable[9][8]  = true
    welcomeTable[9][9]  = true
    welcomeTable[9][10] = true

    return welcomeTable
}

function offsetToGMT(value)
{
    return String("%1%2:%3").arg(Math.sign(value) < 0 ? "-" : "+")
    /**/                    .arg(("0" + Math.abs(Math.trunc(value/2))).slice(-2))
    /**/                    .arg(value%2 ? "30" : "00")
}
