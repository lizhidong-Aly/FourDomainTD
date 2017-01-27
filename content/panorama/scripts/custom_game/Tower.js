"use strict";

var tittle;
var des;
var context=$.GetContextPanel()
function SetTower(imageName,unlock){
	$("#TowerImage").heroname=imageName;
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:context.id} );
	$("#TowerLocker").SetHasClass("enable",unlock);
}

function ShowToolTip(){
	$.DispatchEvent( "DOTAShowTitleTextTooltip", context, tittle,des);
}

function SetTowerInfo(data){
	if(data.entry=="help" || data.name!=context.id){
		return;
	}
	HideTowerDes()
	var type =data.name;
	var button = $("#"+ type );
	tittle = $.Localize( "#Summon" )+$.Localize( "#"+type );
	des = "";
	if (!$("#TowerLocker").BHasClass("enable")){
		des=des + $.Localize( "#TowerLocked" );
	}
	des=des + $.Localize( "#TowerDesA" ) + DecodeAttribute(data.attri) ;
	des=des + $.Localize( "#TowerDesB" )+ "<font color='gold'> " + data.cost + " </font>黄金 以及" + "<font color='#b72cff'> " + data.eh + " </font>水晶";
	$("#GoldCost").text=data.cost;
	des=des + $.Localize( "#TowerDesC" ) + data.dmg;
	des=des + $.Localize( "#TowerDesD" ) + Math.round(data.spe*100)/100;
	des=des + $.Localize( "#TowerDesE" ) + data.range;
	for(var i=1;typeof(data.aname[i])=="string";i++){
			des=des+ $.Localize( "#TowerDesF" ) + $.Localize( "#DOTA_Tooltip_ability_" + data.aname[i]);
			des=des + $.Localize( "#TowerDesG" ) + $.Localize( "#DOTA_Tooltip_ability_" + data.aname[i] + "_Description");
			if(typeof(data.aname[i+1])=="string"){
				des=des+"<br>";
			}
		}
}

function DecodeAttribute(attribute){
	var text='';
	for(var i=0;i<attribute.length;i++){
		text=text+$.Localize( "#"+attribute[i] );
		if(i<attribute.length-1){
			text=text+"-";
		}
	}
	return text;
}

function BuildTower(name) {
	if ($("#TowerLocker").BHasClass("enable")){
		var builder=Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
		var ability = Entities.GetAbilityByName(builder,"SelectPosition");
		Abilities.ExecuteAbility( ability, builder, false );
		GameEvents.SendCustomGameEventToServer( "SetTowerType", {type:context.id} );
	}
	else {
		Game.EmitSound("General.Cancel");
	}
}

function HideTowerDes(){
	$.DispatchEvent( "DOTAHideTitleTextTooltip",context);
}

(function()
{
	context.SetTower = SetTower;
	GameEvents.Subscribe( "TowerInfoSent", SetTowerInfo);
	GameEvents.Subscribe( "MenuSwtich", HideTowerDes);
})();