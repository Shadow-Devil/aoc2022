%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays

fun toChars(str: String): Array<String> = str splitBy ""

var alphabet: Array<String> = toChars("-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
var parsed: Array<Array<String>> = lines(payload) map toChars($)

fun solveLine(first: Array<String>, others: Array<Array<String>>): Number = 
    (first firstWith (arr) -> others every ($ contains arr)) match {
        case is String -> alphabet indexOf $
        case is Null -> ???
    }

fun halve(array: Array<String>): Pair<Array<String>, Array<String>> = array splitAt (sizeOf(array) / 2)
---
{
    part1: parsed map (halve($) then solveLine($.l, [$.r])) then sum($),
    part2: parsed divideBy 3 map solveLine($[0], $ drop 1) then sum($)
}