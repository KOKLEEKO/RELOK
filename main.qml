import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: root
    width: 640
    height: 480
    visible: true
    color: "black"

    function reset_table(table) {
        var rowsCount = table.length
        for (var i = 0; i < rowsCount; ++i) {
            var columnsCount = table[i].length
            for (var j = 0; j < columnsCount; ++j) {
                table[i][j] = false
            }
        }
    }

    function son_las() {
        tmp_enable_table[0][1]  = true
        tmp_enable_table[0][2]  = true
        tmp_enable_table[0][3]  = true
        tmp_enable_table[0][5]  = true
        tmp_enable_table[0][6]  = true
        tmp_enable_table[0][7]  = true
    }
    function y() {
        tmp_enable_table[6][5]  = true
    }
    function menos() {
        tmp_enable_table[6][6] = true
        tmp_enable_table[6][7] = true
        tmp_enable_table[6][8] = true
        tmp_enable_table[6][9] = true
        tmp_enable_table[6][10] = true
    }
    function updateMatrix() {
        /*
          Instead of resetting all tables
          I should compare the previous 'written_time_table' with the new one
          to reset only what needs to be reset.
        */
        reset_table(tmp_enable_table)
        var written_time_table = written_time.split(':')
        switch(written_time_table[0]) {
        case "ES LA UNA":
            tmp_enable_table[0][0] = true
            tmp_enable_table[0][1] = true
            tmp_enable_table[0][5] = true
            tmp_enable_table[0][6] = true
            tmp_enable_table[0][5] = true
            tmp_enable_table[0][8] = true
            tmp_enable_table[0][9] = true
            tmp_enable_table[0][10] = true
            break;
        case "SON LAS DOS":
            son_las()
            tmp_enable_table[1][0] = true
            tmp_enable_table[1][1] = true
            tmp_enable_table[1][2] = true
            break;
        case "SON LAS TRES":
            son_las()
            tmp_enable_table[1][4] = true
            tmp_enable_table[1][5] = true
            tmp_enable_table[1][6] = true
            tmp_enable_table[1][7] = true
            break;
        case "SON LAS CUATRO":
            son_las()
            tmp_enable_table[2][0] = true
            tmp_enable_table[2][1] = true
            tmp_enable_table[2][2] = true
            tmp_enable_table[2][3] = true
            tmp_enable_table[2][4] = true
            tmp_enable_table[2][5] = true
            break;
        case "SON LAS CINCO":
            son_las()
            tmp_enable_table[2][6] = true
            tmp_enable_table[2][7] = true
            tmp_enable_table[2][8] = true
            tmp_enable_table[2][9] = true
            tmp_enable_table[2][10] = true
            break;
        case "SON LAS SEIS":
            son_las()
            tmp_enable_table[3][0] = true
            tmp_enable_table[3][1] = true
            tmp_enable_table[3][2] = true
            tmp_enable_table[3][3] = true
            break;
        case "SON LAS SIETE":
            son_las()
            tmp_enable_table[3][5] = true
            tmp_enable_table[3][6] = true
            tmp_enable_table[3][7] = true
            tmp_enable_table[3][8] = true
            tmp_enable_table[3][9] = true
            break;
        case "SON LAS OCHO":
            son_las()
            tmp_enable_table[4][0] = true
            tmp_enable_table[4][1] = true
            tmp_enable_table[4][2] = true
            tmp_enable_table[4][3] = true
            break;
        case "SON LAS NUEVE":
            son_las()
            tmp_enable_table[4][4] = true
            tmp_enable_table[4][5] = true
            tmp_enable_table[4][6] = true
            tmp_enable_table[4][7] = true
            tmp_enable_table[4][8] = true
            break;
        case "SON LAS DIEZ":
            son_las()
            tmp_enable_table[5][2] = true
            tmp_enable_table[5][3] = true
            tmp_enable_table[5][4] = true
            tmp_enable_table[5][5] = true
            break;
        case "SON LAS ONCE":
            son_las()
            tmp_enable_table[5][7] = true
            tmp_enable_table[5][8] = true
            tmp_enable_table[5][9] = true
            tmp_enable_table[5][10] = true
            break;
        case "SON LAS DOCE":
            son_las()
            tmp_enable_table[6][0] = true
            tmp_enable_table[6][1] = true
            tmp_enable_table[6][2] = true
            tmp_enable_table[6][3] = true
            break;
        }
        switch(written_time_table[1]) {
        case "Y CINCO":
            y()
            tmp_enable_table[8][6] = true
            tmp_enable_table[8][7] = true
            tmp_enable_table[8][8] = true
            tmp_enable_table[8][9] = true
            tmp_enable_table[8][10] = true
            break;
        case "Y DIEZ":
            y()
            tmp_enable_table[7][7] = true
            tmp_enable_table[7][8] = true
            tmp_enable_table[7][9] = true
            tmp_enable_table[7][10] = true
            break;
        case "Y CUARTO":
            y()
            tmp_enable_table[9][5] = true
            tmp_enable_table[9][6] = true
            tmp_enable_table[9][7] = true
            tmp_enable_table[9][8] = true
            tmp_enable_table[9][9] = true
            tmp_enable_table[9][10] = true
            break;
        case "Y VIENTE":
            y()
            tmp_enable_table[7][1] = true
            tmp_enable_table[7][2] = true
            tmp_enable_table[7][3] = true
            tmp_enable_table[7][4] = true
            tmp_enable_table[7][5] = true
            tmp_enable_table[7][6] = true
            break;
        case "Y VIENTICINCO":
            y()
            tmp_enable_table[8][0] = true
            tmp_enable_table[8][1] = true
            tmp_enable_table[8][2] = true
            tmp_enable_table[8][3] = true
            tmp_enable_table[8][4] = true
            tmp_enable_table[8][5] = true
            tmp_enable_table[8][6] = true
            tmp_enable_table[8][7] = true
            tmp_enable_table[8][8] = true
            tmp_enable_table[8][9] = true
            tmp_enable_table[8][10] = true
            break;
        case "Y MEDIA":
            y()
            tmp_enable_table[9][0] = true
            tmp_enable_table[9][1] = true
            tmp_enable_table[9][2] = true
            tmp_enable_table[9][3] = true
            tmp_enable_table[9][4] = true
            break;
        case "MENOS VIENTICINCO":
            menos()
            tmp_enable_table[8][0] = true
            tmp_enable_table[8][1] = true
            tmp_enable_table[8][2] = true
            tmp_enable_table[8][3] = true
            tmp_enable_table[8][4] = true
            tmp_enable_table[8][5] = true
            tmp_enable_table[8][6] = true
            tmp_enable_table[8][7] = true
            tmp_enable_table[8][8] = true
            tmp_enable_table[8][9] = true
            tmp_enable_table[8][10] = true
            break;
        case "MENOS VIENTE":
            menos()
            tmp_enable_table[7][1] = true
            tmp_enable_table[7][2] = true
            tmp_enable_table[7][3] = true
            tmp_enable_table[7][4] = true
            tmp_enable_table[7][5] = true
            tmp_enable_table[7][6] = true
            break;
        case "MENOS CUARTO":
            menos()
            tmp_enable_table[9][5] = true
            tmp_enable_table[9][6] = true
            tmp_enable_table[9][7] = true
            tmp_enable_table[9][8] = true
            tmp_enable_table[9][9] = true
            tmp_enable_table[9][10] = true
            break;
        case "MENOS DIEZ":
            menos()
            tmp_enable_table[7][7] = true
            tmp_enable_table[7][8] = true
            tmp_enable_table[7][9] = true
            tmp_enable_table[7][10] = true
            break;
        case "MENOS CINCO":
            menos()
            tmp_enable_table[8][6] = true
            tmp_enable_table[8][7] = true
            tmp_enable_table[8][8] = true
            tmp_enable_table[8][9] = true
            tmp_enable_table[8][10] = true
            break;
        }
        enable_table = tmp_enable_table
    }

    property string time: "0:0"
    property int dots: 0
    property color on_color: "red"
    property color off_color: "grey"
    property string written_time: ""
    readonly property var minutes_table: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
    readonly property int minutes_table_size: minutes_table.length
    readonly property var spanish_table:
        // 0    1    2    3    4    5    6    7    8    9   10
        [['E', 'S', 'O', 'N', ' ', 'L', 'A', 'S', 'U', 'N', 'A']  // 0
        ,['D', 'O', 'S', ' ', 'T', 'R', 'E', 'S', ' ', ' ', ' ']  // 1
        ,['C', 'U', 'A', 'T', 'R', 'O', 'C', 'I', 'N', 'C', 'O']  // 2
        ,['S', 'E', 'I', 'S', ' ', 'S', 'I', 'E', 'T', 'E', ' ']  // 3
        ,['O', 'C', 'H', 'O', 'N', 'U', 'E', 'V', 'E', ' ', ' ']  // 4
        ,[' ', ' ', 'D', 'I', 'E', 'Z', ' ', 'O', 'N', 'C', 'E']  // 5
        ,['D', 'O', 'C', 'E', ' ', 'Y', 'M', 'E', 'N', 'O', 'S']  // 6
        ,[' ', 'V', 'E', 'I', 'N', 'T', 'E', 'D', 'I', 'E', 'Z']  // 7
        ,['V', 'E', 'I', 'N', 'T', 'I', 'C', 'I', 'N', 'C', 'O']  // 8
        ,['M', 'E', 'D', 'I', 'A', 'C', 'U', 'A', 'R', 'T', 'O']] // 9
    readonly property var spanish_hours_table:
        ["DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ", "ONCE", "DOCE"]
    readonly property var spanish_minutes_table:
        ["", "Y CINCO", "Y DIEZ", "Y CUARTO", "Y VIENTE", "Y VIENTICINCO", "Y MEDIA",
        "MENOS VIENTICINCO", "MENOS VIENTE", "MENOS CUARTO", "MENOS DIEZ", "MENOS CINCO"]
    property var enable_table: new Array(10).fill(true).map(() => new Array(11).fill(true));
    property var tmp_enable_table: new Array(10).fill(true).map(() => new Array(11).fill(false));

    onTimeChanged: {
        var tmp_written_time
        var splitted_time = time.split(':')
        var hours_value = splitted_time[0]
        var minutes_value = splitted_time[1]
        if (minutes_value > 30) { hours_value++ }
        if (hours_value > 12) {hours_value = hours_value % 12}
        if (hours_value === 1) {
            tmp_written_time = "ES LA UNA"
        } else {
            tmp_written_time = "SON LAS " + spanish_hours_table[hours_value-2]
        }
        for (var index=0; index < minutes_table_size; ++index) {
            if  (minutes_table[index] <= minutes_value && minutes_value <= minutes_table[index] + 4) {
                tmp_written_time += ":" + spanish_minutes_table[index]
                dots = minutes_value - minutes_table[index]
                break;
            }
        }
        console.log(tmp_written_time)
        written_time = tmp_written_time
    }
    Component.onCompleted: written_timeChanged.connect(updateMatrix)

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            time = new Date().toLocaleTimeString(Qt.locale("en_US"), "h:m:a")
        }
    }
    Column {
        id: table
        readonly property real horizontalMargin: root.width/4
        readonly property real verticalMargin: root.height/4
        anchors {
            fill: parent
            leftMargin: horizontalMargin
            rightMargin: horizontalMargin
            topMargin: verticalMargin
            bottomMargin: verticalMargin
        }
        Repeater {
            model: spanish_table
            Row {
                Repeater {
                    id: repeater
                    property int rowIndex: index
                    model: spanish_table[index]
                    Text {
                        readonly property int rowIndex: repeater.rowIndex
                        readonly property int columnIndex: index
                        readonly property bool isEnabled: enable_table[rowIndex][columnIndex]
                        width: table.width/11
                        height: table.height/10
                        text: modelData
                        color: isEnabled ? on_color : off_color
                        style: isEnabled ? Text.Outline : Text.Normal
                        styleColor: Qt.lighter(color, 1.33)
                    }
                }
            }
        }
        Item{ height: table.height/10; width:1}
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Repeater {
                model: 4
                Rectangle {
                    readonly property bool isEnabled: index+1 <= dots
                    color: isEnabled ? on_color : off_color
                    width: 10
                    height: width
                    radius: width/2
                }
            }
        }
    }
}
