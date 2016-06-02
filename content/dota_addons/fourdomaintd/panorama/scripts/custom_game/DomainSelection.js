
GameEvents.Subscribe( "SelectDomainRandom", SelectDomainRandom);
//GameEvents.Subscribe( "UnlockTech", UnlockTech);
CustomNetTables.SubscribeNetTableListener( "domain_selected_list", OnNettable2Changed );
var selected=false;
function SelectionDomain(dname){
	if(!selected){
		$("#Close").SetHasClass("Hidden", false);
		GameEvents.SendCustomGameEventToServer( "SetDomainForPlayer", {domain:dname} );
		selected=true;
	}
}

function CloseSelectionPanel(){
	$("#Main").SetHasClass("Hidden", true);
}

function ShowToolTip(bname){
	var button = $("#"+ bname );
	var des=$.Localize( "#"+bname )+"";
	var data=CustomNetTables.GetTableValue( "domain_selected_list", bname )
	if(data.pid!=-1){
		var pname=Players.GetPlayerName(data.pid);
		var des=des+$.Localize( "#player" )+"<br>"pname;
	}
	$.DispatchEvent( "DOTAShowTextTooltip", button,des);
}
function HideToolTip(){
	$.DispatchEvent( "DOTAHideTextTooltip");
}

function OnNettable2Changed( table_name, key, data )
{
	$("#"+key).GetChild(1).SetHasClass("enable",false);
	GameUI.PingMinimapAtLocation(data.pos);
}

function SelectDomainRandom(){
	var domain=new Array(
		"Earth",
		"Air",
		"Water",
		"Fire"
	);
	var i=0;
	while(!selected){
		SelectionDomain(domain[i]);
		i++;
	}
	CloseSelectionPanel()
}
