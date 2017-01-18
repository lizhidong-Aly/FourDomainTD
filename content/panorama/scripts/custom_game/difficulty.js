function ShowToolTip(data){
	var des="";
	if (data==0){
		$("#DiffDes").text=$.Localize( "#normaldesc" );
	}else if (data==1){
		$("#DiffDes").text=$.Localize( "#harddesc" );
	}else if(data==2){
		$("#DiffDes").text=$.Localize( "#vharddesc" );
	}
	$("#DesContent").SetHasClass("Hidden", !($("#DesContent").BHasClass("Hidden")));
}

function HideToolTip(){
	$("#DesContent").SetHasClass("Hidden", !($("#DesContent").BHasClass("Hidden")));
}

function SelectDiff(d){
	GameEvents.SendCustomGameEventToServer( "SetDifficulty", {data:d} );
}

function UpdateDiff(data){
	var diff=data.diff;
	if (diff==0)
		$("#CurrentDifficulty").text=$.Localize( "#normal" );
	else if (diff==1)
		$("#CurrentDifficulty").text=$.Localize( "#hard" );
	else if (diff==2)
		$("#CurrentDifficulty").text=$.Localize( "#vhard" );
	
}

(function()
{
	$.Msg("difficulty.js is loaded");
	GameEvents.Subscribe( "CurrentDifficulty", UpdateDiff);
})();

