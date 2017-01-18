"use strict";
GameEvents.Subscribe( "UpdateTowerInfo", UpdateData);
var info=null;
function UpdateData(data){
	info=data
	var panel=$.GetContextPanel().FindChildTraverse("CustomTowerInfoPanel")
	if(panel!=null && panel.visible){
		var u =Players.GetLocalPlayerPortraitUnit();
		info.minDmg=Entities.GetDamageMin(u);
		info.maxDmg=Entities.GetDamageMax(u);
		info.extraDmg=Entities.GetDamageBonus(u);
		var aveDmg=(info.minDmg+info.maxDmg)/2+info.extraDmg;
		info.spe=Entities.GetAttackSpeed(u);
		info.range=Entities.GetAttackRange(u);
		$("#dmg_data").text=aveDmg;
		$("#spe_data").text=Math.round(info.spe*100);
		$("#range_data").text=info.range;
		$("#cost_data").text=data.totalcost;
		$("#upcost_data").text=data.upcost;
		$("#attribute_data").text=data.attribute;
		//$.Msg(Entities.IsOwnedByAnyPlayer( u ))
	}
}

function ShowDetailedInfo(data){
	var des=null;
	var tittle='详细属性';
	var context=$.GetContextPanel().FindChildTraverse("TowerDmgInfo");
	var u =Players.GetLocalPlayerPortraitUnit();
	if(info!=null){
		if(data=="a"){
			des=' 攻击力:'+info.minDmg+'-'+info.maxDmg;
			if(info.extraDmg>1){
				des=des+'('+'+'+info.extraDmg+')';
			}
			var attInterval=Math.round((info.bat/info.spe)*100)/100
			des=des+'<br>'+'攻击速度:'+Math.round(info.spe*100)+'('+attInterval+'秒攻击一次'+')';
			des=des+'<br>'+'射程:'+info.range;
			$.DispatchEvent( "DOTAShowTitleTextTooltip", context, tittle,des);
		}else{
			context=$.GetContextPanel().FindChildTraverse("TowerCostInfo");
			des='总计花费:'+info.totalcost;
			des=des+'<br>'+'升级需要:'+info.upcost;
			des=des+'<br>'+'水晶占用:'+info.eh;
			des=des+'<br>'+'属性:'+info.attribute;
			$.DispatchEvent( "DOTAShowTitleTextTooltip", context, tittle,des);
		}
	}
}

function HideToolTips(){
	//GameEvents.SendCustomGameEventToServer( "ClearAttackRange", {} );
	$.DispatchEvent( "DOTAHideTitleTextTooltip");
}

(function()
{
	$.Msg("custom_status_panel.js is loaded")
})();
//url("s2r://panorama/images/hud/reborn/inventory_bg_bg_psd.vtex"