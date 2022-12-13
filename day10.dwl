%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
type Instruction = "noop" | Number

type State = {|
    X: Number,
    cycle: Number,
    signalStrength: Number,
    display: String
|}

fun singalStrength(cycle: Number) = ((cycle + 21) mod 40) == 0

fun execNoop(state: State) = state update {
    case .cycle -> $ + 1
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> $ ++ if ([-1, 0, 1] contains (state.X - (state.cycle mod 40))) "#" else "."
}

fun execAdd(amount: Number, state: State) = state update {
    case .cycle -> $ + 1
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> $ ++ if ([-1, 0, 1] contains (state.X - (state.cycle mod 40))) "#" else "."
} then (state) -> state update {
    case .cycle -> $ + 1
    case .X -> $ + amount
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> $ ++ if ([-1, 0, 1] contains (state.X - (state.cycle mod 40))) "#" else "."
}

fun duringExecution(instruction: Instruction, state: State): State = instruction  match {
    case is "noop" -> execNoop(state)
    case is Number -> execAdd($, state)
}
var executed = lines(payload) reduce ((item: String, state = {
    X: 1, 
    cycle: 0,
    signalStrength: 0,
    display: ""
}) -> duringExecution(if(item == "noop") "noop" else words(item)[1] as Number, state)
)
---
{
    part1: executed.signalStrength,
    part2: ((executed.display splitBy "") divideBy 40) map ($ joinBy "")
}
