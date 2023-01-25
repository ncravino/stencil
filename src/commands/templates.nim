
import std/[strutils, sequtils]

type HtmlTemplate* = object
    html* : string 

proc read_template*(path : string) : HtmlTemplate = 
    let post_template = readAll(open(path))

    HtmlTemplate(
        html: post_template,
    )

proc apply_template*(t : HtmlTemplate, mappings : seq[(string, string)]) : string = 
    return mappings.foldl(replace(a,"{{{"&b[0]&"}}}",b[1]),t.html)
    