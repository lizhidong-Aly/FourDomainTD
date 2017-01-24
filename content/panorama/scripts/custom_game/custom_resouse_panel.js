"use strict";
GameEvents.Subscribe( "UpdateResourceInfo", UpdateData);
function UpdateData(data){
	var panel=$.GetContextPanel().FindChildTraverse("CustomrResouseInfoPanel")
	if(panel!=null && panel.visible){
		$("#gold_data").text=MakeTextColor(data.gold,"gold");
		$("#essence_data").text=MakeTextColor(data.tech,"#00baff");
		$("#crystal_data").text=MakeTextColor(data.eh+"/"+data.eh_limit,"#b72cff");
		//$.Msg(Entities.IsOwnedByAnyPlayer( u ))
	}
}

function ShowResourceHelp(type){
	var title=$.Localize( "#resource_"+type )+$("#"+type+"_data").text;
	var des=$.Localize( "#resource_"+type+"_help" );
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $("#"+type), title,des);
}

function MakeTextColor(text,color){
	return "<font color='"+color+"'>"+text+"</font>";
}

function HideResourceHelp(){
	$.DispatchEvent( "DOTAHideTitleTextTooltip")
}

(function()
{
	$.Msg("custom_resource_panel.js is loaded")
})();
//url("s2r://panorama/images/hud/reborn/inventory_bg_bg_psd.vtex"