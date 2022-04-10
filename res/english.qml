Language {
    function it_is(enable) {
        tmp_enable_table[0][0] = enable
        tmp_enable_table[0][1] = enable
        tmp_enable_table[0][3] = enable
        tmp_enable_table[0][4] = enable
    }
    function past(enable) {
        tmp_enable_table[4][0] = enable
        tmp_enable_table[4][1] = enable
        tmp_enable_table[4][2] = enable
        tmp_enable_table[4][3] = enable
    }
    function to(enable) {
        tmp_enable_table[3][4] = enable
        tmp_enable_table[3][5] = enable
    }
    function five_minutes(enable) {
        tmp_enable_table[1][7] = enable
        tmp_enable_table[1][8] = enable
        tmp_enable_table[1][9] = enable
        tmp_enable_table[1][10] = enable
    }
    function ten_minutes(enable) {
        tmp_enable_table[3][0] = enable
        tmp_enable_table[3][1] = enable
        tmp_enable_table[3][2] = enable
    }
    function fifteen_minutes(enable) {
        tmp_enable_table[2][4] = enable
        tmp_enable_table[2][5] = enable
        tmp_enable_table[2][6] = enable
        tmp_enable_table[2][7] = enable
        tmp_enable_table[2][8] = enable
        tmp_enable_table[2][9] = enable
        tmp_enable_table[2][10] = enable
    }
    function twenty_minutes(enable) {
        tmp_enable_table[1][0] = enable
        tmp_enable_table[1][1] = enable
        tmp_enable_table[1][2] = enable
        tmp_enable_table[1][3] = enable
        tmp_enable_table[1][4] = enable
        tmp_enable_table[1][5] = enable
    }
    function twentyfive_minutes(enable) {
        twenty_minutes(enable)
        five_minutes(enable)
    }

    function hours_00(enable) { //"IT IS _ TWELVE _"
        it_is(enable)
        tmp_enable_table[6][0] = enable
        tmp_enable_table[6][1] = enable
        tmp_enable_table[6][2] = enable
        tmp_enable_table[6][3] = enable
        tmp_enable_table[6][4] = enable
        tmp_enable_table[6][5] = enable
    }
    function hours_01(enable) { //"IT IS _ ONE _"
        it_is(enable)
        tmp_enable_table[9][0] = enable
        tmp_enable_table[9][1] = enable
        tmp_enable_table[9][2] = enable
    }
    function hours_02(enable) { //"IT IS _ TWO _"
        it_is(enable)
        tmp_enable_table[8][8] = enable
        tmp_enable_table[8][9] = enable
        tmp_enable_table[8][10] = enable
    }
    function hours_03(enable) { //"IT IS _ THREE _"
        it_is(enable)
        tmp_enable_table[8][3] = enable
        tmp_enable_table[8][4] = enable
        tmp_enable_table[8][5] = enable
        tmp_enable_table[8][6] = enable
        tmp_enable_table[8][7] = enable
    }
    function hours_04(enable) { //IT IS _ FOUR _"
        it_is(enable)
        tmp_enable_table[7][7] = enable
        tmp_enable_table[7][8] = enable
        tmp_enable_table[7][9] = enable
        tmp_enable_table[7][10] = enable
    }
    function hours_05(enable) { //"IT IS _ FIVE _"
        it_is(enable)
        tmp_enable_table[7][3] = enable
        tmp_enable_table[7][4] = enable
        tmp_enable_table[7][5] = enable
        tmp_enable_table[7][6] = enable
    }
    function hours_06(enable) { //"IT IS _ SIX _"
        it_is(enable)
        tmp_enable_table[8][0] = enable
        tmp_enable_table[8][1] = enable
        tmp_enable_table[8][2] = enable
    }
    function hours_07(enable) { //"IT IS _ SEVEN _"
        it_is(enable)
        tmp_enable_table[6][6] = enable
        tmp_enable_table[6][7] = enable
        tmp_enable_table[6][8] = enable
        tmp_enable_table[6][9] = enable
        tmp_enable_table[6][10] = enable
    }
    function hours_08(enable) { //"IT IS _ EIGHT _"
        it_is(enable)
        tmp_enable_table[5][1] = enable
        tmp_enable_table[5][2] = enable
        tmp_enable_table[5][3] = enable
        tmp_enable_table[5][4] = enable
        tmp_enable_table[5][5] = enable
    }
    function hours_09(enable) { //"IT IS _ NINE _"
        it_is(enable)
        tmp_enable_table[5][7] = enable
        tmp_enable_table[5][8] = enable
        tmp_enable_table[5][9] = enable
        tmp_enable_table[5][10] = enable
    }
    function hours_10(enable) { //"IT IS _ TEN _"
        it_is(enable)
        tmp_enable_table[7][0] = enable
        tmp_enable_table[7][1] = enable
        tmp_enable_table[7][2] = enable
    }
    function hours_11(enable) { //"IT IS _ ELEVEN _"
        it_is(enable)
        tmp_enable_table[4][5] = enable
        tmp_enable_table[4][6] = enable
        tmp_enable_table[4][7] = enable
        tmp_enable_table[4][8] = enable
        tmp_enable_table[4][9] = enable
        tmp_enable_table[4][10] = enable
    }

    function minutes_00(enable) { // "O'CLOCK"
        tmp_enable_table[9][5] = enable
        tmp_enable_table[9][6] = enable
        tmp_enable_table[9][7] = enable
        tmp_enable_table[9][8] = enable
        tmp_enable_table[9][9] = enable
        tmp_enable_table[9][10] = enable
    }
    function minutes_05(enable) { //"FIVE PAST"
        five_minutes(enable)
        past(enable)
    }
    function minutes_10(enable) { //"TEN PAST"
        ten_minutes(enable)
        past(enable)
    }
    function minutes_15(enable) { //"QUARTER PAST"
        fifteen_minutes(enable)
        past(enable)
    }
    function minutes_20(enable) { //"TWENTY PAST"
        twenty_minutes(enable)
        past(enable)
    }
    function minutes_25(enable) { //"TWENTY FIVE PAST"
        twentyfive_minutes(enable)
        past(enable)
    }
    function minutes_30(enable) { //"HALF PAST"
        tmp_enable_table[0][6] = enable
        tmp_enable_table[0][7] = enable
        tmp_enable_table[0][8] = enable
        tmp_enable_table[0][9] = enable
        past(enable)
    }
    function minutes_35(enable) { //"TWENTY FIVE TO"
        twentyfive_minutes(enable)
        to(enable)
    }
    function minutes_40(enable) { //"TWENTY TO"
        twenty_minutes(enable)
        to(enable)
    }
    function minutes_45(enable) { //"QUARTER TO"
        fifteen_minutes(enable)
        to(enable)
    }
    function minutes_50(enable) { //"TEN TO"
        ten_minutes(enable)
        to(enable)
    }
    function minutes_55(enable) { //"FIVE TO"
        five_minutes(enable)
        to(enable)
    }

    function special_message(enable) { //"IT IS TIME TO RISE"
        it_is(enable)
        tmp_enable_table[2][0] = enable
        tmp_enable_table[2][1] = enable
        tmp_enable_table[2][2] = enable
        tmp_enable_table[2][3] = enable
        tmp_enable_table[3][4] = enable
        tmp_enable_table[3][5] = enable
        tmp_enable_table[3][7] = enable
        tmp_enable_table[3][8] = enable
        tmp_enable_table[3][9] = enable
        tmp_enable_table[3][10] = enable
    }

    function written_time(hours_array_index, minutes_array_index){
        var written_time = "IT IS"
        if (minutes_array_index !== 0)
            written_time += ' ' + written_minutes_array[minutes_array_index]
        written_time += ' ' + written_hours_array[hours_array_index]
        if (minutes_array_index === 0)
            written_time += ' ' + written_minutes_array[0]
        return written_time
    }

    table:
        // 0    1    2    3    4    5     6    7    8    9   10
        [["I", "T", "B", "I", "S", "D" , "H", "A", "L", "F", "M"]  // 0
        ,["T", "W", "E", "N", "T", "Y" , "X", "F", "I", "V", "E"]  // 1
        ,["T", "I", "M", "E", "Q", "U" , "A", "R", "T", "E", "R"]  // 2
        ,["T", "E", "N", "Z", "T", "O" , "U", "R", "I", "S", "E"]  // 3
        ,["P", "A", "S", "T", "O", "E" , "L", "E", "V", "E", "N"]  // 4
        ,["H", "E", "I", "G", "H", "T" , "A", "N", "I", "N", "E"]  // 5
        ,["T", "W", "E", "L", "V", "E" , "S", "E", "V", "E", "N"]  // 6
        ,["T", "E", "N", "F", "I", "V" , "E", "F", "O", "U", "R"]  // 7
        ,["S", "I", "X", "T", "H", "R" , "E", "E", "T", "W", "O"]  // 8
        ,["O", "N", "E", "A", "T", "O'", "C", "L", "O", "C", "K"]] // 9
    written_hours_array:
        ["TWELVE", "ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN",
        "ELEVEN"]
    written_minutes_array:
        ["O'CLOCK", "FIVE PAST", "TEN PAST", "QUARTER PAST", "TWENTY PAST", "TWENTY FIVE PAST",
        "HALF PAST", "TWENTY FIVE TO", "TWENTY TO", "QUARTER TO", "TEN TO", "FIVE TO"]
}
