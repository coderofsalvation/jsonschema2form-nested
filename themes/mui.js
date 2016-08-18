jfn_theme_mui = function(jfn){
  jfn.template.nestingtag = 'div'
  jfn.template.nesting = jfn.template.nesting.replace(/fieldset class="/,'div class="mui-panel ').replace(/fieldset/, "div")
  arr = ["string","integer","number"]
  for( i in arr )
    jfn.template.types[ arr[i] ] = jfn.template.types.default.replace(/^<div>/,'<div class="mui-row"><div class="mui-col-md-4 mui-textfield">')+'</div>'
  jfn.template.types.string_enum = jfn.template.types.string_enum.replace(/^<div>/,'<div class="mui-row"><div class="mui-col-md-4 mui-select">')+'</div>'
  //jfn.template.button_add = '<button name="{{id}}" class="button_add mui-btn mui-btn--small mui-btn--fab">+</button>'
  //jfn.template.button_del = '<button name="{{id}}" class="button_del mui-btn mui-btn--small mui-btn--primary mui-btn--flat">&ndash;</button>'
}

try{ 
  if( module != undefined && module.exports != undefined )
    module.exports = jfn_theme_mui 
}catch(e){}

