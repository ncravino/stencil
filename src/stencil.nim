
import std/[os,logging]
from std/parseopt import initOptParser, next, cmdEnd, cmdLongOption, cmdArgument

import commands/[generate, init, new_post]

let logger = newConsoleLogger()
addHandler(logger)

proc printHelp() = 
  let helpStr = "Usage: [option] command [parameter]" &
    "\n\nfor options:" &
    "\n\t--path_prefix=path \tThe path to the blog (otherwise ./)." &
    "\n\t--help \t\t\tprint this help." &
    "\n\nwhere command is one of:" &
    "\n\tinit --title=\"your blog title\" \tCreates the structure for a new static blog." &
    "\n\tnew --title=\"your post title\" \tCreates the files for a new post." &
    "\n\tgen  \t\t\t\t(Re-)generates the html pages.\n"
  info helpStr

# Main ----------------------------------

let argv = commandLineParams()
var 
    p = initOptParser(argv)
    path_prefix = "./"
    title = ""
    command = ""

while true:
  p.next()
  case p.kind
  of cmdEnd: 
    break
  of cmdLongOption: 
    if p.key == "path_prefix":
      path_prefix = p.val
    elif p.key == "title":
        title = p.val
    elif p.key == "help":    
      printHelp()
      quit(QuitSuccess)
    else:
        error "Invalid parameter: "&p.key
        quit(QuitFailure) 
  of cmdArgument:
    if p.key == "new":
        command = "new"
    elif p.key == "init":
        command = "init"
    elif p.key == "gen":
        command = "gen"
    else:
        error "Invalid argument: "&p.key
        quit(QuitFailure) 
  else:
    error "Invalid argument: "&p.key
    quit(QuitFailure)

if command.len() == 0:
    error "No command found!"
    printHelp()
    quit(QuitFailure)

if path_prefix[path_prefix.high] != '/':
    path_prefix = path_prefix & "/"
try:
    case command 
        of "init":
            if title == "":
                error "Please provide --title=\"your title\" for the blog"
                quit(QuitFailure)
            init(path_prefix, title)
        of "new":
            if title == "":
                error "Please provide --title=\"your title\" for the post"
                quit(QuitFailure)
            new_post(path_prefix, title)
        of "gen":
            if title != "":
                warn "--title provided but not used in gen"
            generate(path_prefix)
        else:
            error "Undefined error: command is "&command
            quit(QuitFailure)
except:
    error getCurrentExceptionMsg()
    quit(QuitFailure)