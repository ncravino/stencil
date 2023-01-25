const posts_directory* = "posts/"
const template_directory* = "templates/"
const blog_info_file* = "blog_info.cfg"
const rssRFC822* = "ddd, dd MMM YYYY HH:mm:ss ZZZ"

const default_template* = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="author" content="{{{author}}}">
  <title>{{{title}}}</title>
</head>
<body>
{{{body}}}
</body>

</html>
""" 