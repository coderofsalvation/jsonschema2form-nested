jsdom = require('jsdom')
tinydown = require('tinydown')

html = '<body><div id="form"></div></body>';

jsdom.env html, ["http://code.jquery.com/jquery.js"], (err, window) ->

  $ = window.$

  jfn = require __dirname+'/../.'
  form = $('#form')[0]
  out = '<h1>JFN <br><img alt="" src="http://www.gifbin.com/bin/102009/1254478578_robot_hand.gif"/></h1>'
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
      <h3>Example: #{title}</h3>
      
      <table width='100%'>
        <tr>
          <td width='50%'>#{value}</td>
          <td><code><pre>#{json}</pre></code></td>
        <tr>
      </table>
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

