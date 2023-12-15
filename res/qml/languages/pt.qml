/**************************************************************************************************
**  Copyright (c) Kokleeko S.L. (https://github.com/kokleeko) and contributors.
**  All rights reserved.
**  Licensed under the LGPL license. See LICENSE file in the project root for
**  details.
**  Author: Johan, Axel REMILIEN (https://github.com/johanremilien)
**************************************************************************************************/
Language
{
    function e_agudo(enable)
    {
        tmp_onoff_table[0][0] = enable;
    }
    function sao(enable)
    {
        tmp_onoff_table[0][1] = enable;
        tmp_onoff_table[0][2] = enable;
        tmp_onoff_table[0][3] = enable;
    }
    function e(enable)
    {
        tmp_onoff_table[6][1] = enable;
    }
    function menos(enable)
    {
        tmp_onoff_table[6][0] = enable;
        tmp_onoff_table[6][1] = enable;
        tmp_onoff_table[6][2] = enable;
        tmp_onoff_table[6][3] = enable;
        tmp_onoff_table[6][4] = enable;
    }

    function cinco_minutos(enable)
    {
        tmp_onoff_table[8][0] = enable;
        tmp_onoff_table[8][1] = enable;
        tmp_onoff_table[8][2] = enable;
        tmp_onoff_table[8][3] = enable;
        tmp_onoff_table[8][4] = enable;
    }
    function dez_minutos(enable)
    {
        tmp_onoff_table[7][0]  = enable;
        tmp_onoff_table[7][1]  = enable;
        tmp_onoff_table[7][2]  = enable;
    }
    function quinze_minutos(enable)
    {
        tmp_onoff_table[7][3]  = enable;
        tmp_onoff_table[7][4]  = enable;
        tmp_onoff_table[8][5]  = enable;
        tmp_onoff_table[8][6]  = enable;
        tmp_onoff_table[8][7]  = enable;
        tmp_onoff_table[8][9]  = enable;
        tmp_onoff_table[8][10] = enable;
    }
    function vinte_minutos(enable)
    {
        tmp_onoff_table[6][6]  = enable;
        tmp_onoff_table[6][7]  = enable;
        tmp_onoff_table[6][8]  = enable;
        tmp_onoff_table[6][9]  = enable;
        tmp_onoff_table[6][10] = enable;
    }
    function vinte_e_cinco_minutos(enable)
    {
        vinte_minutos(enable);
        tmp_onoff_table[7][5] = enable;
        cinco_minutos(enable);
    }

    function hours_00(enable, isAM)     //"É MEIA-NOITE | É MEIO-DIA"
    {
        e_agudo(enable);
        if (isAM)
        {
            tmp_onoff_table[2][7]  = enable;
            tmp_onoff_table[2][8]  = enable;
            tmp_onoff_table[2][9]  = enable;
            tmp_onoff_table[2][10] = enable;
            tmp_onoff_table[3][6]  = enable;
            tmp_onoff_table[3][7]  = enable;
            tmp_onoff_table[3][8]  = enable;
            tmp_onoff_table[3][9]  = enable;
            tmp_onoff_table[3][10] = enable;
        }
        else
        {
            tmp_onoff_table[0][7]  = enable;
            tmp_onoff_table[0][8]  = enable;
            tmp_onoff_table[0][9]  = enable;
            tmp_onoff_table[0][10] = enable;
            tmp_onoff_table[1][8]  = enable;
            tmp_onoff_table[1][9]  = enable;
            tmp_onoff_table[1][10] = enable;
        }
    }
    function hours_01(enable, isAM)     //"É UMA"
    {
        e_agudo(enable);
        tmp_onoff_table[0][4] = enable;
        tmp_onoff_table[0][5] = enable;
        tmp_onoff_table[0][6] = enable;
    }
    function hours_02(enable, isAM)     //"SÃO DUAS"
    {
        sao(enable);
        tmp_onoff_table[4][4] = enable;
        tmp_onoff_table[4][5] = enable;
        tmp_onoff_table[4][6] = enable;
        tmp_onoff_table[4][7] = enable;
    }
    function hours_03(enable, isAM)     //"SÃO TRÊS"
    {
        sao(enable);
        tmp_onoff_table[2][0] = enable;
        tmp_onoff_table[2][1] = enable;
        tmp_onoff_table[2][2] = enable;
        tmp_onoff_table[2][3] = enable;
    }
    function hours_04(enable, isAM)     //"SÃO QUATRO"
    {
        sao(enable);
        tmp_onoff_table[3][0] = enable;
        tmp_onoff_table[3][1] = enable;
        tmp_onoff_table[3][2] = enable;
        tmp_onoff_table[3][3] = enable;
        tmp_onoff_table[3][4] = enable;
        tmp_onoff_table[3][5] = enable;
    }
    function hours_05(enable, isAM)     //"SÃO CINCO"
    {
        sao(enable);
        tmp_onoff_table[5][3] = enable;
        tmp_onoff_table[5][4] = enable;
        tmp_onoff_table[5][5] = enable;
        tmp_onoff_table[5][6] = enable;
        tmp_onoff_table[5][7] = enable;
    }
    function hours_06(enable, isAM)     //"SÃO SEIS"
    {
        sao(enable);
        tmp_onoff_table[4][7]  = enable;
        tmp_onoff_table[4][8]  = enable;
        tmp_onoff_table[4][9]  = enable;
        tmp_onoff_table[4][10] = enable;
    }
    function hours_07(enable, isAM)     //"SÃO SETE"
    {
        sao(enable);
        tmp_onoff_table[2][3] = enable;
        tmp_onoff_table[2][4] = enable;
        tmp_onoff_table[2][5] = enable;
        tmp_onoff_table[2][6] = enable;
    }
    function hours_08(enable, isAM)     //"SÃO OITO"
    {
        sao(enable);
        tmp_onoff_table[5][7]  = enable;
        tmp_onoff_table[5][8]  = enable;
        tmp_onoff_table[5][9]  = enable;
        tmp_onoff_table[5][10] = enable;
    }
    function hours_09(enable, isAM)      //"SÃO NOVE"
    {
        sao(enable);
        tmp_onoff_table[1][4] = enable;
        tmp_onoff_table[1][5] = enable;
        tmp_onoff_table[1][6] = enable;
        tmp_onoff_table[1][7] = enable;
    }
    function hours_10(enable, isAM)     //"SÃO DEZ"
    {
        sao(enable);
        tmp_onoff_table[5][0] = enable;
        tmp_onoff_table[5][1] = enable;
        tmp_onoff_table[5][2] = enable;
    }
    function hours_11(enable, isAM)      //"SÃO ONZE"
    {
        sao(enable);
        tmp_onoff_table[1][0] = enable;
        tmp_onoff_table[1][1] = enable;
        tmp_onoff_table[1][2] = enable;
        tmp_onoff_table[1][3] = enable;
    }

    function minutes_00(enable, hours_array_index)         //"EM PONTO"
    {
        tmp_onoff_table[9][0]  = enable;
        tmp_onoff_table[9][1]  = enable;
        tmp_onoff_table[9][6]  = enable;
        tmp_onoff_table[9][7]  = enable;
        tmp_onoff_table[9][8]  = enable;
        tmp_onoff_table[9][9]  = enable;
        tmp_onoff_table[9][10] = enable;
    }
    function minutes_05(enable, hours_array_index)     //"E CINCO"
    {
        e(enable);
        cinco_minutos(enable);
    }
    function minutes_10(enable, hours_array_index)      //"E DEZ"
    {
        e(enable);
        dez_minutos(enable);
    }
    function minutes_15(enable, hours_array_index)      //"E CUARTO"
    {
        e(enable);
        quinze_minutos(enable);
    }
    function minutes_20(enable, hours_array_index)      //"Y VINTE"
    {
        e(enable);
        vinte_minutos(enable);
    }
    function minutes_25(enable, hours_array_index)     //"E VINTE E CINCO"
    {
        e(enable);
        vinte_e_cinco_minutos(enable);
    }
    function minutes_30(enable, hours_array_index)     //"E MEIA"
    {
        e(enable);
        tmp_onoff_table[7][4] = enable;
        tmp_onoff_table[7][5] = enable;
        tmp_onoff_table[7][6] = enable;
        tmp_onoff_table[7][7] = enable;
    }
    function minutes_35(enable, hours_array_index)     //"MENOS VEINTICINCO"
    {
        menos(enable);
        vinte_e_cinco_minutos(enable);
    }
    function minutes_40(enable, hours_array_index)     //"MENOS VEINTE"
    {
        menos(enable);
        vinte_minutos(enable);
    }
    function minutes_45(enable, hours_array_index)     //"MENOS CUARTO"
    {
        menos(enable);
        quinze_minutos(enable);
    }
    function minutes_50(enable, hours_array_index)     //"MENOS DIEZ"
    {
        menos(enable);
        dez_minutos(enable);
    }
    function minutes_55(enable, hours_array_index)     //"MENOS CINCO"
    {
        menos(enable);
        cinco_minutos(enable);
    }

    function special_message(enable)
    {
        tmp_onoff_table[0][0]  = enable;
        tmp_onoff_table[0][1]  = enable;
        tmp_onoff_table[0][4]  = enable;
        tmp_onoff_table[0][5]  = enable;
        tmp_onoff_table[0][6]  = enable;
        tmp_onoff_table[4][0]  = enable;
        tmp_onoff_table[4][1]  = enable;
        tmp_onoff_table[4][2]  = enable;
        tmp_onoff_table[4][3]  = enable;
        tmp_onoff_table[7][0]  = enable;
        tmp_onoff_table[7][1]  = enable;
        tmp_onoff_table[7][7]  = enable;
        tmp_onoff_table[7][8]  = enable;
        tmp_onoff_table[7][9]  = enable;
        tmp_onoff_table[7][10] = enable;
    }

    function written_time(hours_array_index, minutes_array_index, isAM)
    {
        var written_time = hours_array_index > 1 ? "SÃO ": "É ";
        if (hours_array_index === 0)
        {
            const split_written_hour = written_hours_array[0].split('|');
            written_time += split_written_hour[isAM ? 0 : 1];
        }
        else
        {
            written_time += written_hours_array[hours_array_index];
        }
        written_time += ' ' + written_minutes_array[minutes_array_index];
        return written_time;
    }

    table:
        // 0    1    2    3    4    5    6    7    8    9   10
        [["É", "S", "Ã", "O", "U", "M", "A", "M", "E", "I", "O"]  // 0
        ,["O", "N", "Z", "E", "N", "O", "V", "E", "D", "I", "A"]  // 1
        ,["T", "R", "Ê", "S", "E", "T", "E", "M", "E", "I", "A"]  // 2
        ,["Q", "U", "A", "T", "R", "O", "N", "O", "I", "T", "E"]  // 3
        ,["O", "B", "R", "A", "D", "U", "A", "S", "E", "I", "S"]  // 4
        ,["D", "E", "Z", "C", "I", "N", "C", "O", "I", "T", "O"]  // 5
        ,["M", "E", "N", "O", "S", "Ó", "V", "I", "N", "T", "E"]  // 6
        ,["D", "E", "Z", "U", "M", "E", "I", "A", "R", "T", "E"]  // 7
        ,["C", "I", "N", "C", "O", "Q", "U", "A", "R", "T", "O"]  // 8
        ,["E", "M", "P", "U", "X", "O", "P", "O", "N", "T", "O"]] // 9
    written_hours_array:
        ["MEIA-NOITE|MEIO-DIA", "UMA", "DUAS", "TRÊS", "QUATRO", "CINCO", "SEIS", "SETE", "OITO", "NOVE", "DEZ",
        "ONZE"]
    written_minutes_array:
        ["EM PONTO", "E CINCO", "E DEZ", "E UM QUARTO", "E VINTE", "E VINTE E CINCO", "E MEIA",
        "MENOS VINTE E CINCO", "MENOS VINTE", "MENOS UM QUARTO", "MENOS DEZ", "MENOS CINCO"]
}
