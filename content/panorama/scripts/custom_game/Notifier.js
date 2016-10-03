var allid =Game.GetAllPlayerIDs();
var e=0;
GameEvents.Subscribe( "LevelEnd", ShowLevelEndMessage);
GameEvents.Subscribe( "TimingforNextWave", TimingforNextWave);
GameEvents.Subscribe( "ErrorMsg", ErrorMsg);
GameEvents.Subscribe( "WaveAlert", WaveAlert);

function ErrorMsg(data){
		$.GetContextPanel().SetHasClass( "Hidden", false);
		if (data.str==1){
			$("#msg").text=$.Localize( "#wrongposition" );
		}else if (data.str==2){
			$("#msg").text=$.Localize( "#notower" );
		}else if(data.str==3){
			$("#msg").text=$.Localize( "#nogold" );
		}else if(data.str==4){
			$("#msg").text=$.Localize( "#maxlevel" );
		}else if(data.str==5){
			$("#msg").text=$.Localize( "#needunlock" );
		}else if(data.str==6){
			$("#msg").text=$.Localize( "#wrongspellpos" );
		}else if(data.str==7){
			$("#msg").text=$.Localize( "#notp" );
		}
		Game.EmitSound("General.Cancel");
		$.GetContextPanel().SetHasClass( "ErrAlert", true);
		e=1.2
		HideErrAlert();
}

function HideErrAlert(){
	if (e<0){
		$.GetContextPanel().SetHasClass( "ErrAlert", false);
		return;
	}
	e=e-0.2;
	$.Schedule(0.2,HideErrAlert);
}

function ShowLevelEndMessage(data){
	var text=$.Localize( "#goldgain" )+" "+data.gold+" "+$.Localize( "#tpgain" );
	GameEvents.SendCustomGameEventToServer( "DisplayMessage", {text:text} );
}

function TimingforNextWave(data){
	var nw="Next Wave: "
	if (data.mode=="level"){
		nw="Next Level: "
	}
	if (data.rt<0){
		$("#timer").SetHasClass("Hidden", true);
		return;
	}
	else {
		$("#timer").SetHasClass("Hidden", false);
		$( "#time" ).text=nw+data.rt;
		$("#LevelDes").text="\n"+$.Localize( "#amount" )+data.am;
		if(data.am==1){
			$("#LevelDes").text="\nBOSS";
		}
		if (data.am==0){
			$("#LevelDes").text=""
		}
		if(data.mr>0){
			$("#LevelDes").text=$("#LevelDes").text+"\n"+Math.round(data.mr*100)+$.Localize( "#magicresi" );
		}
		if(data.mi){
			$("#LevelDes").text=$("#LevelDes").text+"\n"+$.Localize( "#magicimue" );
		}
		if(data.ms>522){
			$("#LevelDes").text=$("#LevelDes").text+"\n"+data.ms+$.Localize( "#movespe" );
		}
	}
}



function WaveAlert(data){
	var w="Wave "
	if (data.mode=="level"){
		w="Level "
	}
	if (!($.GetContextPanel().BHasClass("ShowAlert"))){
		$.GetContextPanel().SetHasClass( "ShowAlert", true);
		if(data.waveno==-1){
			$( "#WaveAlert_Text" ).text = $( "#WaveAlert_Text" ).text+" Complete";
		}
		else{
			$( "#WaveAlert_Text" ).text = w+data.waveno;
		}
		Game.EmitSound("ui.npe_objective_complete");
		$.Schedule(1.5,HideWaveAlert);
	}

}

function HideWaveAlert(){
	$.GetContextPanel().SetHasClass( "ShowAlert", false);
}





