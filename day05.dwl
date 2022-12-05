%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
var initial: Array<Array<String>> = payload splitBy "\n\n" 
                then lines($[0])[0 to -2] 
                map ($ splitBy "" divideBy 4 map $[1]) 
                reduce ((item, accumulator = null) -> if (accumulator == null) item map [$] else accumulator map $ + item[$$]) 
                map ($ filter $ != " ")


type Move = {| amount: Number, from: Number, to: Number |}
var moves: Array<Move> = payload splitBy "\n\n" then lines($[1]) map words($) map {
    amount: $[1] as Number,
    from: $[3] as Number - 1,
    to: $[5]  as Number - 1
}

fun simulate(state: Array<Array<String>>, move: Move, reverse = false) = do {
    var moving = state[move.from] take move.amount then if (reverse) $[-1 to 0] else $
    ---
    state map 
        if ($$ == move.from) $ drop move.amount 
        else if ($$ == move.to) moving ++ $ 
        else $
}
---
{
    part1: moves reduce ((move, acc = initial) -> simulate(acc, move, true)) map $[0] joinBy "",
    part2: moves reduce ((move, acc = initial) -> simulate(acc, move)) map $[0] joinBy "",
}
