"use strict";

var towerId="";
var desPanelList=[];
var tittle;
var des;
function SetTower(imageName,unlock){
	$("#TowerImage").heroname=imageName;
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:$.GetContextPanel().id} );
	$("#TowerLocker").SetHasClass("enable",unlock);
}

function ShowToolTip(){
	var buiPanel=$.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent();
	var desPanel = $.CreatePanel( "Panel", buiPanel, "TowerToolTop" );
	desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
	var cursor = GetPercPos();
	desPanel.style.x=cursor[0];
	desPanel.style.y=cursor[1];
	desPanel.style.z="10px";
	desPanel.style.width="360px";
	desPanel.GetChild(0).GetChild(0).text=tittle;
	desPanel.GetChild(0).GetChild(1).text=des;
	desPanelList.push(desPanel);
}

function SetTowerInfo(data){
	if(data.entry=="help" || data.name!=$.GetContextPanel().id){
		return;
	}
	HideTowerDes()
	var type =data.name;
	var button = $("#"+ type );
	tittle = $.Localize( "#Summon" )+$.Localize( "#"+type );
	var attri="";
	for(var i=0;i<data.attri.length;i++){
		attri=attri+$.Localize( "#"+data.attri[i] );
		if(i<data.attri.length-1){
			attri=attri+"-";
		}
		
	}

	des = "";
	if (!$("#TowerLocker").BHasClass("enable")){
		des=des + $.Localize( "#TowerLocked" );
	}
	des=des + $.Localize( "#TowerDesA" ) + attri ;
	des=des + $.Localize( "#TowerDesB" ) + "<font color='gold'>" + data.cost + "</font>" ;
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
	//$.DispatchEvent( "DOTAShowTitleTextTooltipStyled", button, tittle , des,'test');
}


function GetPercPos(posa,posb){
	var cPos=GameUI.GetCursorPosition();
	cPos[0]=((cPos[0])/Game.GetScreenWidth())*100+2.5+"%";
	cPos[1]=((cPos[1])/(Game.GetScreenHeight()/0.808))*100+3+"%";
	return cPos;
}


function BuildTower(name) {
	if ($("#TowerLocker").BHasClass("enable")){
		var builder=Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
		var ability = Entities.GetAbilityByName(builder,"SelectPosition");
		Abilities.ExecuteAbility( ability, builder, false );
		GameEvents.SendCustomGameEventToServer( "SetTowerType", {type:$.GetContextPanel().id} );
	}
	else {
		Game.EmitSound("General.Cancel");
	}
}

function HideTowerDes(){
	for(var i=desPanelList.length;i>0;i--){
		desPanelList[i-1].RemoveAndDeleteChildren();
		desPanelList.pop();
	}
}

(function()
{
	$.GetContextPanel().SetTower = SetTower;
	GameEvents.Subscribe( "TowerInfoSent", SetTowerInfo);
	GameEvents.Subscribe( "MenuSwtich", HideTowerDes);
})();
