%dw 2.0
output application/json
import drop from dw::core::Arrays

@TailRec()
fun findStartPacket(chars: Array<String>, length: Number, counter: Number): Number = do{
    var sub = chars[0 to length - 1]
    ---
    if ((sub distinctBy $) == sub)
        counter
    else
        findStartPacket(chars drop 1, length, counter + 1)
}
---
{
    part1: findStartPacket(payload splitBy "", 4, 4),
    part2: findStartPacket(payload splitBy "", 14, 14)
}
