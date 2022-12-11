%dw 2.0
output application/json
import lines, words from dw::core::Strings
import drop from dw::core::Arrays
var parsed = lines(payload) map (words($) then [$[0], $[1]])

type Position = {| x: Number, y: Number|}
type State = {| head: Position, tails: Array<Position>, visited: Array<Position> |}

@TailRec()
fun moveTail(state: State, track: Number, x: Number, this: Position | Null, other: Position): State = do {
    var newThis = (this match {
        case is Position -> {
            x: if ($.x == other.x) $.x else if ($.x < other.x) $.x + 1 else $.x - 1,
            y: if ($.y == other.y) $.y else if ($.y < other.y) $.y + 1 else $.y - 1
        }
        case is Null -> { //Should never be used but is needed for the type checker
            x: other.x,
            y: other.y
        }
    })
    var diffX = other.x - (this.x default 0)
    var diffY = other.y - (this.y default 0)
    ---
    if(
        this == null or
        ((diffX == 0 or diffX == -1 or diffX == 1) and 
        (diffY == 0 or diffY == -1 or diffY == 1))
    )
        state 
    else 
        moveTail(
        if(x == track)
            state update {
                case .tails -> $ map if($$ == x) newThis else $
                case .visited -> newThis >> $
            }
        else
            state update {
                case .tails -> $ map if($$ == x) newThis else $
            },
        track, 
        x + 1,
        state.tails[x + 1],
        newThis
    )
}

fun updateState(direction: String, amount: Number, track: Number, state: State): State = 
    (0 to amount - 1) reduce (item: Number, acc: State=state) -> do{
        var newState = if (direction == "R") acc update {
            case .head.x -> $ + 1
        } else if(direction == "L") acc update {
            case .head.x -> $ - 1
        } else if(direction == "U") acc update {
            case .head.y -> $ - 1
        } else acc update {
            case .head.y -> $ + 1
        } 
        ---
    moveTail(
        newState, 
        track,
        0,
        newState.tails[0],
        newState.head
    )
}


fun simulate(commands: Array<Array<String>>, track: Number, state: State): State = commands reduce (item: Array<String>, acc: State = state) -> updateState(item[0], item[1] as Number, track, acc)

---
{
    part1: simulate(
        parsed, 
        0, 
        {
            head:{x:0, y:0}, 
            tails:[{x:0, y:0}], 
            visited:[{x:0, y:0}]
        }).visited distinctBy ($) then sizeOf($),
    part2: simulate(
        parsed, 
        8, 
        { 
            head:{x:0, y:0}, 
            tails: 1 to 9 map {x:0, y:0}, 
            visited:[{x:0, y:0}]
        }).visited distinctBy ($) then sizeOf($)
}