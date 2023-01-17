
%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
import * from dw::Runtime

var alphabet: Array<String> = "-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" splitBy ""
var parsed = lines(payload) map ($ splitBy "")

fun calcScore(first: Array<String>, others: Array<Array<String>>): Number = 
    (first firstWith (arr) -> others every ($ contains arr)) match {
        case found is String -> alphabet indexOf found
        case is Null -> fail("No duplicate found")
    }


fun halve(array) = array splitAt (sizeOf(array) / 2)
---
{
    part1: parsed map (halve($) then calcScore($.l, [$.r])) then sum($),
    part2: parsed divideBy 3 map calcScore($[0], $ drop 1) then sum($)
}