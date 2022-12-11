%dw 2.0
output application/json
import * from dw::core::Strings
import * from dw::core::Arrays
type Instruction = "noop" | Number

type State = {|
    X: Number,
    cycle: Number,
    signalStrength: Number
|}

fun execNoop(state: State) = state update {
    case .cycle -> $ + 1
    case .signalStrength if(((state.cycle + 21) mod 40) == 0) -> $ + log("noop", state.X * (state.cycle + 1))
}

fun execAdd(amount: Number, state: State) = state update {
    case .cycle -> $ + 1
    case .signalStrength if(((state.cycle + 21) mod 40) == 0) -> $ + log("add1", state.X * (state.cycle + 1))
} then (state) -> state update {
    case .cycle -> $ + 1
    case .X -> $ + amount
    case .signalStrength if(((state.cycle + 21) mod 40) == 0) -> $ + log("add2", state.X * (state.cycle + 1))
}

fun duringExecution(instruction: Instruction, state: State): State = instruction  match {
    case is "noop" -> execNoop(state)
    case is Number -> execAdd($, state)
}

---
lines(payload) reduce ((item: String, state = {
    X: 1, 
    cycle: 0,
    signalStrength: 0,
}) -> duringExecution(if(item == "noop") "noop" else words(item)[1] as Number, state)
)