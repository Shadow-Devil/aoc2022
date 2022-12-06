%dw 2.0
output application/json
import * from dw::core::Arrays

fun findStartPacket(in: Array<String>, length: Number, counter: Number | Null = null) = do{
    var sub = in[0 to length - 1]
    var c = counter default length
    ---
    if ((sub distinctBy $) == sub) 
        counter 
    else 
        findStartPacket(in drop 1, length, c + 1)
}
---
{
    part1: findStartPacket(payload splitBy "", 4),
    part2: findStartPacket(payload splitBy "", 14)
}
