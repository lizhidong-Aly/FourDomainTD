
GameEvents.Subscribe( "OpenTransformMenu", OpenTransformMenu);
//GameEvents.Subscribe( "UndateTechInfo", UndateTechInfo);
//GameEvents.Subscribe( "UnlockTech", UnlockTech);
var unit;
function OpenTransformMenu(data)
{
	unit=data.unit;
	$("#Main").SetHasClass("Hidden", !($("#Main").BHasClass("Hidden")));
	HideTransformMenu();
}

function HideTransformMenu(){
	var u = Players.GetLocalPlayerPortraitUnit();
	if(u!=unit){
		$("#Main").SetHasClass("Hidden", true);
		unit=null;
		return
	}
	if($("#Main").BHasClass("Hidden")){
		unit=null;
		return
	}
	$.Schedule(1/30,HideTransformMenu);
}

function Transform(form){
	GameEvents.SendCustomGameEventToServer( "Transform", {unit:unit,form:form} );
}