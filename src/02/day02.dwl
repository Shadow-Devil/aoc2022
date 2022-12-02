%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
import * from dw::util::Coercions
var winsAgainst = {
    A: "C",
    B: "A",
    C: "B"
}

var mapping1 = {
    X: "A",
    Y: "B",
    Z: "C"
}

var mapp1 = {
    A: 1,
    B: 2,
    C: 3
}

fun outcome(my: String, opp: String) = if (my == opp) 3 else if(winsAgainst[my] == opp) 6 else 0

fun part1(in: Array<String>) = do{
    var opponent = in[0]
    var my = mapping1[in[1]]
    ---
    outcome(my, opponent) + mapp1[my]
}

fun part2(in: Array<String>) = do{
    var opponent = in[0]
    var needsToEndAs = mapping1[in[1]]
    ---
    needsToEndAs match {
        case "A" -> 0 + (((mapp1[opponent]-1) + 2) mod 3) + 1
        case "B" -> 3 + mapp1[opponent]
        case "C" -> 6 + (((mapp1[opponent]-1) + 1) mod 3) + 1
    }
}

---
{
    part1: sum(lines(payload) map part1($ splitBy " ")),
    part2: sum(lines(payload) map part2($ splitBy " "))
}