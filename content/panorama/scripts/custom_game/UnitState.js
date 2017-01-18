GameEvents.Subscribe( "MergeTargetInfoSent", SetTowerInfo);

ShowUpgradeCost();
ShowMergeButton();
var desPanelList=[];
var ctarget="";
var hudRoot;
var panel;
for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
	hudRoot=panel;
}
var abil;
var image;

function HideState(){
	HideTowerDes();
}

function ShowUpgradeCost(){
	if(hudRoot!=null){
		abil=hudRoot.FindChildTraverse("Ability1");
	}
	if(abil!=null){
		image=abil.FindChildTraverse("AbilityImage")
	}
	var u = Players.GetLocalPlayerPortraitUnit();
	if (image!=null){
		if(image.abilityname=="Upgrade"){

		//$.DispatchEvent( "DOTAShowTitleTextTooltip", abil, "tittle","des" );
			/*
		costPanel.SetHasClass("Hidden", false);
		costPanel.FindChildTraverse("upcost").text = Entities.GetDayTimeVisionRange(u);
		costPanel.SetParent(image,"13")
		}
		else {
			costPanel.SetHasClass("Hidden", true);
		}*/
		//$.Msg("Update Upgrade Cost");
		}
	}
	$.Schedule(1/30,ShowUpgradeCost);
}

function ShowRefund(){
	var u = Players.GetLocalPlayerPortraitUnit();
	if ((Entities.GetAbilityByName(u,"SellTower")!=-1)){
		$("#RefundPanel").SetHasClass("Hidden", false);
		$( "#refund" ).text = Entities.GetDayTimeVisionRange(u);
	}
	else {
		$("#RefundPanel").SetHasClass("Hidden", true);
	}
	$.Schedule(1/30,ShowRefund);
}

function ShowMergeDes(){
	var u = Players.GetLocalPlayerPortraitUnit();
	var name=Entities.GetUnitName(u)
	var mergeinfo=CustomNetTables.GetTableValue( "merge_list", name );
	var desPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
	desPanelList.push(desPanel);
	desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
	desPanel.SetHasClass("MergeDes",true);
	var tittle=$.Localize( "#Merge" )
	var des="";
	des=des + $.Localize( "#MergeDes" )
	des=des + $.Localize( "#MergeWarning" )
	des=des + $.Localize( "#MergeList" )
	for(var i=1;i<10;i++){
		if(typeof(mergeinfo[i])=="undefined"){
			break;
		}
		var require=mergeinfo[i][3];
		des=des +"<br>"+$.Localize("#"+require)
	}
	desPanel.GetChild(0).GetChild(0).text=tittle
	desPanel.GetChild(0).GetChild(1).text=des
}

function HideMergeDes(){
	HideTowerDes();
}

function EnterMergeMode(){
	var u = Players.GetLocalPlayerPortraitUnit();
	var abi=Entities.GetAbilityByName(u,"Merge");
	Abilities.ExecuteAbility(abi, u, false);
	MergeMode();
}

function MergeMode(){
	var abi=Abilities.GetLocalPlayerActiveAbility()
	var aname=Abilities.GetAbilityName(abi)
	var u =Abilities.GetCaster(abi);
	var name=Entities.GetUnitName(u)
	if(aname=="Merge")
	{
		var mergeinfo=CustomNetTables.GetTableValue( "merge_list", name );
		var target=GetMouseCastTarget()
		if(target!=ctarget){
			HideTowerDes();
		}
		if (target!=-1)
		{
			var tname=Entities.GetUnitName(target)
			var index=CanMerge(name,tname)
			if(desPanelList.length==0)
				{
					if(index!=-1)
					{
						ShowToolTip(mergeinfo[index][2]);
						ctarget=target;
					}
					else
					{
						SetTowerInfo({none:true})
						ctarget=target;
					}
				}
		
		}
		else
		{
			HideTowerDes();
		}
		$.Schedule(1/30,MergeMode);
	}
	else
	{
		HideTowerDes();
	}
}

function CanMerge(sname,tname){
	var mergeinfo=CustomNetTables.GetTableValue( "merge_list", sname );
	for(var i=1;i<10;i++){
		if(typeof(mergeinfo[i])=="undefined"){
					break;
		}
		var require=mergeinfo[i][3]
		if(tname==require){
			return i
		}
	}
	return -1
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



function ShowMergeButton(){
	var u = Players.GetLocalPlayerPortraitUnit();
	if ((Entities.GetAbilityByName(u,"Merge")!=-1)){
		$("#MergeButton").SetHasClass("Hidden", false);
	}
	else {
		$("#MergeButton").SetHasClass("Hidden", true);
	}
	$.Schedule(1/30,ShowMergeButton);
}

function ShowToolTip(name){
	$.Msg("ShowToolTip:"+name)
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:name,entry:"Merge"} );
}

function SetTowerInfo(data){
	if(data.entry=="help"){
		return;
	}
	HideTowerDes();
	var des = "";
	var tittle="";
	var desPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
	desPanelList.push(desPanel);
	desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
 	var cursor = GetPercPos();
	desPanel.style.x=cursor[0];
	desPanel.style.y=cursor[1];
	desPanel.style.z="10px";
	if (!data.none){
		var type =data.name;
		tittle = $.Localize( "#MergeTo" )+$.Localize( "#"+type );
		var button = $("#"+ type );
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
		var tname=Entities.GetUnitName(GetMouseCastTarget())
		var cost=mergeinfo[1][1]
		for(var i=1;i<10;i++){
			if(typeof(mergeinfo[i])=="undefined"){
						break;
			}
			if(tname==mergeinfo[i][3]){
				cost=mergeinfo[i][1]
			}
		}
		des = "";
		des=des + $.Localize( "#TowerDesA" ) + attri ;
		des=des + $.Localize( "#MergeDesA" ) + "<font color='gold'>" + cost + "</font>" ;
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
		desPanel.style.width="360px";
		desPanel.GetChild(0).GetChild(0).text=tittle;
		desPanel.GetChild(0).GetChild(1).text=des;
	}else{
		tittle=$.Localize( "#CanNotMerge" )
		desPanel.GetChild(0).GetChild(0).text=tittle;
		desPanel.GetChild(0).GetChild(1).RemoveAndDeleteChildren();
	}
}

function HideTowerDes(){
	for(var i=desPanelList.length;i>0;i--){
		desPanelList[i-1].RemoveAndDeleteChildren();
		desPanelList.pop();
	}
}


function GetPercPos(posa,posb){
	var cPos=GameUI.GetCursorPosition();
	cPos[0]=((cPos[0])/Game.GetScreenWidth())*100+2.5+"%";
	cPos[1]=((cPos[1])/(Game.GetScreenHeight()/0.808))*100+3+"%";
	return cPos;
}