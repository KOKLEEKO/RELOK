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
var wordClock = null

class Object
{
    constructor(_instance, _wordClock, _isDebug)
    {
        instance = _instance
        isDebug = _isDebug
        wordClock = _wordClock

        if (instance.isMinutes)
        {
            instance.positions.unshift(QT_TRANSLATE_NOOP("PositionSelector","Around"))
        }
        instance.model = instance.positions
        const positionIndex = DeviceAccess.managers.persistence.value("Accessories/%1".arg(instance.name),
                                                                      instance.isMinutes ? 4 : -1)
        if (positionIndex !== -1)
        {
            this.activate(positionIndex)
        }
    }

    activate(positionIndex)
    {
        if (instance.activatedPositionIndex !== positionIndex)
        {
            this.hide(false)
            wordClock.accessories[positionIndex] = instance.name
            if (instance.isMinutes && positionIndex === 0)
            {
                wordClock.accessories[2] = instance.name
                wordClock.accessories[3] = instance.name
                wordClock.accessories[5] = instance.name
            }
            this.notify(positionIndex)
        }
    }

    hide(shouldNotify = true)
    {
        if (instance.activatedPositionIndex !== -1 &&
            wordClock.accessories[instance.activatedPositionIndex] === instance.name)
        {
            wordClock.accessories[instance.activatedPositionIndex] = ""
            if (instance.isMinutes && instance.activatedPositionIndex === 0)
            {
                wordClock.accessories[2] = ""
                wordClock.accessories[3] = ""
                wordClock.accessories[5] = ""
            }
            if (shouldNotify)
            {
                this.notify(-1)
            }
        }
    }

    notify(positionIndex)
    {
        wordClock.accessoriesChanged()
        instance.activatedPositionIndex = positionIndex
        DeviceAccess.managers.persistence.setValue("Accessories/%1".arg(instance.name), positionIndex)
    }
}
