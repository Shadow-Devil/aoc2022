%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
type File = {
    name: String,
    size: Number
}

type Directory = {
    path: Array<String>,
    size?: Number,
    children: Array<String | File>
}

@TailRec()
fun ls(rest: Array<String>, parsed: Directory): {| rest: Array<String>, parsed: Directory |} = do{
    var cur = rest[0]
    ---
    if(cur == null or (cur startsWith "\$")) { // end of ls
        rest: rest,
        parsed: parsed
    } else if(cur startsWith "dir") ls(rest drop 1, { // found dir
        path: parsed.path,
        children: parsed.children << words(cur)[1]
    }) else ls(rest drop 1, { // found file
        path: parsed.path,
        children: parsed.children << (words(cur) then {
            name: $[1],
            size: $[0] as Number
        })
    })
}

@TailRec()
fun parse(rest: Array<String>, path: Array<String> = [], parsed: Array<Directory> = []): Array<Directory> = do{
    var cur = rest[0]
    var dir = ls(rest drop 1, { path: path, children: [] })
    ---
    if(cur == null) 
        parsed 
    else if(cur startsWith "\$ ls") 
        parse(dir.rest, path, parsed + dir.parsed)
    else if (cur == "\$ cd ..")
        parse(rest drop 1, path[0 to -2], parsed)
    else
        parse(rest drop 1, path + words(cur)[2], parsed)
}

fun matchPaths(current: Array<String>, toCheck: Array<String>) = 
    if(isEmpty(current)) 
        true 
    else if(isEmpty(toCheck)) 
        false 
    else if(current[0] == toCheck[0]) 
        matchPaths(current drop 1, toCheck drop 1) 
    else 
        false 

fun dirSizes(in: Array<Directory>): Array<Directory> = in map (cur) -> do{
    var x = null
    ---
    {
        path: log(cur.path),
        children: cur.children,
        size: sum(in filter (matchPaths(cur.path, $.path)) flatMap ($.children filter ($ is File) map $.size))
    }
}

var parsed = parse(lines(payload)) then dirSizes($)
var occupied = max(parsed.size)
---
{
    part1: sum(parsed.size filter ($ <= 100000)),
    part2: min((parsed filter (occupied - $.size  < 70000000 - 30000000)).size)
}
