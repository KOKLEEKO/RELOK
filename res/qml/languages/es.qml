/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
Language {
    function es_la(enable) {
        tmp_onoff_table[0][0] = enable
        tmp_onoff_table[0][1] = enable
        tmp_onoff_table[0][5] = enable
        tmp_onoff_table[0][6] = enable
    }
    function son_las(enable) {
        tmp_onoff_table[0][1]  = enable
        tmp_onoff_table[0][2]  = enable
        tmp_onoff_table[0][3]  = enable
        tmp_onoff_table[0][5]  = enable
        tmp_onoff_table[0][6]  = enable
        tmp_onoff_table[0][7]  = enable
    }
    function y(enable) {
        tmp_onoff_table[6][5]  = enable
    }
    function cinco_minutos(enable) {
        tmp_onoff_table[8][6] = enable
        tmp_onoff_table[8][7] = enable
        tmp_onoff_table[8][8] = enable
        tmp_onoff_table[8][9] = enable
        tmp_onoff_table[8][10] = enable
    }
    function diez_minutos(enable) {
        tmp_onoff_table[7][7] = enable
        tmp_onoff_table[7][8] = enable
        tmp_onoff_table[7][9] = enable
        tmp_onoff_table[7][10] = enable
    }
    function quince_minutos(enable) {
        tmp_onoff_table[9][5] = enable
        tmp_onoff_table[9][6] = enable
        tmp_onoff_table[9][7] = enable
        tmp_onoff_table[9][8] = enable
        tmp_onoff_table[9][9] = enable
        tmp_onoff_table[9][10] = enable
    }
    function veinte_minutos(enable) {
        tmp_onoff_table[7][1] = enable
        tmp_onoff_table[7][2] = enable
        tmp_onoff_table[7][3] = enable
        tmp_onoff_table[7][4] = enable
        tmp_onoff_table[7][5] = enable
        tmp_onoff_table[7][6] = enable
    }
    function veinticinco_minutos(enable) {
        tmp_onoff_table[8][0] = enable
        tmp_onoff_table[8][1] = enable
        tmp_onoff_table[8][2] = enable
        tmp_onoff_table[8][3] = enable
        tmp_onoff_table[8][4] = enable
        tmp_onoff_table[8][5] = enable
        cinco_minutos(enable)
    }

    function menos(enable) {
        tmp_onoff_table[6][6] = enable
        tmp_onoff_table[6][7] = enable
        tmp_onoff_table[6][8] = enable
        tmp_onoff_table[6][9] = enable
        tmp_onoff_table[6][10] = enable
    }

    function hours_00(enable, isAM) { //"SON LAS DOCE"
        son_las(enable)
        tmp_onoff_table[6][0] = enable
        tmp_onoff_table[6][1] = enable
        tmp_onoff_table[6][2] = enable
        tmp_onoff_table[6][3] = enable
    }
    function hours_01(enable, isAM) { //"ES LA UNA"
        es_la(enable)
        tmp_onoff_table[0][8] = enable
        tmp_onoff_table[0][9] = enable
        tmp_onoff_table[0][10] = enable
    }
    function hours_02(enable, isAM) { //"SON LAS DOS"
        son_las(enable)
        tmp_onoff_table[2][4] = enable
        tmp_onoff_table[2][5] = enable
        tmp_onoff_table[2][6] = enable
    }
    function hours_03(enable, isAM) { //"SON LAS TRES"
        son_las(enable)
        tmp_onoff_table[2][0] = enable
        tmp_onoff_table[2][1] = enable
        tmp_onoff_table[2][2] = enable
        tmp_onoff_table[2][3] = enable
    }
    function hours_04(enable, isAM) { //"SON LAS CUATRO"
        son_las(enable)
        tmp_onoff_table[3][5] = enable
        tmp_onoff_table[3][6] = enable
        tmp_onoff_table[3][7] = enable
        tmp_onoff_table[3][8] = enable
        tmp_onoff_table[3][9] = enable
        tmp_onoff_table[3][10] = enable
    }
    function hours_05(enable, isAM) { //"SON LAS CINCO"
        son_las(enable)
        tmp_onoff_table[5][0] = enable
        tmp_onoff_table[5][1] = enable
        tmp_onoff_table[5][2] = enable
        tmp_onoff_table[5][3] = enable
        tmp_onoff_table[5][4] = enable
    }
    function hours_06(enable, isAM) { //"SON LAS SEIS"
        son_las(enable)
        tmp_onoff_table[4][7] = enable
        tmp_onoff_table[4][8] = enable
        tmp_onoff_table[4][9] = enable
        tmp_onoff_table[4][10] = enable
    }
    function hours_07(enable, isAM) { //"SON LAS SIETE"
        son_las(enable)
        tmp_onoff_table[2][6] = enable
        tmp_onoff_table[2][7] = enable
        tmp_onoff_table[2][8] = enable
        tmp_onoff_table[2][9] = enable
        tmp_onoff_table[2][10] = enable
    }
    function hours_08(enable, isAM) { //"SON LAS OCHO"
        son_las(enable)
        tmp_onoff_table[5][4] = enable
        tmp_onoff_table[5][5] = enable
        tmp_onoff_table[5][6] = enable
        tmp_onoff_table[5][7] = enable
    }
    function hours_09(enable, isAM) { //"SON LAS NUEVE"
        son_las(enable)
        tmp_onoff_table[3][0] = enable
        tmp_onoff_table[3][1] = enable
        tmp_onoff_table[3][2] = enable
        tmp_onoff_table[3][3] = enable
        tmp_onoff_table[3][4] = enable
    }
    function hours_10(enable, isAM) { //"SON LAS DIEZ"
        son_las(enable)
        tmp_onoff_table[1][7] = enable
        tmp_onoff_table[1][8] = enable
        tmp_onoff_table[1][9] = enable
        tmp_onoff_table[1][10] = enable
    }
    function hours_11(enable, isAM) { //"SON LAS ONCE"
        son_las(enable)
        tmp_onoff_table[5][7] = enable
        tmp_onoff_table[5][8] = enable
        tmp_onoff_table[5][9] = enable
        tmp_onoff_table[5][10] = enable
    }

    function minutes_00(enable) { }
    function minutes_05(enable) { //"Y CINCO"
        y(enable)
        cinco_minutos(enable)
    }
    function minutes_10(enable) { //"Y DIEZ"
        y(enable)
        diez_minutos(enable)
    }
    function minutes_15(enable) { //"Y CUARTO"
        y(enable)
        quince_minutos(enable)
    }
    function minutes_20(enable) { //"Y VEINTE"
        y(enable)
        veinte_minutos(enable)
    }
    function minutes_25(enable) { //"Y VEINTICINCO"
        y(enable)
        veinticinco_minutos(enable)
    }
    function minutes_30(enable) { //"Y MEDIA"
        y(enable)
        tmp_onoff_table[9][0] = enable
        tmp_onoff_table[9][1] = enable
        tmp_onoff_table[9][2] = enable
        tmp_onoff_table[9][3] = enable
        tmp_onoff_table[9][4] = enable
    }
    function minutes_35(enable) { //"MENOS VEINTICINCO"
        menos(enable)
        veinticinco_minutos(enable)
    }
    function minutes_40(enable) { //"MENOS VEINTE"
        menos(enable)
        veinte_minutos(enable)
    }
    function minutes_45(enable) { //"MENOS CUARTO"
        menos(enable)
        quince_minutos(enable)
    }
    function minutes_50(enable) { //"MENOS DIEZ"
        menos(enable)
        diez_minutos(enable)
    }
    function minutes_55(enable) { //"MENOS CINCO"
        menos(enable)
        cinco_minutos(enable)
    }

    function special_message(enable) {
        tmp_onoff_table[0][0] = enable
        tmp_onoff_table[0][1] = enable
        tmp_onoff_table[0][4] = enable
        tmp_onoff_table[0][5] = enable
        tmp_onoff_table[1][0] = enable
        tmp_onoff_table[1][1] = enable
        tmp_onoff_table[1][2] = enable
        tmp_onoff_table[1][3] = enable
        tmp_onoff_table[1][4] = enable
        tmp_onoff_table[1][5] = enable
        tmp_onoff_table[1][6] = enable
        tmp_onoff_table[2][4] = enable
        tmp_onoff_table[3][4] = enable
        tmp_onoff_table[4][0] = enable
        tmp_onoff_table[4][1] = enable
        tmp_onoff_table[4][2] = enable
        tmp_onoff_table[4][3] = enable
        tmp_onoff_table[4][4] = enable
        tmp_onoff_table[4][5] = enable
        tmp_onoff_table[4][6] = enable
        tmp_onoff_table[4][7] = enable
        tmp_onoff_table[4][8] = enable
    }

    function written_time(hours_array_index, minutes_array_index, isAM) {
        var written_time = hours_array_index === 1 ? "ES LA " : "SON LAS "
        written_time += written_hours_array[hours_array_index]
        written_time += ' ' + written_minutes_array[minutes_array_index]
        return written_time
    }

    table:
        // 0    1    2    3    4    5    6    7    8    9   10
        [["E", "S", "O", "N", "E", "L", "A", "S", "U", "N", "A"]  // 0
        ,["M", "O", "M", "E", "N", "T", "O", "D", "I", "E", "Z"]  // 1
        ,["T", "R", "E", "S", "D", "O", "S", "I", "E", "T", "E"]  // 2
        ,["N", "U", "E", "V", "E", "C", "U", "A", "T", "R", "O"]  // 3
        ,["S", "U", "P", "E", "R", "A", "R", "S", "E", "I", "S"]  // 4
        ,["C", "I", "N", "C", "O", "C", "H", "O", "N", "C", "E"]  // 5
        ,["D", "O", "C", "E", "X", "Y", "M", "E", "N", "O", "S"]  // 6
        ,["W", "V", "E", "I", "N", "T", "E", "D", "I", "E", "Z"]  // 7
        ,["V", "E", "I", "N", "T", "I", "C", "I", "N", "C", "O"]  // 8
        ,["M", "E", "D", "I", "A", "C", "U", "A", "R", "T", "O"]] // 9
    written_hours_array:
        ["DOCE", "UNA", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ",
        "ONCE"]
    written_minutes_array:
        ["", "Y CINCO", "Y DIEZ", "Y CUARTO", "Y VEINTE", "Y VEINTICINCO", "Y MEDIA",
        "MENOS VEINTICINCO", "MENOS VEINTE", "MENOS CUARTO", "MENOS DIEZ", "MENOS CINCO"]
}
