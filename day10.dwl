%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
type State = {|
    X: Number,
    cycle: Number,
    signalStrength: Number,
    display: String
|}

fun singalStrength(cycle: Number): Boolean = ((cycle + 21) mod 40) == 0
fun updateDisplay(state: State): String = state.display ++ if ([-1, 0, 1] contains (state.X - (state.cycle mod 40))) "#" else "."

fun execNoop(state: State): State = state update {
    case .cycle -> $ + 1
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> updateDisplay(state)
}

fun execAdd(amount: Number, state: State): State = state update {
    case .cycle -> $ + 1
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> updateDisplay(state)
} then (state) -> state update {
    case .cycle -> $ + 1
    case .X -> $ + amount
    case .signalStrength if(singalStrength(state.cycle)) -> $ + state.X * (state.cycle + 1)
    case .display -> updateDisplay(state)
}

var executed: State = lines(payload) reduce (item: String, state = {X: 1, cycle: 0, signalStrength: 0, display: ""}) -> 
    if (item == "noop") execNoop(state) else execAdd(words(item)[1] as Number, state)

---
{
    part1: executed.signalStrength,
    part2: executed.display splitBy "" divideBy 40 map ($ joinBy "")
}
