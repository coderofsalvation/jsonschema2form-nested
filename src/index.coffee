JFN = 
  nextid: 1
  element: false 
  data: {}
  validator: false
  iddata: {}
  mustache: require 'micromustache'
  verbose: 0
  htmlEncodeFields: ['title','description']
  template:
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

for type in ["integer","number","boolean","string","string.rich"]
  JFN.template.types[ type ] = JFN.template.types.default

JFN.template_data = {}
JFN.template_data.label = () -> 
  @title = "&nbsp" if not @title? 
  JFN.mustache.render JFN.template.label, {title:@title} 

JFN.htmlEncode = (html) ->
  String(html).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace />/g, '&gt;'

JFN.htmlDecode = (html) ->
  String(html).replace(/&quot;/g, '"').replace(/&#39;/g, '\'').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace /&amp;/g, '&'

JFN.extend = (source, obj, clone) ->
  prop = undefined; v = undefined
  return source if not source? or source == null or not obj?
  for prop of obj
    v = obj[prop]
    if source[prop] != null and typeof source[prop] == 'object' and typeof obj[prop] == 'object'
      @extend source[prop], obj[prop]
    else
      if clone
        source[prop] = @clone
      else
        source[prop] = obj[prop]
  source

JFN.setSchema = (schema, loadSchemaCB) ->
  @schema = @fixupSchema(schema)
  @schemaCB = loadSchemaCB
  return

JFN.uniqueName = ->
  'jfn_' + ++@nextid

JFN.hasClass = (el, name) ->
  new RegExp('(\\s|^)' + name + '(\\s|$)').test el.className

JFN.addClass = (el, name) ->
  if !@hasClass(el, name)
    el.className += (if el.className then ' ' else '') + name
  return

JFN.removeClass = (el, name) ->
  if @hasClass(el, name)
    el.className = el.className.replace(new RegExp('(\\s|^)' + name + '(\\s|$)'), ' ').replace(/^\s+|\s+$/g, '')
  return

JFN.mergeSchema = (a, b) ->
  for p of b
    try
      if b[p].constructor == Object
        a[p] = @mergeSchema(a[p], b[p])
      else
        a[p] = b[p]
    catch e
      a[p] = b[p]
  a

JFN.fixupSchema = (schema) ->
  if !@schemaCB

    ### We can't do much if we can't load more schema ###

    return schema
  if !schema.type
    if schema.items
      schema.type = 'array'
    else if schema.properties
      schema.type = 'object'
  if schema and schema['$ref']
    schema = @schemaCB(schema['$ref'])

  ###Clone the object so we don't mess with the original ###

  schema = JSON.parse(JSON.stringify(schema))
  extendlist = []
  switch typeof schema['extends']
    when 'string'
      extendlist = [ schema['extends'] ]
    when 'object'
      extendlist = schema['extends']
  delete schema['extends']
  i = 0
  e = undefined
  while e = extendlist[i]
    supero = undefined
    nschema = {}
    if !(supero = @schemaCB(e))
            i++
      continue
    schema = @mergeSchema(schema, supero)
    i++
  schema

JFN.renderHTML = (schema, name, data, options) ->
  throw 'JFN_SCHEMA_UNDEFINED' if not schema?
  data = "" if not data?
  `var i`
  `var i`
  id = @uniqueName()
  schema = @fixupSchema(schema)
  schema = JSON.parse JSON.stringify schema
  @extend schema, @template_data

  # rebind so 'this' is static so mustache won't mess 'this' up ...nice..2 wordjokes! :)
  schema[k] = (v).bind( schema ) if typeof v == 'function' for k,v of JFN.template_data

  schema.id = id
  schema.data = @htmlEncode data
  @iddata[id] =
    schema: schema
    name: name
  options = options or {}
  html = ''
  value = undefined
  type = undefined
  for i in @htmlEncodeFields
    schema[i] = @htmlEncode schema[i] if schema[i]?
  schema.title = schema.title || name
  switch typeof schema.type
    when 'string'
      type = schema.type
    when 'undefined'
      type = 'object'
    when 'object'
      ###
      	If multiple types are allowed attempt to use array, since it is
      	the most complex one that we support.

      	For example:
      		[ 'string', 'array' ]
      ###
      if -1 != schema.type.indexOf('array')
        type = 'array'
      else
        type = schema.type[0]
  @iddata[id].type = type
  if schema['enum'] and !schema.hidden
    values = []
    if !schema.required
      ### Insert a blank item; this field isn't required ###
      values.push @mustache.render @template.types.string_enum_value, {}
    i = 0
    e = undefined
    while e = schema['enum'][i]
      schema.value = e
      schema.selected = ""
      schema.selected = @template.types.string_enum_value_selected if data and data == e
      values.push @mustache.render @template.types.string_enum_value, schema
      i++
    schema.values = values.join ''
    html += @mustache.render @template.types.string_enum, schema
  else
    classname = type
    switch type
      when 'string'
        schema.placeholder = schema.placeholder || schema.title || name || schema.description
        schema.placeholder = "Enter "+schema.placeholder.toLowerCase()+" here" if schema.placeholder
        if not schema.typehint?
          html += @mustache.render @template.types.string, schema
        else
          schema.data = @htmlDecode schema.data
          html += @mustache.render @template.types[ type+'.'+schema.typehint ], schema
        break

      # fallthrough 
      when 'number', 'integer', 'boolean'
        schema.attributes = @mustache.render @template.types.boolean_selected, schema if type == "boolean" and data
        html += @mustache.render @template.types[ type ], schema
      when 'array'
        item = undefined
        if item = schema.items
          item = item[0] if item[0]?
          @iddata[id].action = 'add'
          @iddata[id].item = item
          html += @mustache.render @template.array_header,
            id: id
            class: classname
          html += @mustache.render @template.button_add, schema
          ###
            Assume that this is intended to be an array of this
            item, which is possible if the item has multiple
            allowed types.
            Let validation sort it out later. Just try to render
            it now.
          ###
          data = [ data ]
          break
          if data
            was = item.readonly or false
            if schema.preserveItems
              item.readonly = true
            values = []
            i = 0
            while i < data.length
              values.push @insertArrayItem(item, data[i], options, schema.readonly or schema.preserveItems)
              i++
            html += @mustache.render @template.nesting, { html: values.join(''), id: id }
            if schema.preserveItems
              item.readonly = was
          html += @mustache.render @template.array_footer, {}
      when 'object'
        if schema.properties
          i = 0; p = undefined ; values = ""
          if options.schema.button_del
            values += @mustache.render @template.button_del, {id:id} 
            @iddata[id] =
              schema: options.schema
              data: null
              action: 'del'
          properties = Object.keys(schema.properties)
          while p = schema.properties[properties[i]]
            values += @renderHTML(p, properties[i], (data or {})[properties[i]], options)
            i++
          html += @mustache.render @template.nesting, { html: values, id: id }

        if item = schema.patternProperties
          # TODO	Write me
          html = ''
  html

JFN.insertArrayItem = (item, data, options, readonly) ->
  id = @uniqueName()
  html = ''
  data = data || {}
  options.schema.button_del = true if not options.schema.readonly 
  html += @renderHTML(item, null, data, options)
  html

JFN.render = (options) ->
  @schema = options.schema if options.schema?
  @element = options.element if options.element?
  @data = options.data if options.data?
  html = @renderHTML(@schema, null, @data, options or {})
  @element.innerHTML = html
  @element.addEventListener 'click', ((e) ->
    `var container`
    detail = undefined
    target = null
    if e
      target = e.toElement or e.target
    console.dir(e)
    console.log target.tagName
    if target.tagName.toLowerCase() is "input"
      Array.prototype.slice.call( document.querySelectorAll("label") ).map (item) -> item.className = "hide"
      Array.prototype.slice.call( document.querySelectorAll("span.description")  ).map (item) -> item.className = "description hide"
      target.parentNode.querySelector("label").className = "animated bounce"
      description = target.parentNode.querySelector("span.description")
      description.className = "description" if description
    return if !target or !(detail = @getDetail(target))
    switch detail.action
      when 'add'
        container = undefined
        item = undefined
        #if (container = target.parentNode) and (container = container.querySelector('.button_add'))
        #  container = container[0]
        container = target.parentNode
        console.dir container
        if !container and (container = document.createElement( @template.nestingtag ))
          if target.nextSibling
            target.parentNode.insertBefore container, target.nextSibling
          else
            target.parentNode.appendChild container
        if container
          span = document.createElement('span')
          span.innerHTML = @insertArrayItem(detail.item, detail.data, options)
          container.appendChild span
        @validate()
      when 'del'
        container = undefined
        p = undefined
        if detail and target and (container = target.parentNode)
          p = container.parentNode
          console.dir(p)
          p.removeChild container
          if !p.firstChild
            p.parentNode.removeChild p
        @validate()
    return
  ).bind(this)
  @element.addEventListener 'change', ((e) ->
    @validate()
    return
  ).bind(this)
  @validate()
  @addClass @element, 'jfn'
  return

JFN.getDetail = (el) ->
  if !el
    return null
  if el.name
    return @iddata[el.name]
  if el.className
    classes = el.className.split(' ')
    i = 0
    c = undefined
    while c = classes[i]
      if 0 == c.indexOf('jfn_')
        return @iddata[c]
      i++
  null

JFN.getValue = (element) ->
  value = undefined
  detail = null
  switch element.nodeName.toLowerCase()
    when 'button'
      return null
  detail = @getDetail(element)
  if detail and detail.schema
    switch detail.type
      when 'object'
        value = {}
        i = 0
        n = undefined
        while n = element.childNodes[i]
          v = undefined
          d = undefined
          if !(d = @getDetail(n)) or !d.name
                        i++
            continue
          if v = @getValue(n)
            value[d.name] = v
          i++
        return value
      when 'array'
        fieldset = null
        if !isNaN(detail.schema.minItems) and detail.schema.minItems > 0

          ### Always include an array that requires items ###

          value = []
        i = 0
        n = undefined
        while n = element.childNodes[i]
          if n.nodeName.toLowerCase() == @template.nestingtag
            fieldset = n
            break
          i++
        if fieldset
          i = 0
          n = undefined
          while n = fieldset.childNodes[i]
            v = undefined
            if v = @getValue(n)
              if !value
                value = []
              value.push v
            i++
        return value
  switch element.nodeName.toLowerCase()
    when 'textarea', 'input'
      if !detail
        break
      switch detail.type
        when 'string'
          if element.value and element.value.length > 0
            value = element.value
        when 'number', 'integer'
          value = parseInt(element.value)
          if isNaN(value)
            value = undefined
        when 'boolean'
          value = element.checked
    when 'select'
      if !detail
        break
      if detail.schema.required or element.selectedIndex > 0
        value = element.options[element.selectedIndex].value
    else

      ### Get the first child's value ###

      i = 0
      n = undefined
      while n = element.childNodes[i]
        if value = @getValue(n)
          break
        i++
      break
  value

JFN.validate = (el) ->
  detail = undefined
  valid = true
  value = undefined
  if !(el = el or @element)
    return true
  switch el.nodeName.toLowerCase()
    when 'label', 'button'

      ### Ignore add and remove buttons ###

    else
      @removeClass el, 'invalid'
      try
        el.removeAttribute 'title'
      catch e
      if detail = @getDetail(el)
        if @validator
          value = @getValue(el)

          ### Use jsonschema validator if loaded ###

          if value and !@validator.validate(value, detail.schema, false, true)
            console.log validator.error
            @addClass el, 'invalid'
            el.setAttribute 'title', @validator.error.message
            valid = false
        else if detail.schema.required

          ### Very simple built in validation ###

          if !el.value or el.value.length == 0
            @addClass el, 'invalid'
            valid = false
      break
  i = 0
  n = undefined
  while n = el.childNodes[i]
    if !@validate(n)
      valid = false
    i++
  valid

JFN.toJSON = ( element ) ->
  @getValue element

module.exports = JFN
