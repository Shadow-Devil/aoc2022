%dw 2.0
output application/json
import lines from dw::core::Strings
import take from dw::core::Arrays

var parsed = payload splitBy "\n\n" map (lines($) map $ as Number)
var calories = parsed map sum($)
---
{
    part1: max(calories),
    part2: sum(calories orderBy -$ take 3),
}