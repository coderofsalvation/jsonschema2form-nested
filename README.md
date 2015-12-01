JFN
===

<img alt="" src="http://www.gifbin.com/bin/102009/1254478578_robot_hand.gif"/>
nested jsonschema html form builder: A simple javascript based form generator based on json-schema.

* zero dependencies
* easily extendable 

## Basic setup

  Lets assume a `<div id="form"></div>` somewhere in your html, and this javascriptcode:

    jfn = require 'jsonschema2form-nested'
    jfn.render({ element:$('#foo')[0], schema:schema, data:data, ...});

## Demo

See examples [here](https://rawgit.com/coderofsalvation/jsonschema2form-nested/master/test/test.html)

## Extending 

JFN uses a small template engine [mustache](https://www.npmjs.com/package/micromustache).

#### Templates

The default templates (residing in `jfn.template`) look like this by default:

    jfn.template:
      nestingtag: 'fieldset'
      nesting: '<fieldset class="{{id}}">{{html}}</fieldset>'
      types:
        default: '<span>{{#title}}<label>{{title}}</label>{{/title}}<input type="text" value="{{data}}" id="{{id}}" class="{{type}} {{class}}"/>{{description}}</span>'+"\n"
        'string.rich': '<span>{{#title}}<label>{{title}}</label>{{/title}}<textarea>{{data}}</textarea></span>'+"\n"
        string_enum: '<select>{{values}}</select>'+"\n"
        string_enum_value: '<option value="{{value}}" {{selected}}>{{value}}</option>'
        string_enum_value_selected: 'selected="selected"'
    
> HINT: you might want to override these with your own [mustache](https://www.npmjs.com/package/micromustache) templatestrings :)

Every jsonschematype which isn't defined will be rendered using the `default` template.
So in order to render an property integer-type from a jsonschema, customize it like so:

    jfn.template.types.integer = '<input type='number' value="{{data}}"/>';
    jfn.render({..})

#### Functions

Global vars/functions are supported too:

    jfn.template_data.foo = "hi"
    jfn.template_data.world = function(){ return "world!"; }
    jfn.template.types.integer = '<input type='number' value="{{data}}" class="{{foo}} {{world}}"/>';
    jfn.render({..})

## TODO

* selective html encoding based on propertyname instead of field
