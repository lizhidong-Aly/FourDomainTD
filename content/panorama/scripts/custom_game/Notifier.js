"use strict";
var allid =Game.GetAllPlayerIDs();
var err_timer=0;
var DELAY=0;
var spawn_timer=0;
var lvNo=0;
//---------------Timer for Error Msg-------------------------
function ErrorMsg(data){
	err_timer=1.2
	Game.EmitSound("General.Cancel");
	$("#err_msg").text=$.Localize( data.err );
	$.GetContextPanel().SetHasClass( "ErrAlert", true);
}

function HideErrAlert(){
	if (err_timer<0){
		$.GetContextPanel().SetHasClass( "ErrAlert", false);
	}else{
		err_timer-=0.1;
	}
	$.Schedule(0.1,HideErrAlert);
}

function HideSpawnTimer(){
	if(spawn_timer<=0 || spawn_timer==DELAY){
		if($.GetContextPanel().BHasClass("SpawnAlert")){
			$.GetContextPanel().SetHasClass( "SpawnAlert", false);
			ShowStartMsg();
		}
	}else{
		$("#spawn_msg").text=$.Localize( "#nextleveltimer" )+spawn_timer;
		$.GetContextPanel().SetHasClass("SpawnAlert", true);
	}
	$.Schedule(0.1,HideSpawnTimer);
}

function SynchronizeTimer(data){
	if(data.reset){
		DELAY=data.delay+1;
		spawn_timer=data.delay+1;
		lvNo=data.lvNo;
	}else{
		spawn_timer-=1;
	}
}

function ShowStartMsg(){
	$("#start_msg").text=$.Localize( "#wave_alert_prefix" )+lvNo+$.Localize( "#wave_alert_suffix" );
	Game.EmitSound("ui.npe_objective_complete");
	$.GetContextPanel().SetHasClass("Show", true);
	$.Schedule(2,function(){
		$.GetContextPanel().SetHasClass("Show", false);
	});
}


//-----------------------Level End, give end bound to each player-----------
function GiveEndBouns(){
	var text_l=$.Localize( "#goldgain" );
	var text_r=$.Localize( "#tpgain" );
	GameEvents.SendCustomGameEventToServer( "Notifier_LocalizeEndMsg", {left:text_l,right:text_r} );
}

(function()
{
	$.Msg("Notifier.js is loaded");
	GiveEndBouns();
	GameEvents.Subscribe( "ErrorMsg", ErrorMsg);
	GameEvents.Subscribe( "SynchronizeTimer", SynchronizeTimer);
	HideErrAlert();
	HideSpawnTimer();
})();



