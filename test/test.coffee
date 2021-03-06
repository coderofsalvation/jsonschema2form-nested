jsdom = require('jsdom')

html = '<body><div id="form"></div></body>';

jsdom.env html, ["http://code.jquery.com/jquery.js"], (err, window) ->

  $ = window.$

  jfn = require __dirname+'/../.'
  form = $('#form')[0]
  out = '''
    <html>
      <head>
        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
      </head> 
    <body style="padding:50px">

    <h1>JFN Examples<br><img alt="" style='width:100px' src="http://www.gifbin.com/bin/102009/1254478578_robot_hand.gif"/></h1>
    <br>
    For docs see <a href="https://github.com/coderofsalvation/jsonschema2form-nested">here</a><br><Br>
    '''

  runTest = (opts) ->
    console.dir opts.data
    args = 
      verbose: 1
      element: form
      schema: opts.schema
      data: opts.data
    jfn.render args
    value = $('#form')[0].innerHTML
    json = JSON.stringify opts.schema, null,2
    out += '''
    
      <div class="panel panel-default">
        <div class="panel panel-primary">
          <div class="panel panel-heading">
            Example: #{title}
          </div>
          <div class="panel panel-body">
            <table style='width:100%'>
              <tr>
                <td style='width:50%;vertical-align:top'>#{value}</td>
                <td>
                    <b>data:</b><hr>
                    <code><pre>#{data}</pre></code>
                    <b>schema:</b><hr>
                    <code><pre>#{json}</pre></code>
                </td>
              <tr>
            </table>
          </div>
        </div>
      </div>
    '''
    out = out.replace '#{title}', opts.title
    out = out.replace '#{json}', jfn.htmlEncode json
    out = out.replace '#{data}', jfn.htmlEncode JSON.stringify(opts.data,null,2)
    out = out.replace '#{value}', value
    if JSON.stringify(jfn.toJSON(form)) == "{}"
      console.log "\n!!! out:\n\n"+JSON.stringify jfn.toJSON(form),null,2
      process.exit 1 

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
  
  runTest 
    title: "arrays"
    schema: 
      type: "object"
      properties:
        persons: 
          type: "array"
          items: [{
            name:
              type: "string"
            age:
              type: "integer"
            }]
    data: {persons:[{name:"john doe",age:12}] }

  out += '</body></html>'
  orig = require('fs').readFileSync(__dirname+"/testout.html").toString()
  require('fs').writeFileSync __dirname+"/testout.html", out
  if out != orig and not process.env.DEBUG?
    console.log "generated output does not match desired output :/"
    process.exit 1 
  return

