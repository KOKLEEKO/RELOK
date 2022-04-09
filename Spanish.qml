import QtQuick 2.15

Language {
    function es_la(enable) {
        tmp_enable_table[0][0] = enable
        tmp_enable_table[0][1] = enable
        tmp_enable_table[0][5] = enable
        tmp_enable_table[0][6] = enable
    }
    function son_las(enable) {
        tmp_enable_table[0][1]  = enable
        tmp_enable_table[0][2]  = enable
        tmp_enable_table[0][3]  = enable
        tmp_enable_table[0][5]  = enable
        tmp_enable_table[0][6]  = enable
        tmp_enable_table[0][7]  = enable
    }
    function y(enable) {
        tmp_enable_table[6][5]  = enable
    }
    function menos(enable) {
        tmp_enable_table[6][6] = enable
        tmp_enable_table[6][7] = enable
        tmp_enable_table[6][8] = enable
        tmp_enable_table[6][9] = enable
        tmp_enable_table[6][10] = enable
    }

    function hours_00(enable) { //"SON LAS DOCE"
        son_las(enable)
        tmp_enable_table[6][0] = enable
        tmp_enable_table[6][1] = enable
        tmp_enable_table[6][2] = enable
        tmp_enable_table[6][3] = enable
    }
    function hours_01(enable) { //"ES LA UNA"
        tmp_enable_table[0][8] = enable
        tmp_enable_table[0][9] = enable
        tmp_enable_table[0][10] = enable
    }
    function hours_02(enable) { //"SON LAS DOS"
        son_las(enable)
        tmp_enable_table[1][0] = enable
        tmp_enable_table[1][1] = enable
        tmp_enable_table[1][2] = enable
    }
    function hours_03(enable) { //"SON LAS TRES"
        son_las(enable)
        tmp_enable_table[1][4] = enable
        tmp_enable_table[1][5] = enable
        tmp_enable_table[1][6] = enable
        tmp_enable_table[1][7] = enable
    }
    function hours_04(enable) { //"SON LAS CUATRO"
        son_las(enable)
        tmp_enable_table[2][0] = enable
        tmp_enable_table[2][1] = enable
        tmp_enable_table[2][2] = enable
        tmp_enable_table[2][3] = enable
        tmp_enable_table[2][4] = enable
        tmp_enable_table[2][5] = enable
    }
    function hours_05(enable) { //"SON LAS CINCO"
        son_las(enable)
        tmp_enable_table[2][6] = enable
        tmp_enable_table[2][7] = enable
        tmp_enable_table[2][8] = enable
        tmp_enable_table[2][9] = enable
        tmp_enable_table[2][10] = enable
    }
    function hours_06(enable) { //"SON LAS SEIS"
        son_las(enable)
        tmp_enable_table[3][0] = enable
        tmp_enable_table[3][1] = enable
        tmp_enable_table[3][2] = enable
        tmp_enable_table[3][3] = enable
    }
    function hours_07(enable) { //"SON LAS SIETE"
        son_las(enable)
        tmp_enable_table[3][5] = enable
        tmp_enable_table[3][6] = enable
        tmp_enable_table[3][7] = enable
        tmp_enable_table[3][8] = enable
        tmp_enable_table[3][9] = enable
    }
    function hours_08(enable) { //"SON LAS OCHO"
        son_las(enable)
        tmp_enable_table[4][0] = enable
        tmp_enable_table[4][1] = enable
        tmp_enable_table[4][2] = enable
        tmp_enable_table[4][3] = enable
    }
    function hours_09(enable) { //"SON LAS NUEVE"
        son_las(enable)
        tmp_enable_table[4][4] = enable
        tmp_enable_table[4][5] = enable
        tmp_enable_table[4][6] = enable
        tmp_enable_table[4][7] = enable
        tmp_enable_table[4][8] = enable
    }
    function hours_10(enable) { //"SON LAS DIEZ"
        son_las(enable)
        tmp_enable_table[5][2] = enable
        tmp_enable_table[5][3] = enable
        tmp_enable_table[5][4] = enable
        tmp_enable_table[5][5] = enable
    }
    function hours_11(enable) { //"SON LAS ONCE"
        son_las(enable)
        tmp_enable_table[5][7] = enable
        tmp_enable_table[5][8] = enable
        tmp_enable_table[5][9] = enable
        tmp_enable_table[5][10] = enable
    }

    function minutes_00(enable) { }
    function minutes_05(enable) { //"Y CINCO"
        y(enable)
        tmp_enable_table[8][6] = enable
        tmp_enable_table[8][7] = enable
        tmp_enable_table[8][8] = enable
        tmp_enable_table[8][9] = enable
        tmp_enable_table[8][10] = enable
    }
    function minutes_10(enable) { //"Y DIEZ"
        y(enable)
        tmp_enable_table[7][7] = enable
        tmp_enable_table[7][8] = enable
        tmp_enable_table[7][9] = enable
        tmp_enable_table[7][10] = enable
    }
    function minutes_15(enable) { //"Y CUARTO"
        y(enable)
        tmp_enable_table[9][5] = enable
        tmp_enable_table[9][6] = enable
        tmp_enable_table[9][7] = enable
        tmp_enable_table[9][8] = enable
        tmp_enable_table[9][9] = enable
        tmp_enable_table[9][10] = enable
    }
    function minutes_20(enable) { //"Y VIENTE"
        y(enable)
        tmp_enable_table[7][1] = enable
        tmp_enable_table[7][2] = enable
        tmp_enable_table[7][3] = enable
        tmp_enable_table[7][4] = enable
        tmp_enable_table[7][5] = enable
        tmp_enable_table[7][6] = enable
    }
    function minutes_25(enable) { //"Y VIENTICINCO"
        y(enable)
        tmp_enable_table[8][0] = enable
        tmp_enable_table[8][1] = enable
        tmp_enable_table[8][2] = enable
        tmp_enable_table[8][3] = enable
        tmp_enable_table[8][4] = enable
        tmp_enable_table[8][5] = enable
        tmp_enable_table[8][6] = enable
        tmp_enable_table[8][7] = enable
        tmp_enable_table[8][8] = enable
        tmp_enable_table[8][9] = enable
        tmp_enable_table[8][10] = enable
    }
    function minutes_30(value) { //"Y MEDIA"
        y(value)
        tmp_enable_table[9][0] = value
        tmp_enable_table[9][1] = value
        tmp_enable_table[9][2] = value
        tmp_enable_table[9][3] = value
        tmp_enable_table[9][4] = value
    }
    function minutes_35(enable) { //"MENOS VIENTICINCO"
        menos(enable)
        tmp_enable_table[8][0] = enable
        tmp_enable_table[8][1] = enable
        tmp_enable_table[8][2] = enable
        tmp_enable_table[8][3] = enable
        tmp_enable_table[8][4] = enable
        tmp_enable_table[8][5] = enable
        tmp_enable_table[8][6] = enable
        tmp_enable_table[8][7] = enable
        tmp_enable_table[8][8] = enable
        tmp_enable_table[8][9] = enable
        tmp_enable_table[8][10] = enable
    }
    function minutes_40(enable) { //"MENOS VIENTE"
        menos(enable)
        tmp_enable_table[7][1] = enable
        tmp_enable_table[7][2] = enable
        tmp_enable_table[7][3] = enable
        tmp_enable_table[7][4] = enable
        tmp_enable_table[7][5] = enable
        tmp_enable_table[7][6] = enable
    }
    function minutes_45(enable) { //"MENOS CUARTO"
        menos(enable)
        tmp_enable_table[9][5] = enable
        tmp_enable_table[9][6] = enable
        tmp_enable_table[9][7] = enable
        tmp_enable_table[9][8] = enable
        tmp_enable_table[9][9] = enable
        tmp_enable_table[9][10] = enable
    }
    function minutes_50(enable) { //"MENOS DIEZ"
        menos(enable)
        tmp_enable_table[7][7] = enable
        tmp_enable_table[7][8] = enable
        tmp_enable_table[7][9] = enable
        tmp_enable_table[7][10] = enable
    }
    function minutes_55(enable) { //"MENOS CINCO"
        menos(enable)
        tmp_enable_table[8][6] = enable
        tmp_enable_table[8][7] = enable
        tmp_enable_table[8][8] = enable
        tmp_enable_table[8][9] = enable
        tmp_enable_table[8][10] = enable
    }

    table:
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
    written_hours_array:
        ["SON LAS DOCE", "ES LA UNA", "SON LAS DOS", "SON LAS TRES", "SON LAS CUATRO", "SON LAS CINCO",
        "SON LAS SEIS", "SON LAS SIETE", "SON LAS OCHO", "SON LAS NUEVE", "SON LAS DIEZ",
        "SON LAS ONCE"]
    written_minutes_array:
        ["", "Y CINCO", "Y DIEZ", "Y CUARTO", "Y VIENTE", "Y VIENTICINCO", "Y MEDIA",
        "MENOS VIENTICINCO", "MENOS VIENTE", "MENOS CUARTO", "MENOS DIEZ", "MENOS CINCO"]
}
