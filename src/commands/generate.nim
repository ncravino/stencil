
import constants, templates
import std/[os, times, xmltree, parsecfg, uri, logging]

import markdown

proc generate* (path_prefix : string) = 

    let html_template = read_template(path_prefix & template_directory & "post.html.template")

    let blog_info = loadConfig(path_prefix & blog_info_file)

    let author = blog_info.getSectionValue("stencil", "blog author")

    let blog_title = newElement("title")
    blog_title.add newText(blog_info.getSectionValue("stencil", "blog title"))

    var blog_link_text = blog_info.getSectionValue("stencil", "blog link")
    
    let blog_link_uri = parseUri(blog_link_text)

    if blog_link_uri.scheme == "" or blog_link_uri.hostname == "":
        error "Invalid blog link in configuration. Please review."
        quit(QuitFailure)

    if blog_link_text[blog_link_text.high] != '/':
        blog_link_text = blog_link_text & "/"

    let blog_link = newElement("link") 
    blog_link.add newText (blog_link_text)

    let blog_description = newElement("description")
    blog_description.add newText (blog_info.getSectionValue("stencil", "blog description"))
    
    let blog_atom_link_attrs = {"href":blog_link_text, "rel":"self", "type":"application/rss+xml"}.toXmlAttributes
    let blog_atom_link = newElement("atom:link")
    blog_atom_link.attrs = blog_atom_link_attrs

    let blog_pubdate = newElement("pubDate")
    blog_pubdate.add newText ($(now().format(rssRFC822)))

    var items = newSeq[XmlNode]()
    items.add(blog_title)
    items.add(blog_link)
    items.add(blog_description)
    items.add(blog_atom_link)
    items.add(blog_pubdate)

    for file in walkFiles(path_prefix & "/posts/*.md"):
            #read markdown file
            let post_md = readFile(file)
            let (_,file_no_ext,_) = splitFile(file)
            
            #read post metadata
            let post_meta = loadConfig(path_prefix & posts_directory & file_no_ext & ".cfg")
            let title = post_meta.getSectionValue("stencil post", "post title")
            let date = post_meta.getSectionValue("stencil post", "post date")

            #turn into html
            let html = markdown(post_md)

            let final_html = apply_template(html_template,@{"title":title, "body":html, "author":author})
            
            #write html
            let post_filename = file_no_ext & ".html"
            var post_file = open(path_prefix & posts_directory & post_filename, mode = fmWrite)
            post_file.write(final_html)
            post_file.close()

            #add to rss item
            
            var item_title = newElement("title")
            item_title.add newText(title)
            let post_link = blog_link_text & posts_directory & file_no_ext & ".html"
            var item_link = newElement("link")
            item_link.add newText(post_link)
            var item_description = newElement("description")
            item_description.add newCData(html)
            var item_pubdate = newElement("pubDate")
            item_pubdate.add newText(date)
            let item_guid = newElement("guid") 
            item_guid.add newText (post_link)
            var item = newXmlTree("item", [item_title, item_guid, item_link, item_description, item_pubdate])
            items.add(item)

    var channel = newXmlTree("channel", items)
    let rss_attr = {"version": "2.0", "xmlns:atom":"http://www.w3.org/2005/Atom"}.toXmlAttributes
    var rss = newXmlTree("rss", [channel], rssAttr)

    let rss_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n" & $(rss)
    let rss_file = open(path_prefix&"rss.xml", mode=fmWrite)
    rss_file.write(rss_xml)
    rss_file.close()

    info "(Re)Generated blog and rss."
