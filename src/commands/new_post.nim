
import constants
import std/[parsecfg, logging, times, unidecode, strutils]

proc new_post* (path_prefix : string, title: string) =
    
    let current_date = now()
    
    var url_title = unidecode(title).replace(" ", "_").toLower
    
    if url_title.high > 25:
        url_title = url_title.substr(0, url_title.rfind("_", last=25) - 1 )
    
    let post_meta_path = path_prefix & posts_directory & current_date.format("yyyyMMdd") & "_" & url_title
    
    var post_meta = newConfig()
    post_meta.setSectionKey("stencil post", "post title", title)
    post_meta.setSectionKey("stencil post", "post date", $(current_date.format(rssRFC822)))
    post_meta.writeConfig(post_meta_path & ".cfg")

    writeFile(post_meta_path & ".md", "# " & title & "\n")

    info "Created post at " & post_meta_path & ".[cfg, md]"
    quit(QuitSuccess)


