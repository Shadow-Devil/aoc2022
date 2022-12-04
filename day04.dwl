%dw 2.0
output application/json
import * from dw::core::Strings
var parsed: Array<Array<Array<Number>>> = lines(payload) map ($ splitBy "," map ($ splitBy "-" map $ as Number))

fun fullyContains(l: Array<Number>, r: Array<Number>) = l[0] <= r[0] and l[1] >= r[1]
fun overlap(l: Array<Number>, r: Array<Number>) = l[0] <= r[1] and l[1] >= r[0]
---
{
    part1: parsed filter ($[0] fullyContains $[1]) or ($[1] fullyContains $[0]) then sizeOf($),
    part2: parsed filter ($[0] overlap $[1]) then sizeOf($)
}