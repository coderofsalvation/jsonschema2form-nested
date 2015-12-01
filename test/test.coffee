jsdom = require('jsdom')
tinydown = require('tinydown')

html = '<body><div id="form"></div></body>';

jsdom.env html, ["http://code.jquery.com/jquery.js"], (err, window) ->

  $ = window.$

  jfn = require __dirname+'/../.'
  form = $('#form')[0]
  out = '''
    ## Basic setup
    
      Lets assume a `<div id="form"></div>` somewhere in your html, and this javascriptcode:

        jfn = require 'jsonschema2form-nested'
        jfn.render({ element:$('#foo')[0], schema:schema, data:data, ...});

    The default templates (residing in `jfn.template`) look like this by default:

    #{templates}
    
    > HINT: you might want to override these with your own [mustache](https://www.npmjs.com/package/micromustache) :)

  '''
  out = out.replace '#{templates}', jfn.htmlEncode JSON.stringify(jfn.template,null,2)
  
  runTest = (opts) ->
    args = 
      verbose: 1
      element: form
      schema: opts.schema
      data: opts.data
    jfn.render args
    value = $('#form')[0].innerHTML
    json = JSON.stringify opts.schema, null,2
    out += '''
      #### Example: #{title}
      
      ```<table width='100%'>
        <tr>
          <td width='50%'>#{value}</td>
          <td><code><pre>#{json}</pre></code></td>
        <tr>
      </table>```
    '''
    out = out.replace '#{title}', opts.title
    out = out.replace '#{json}', jfn.htmlEncode json
    out = out.replace '#{value}', value

  runTest 
    title: "simple"
    schema: 
      type: "object"
      properties:
        foo: type: "string", enum: ["foo","bar"], title: "Your title"
        bar: type: "integer", description: "integers are nice"
    data: {foo:"bar",bar:3}

  runTest 
    title: "type hinting"
    schema: 
      type: "object"
      properties:
        foo: type: "string", typehint: "rich"
    data: {foo:"bar",bar:3}

  require('fs').writeFileSync __dirname+"/test.html", out
  console.log out
  return

