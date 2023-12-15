/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
Language
{
    function es_ist(enable)
    {
        tmp_onoff_table[0][0] = enable;
        tmp_onoff_table[0][1] = enable;
        tmp_onoff_table[0][3] = enable;
        tmp_onoff_table[0][4] = enable;
        tmp_onoff_table[0][5] = enable;
    }
    function nach(enable)
    {
        tmp_onoff_table[3][1] = enable;
        tmp_onoff_table[3][2] = enable;
        tmp_onoff_table[3][3] = enable;
        tmp_onoff_table[3][4] = enable;
    }
    function vor(enable)
    {
        tmp_onoff_table[3][8]  = enable;
        tmp_onoff_table[3][9]  = enable;
        tmp_onoff_table[3][10] = enable;
    }
    function funf_minuten(enable)
    {
        tmp_onoff_table[0][7]  = enable;
        tmp_onoff_table[0][8]  = enable;
        tmp_onoff_table[0][9]  = enable;
        tmp_onoff_table[0][10] = enable;
    }
    function zehn_minuten(enable)
    {
        tmp_onoff_table[1][0] = enable;
        tmp_onoff_table[1][1] = enable;
        tmp_onoff_table[1][2] = enable;
        tmp_onoff_table[1][3] = enable;
    }
    function fünfzehn_minuten(enable)
    {
        tmp_onoff_table[1][4]  = enable;
        tmp_onoff_table[1][5]  = enable;
        tmp_onoff_table[1][6]  = enable;
        tmp_onoff_table[1][7]  = enable;
        tmp_onoff_table[1][8]  = enable;
        tmp_onoff_table[1][9]  = enable;
        tmp_onoff_table[1][10] = enable;
    }
    function zwanzig_minuten(enable)
    {
        tmp_onoff_table[2][0] = enable;
        tmp_onoff_table[2][1] = enable;
        tmp_onoff_table[2][2] = enable;
        tmp_onoff_table[2][3] = enable;
        tmp_onoff_table[2][4] = enable;
        tmp_onoff_table[2][5] = enable;
        tmp_onoff_table[2][6] = enable;
    }
    function halb(enable)
    {
        tmp_onoff_table[4][7]  = enable;
        tmp_onoff_table[4][8]  = enable;
        tmp_onoff_table[4][9]  = enable;
        tmp_onoff_table[4][10] = enable;
    }

    function hours_00(enable, isAM)     //"ES IST ZWÖLF"
    {
        es_ist(enable);
        tmp_onoff_table[8][3] = enable;
        tmp_onoff_table[8][4] = enable;
        tmp_onoff_table[8][5] = enable;
        tmp_onoff_table[8][6] = enable;
        tmp_onoff_table[8][7] = enable;
    }
    function hours_01(enable, isAM)     //"ES IST EIN(S)"
    {
        es_ist(enable);
        tmp_onoff_table[5][0] = enable;
        tmp_onoff_table[5][1] = enable;
        tmp_onoff_table[5][2] = enable;
        tmp_onoff_table[5][3] = enable;
    }
    function hours_02(enable, isAM)     //"ES IST ZWEI"
    {
        es_ist(enable);
        tmp_onoff_table[6][4] = enable;
        tmp_onoff_table[6][5] = enable;
        tmp_onoff_table[6][6] = enable;
        tmp_onoff_table[6][7] = enable;
    }
    function hours_03(enable, isAM)     //"ES IST DREI"
    {
        es_ist(enable);
        tmp_onoff_table[6][0] = enable;
        tmp_onoff_table[6][1] = enable;
        tmp_onoff_table[6][2] = enable;
        tmp_onoff_table[6][3] = enable;
    }
    function hours_04(enable, isAM)     //IT IS VIER"
    {
        es_ist(enable);
        tmp_onoff_table[7][0] = enable;
        tmp_onoff_table[7][1] = enable;
        tmp_onoff_table[7][2] = enable;
        tmp_onoff_table[7][3] = enable;
    }
    function hours_05(enable, isAM)     //"ES IST FÜNF"
    {
        es_ist(enable);
        tmp_onoff_table[8][7]  = enable;
        tmp_onoff_table[8][8]  = enable;
        tmp_onoff_table[8][9]  = enable;
        tmp_onoff_table[8][10] = enable;
    }
    function hours_06(enable, isAM)     //"ES IST SECHS"
    {
        es_ist(enable);
        tmp_onoff_table[5][3] = enable;
        tmp_onoff_table[5][4] = enable;
        tmp_onoff_table[5][5] = enable;
        tmp_onoff_table[5][6] = enable;
        tmp_onoff_table[5][7] = enable;
    }
    function hours_07(enable, isAM)     //"ES IST SIEBEN"
    {
        es_ist(enable);
        tmp_onoff_table[7][5]  = enable;
        tmp_onoff_table[7][6]  = enable;
        tmp_onoff_table[7][7]  = enable;
        tmp_onoff_table[7][8]  = enable;
        tmp_onoff_table[7][9]  = enable;
        tmp_onoff_table[7][10] = enable;
    }
    function hours_08(enable, isAM)     //"ES IST ACHT"
    {
        es_ist(enable);
        tmp_onoff_table[9][7]  = enable;
        tmp_onoff_table[9][8]  = enable;
        tmp_onoff_table[9][9]  = enable;
        tmp_onoff_table[9][10] = enable;
    }
    function hours_09(enable, isAM)     //"ES IST NEUN"
    {
        es_ist(enable);
        tmp_onoff_table[9][3] = enable;
        tmp_onoff_table[9][4] = enable;
        tmp_onoff_table[9][5] = enable;
        tmp_onoff_table[9][6] = enable;
    }
    function hours_10(enable, isAM)      //"ES IST ZEHN"
    {
        es_ist(enable);
        tmp_onoff_table[9][0] = enable;
        tmp_onoff_table[9][1] = enable;
        tmp_onoff_table[9][2] = enable;
        tmp_onoff_table[9][3] = enable;
    }
    function hours_11(enable, isAM)     //"ES IST ELF"
    {
        es_ist(enable);
        tmp_onoff_table[6][8]  = enable;
        tmp_onoff_table[6][9]  = enable;
        tmp_onoff_table[6][10] = enable;
    }

    function minutes_00(enable, hours_array_index) { }
    function minutes_05(enable, hours_array_index)     //"FÜNF NACH"
    {
        funf_minuten(enable);
        nach(enable);
    }
    function minutes_10(enable, hours_array_index)     //"ZEHN NACH"
    {
        zehn_minuten(enable);
        nach(enable);
    }
    function minutes_15(enable, hours_array_index)     //"VIERTEL NACH"
    {
        fünfzehn_minuten(enable);
        nach(enable);
    }
    function minutes_20(enable, hours_array_index)     //"ZWANZIG NACH"
    {
        zwanzig_minuten(enable);
        nach(enable);
    }
    function minutes_25(enable, hours_array_index)     //"FÜNF VOR HALB"
    {
        funf_minuten(enable);
        vor(enable)
        halb(enable);
    }
    function minutes_30(enable, hours_array_index)     //"HALB"
    {
        halb(enable);
    }
    function minutes_35(enable, hours_array_index)     //"FÜNF NACH HALB"
    {
        funf_minuten(enable);
        nach(enable)
        halb(enable);
    }
    function minutes_40(enable, hours_array_index)      //"ZWANZIG VOR"
    {
        zwanzig_minuten(enable);
        vor(enable);
    }
    function minutes_45(enable, hours_array_index)      //"VIERTEL VOR"
    {
        fünfzehn_minuten(enable);
        vor(enable);
    }
    function minutes_50(enable, hours_array_index)      //"ZEHN VOR"
    {
        zehn_minuten(enable);
        vor(enable);
    }
    function minutes_55(enable, hours_array_index)     //"FÜNF VOR"
    {
        funf_minuten(enable);
        vor(enable);
    }

    function special_message(enable)
    {
        tmp_onoff_table[2][6]  = enable;
        tmp_onoff_table[2][7]  = enable;
        tmp_onoff_table[2][8]  = enable;
        tmp_onoff_table[2][9]  = enable;
        tmp_onoff_table[2][10] = enable;
        tmp_onoff_table[3][0]  = enable;
        tmp_onoff_table[3][1]  = enable;
        tmp_onoff_table[3][5]  = enable;
        tmp_onoff_table[3][6]  = enable;
        tmp_onoff_table[3][7]  = enable;
        tmp_onoff_table[4][0]  = enable;
        tmp_onoff_table[4][1]  = enable;
        tmp_onoff_table[4][2]  = enable;
        tmp_onoff_table[4][3]  = enable;
        tmp_onoff_table[4][4]  = enable;
        tmp_onoff_table[4][5]  = enable;
        tmp_onoff_table[5][1]  = enable;
        tmp_onoff_table[5][2]  = enable;
        tmp_onoff_table[5][8]  = enable;
        tmp_onoff_table[5][9]  = enable;
        tmp_onoff_table[5][10] = enable;
    }

    function written_time(hours_array_index, minutes_array_index, isAM)
    {
        var written_time = "ES IST ";
        if (minutes_array_index > 0)
        {
            written_time += written_minutes_array[minutes_array_index] + ' ';
        }
        written_time += written_hours_array[hours_array_index];
        return written_time;
    }

    table:
        // 0    1    2    3    4    5    6    7    8    9   10
        [["E", "S", "E", "I", "S", "T", "A", "F", "Ü", "N", "F"]  // 0
        ,["Z", "E", "H", "N", "V", "I", "E", "R", "T", "E", "L"]  // 1
        ,["Z", "W", "A", "N", "Z", "I", "G", "L", "A", "U", "B"]  // 2
        ,["A", "N", "A", "C", "H", "D", "E", "N", "V", "O", "R"]  // 3
        ,["H", "E", "L", "D", "E", "N", "A", "H", "A", "L", "B"]  // 4
        ,["E", "I", "N", "S", "E", "C", "H", "S", "D", "I", "R"]  // 5
        ,["D", "R", "E", "I", "Z", "W", "E", "I", "E", "L", "F"]  // 6
        ,["V", "I", "E", "R", "E", "S", "I", "E", "B", "E", "N"]  // 7
        ,["T", "A", "N", "Z", "W", "Ö", "L", "F", "Ü", "N", "F"]  // 8
        ,["Z", "E", "H", "N", "E", "U", "N", "A", "C", "H", "T"]] // 9
    written_hours_array:
        ["ZWÖLF", "EINS", "ZWEI", "DREI", "VIER", "FÜNF", "SECHS", "SIEBEN", "ACHT", "NEUN", "ZEHN", "ELF"]
    written_minutes_array:
        ["", "FÜNF NACH", "ZEHN NACH", "VIERTEL NACH", "ZWANZIG NACH", "FÜNF VOR HALB", "HALB", "FÜNF NACH HALB",
        "ZWANZIG VOR", "VIERTEL VOR", "ZEHN VOR", "FÜNF VOR"]
}
