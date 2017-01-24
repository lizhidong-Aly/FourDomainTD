function ShowToolTip(data){
	var des=$.Localize( "#"+data+"desc" );
	$.DispatchEvent( "DOTAShowTextTooltip", $("#"+data),des);
	//$("#DesContent").SetHasClass("Hidden", !($("#DesContent").BHasClass("Hidden")));
}

function HideToolTip(){
	$.DispatchEvent( "DOTAHideTextTooltip")
	//$("#DesContent").SetHasClass("Hidden", !($("#DesContent").BHasClass("Hidden")));
}

function SelectDiff(d){
	GameEvents.SendCustomGameEventToServer( "SetDifficulty", {data:d} );
}

function UpdateDiff(data){
	var diff=data.diff;
	if (diff==1)
		$("#CurrentDifficulty").text=$.Localize( "#normal" );
	else if (diff==2)
		$("#CurrentDifficulty").text=$.Localize( "#hard" );
	else if (diff==3)
		$("#CurrentDifficulty").text=$.Localize( "#vhard" );
	
}

(function()
{
	$.Msg("difficulty.js is loaded");
	GameEvents.Subscribe( "CurrentDifficulty", UpdateDiff);
})();

