##dart_token_replace

A simple dart command line and library for performing token replace

Tokens are defined as ```@@token_name@@``` syntax. e.g.

```
<html>
  <head>
    <title>@@title@@</title>
  </head>
 
  <body>   
    <h1>@@title@@</h1>
    <p>@@content@@</p>
  </body>
</html>
```

Replacements are defined in replace.json file e.g.

```json
[
  {
    "output_file": "about.html",
    "replace": 
      {
         "title": "My Site - About" ,
         "content": "This is some information about my site" 
      }
  },
  {
    "output_file": "home.html",
    "replace": 
      {
        "title": { "type": "string", "string": "My Site"  },
        "content": { "type": "file", "file": "home_content.html" }
      }
  }
]
```

###Command-line Usage

```bash
dart apply_token_replace.dart template_file replace.json
```

###Library Usage

TBD