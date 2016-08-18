JFN
===

<img alt="" src="http://www.gifbin.com/bin/102009/1254478578_robot_hand.gif"/><br>
nested jsonschema html form builder: A simple javascript based form generator based on json-schema.

* zero dependencies
* easily extendable 
* finally a jsonform generator which supports nesting
* serialize (nested) formvalues back to json
* 3.8K gzipped (unlike JSONform or apalca)

<img src="https://raw.githubusercontent.com/coderofsalvation/jsonschema2form-nested/master/screenshot.png"/>

## Usage 

    npm install jsonschema2form

or 
    
    <script src="jsonschema2form.min.js"></script>

## Basic setup

Supereasy: just a `<div id="form"></div>` somewhere in your html, and this javascriptcode:

    jfn = require 'jsonschema2form-nested'
    jfn.render({ element:$('#foo')[0], schema:schema, data:data});

## Demo

See examples [here](https://rawgit.com/coderofsalvation/jsonschema2form-nested/master/test/test.html)

## Extending 

JFN uses a small template engine [mustache](https://www.npmjs.com/package/micromustache).

#### Templates

The default templates (residing in `jfn.template`) look like this by default:

    jfn.template:
      nestingtag: 'fieldset'
      nesting: '<fieldset class="{{id}} nested">{{name}}{{button_del}}{{html}}</fieldset>'
      array_header: '<span class="array {{id}} {{class}}">{{title}}'
      array_footer: '</span>'
      button_add: '<button class="button_add" name="{{id}}">+ {{title}}</button>'
      button_del: '<button class="button_del" name="{{id}}">&ndash;</button>'
      label: '<div><label class="hide">{{title}}</label></div>'
      types:
        default: '<div>{{label}}<input type="text" value="{{data}}" id="{{id}}" placeholder="{{placeholder}}" class="{{type}} {{attributes}}"/><span class="description">{{description}}</span></div>'+"\n"
        boolean_selected: 'checked="checked"'
        'string.rich': '<div>{{#title}}<label class="hide">{{title}}</label>{{/title}}<textarea placeholder="{{description}}">{{data}}</textarea></div>'+"\n"
        string_enum: '<div>{{label}}<select>{{values}}</select></div>'+"\n"
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

You even apply mustache on it recursively and/or create conditionals, exceptions etc:

    jfn.template_data.label = () -> 
      ( if @title? then jfn.mustache.render "<h3>{{title}}</h3>", {title:@title} else "" )

## TODO

* selective html encoding based on propertyname instead of field
