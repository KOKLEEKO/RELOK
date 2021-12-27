/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
Language {
    function il_est(enable) {
        tmp_onoff_table[0][0] = enable
        tmp_onoff_table[0][1] = enable
        tmp_onoff_table[0][3] = enable
        tmp_onoff_table[0][4] = enable
        tmp_onoff_table[0][5] = enable
    }
    function heure(enable) {
        tmp_onoff_table[5][5] = enable
        tmp_onoff_table[5][6] = enable
        tmp_onoff_table[5][7] = enable
        tmp_onoff_table[5][8] = enable
        tmp_onoff_table[5][9] = enable
    }
    function heures(enable) {
        heure(enable)
        tmp_onoff_table[5][10] = enable
    }
    function et(enable) {
        tmp_onoff_table[6][1] = enable
        tmp_onoff_table[6][2] = enable
    }
    function moins(enable) {
        tmp_onoff_table[6][3] = enable
        tmp_onoff_table[6][4] = enable
        tmp_onoff_table[6][5] = enable
        tmp_onoff_table[6][6] = enable
        tmp_onoff_table[6][7] = enable
    }
    function cinq_minutes(enable) {
        tmp_onoff_table[8][6] = enable
        tmp_onoff_table[8][7] = enable
        tmp_onoff_table[8][8] = enable
        tmp_onoff_table[8][9] = enable
    }
    function dix_minutes(enable) {
        tmp_onoff_table[9][8] = enable
        tmp_onoff_table[9][9] = enable
        tmp_onoff_table[9][10] = enable
    }
    function quinze_minutes(enable) {
        tmp_onoff_table[9][3] = enable
        tmp_onoff_table[9][4] = enable
        tmp_onoff_table[9][5] = enable
        tmp_onoff_table[9][6] = enable
        tmp_onoff_table[9][7] = enable
    }
    function vingt_minutes(enable) {
        tmp_onoff_table[8][0] = enable
        tmp_onoff_table[8][1] = enable
        tmp_onoff_table[8][2] = enable
        tmp_onoff_table[8][3] = enable
        tmp_onoff_table[8][4] = enable
    }
    function vingtcinq_minutes(enable) {
        vingt_minutes(enable)
        cinq_minutes(enable)
    }

    function hours_00(enable, isAM) { //"IL EST (MINUIT|MIDI)"
        il_est(enable)
        if (isAM) {
            tmp_onoff_table[4][5] = enable
            tmp_onoff_table[4][6] = enable
            tmp_onoff_table[4][7] = enable
            tmp_onoff_table[4][8] = enable
            tmp_onoff_table[4][9] = enable
            tmp_onoff_table[4][10] = enable
        } else {
            tmp_onoff_table[4][0] = enable
            tmp_onoff_table[4][1] = enable
            tmp_onoff_table[4][2] = enable
            tmp_onoff_table[4][3] = enable
        }
    }
    function hours_01(enable, isAM) { //"IL EST UNE HEURE"
        il_est(enable)
        tmp_onoff_table[1][0] = enable
        tmp_onoff_table[1][1] = enable
        tmp_onoff_table[1][2] = enable
        heure(enable)
    }
    function hours_02(enable, isAM) { //"IL EST DEUX HEURES"
        il_est(enable)
        tmp_onoff_table[0][7] = enable
        tmp_onoff_table[0][8] = enable
        tmp_onoff_table[0][9] = enable
        tmp_onoff_table[0][10] = enable
        heures(enable)
    }
    function hours_03(enable, isAM) { //"IL EST TROIS HEURES"
        il_est(enable)
        tmp_onoff_table[1][3] = enable
        tmp_onoff_table[1][4] = enable
        tmp_onoff_table[1][5] = enable
        tmp_onoff_table[1][6] = enable
        tmp_onoff_table[1][7] = enable
        heures(enable)
    }
    function hours_04(enable, isAM) { //"IL EST QUATRE HEURES"
        il_est(enable)
        tmp_onoff_table[2][0] = enable
        tmp_onoff_table[2][1] = enable
        tmp_onoff_table[2][2] = enable
        tmp_onoff_table[2][3] = enable
        tmp_onoff_table[2][4] = enable
        tmp_onoff_table[2][5] = enable
        heures(enable)
    }
    function hours_05(enable, isAM) { //"IL EST CINQ HEURES"
        il_est(enable)
        tmp_onoff_table[2][6] = enable
        tmp_onoff_table[2][7] = enable
        tmp_onoff_table[2][8] = enable
        tmp_onoff_table[2][9] = enable
        heures(enable)
    }
    function hours_06(enable, isAM) { //"IL EST SIX HEURES"
        il_est(enable)
        tmp_onoff_table[3][0] = enable
        tmp_onoff_table[3][1] = enable
        tmp_onoff_table[3][2] = enable
        heures(enable)
    }
    function hours_07(enable, isAM) { //"IL EST SEPT HEURES"
        il_est(enable)
        tmp_onoff_table[1][7] = enable
        tmp_onoff_table[1][8] = enable
        tmp_onoff_table[1][9] = enable
        tmp_onoff_table[1][10] = enable
        heures(enable)
    }
    function hours_08(enable, isAM) { //"IL EST HUIT HEURES"
        il_est(enable)
        tmp_onoff_table[3][3] = enable
        tmp_onoff_table[3][4] = enable
        tmp_onoff_table[3][5] = enable
        tmp_onoff_table[3][6] = enable
        heures(enable)
    }
    function hours_09(enable, isAM) { //"IL EST NEUF HEURES"
        il_est(enable)
        tmp_onoff_table[3][7] = enable
        tmp_onoff_table[3][8] = enable
        tmp_onoff_table[3][9] = enable
        tmp_onoff_table[3][10] = enable
        heures(enable)
    }
    function hours_10(enable, isAM) { //"IL EST DIX HEURES"
        il_est(enable)
        tmp_onoff_table[4][2] = enable
        tmp_onoff_table[4][3] = enable
        tmp_onoff_table[4][4] = enable
        heures(enable)
    }
    function hours_11(enable, isAM) { //"IL EST ONZE HEURES"
        il_est(enable)
        tmp_onoff_table[5][0] = enable
        tmp_onoff_table[5][1] = enable
        tmp_onoff_table[5][2] = enable
        tmp_onoff_table[5][3] = enable
        heures(enable)
    }

    function minutes_00(enable) { }
    function minutes_05(enable) { //"CINQ"
        cinq_minutes(enable)
    }
    function minutes_10(enable) { //"DIX"
        dix_minutes(enable)
    }
    function minutes_15(enable) { //"ET QUART"
        et(enable)
        quinze_minutes(enable)
    }
    function minutes_20(enable) { //"VINGT"
        vingt_minutes(enable)
    }
    function minutes_25(enable) { //"VINGT-CINQ"
        vingtcinq_minutes(enable)
    }
    function minutes_30(enable) { //"ET DEMIE"
        et(enable)
        tmp_onoff_table[7][6] = enable
        tmp_onoff_table[7][7] = enable
        tmp_onoff_table[7][8] = enable
        tmp_onoff_table[7][9] = enable
        tmp_onoff_table[7][10] = enable
    }
    function minutes_35(enable) { //"MOINS VINGT-CINQ"
        moins(enable)
        vingtcinq_minutes(enable)
    }
    function minutes_40(enable) { //"MOINS VINGT"
        moins(enable)
        vingt_minutes(enable)
    }
    function minutes_45(enable) { //"MOINS LE QUART"
        moins(enable)
        tmp_onoff_table[9][0] = enable
        tmp_onoff_table[9][1] = enable
        quinze_minutes(enable)
    }
    function minutes_50(enable) { //"MOINS DIX"
        moins(enable)
        dix_minutes(enable)
    }
    function minutes_55(enable) { //"MOINS 5"
        moins(enable)
        cinq_minutes(enable)
    }

    function special_message(enable) {
        il_est(enable)
        tmp_onoff_table[5][4] = enable
        heure(enable)
        tmp_onoff_table[6][0] = enable
        tmp_onoff_table[6][1] = enable
        tmp_onoff_table[6][7] = enable
        tmp_onoff_table[6][8] = enable
        tmp_onoff_table[7][0] = enable
        tmp_onoff_table[7][1] = enable
        tmp_onoff_table[7][2] = enable
        tmp_onoff_table[7][3] = enable
        tmp_onoff_table[7][4] = enable
        tmp_onoff_table[7][5] = enable
    }

    function written_time(hours_array_index, minutes_array_index, isAM){
        var written_time = "IL EST "
        if (hours_array_index === 0) {
            const split_written_hour = written_hours_array[0].split('|')
            written_time += split_written_hour[isAM ? 0 : 1]
        } else {
            written_time += written_hours_array[hours_array_index]
            written_time += (hours_array_index > 1) ? " HEURES" : " HEURE"
        }
        written_time += ' ' + written_minutes_array[minutes_array_index]
        return written_time
    }

    table:
        // 0    1    2    3    4     5    6    7    8    9   10
        [["I", "L", " ", "E", "S" , "T", " ", "D", "E", "U", "X"]  // 0
        ,["U", "N", "E", "T", "R" , "O", "I", "S", "E", "P", "T"]  // 1
        ,["C", "I", "N", "Q", "U" , "A", "T", "R", "E", "S", " "]  // 2
        ,["S", "I", "X", "H", "U" , "I", "T", "N", "E", "U", "F"]  // 3
        ,["M", "I", "D", "I", "X" , "M", "I", "N", "U", "I", "T"]  // 4
        ,["O", "N", "Z", "E", "L'", "H", "E", "U", "R", "E", "S"]  // 5
        ,["M", "O", "I", "N", "S" , " ", "E", "T", "D", "I", "X"]  // 6
        ,["V", "I", "N", "G", "T" , "R", "O", "I", "S", " ", " "]  // 7
        ,[" ", " ", " ", " ", " " , " ", "D", "E", "M", "I", "E"]  // 8
        ,["C", "I", "N", "Q", "U" , "A", "R", "T", "S", " ", " "]] // 9
    written_hours_array:
        ["MINUIT|MIDI", "UNE", "DEUX", "TROIS", "QUATRE", "CINQ", "SIX", "SEPT", "HUIT", "NEUF",
        "DIX", "ONZE"]
    written_minutes_array:
        ["", "CINQ", "DIX", "ET QUART", "VINGT", "VINGT-CINQ", "ET DEMIE",
        "MOINS VINGT-CINQ", "MOINS VINGT", "ET TROIS QUART", "MOINS DIX", "MOINS CINQ"]
}
