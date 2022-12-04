
%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
var alphabet = "-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" splitBy ""
var parsed = lines(payload) map ($ splitBy "")
fun part1(x: Array<String>, xs: Array<Array<String>>) =
    charToScore((x firstWith (arr) -> (xs every ($ contains arr))) as String)
fun charToScore(char: String): Number = alphabet indexOf char
fun halve(arr: Array) = arr splitAt (sizeOf(arr) / 2)
---
{
    part1: sum(parsed map (halve($) then part1($.l, [$.r]))),
    part2: sum(parsed divideBy 3 map part1($[0], $ drop 1))
}