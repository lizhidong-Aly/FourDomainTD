GameEvents.Subscribe( "ClosedAllUI", HideInfoPanel);
GameEvents.Subscribe( "CloseInfo", HideInfoPanel);
GameEvents.Subscribe( "TowerInfoSent", SetTowerInfo);
var desPanelList=[];
function ShowInfoPanel(){
	//print($.GetContextPanel().GetParent().GetParent().GetChild(2).GetChild(2))
	$("#Main").SetHasClass("Show", !($("#Main").BHasClass("Show")))
	HideTowerDes();
}

function HideInfoPanel(){
	$("#Main").SetHasClass("Show",  false)
	HideTowerDes();
}

function ShowContextPanel(name){
	$("#InfoMain").SetHasClass("Show", false)
	$("#InfoMerge").SetHasClass("Show", false)
	$("#InfoRest").SetHasClass("Show", false)
	$("#InfoMainButton").GetChild(0).SetHasClass("Focus", false)
	$("#InfoMergeButton").GetChild(0).SetHasClass("Focus", false)
	$("#InfoRestButton").GetChild(0).SetHasClass("Focus", false)
	$("#"+name).SetHasClass("Show", true)
	$("#"+name+"Button").GetChild(0).SetHasClass("Focus", true)
}

function InitContextOfInfo(){

	var text="";
	text=text+$.Localize("addon_game_name");
	text=text + "<br>" + $.Localize("#version")
	text=text + "<br><br>" + $.Localize("#intro")
	text=text + "<br><br>" + $.Localize("#comm")
	//text=text + "<br><br>" + "游戏信息:<br>当前波数:20"
	$("#InfoMainContext").text=text;
	text="";
	text=$.Localize("#merge_intro")
	$("#MergeListLabel").text=text;
	var mergelist=CustomNetTables.GetTableValue( "merge_list", "SingleMegeList" );
	var i;
	text=""
	for (i in mergelist){
		var towera=$.Localize("#"+mergelist[i][1]);
		towera=towera.slice(0,-4)
		var towerb=$.Localize("#"+mergelist[i][2]);
		towerb=towerb.slice(0,-4)
		text=text+towera + " + " + towerb + " = " +  $.Localize("#"+mergelist[i][4])+"<br>"
	}
	//$("#MergeList").text=text;
}

function print(o){
	$.Msg(o);
}

InitContextOfInfo();


function ShowToolTip(name){
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:name,entry:"help"} );
}

function SetTowerInfo(data){
	if(data.entry!="help"){
		return null
	}
	HideTowerDes()
	var type =data.name;
	var button = $("#"+ type );
	var tittle = $.Localize( "#"+type );
	var attri="";
	for(var i=0;i<data.attri.length;i++){
		attri=attri+$.Localize( "#"+data.attri[i] );
		if(i<data.attri.length-1){
			attri=attri+"-";
		}
		
	}

	var des = "";
	var mergelist=CustomNetTables.GetTableValue( "merge_list", "SingleMegeList" );
	var i=1
	for (i in mergelist){
		if(type==mergelist[i][4]){
			break;
		}
	}
	var towera=$.Localize("#"+mergelist[i][1]);
	towera=towera.slice(0,-4)
	var towerb=$.Localize("#"+mergelist[i][2]);
	towerb=towerb.slice(0,-4)
	des=des + $.Localize( "#MergeElement" ) + towera+" , "+towerb;

	des=des +"<br>"+ $.Localize( "#TowerDesA" ) + attri ;
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
 	var cursor = GetPercPos();
	desPanel.style.x=cursor[0];
	desPanel.style.y=cursor[1];
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


function GetPercPos(posa,posb){
	var cPos=GameUI.GetCursorPosition();
	cPos[0]=((cPos[0])/Game.GetScreenWidth())*100+2+"%";
	cPos[1]=((cPos[1])/(Game.GetScreenHeight()/0.808))*100+12+"%";
	return cPos;
}