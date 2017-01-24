"use strict";

var isOnMergeMoed=false;
var mark=$('#Mark');
function EntreMergeMode(){
	var abi=Abilities.GetLocalPlayerActiveAbility();
	var aname=Abilities.GetAbilityName(abi);
	var u =Abilities.GetCaster(abi);
	var name=Entities.GetUnitName(u)
	var target=GetMouseCastTarget();
	if(aname=="Merge" && !isOnMergeMoed){
		MergeMode()
	}
	$.Schedule(1/30,EntreMergeMode);
}

function MergeMode(){
	//$.Msg('MergeMode');
	isOnMergeMoed=true
	var abi=Abilities.GetLocalPlayerActiveAbility();
	var aname=Abilities.GetAbilityName(abi);
	var u =Abilities.GetCaster(abi);
	var name=Entities.GetUnitName(u)
	var target=GetMouseCastTarget();
	if(aname=="Merge" && target!=-1){
		var tname=Entities.GetUnitName(target);
		var mInfo=GetMergeInfo(name,tname);
		if(	Entities.IsControllableByPlayer(target,Players.GetLocalPlayer()) &&
			mInfo!=null){
			ShowToolTip(mInfo[2],target);
		}else{
			SetMergeInfo({none:true,target:target});
		}
		$.Schedule(1/30,MergeMode);
	}else{
		isOnMergeMoed=false;
		$.DispatchEvent( "DOTAHideTitleTextTooltip");
		$.DispatchEvent( "DOTAHideTextTooltip")
	}
}

function GetMergeInfo(caster,target){
	var mergeinfo=CustomNetTables.GetTableValue( "merge_list", caster );
	for(var i in mergeinfo) {
		if(target==mergeinfo[i][3]){
			return mergeinfo[i]
		}
	}
	return null
}

function ShowToolTip(name,target){
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:name,entry:"Merge",target:target} );
}

function SetMergeInfo(data){
	if(data.entry=="help"){
		return;
	}
	var des = "";
	var tittle="";
	if (!data.none){
		var type =data.name;
		tittle = $.Localize( "#MergeTo" )+$.Localize( "#"+type );
		var attri="";
		for(var i=0;i<data.attri.length;i++){
			attri=attri+$.Localize( "#"+data.attri[i] );
			if(i<data.attri.length-1){
				attri=attri+"-";
			}
			
		}
		var abi=Abilities.GetLocalPlayerActiveAbility();
		var u =Abilities.GetCaster(abi);
		var name=Entities.GetUnitName(u);
		var mergeinfo=CustomNetTables.GetTableValue( "merge_list", name );
		var tname=Entities.GetUnitName(GetMouseCastTarget());
		var cost=0;
		for(var i in mergeinfo){
			if(tname==mergeinfo[i][3]){
				cost=mergeinfo[i][1]
			}
		}
		des = "";
		des=des + $.Localize( "#TowerDesA" ) + attri ;
		des=des + $.Localize( "#MergeDesA" ) + "<font color='gold'>" + cost + "</font>" 
		if(data.eh_needed!=null){
			des=des+"&" +MakeTextColor(data.eh_needed,"#b72cff")
		}
		des=des + $.Localize( "#TowerDesC" ) + data.dmg;
		des=des + $.Localize( "#TowerDesD" ) + Math.round(data.spe*100)/100;
		des=des + $.Localize( "#TowerDesE" ) + data.range;
		//$.Msg(data.aname);
		for(var i=1;typeof(data.aname[i])=="string";i++){
			des=des + $.Localize( "#TowerDesF" ) + $.Localize( "#DOTA_Tooltip_ability_" + data.aname[i]);
			des=des + $.Localize( "#TowerDesG" ) + $.Localize( "#DOTA_Tooltip_ability_" + data.aname[i] + "_Description");
			if(typeof(data.aname[i+1])=="string"){
				des=des+"<br>";
			}
		}
		var cursor = GetPercPos();
		mark.style.x=cursor[0];
		mark.style.y=cursor[1];
		$.DispatchEvent( "DOTAShowTitleTextTooltip",mark,tittle,des);
	}else{
		var cursor = GetPercPos();
		mark.style.x=cursor[0];
		mark.style.y=cursor[1];
		tittle=$.Localize( "#CanNotMerge" )
		$.DispatchEvent( "DOTAShowTextTooltip",mark,tittle);
	}
}


function GetMouseCastTarget()
{
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex != localHeroIndex; } );
	for ( var e of mouseEntities )
	{
		if ( !e.accurateCollision )
			continue;
		return e.entityIndex;
	}

	for ( var e of mouseEntities )
	{
		return e.entityIndex;
	}

	return -1;
}

function GetPercPos(){
	var cPos=GameUI.GetCursorPosition();
	cPos[0]=Math.round((cPos[0])/Game.GetScreenWidth()*1000)/10+"%";
	cPos[1]=Math.round((cPos[1])/(Game.GetScreenHeight())*1000)/10+"%";
	return cPos;
}

function MakeTextColor(text,color){
	return "<font color='"+color+"'>"+text+"</font>";
}

(function()
{
	$.Msg("MergeUI.js is loaded");
	GameEvents.Subscribe( "MergeTargetInfoSent", SetMergeInfo);
	EntreMergeMode();
})();