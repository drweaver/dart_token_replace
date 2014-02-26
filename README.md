##dart_token_replace

A simple dart command line and library for performing token replace

Tokens are defined as ```@@token_name@@``` syntax:

```html
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

###Command-line Usage

Replacements are defined in replace.json file:

```json
{
  "replace":
    {
      "title": "My Site",
      "content": "Page under construction",
      "img_num": { "type": "random", "min": 1, "max": 50 }
    },
  "output":
    [
      {
        "output_file": "about.html",
        "replace": 
          {
             "title": { "type": "string", "string": "My Site - About" },
             "content": "This is some information about my site"
          }
      },
      {
        "output_file": "home.html",
        "replace": 
          {
            "content": { "type": "file", "file": "home_content.html" }
          }
      },
      {
        "output_file": "contact.html"
      }
    ]
}
```
The top ```replace``` section contains default replacements for each ```output```.  
These can be overwridden in the ```output``` section if required. 

```bash
dart /path/to/apply_token_replace.dart template_file replace.json
```

###Library Usage

Add as a dependency in your pubspec.yaml:

```yaml
dependencies:
  token_replace: any
```

###To Do

 - command line args for: token not found behaviour, etc
 - closing files correctly after read/write is completed
 - wait at end of main method - replaceAll must return a future?
 - set different patterns
 - unit tests
 - Check string or file key is defined and error gracefully
 - Sync method in lib - is there any need for async method?
 - Work with streams instead of files?
 - onDone callback
