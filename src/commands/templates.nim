
import mustache

type HtmlTemplate* = object
    html* : string 

proc read_template*(path : string) : HtmlTemplate = 
    let post_template = readAll(open(path))

    HtmlTemplate(
        html: post_template,
    )

proc apply_template*(t : HtmlTemplate, mappings : seq[(string, string)]) : string = 
    var c = newContext()
    for m in mappings:
        c[m[0]]=m[1]
    return t.html.render(c)
    
    