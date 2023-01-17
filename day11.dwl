%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays

type Monkey = {|
    startingItems: Array<Number>,
    operation: {|
        op: String,
        r: Number | String
    |},
    divisibleBy: Number,
    ifTrue: Number,
    ifFalse: Number,
    counted: Number
|}

fun parse(lines: Array<Array<String>>) = lines map {
    startingItems: $[1] splitBy "  Starting items: " then $[1] splitBy ", " map $ as Number,
    operation: $[2] splitBy "  Operation: new = old " then $[1] then words($) then {
        op: $[0],
        r: $[1] as Number default $[1]
    },
    divisibleBy: words($[3])[-1] as Number,
    ifTrue: words($[4])[-1] as Number,
    ifFalse: words($[5])[-1] as Number,
    counted: 0,
}


fun turn(monkeys: Array<Monkey>, idx: Number, divide: Boolean): Array<Monkey> = do {
    var current = monkeys[idx]
    var callback: (Number) -> Number = current.operation.op match {
        case "+" -> if(current.operation.r is Number) (x: Number) -> x + current.operation.r else (x: Number) -> x + x
        case "*" -> if(current.operation.r is Number) (x: Number) -> x * current.operation.r else (x: Number) -> x * x
    }
    var updated = current.startingItems map (if (divide) floor(callback($) / 3) else callback($)) partition (($ mod current.divisibleBy) == 0)
    ---
    if (isEmpty(current.startingItems)) monkeys else monkeys update {
        case [idx].startingItems -> []
        case [idx].counted -> $ + sizeOf(current.startingItems)
        case [current.ifTrue].startingItems -> $ ++ updated.success
        case [current.ifFalse].startingItems -> $ ++ updated.failure
    }
}

fun round(monkeys: Array<Monkey>, divide: Boolean) = (0 to sizeOf(monkeys) - 1) reduce (item, acc = monkeys) -> turn(acc, item, divide)

var simulated1 = payload splitBy "\n\n" map ($ splitBy "\n") then parse($) then (monkeys) -> (1 to 20) reduce (item, acc=monkeys) -> round(acc, true)
//var simulated2 = payload splitBy "\n\n" map ($ splitBy "\n") then parse($) then (monkeys) -> (1 to 1000) reduce (item, acc=monkeys) -> round(acc, false)
---
{
    part1: ((simulated1 orderBy -$.counted) take 2).counted reduce $*$$,
    //part2: null
}
