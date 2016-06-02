GameEvents.Subscribe( "UpdateState", UpdateState);
GameEvents.Subscribe( "MergeTargetInfoSent", SetTowerInfo);

ShowUpgradeCost();
ShowMergeButton();

var desPanelList=[];
var ctarget="";
function UpdateState(data){
	var u = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsHero(u)){
		HideState();
	}
		var extradmg=Entities.GetDamageBonus(u);
		var dmgmin = Entities.GetDamageMin(u)+extradmg;
		var dmgmax = Entities.GetDamageMax(u)+extradmg;
		var attspe = Entities.GetAttackSpeed(u);
		var aps = data.aps;
		var totalcost=data.cost;
		var attri="";
		var label=Entities.GetUnitLabel(u)
		for(var i=0;i<label.length;i++){
			attri=attri+$.Localize( "#"+label[i] );
			if(i<label.length-1){
				attri=attri+"-";
			}
			
		}
		var dps = Math.round(((dmgmin+dmgmax)/2)*aps);
		var des="";
		des=des + $.Localize("#TowerDesA")+attri;
		des=des + $.Localize("#TowerDesB")+"<font color='gold'>"+totalcost+"</font>";
		des=des + "<font color='#ADFF2F'>" + $.Localize("#dmg") + "</font>" +dmgmin+"-"+dmgmax;
		des=des + "<font color='#ADFF2F'>" + $.Localize("#attspe") + "</font>" +(Math.round((1/aps)*1000)/1000);
		des=des + "<font color='#ADFF2F'>" + $.Localize("#range") + "</font>" +Entities.GetAttackRange(u);
		des=des + "<font color='#ADFF2F'>" + $.Localize("#dps") + "</font>" +dps;
		var desPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
		desPanelList.push(desPanel);
		desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
	 	desPanel.GetChild(0).GetChild(0).RemoveAndDeleteChildren();
		desPanel.style.x=660+"px";
		desPanel.style.y=780+"px";
		desPanel.style.z="10px";
		desPanel.GetChild(0).GetChild(1).text=des;
}
function ShowState(){

	var u = Players.GetLocalPlayerPortraitUnit();
	if (Entities.IsControllableByAnyPlayer(u) && !Entities.IsHero(u)){
		GameEvents.SendCustomGameEventToServer( "RequestAps", {name:u} );
	}
}

function HideState(){
	HideTowerDes();
}

function ShowUpgradeCost(){
	var u = Players.GetLocalPlayerPortraitUnit();
	if ((Entities.GetAbilityByName(u,"Upgrade")!=-1)){
		$("#CostPanel").SetHasClass("Hidden", false);
		$( "#upcost" ).text = Entities.GetDayTimeVisionRange(u);
	}
	else {
		$("#CostPanel").SetHasClass("Hidden", true);
	}
	$.Schedule(1/30,ShowUpgradeCost);
}

function ShowMergeDes(){
	var u = Players.GetLocalPlayerPortraitUnit();
	var name=Entities.GetUnitName(u)
	var mergeinfo=CustomNetTables.GetTableValue( "merge_list", name );
	var desPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
	desPanelList.push(desPanel);
	desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
	desPanel.style.x=1300+"px";
	desPanel.style.y=680+"px";
	desPanel.style.width="360px";
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
 	var cursor = GameUI.GetCursorPosition();
	desPanel.style.x=cursor[0]+90+"px";
	desPanel.style.y=cursor[1]+0+"px";
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
	//$.DispatchEvent( "DOTAShowTitleTextTooltipStyled", button, tittle , des,'test');
	//$.Msg(button.selectionpos_x);
	//$.Msg(button.selectionpos_y);
}


function HideTowerDes(){
	for(var i=desPanelList.length;i>0;i--){
		desPanelList[i-1].RemoveAndDeleteChildren();
		desPanelList.pop();
	}
}