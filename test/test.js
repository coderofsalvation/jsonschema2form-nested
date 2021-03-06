// Generated by CoffeeScript 1.10.0
(function() {
  var html, jsdom, tinydown;

  jsdom = require('jsdom');

  tinydown = require('tinydown');

  html = '<body><div id="form"></div></body>';

  jsdom.env(html, ["http://code.jquery.com/jquery.js"], function(err, window) {
    var $, form, jfn, orig, out, runTest;
    $ = window.$;
    jfn = require(__dirname + '/../.');
    form = $('#form')[0];
    out = '<html>\n  <head>\n    <!-- Latest compiled and minified CSS -->\n    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">\n    <!-- Optional theme -->\n    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">\n  </head> \n<body style="padding:50px">\n\n<h1>JFN Examples<br><img alt="" style=\'width:100px\' src="http://www.gifbin.com/bin/102009/1254478578_robot_hand.gif"/></h1>\n<br>\nFor docs see <a href="https://github.com/coderofsalvation/jsonschema2form-nested">here</a><br><Br>';
    runTest = function(opts) {
      var args, json, value;
      args = {
        verbose: 1,
        element: form,
        schema: opts.schema,
        data: opts.data
      };
      jfn.render(args);
      value = $('#form')[0].innerHTML;
      json = JSON.stringify(opts.schema, null, 2);
      out += '    \n<div class="panel panel-default">\n  <div class="panel panel-primary">\n    <div class="panel panel-heading">\n      Example: #{title}\n    </div>\n    <div class="panel panel-body">\n      <table style=\'width:100%\'>\n        <tr>\n          <td style=\'width:50%;vertical-align:top\'>#{value}</td>\n          <td>\n              <b>data:</b><hr>\n              <code><pre>#{data}</pre></code>\n              <b>schema:</b><hr>\n              <code><pre>#{json}</pre></code>\n          </td>\n        <tr>\n      </table>\n    </div>\n  </div>\n</div>';
      out = out.replace('#{title}', opts.title);
      out = out.replace('#{json}', jfn.htmlEncode(json));
      out = out.replace('#{data}', jfn.htmlEncode(JSON.stringify(opts.data, null, 2)));
      return out = out.replace('#{value}', value);
    };
    runTest({
      title: "simple",
      schema: {
        type: "object",
        properties: {
          foo: {
            type: "string",
            "enum": ["foo", "bar"],
            title: "Your title"
          },
          bar: {
            type: "integer",
            description: "integers are nice"
          }
        }
      },
      data: {
        foo: "bar",
        bar: 3
      }
    });
    runTest({
      title: "type hinting",
      schema: {
        type: "object",
        properties: {
          foo: {
            type: "string",
            typehint: "rich"
          }
        }
      },
      data: {
        foo: "bar",
        bar: 3
      }
    });
    runTest({
      title: "arrays",
      schema: {
        type: "object",
        properties: {
          persons: {
            type: "array",
            items: [
              {
                name: {
                  type: "string"
                },
                age: {
                  type: "integer"
                }
              }
            ]
          }
        }
      },
      data: {
        persons: [
          {
            name: "john doe",
            age: 12
          }
        ]
      }
    });
    out += '</body></html>';
    orig = require('fs').readFileSync(__dirname + "/testout.html").toString();
    require('fs').writeFileSync(__dirname + "/testout.html", out);
    if (out !== orig && (process.env.DEBUG == null)) {
      console.log("generated output does not match desired output :/");
      process.exit(1);
    }
  });

}).call(this);
