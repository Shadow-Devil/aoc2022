%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
var parsed = lines(payload) map ($ splitBy " ")

type ABC = "A" | "B" | "C"
var winsAgainst = { A: "C", B: "A", C: "B" }
var losesAgainst = winsAgainst mapObject ($): $$
var XYZtoABC    = { X: "A", Y: "B", Z: "C" }
var ABCtoScore  = { A: 1, B: 2, C: 3 }

fun part1(opponent: ABC, myself: ABC): Number =
    (
        if (myself == opponent) 3
        else if(winsAgainst[myself] == opponent) 6
        else 0
    ) + ABCtoScore[myself]

fun part2(opponent: ABC, needsToEndAs: String): Number = needsToEndAs match {
    case "X" -> 0 + ABCtoScore[winsAgainst[opponent]]
    case "Y" -> 3 + ABCtoScore[opponent]
    case "Z" -> 6 + ABCtoScore[losesAgainst[opponent]]
}

---
{
    part1: sum(parsed map part1($[0], XYZtoABC[$[1]])),
    part2: sum(parsed map part2($[0], $[1]))
}
