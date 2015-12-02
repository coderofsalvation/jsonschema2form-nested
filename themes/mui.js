jfn_theme_mui = function(jfn){
  jfn.template.nestingtag = 'div'
  jfn.template.nesting = jfn.template.nesting.replace(/fieldset/,'div');
  arr = ["string","integer","number"]
  for( i in arr )
    jfn.template.types[ arr[i] ] = jfn.template.types.default.replace(/^<div>/,'<div class="mui-textfield">');
  jfn.template.types.string_enum = jfn.template.types.string_enum.replace(/^<div>/,'<div class="mui-select">');
  //jfn.template.button_add = jfn.template.button_add.replace(/class="/,'class="mui-btn mui-btn--fab mui-btn--primary ');
}

try{ 
  if( module != undefined && module.exports != undefined )
    module.exports = jfn_theme_mui 
}catch(e){}

