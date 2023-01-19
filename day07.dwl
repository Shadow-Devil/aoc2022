%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
type File = {|
    name: String,
    size: Number
|}

type Directory = {|
    path: Array<String>,
    size?: Number,
    children: Array<String | File>
|}

type Context = {| rest: Array<String>, parsed: Directory |}

@TailRec()
fun ls(context: Context): Context = context.rest match {
    case [] -> // end of ls
        { rest: context.rest, parsed: context.parsed }
    case [cur ~ rest] -> if (cur startsWith "\$") // end of ls
            { rest: context.rest, parsed: context.parsed } 
        else ls({
            rest: rest,
            parsed: {
                path: context.parsed.path,
                children: if(cur startsWith "dir") // found dir 
                        context.parsed.children << words(cur)[1]
                    else // found file
                        context.parsed.children << (words(cur) then {
                            name: $[1],
                            size: $[0] as Number
                        })
            }})
}


@TailRec()
fun parse(rest: Array<String>, path: Array<String> = [], parsed: Array<Directory> = []): Array<Directory> = 
rest match {
    case [] -> parsed
    case [current ~ newRest] -> 
        if (current startsWith "\$ ls") 
            ls({ rest: newRest, parsed: { path: path, children: [] } })
            then parse($.rest, path, parsed + $.parsed)
        else parse(
            newRest, 
            if (current startsWith "\$ cd ..") path[0 to -2] else path + words(current)[2], 
            parsed
        )
}


fun matchPaths(current: Array<String>, toCheck: Array<String>) = current map $ == toCheck[$$] every $

fun dirSizes(dirs: Array<Directory>): Array<Directory> = dirs map (cur) -> {
    path: cur.path,
    children: cur.children,
    size: sum(dirs filter (matchPaths(cur.path, $.path)) flatMap ($.children filter ($ is File) map $.size))
}

var parsed = parse(lines(payload)) then dirSizes($)
var occupied = max(parsed.size)
---
{
    part1: sum(parsed.size filter ($ <= 100000)),
    part2: min((parsed filter (occupied - $.size  < 70000000 - 30000000)).size)
}
