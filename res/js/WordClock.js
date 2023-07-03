.pragma library
.import DeviceAccess 1.0 as Global

var instance = null
var DeviceAccess = Global.DeviceAccess
var isDebug = true

function checkInstance()
{
    if (!instance)
    {
        console.exception("%1 is not defined".arg(Object.keys({instance})[0]))
        Qt.exit(-1)
    }
}

function selectLanguage(language, speech)
{
    var fileBaseName = language
    if (!instance.supportedLanguages.includes(fileBaseName))
        fileBaseName = (instance.supportedLanguages.includes(fileBaseName.substring(0,2))) ? language.substring(0,2)
                                                                                           : "en"

    const tmp_language_url = "qrc:/qml/languages/%1.qml".arg(fileBaseName)

    if (isDebug)
        console.log(language, instance.supportedLanguages, tmp_language_url)

    instance.language_url = tmp_language_url
    instance.selected_language = language

    if (DeviceAccess.managers.speech.enabled && instance.enable_speech)
    {
        DeviceAccess.managers.speech.setSpeechLanguage(language)
        DeviceAccess.managers.speech.say(instance.written_time)
    }
}

function detectAndUseDeviceLanguage() { selectLanguage(Qt.locale().name) }

function updateTable()
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

    if (instance.minutes_value >= 35 && (++instance.hours_value % 12 == 0))
        isAM ^= true
    instance.hours_array_index = instance.hours_value % 12
    instance.minutes_array_index = Math.floor(instance.minutes_value/5)
    const tmp_onoff_dots = instance.minutes_value%5

    instance.written_time = instance.language.written_time(instance.hours_array_index,
                                                           instance.minutes_array_index,
                                                           isAM) + (tmp_onoff_dots ? ", (+%1)".arg(tmp_onoff_dots)
                                                                                   : "")
    if (isDebug)
        console.debug(instance.time, instance.written_time)

    if (instance.enable_speech && (instance.minutes_value % parseInt(instance.speech_frequency) == 0))
        DeviceAccess.managers.speech.say(instance.written_time.toLowerCase())

    if (instance.was_special)
        instance.language.special_message(false)

    if (instance.previous_hours_array_index !== instance.hours_array_index || is_special || instance.was_special)
    {
        if (instance.previous_hours_array_index !== -1)
            instance.language["hours_" + instance.hours_array[instance.previous_hours_array_index]](false, instance.was_AM)

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

function showAccessories() { instance.accessoriesOpacity = 1 }

function offsetToGMT(value)
{
    return String("%1%2:%3").arg(Math.sign(value) < 0 ? "-" : "+")
    /**/                    .arg(("0" + Math.abs(Math.trunc(value/2))).slice(-2))
    /**/                    .arg(value%2 ? "30" : "00")
}
