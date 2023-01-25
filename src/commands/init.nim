
import constants
import std/[os, parsecfg, logging]

proc init* (path_prefix : string, title : string) = 
    if fileExists(path_prefix & blog_info_file):
        error "Blog found in directory " & path_prefix & "! Aborting..."
        quit(QuitFailure)
    
    createDir(path_prefix)
    createDir(path_prefix & posts_directory)
    createDir(path_prefix & template_directory)
    
    let template_file = open(path_prefix & template_directory & "post.html.template",mode = fmWrite)
    template_file.write(default_template)

    var conf = newConfig()
    conf.setSectionKey("stencil", "blog title", title)
    conf.setSectionKey("stencil", "blog author", title)
    conf.setSectionKey("stencil", "blog link", "")
    conf.setSectionKey("stencil", "blog description", "")
    conf.writeConfig(path_prefix & blog_info_file)
    info "Blog initialized at " & path_prefix
    info "Remember to fill in the description, and link"
    info "Use: stencil --help-init for more help"
    quit(QuitSuccess)

