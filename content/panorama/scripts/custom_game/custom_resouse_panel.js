"use strict";
GameEvents.Subscribe( "UpdateResourceInfo", UpdateData);
function UpdateData(data){
	var panel=$.GetContextPanel().FindChildTraverse("CustomrResouseInfoPanel")
	if(panel!=null && panel.visible){
		$("#gold_data").text=data.gold;
		$("#essence_data").text=data.tech;
		$("#crystal_data").text=data.eh+"/"+data.eh_limit;
		//$.Msg(Entities.IsOwnedByAnyPlayer( u ))
	}
}

(function()
{
	$.Msg("custom_resource_panel.js is loaded")
})();
//url("s2r://panorama/images/hud/reborn/inventory_bg_bg_psd.vtex"