JFN
===

nested jsonschema html form builder: A simple javascript based form generator based on json-schema


## Basic setup

  Lets assume a `<div id="form"></div>` somewhere in your html, and this javascriptcode:

    jfn = require 'jsonschema2form-nested'
    jfn.render({ element:$('#foo')[0], schema:schema, data:data, ...});

The default templates (residing in `jfn.template`) look like this by default:

{
  &quot;nestingtag&quot;: &quot;fieldset&quot;,
  &quot;nesting&quot;: &quot;&lt;fieldset class=\&quot;{{id}}\&quot;&gt;{{html}}&lt;/fieldset&gt;&quot;,
  &quot;types&quot;: {
    &quot;default&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;,
    &quot;string.rich&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;,
    &quot;string_enum&quot;: &quot;&lt;select&gt;{{values}}&lt;/select&gt;\n&quot;,
    &quot;string_enum_value&quot;: &quot;&lt;option value=\&quot;{{value}}\&quot; {{selected}}&gt;{{value}}&lt;/option&gt;&quot;,
    &quot;string_enum_value_selected&quot;: &quot;selected=\&quot;selected\&quot;&quot;,
    &quot;integer&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;,
    &quot;number&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;,
    &quot;boolean&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;,
    &quot;string&quot;: &quot;&lt;span&gt;{{#title}}&lt;label&gt;{{title}}&lt;/label&gt;{{/title}}&lt;input type=\&quot;text\&quot; value=\&quot;{{data}}\&quot; id=\&quot;{{id}}\&quot; class=\&quot;{{type}} {{class}}\&quot;/&gt;{{description}}&lt;/span&gt;\n&quot;
  }
}

> HINT: you might want to override these with your own [mustache](https://www.npmjs.com/package/micromustache) :)
#### Example: simple

```<table width='100%'>
  <tr>
    <td width='50%'><fieldset class="jfn_2"><select><option value=""></option><option value="foo">foo</option><option value="bar">bar</option></select>
<input name="jfn_4" type="text" class="integer" value="3">
<br>
</fieldset></td>
    <td><code><pre>{
  &quot;type&quot;: &quot;object&quot;,
  &quot;properties&quot;: {
    &quot;foo&quot;: {
      &quot;type&quot;: &quot;string&quot;,
      &quot;enum&quot;: [
        &quot;foo&quot;,
        &quot;bar&quot;
      ],
      &quot;title&quot;: &quot;Your title&quot;
    },
    &quot;bar&quot;: {
      &quot;type&quot;: &quot;integer&quot;,
      &quot;description&quot;: &quot;integers are nice&quot;
    }
  }
}</pre></code></td>
  <tr>
</table>```#### Example: type hinting

```<table width='100%'>
  <tr>
    <td width='50%'><fieldset class="jfn_5"><span><label></label><input type="text" value="bar" id="" class="string "></span>
</fieldset></td>
    <td><code><pre>{
  &quot;type&quot;: &quot;object&quot;,
  &quot;properties&quot;: {
    &quot;foo&quot;: {
      &quot;type&quot;: &quot;string&quot;,
      &quot;typehint&quot;: &quot;rich&quot;
    }
  }
}</pre></code></td>
  <tr>
</table>```
