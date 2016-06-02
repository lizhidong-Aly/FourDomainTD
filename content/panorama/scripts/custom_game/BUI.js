var builder;

var isMenuOpen=false;
var desPanelList=[];
GameEvents.Subscribe( "setbuilder", SetBuilder);
GameEvents.Subscribe( "MenuSwtich", MenuSwtich);
GameEvents.Subscribe( "TowerInfoSent", SetTowerInfo);
GameEvents.Subscribe( "UnlockTower", UnlockTowerLevel);
GameEvents.Subscribe( "CloseBUI", CloseBUI);
GameEvents.Subscribe( "SelectNewTower", SelectNewTower);
GameEvents.Subscribe( "InitUnlock", InitUnlock);
GameEvents.SendCustomGameEventToServer( "RequestTowerUpdate", {} );
GameEvents.Subscribe( "ClosedAllUI", CloseBUI);

function MenuSwtich(){
	$("#Bmenu").SetHasClass("Show", !($("#Bmenu").BHasClass("Show")));
	HideTowerDes()
}
function CloseBUI(){
	$("#Bmenu").SetHasClass("Show", false);
	HideTowerDes()
}
function SetBuilder( data ) {
	builder=data.num;
}

function BuildTower(name) {
	if ($("#"+name).GetChild(1).BHasClass("enable")){
		var ability = Entities.GetAbilityByName(builder,"SelectPosition");
		Abilities.ExecuteAbility( ability, builder, false );
		//GameEvents.SendCustomGameEventToServer( "CastAbility", {unit:builder,ability:ability} );
		MenuSwtich()
		GameEvents.SendCustomGameEventToServer( "SetTowerType", {type:name} );
	}
	else {
		Game.EmitSound("General.Cancel");
	}
}

function ShowToolTip(name){
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:name} );
}

function SetTowerInfo(data){
	if(data.entry=="help"){
		return;
	}
	HideTowerDes()
	var type =data.name;
	var button = $("#"+ type );
	var tittle = $.Localize( "#Summon" )+$.Localize( "#"+type );
	var attri="";
	for(var i=0;i<data.attri.length;i++){
		attri=attri+$.Localize( "#"+data.attri[i] );
		if(i<data.attri.length-1){
			attri=attri+"-";
		}
		
	}

	var des = "";
	if($("#"+data.name)==null){
		return;
	}
	if (!$("#"+data.name).GetChild(1).BHasClass("enable")){
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
	var desPanel = $.CreatePanel( "Panel", $.GetContextPanel(), "" );
	desPanel.BLoadLayout( "file://{resources}/layout/custom_game/towerdes.xml", false, false );
 	var cursor = GameUI.GetCursorPosition();
	desPanel.style.x=cursor[0]+90+"px";
	desPanel.style.y=cursor[1]+0+"px";
	desPanel.style.z="10px";
	desPanel.style.width="360px";
	desPanel.GetChild(0).GetChild(0).text=tittle;
	desPanel.GetChild(0).GetChild(1).text=des;
	desPanelList.push(desPanel);
	//$.Msg(button.selectionpos_x);
	//$.Msg(button.selectionpos_y);
}


function HideTowerDes(){
	for(var i=desPanelList.length;i>0;i--){
		desPanelList[i-1].RemoveAndDeleteChildren();
		desPanelList.pop();
	}
}

function ShowSubMenu(name){
	$("#submenu_e").SetHasClass("Hidden",true);
	$("#submenu_w").SetHasClass("Hidden",true);
	$("#submenu_f").SetHasClass("Hidden",true);
	$("#submenu_a").SetHasClass("Hidden",true);
	$("#submenu_"+name).SetHasClass("Hidden", !($("#submenu_"+name).BHasClass("Hidden")));
}

function UnLockTower(name){
	$("#"+name).GetChild(1).SetHasClass("enable",true);
}

function UnlockTowerLevel(data){
	for(var i=1;i<=4;i++){
		if(data[i]!=null){
			UnLockTower(data[i]);
		}
	}
}



function InitUnlock(data){
	for(var i=1;i<100;i++){
		if(data[i]==null){
			return
		}
		UnLockTower(data[i])
	}
}


function SelectNewTower(data){
	var unit=Players.GetSelectedEntities(Players.GetLocalPlayer())
	for(var i=0;i<unit.length;i++){
		if (unit[i]==data.old){
			GameUI.SelectUnit(data.newone,true)
		}
	}
}