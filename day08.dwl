%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
var parsed = lines(payload) map (line, idx) -> (line splitBy "" map $ as Number)
var parsedTransposed = parsed map (line, x) -> parsed map $[x]

fun part1(in: Array<Array<Number>>): Array<Array<Number>> = 
    in map (line, x) -> 
    (line map (item, y) -> do{
        var lr = line splitAt y
        var ud = parsedTransposed[y] splitAt x
        ---
        if(
            isEmpty(lr.l)        or (not (lr.l some $ >= item)) or 
            isEmpty(lr.r drop 1) or (not ((lr.r drop 1) some $ >= item)) or 
            isEmpty(ud.l)        or (not (ud.l some $ >= item)) or 
            isEmpty(ud.r drop 1) or (not ((ud.r drop 1) some $ >= item))) 
        1 else 0
    })


fun part2(in: Array<Array<Number>>): Array<Array<Number>> = 
    in map (line, x) -> 
    (line map (item, y) -> do{
        var lr = line splitAt y
        var ud = parsedTransposed[y] splitAt x
        var sl = sizeOf((lr.l[-1 to 0] default []) takeWhile $ < item)
        var sr = sizeOf((lr.r drop 1) takeWhile $ < item)
        var su = sizeOf((ud.l[-1 to 0] default []) takeWhile $ < item)
        var sd = sizeOf((ud.r drop 1) takeWhile $ < item)
        ---
        (if(sl == sizeOf(lr.l)) sl else sl + 1) *
        (if(sr == sizeOf(lr.r) - 1) sr else sr + 1) *
        (if(su == sizeOf(ud.l)) su else su + 1) *
        (if(sd == sizeOf(ud.r) - 1) sd else sd + 1)
    })

---
//Solution is quite inefficient. In the playground you can only execute either part1 or part2 but not both or else you get a timeout.
{
  part1: part1(parsed) sumBy sum($),
  part2: max(part2(parsed) flatMap $)
}
