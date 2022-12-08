%dw 2.0
output application/json
import * from dw::core::Arrays
import * from dw::core::Strings
type File = {
    name: String,
    size: Number
}

type Directory = {
    name: String,
    size?: Number,
    children: Array<Directory | File>
}

@TailRec()
fun ls(rest: Array<String>, parsed: Directory): {| rest: Array<String>, parsed: Directory |} = do{
    var cur = rest[0]
    ---
    if(cur == null or (cur startsWith "\$")) { // end of ls
        rest: rest,
        parsed: parsed
    } else if(cur startsWith "dir") ls(rest drop 1, { // found dir
        name: parsed.name,
        children: parsed.children << {
            name: words(cur)[1],
            children: []
        }
    }) else ls(rest drop 1, { // found file
        name: parsed.name,
        children: parsed.children << (words(cur) then {
            name: $[1],
            size: $[0] as Number
        })
    })
}


fun updateParsed(wholeParsed: Directory, path: Array<String> | Null, subParsed: Directory): Directory =
    if (isEmpty(path)) //we found it
        subParsed
    else 
        {
            name: wholeParsed.name,
            children: (wholeParsed.children filter ($.name != path[-1])) + updateParsed((wholeParsed.children firstWith ($.name == path[-1])) as Directory, path[0 to -2], subParsed)
        }


@TailRec()
fun parse(commands: Array<String>, path: Array<String> = [], parsed: Directory = {name: "", children: []}): Directory = do{
    var cur = commands[0]
    var rest = commands drop 1
    ---
    if(cur == null) // finished
        parsed 
    else if(cur startsWith "\$ ls") // list files
        ls(rest, { name: path[0], children: [] })
        then parse($.rest, path, updateParsed(parsed, path[0 to -2], $.parsed)) 
    else if (cur == "\$ cd ..") // move out
        parse(rest, path drop 1, parsed)
    else // move in
        parse(rest, words(cur)[2] >> path, parsed)
}

fun dirSizes(in: Directory) = do{
    var childrenWithSizes = in.children map if ($ is File) $ else dirSizes($)
    ---
    {
    name: in.name,
    children: childrenWithSizes,
    size: sum(childrenWithSizes map if ($ is File) $.size else $.size)
}
}

fun findMost100k(in: Directory): Array<Directory> = in.children filter ($ is Directory) flatMap findMost100k($ as Directory) ++ (if (in.size <= 100000) [in] else [])
---
parse(lines(payload)) then dirSizes($) then sum(findMost100k($).size)
