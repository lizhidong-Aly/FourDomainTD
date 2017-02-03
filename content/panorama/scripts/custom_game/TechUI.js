
function OpenTechMenu(){
	$("#TechMenu").SetHasClass("Hidden", !($("#TechMenu").BHasClass("Hidden")));
}
function CloseTechMenu(){
	$("#TechMenu").SetHasClass("Hidden", true);
}
function UpgradeTech(name){
	GameEvents.SendCustomGameEventToServer( "UpgradeTech", {name:name} );
}

function ShowSubMenu(name){
	$("#EarthTech").SetHasClass("Hidden",true);
	$("#WaterTech").SetHasClass("Hidden",true);
	$("#FireTech").SetHasClass("Hidden",true);
	$("#AirTech").SetHasClass("Hidden",true);
	$("#"+name).SetHasClass("Hidden", !($("#"+name).BHasClass("Hidden")));
}

function UnlockTech(data){
	$("#"+data.name).GetChild(1).SetHasClass("buttonenable",true);
	if($("#"+data.name+"LINE")!=null)
		$("#"+data.name+"LINE").SetHasClass("enable",true);
}


function ShowTechDes(name){
	GameEvents.SendCustomGameEventToServer( "RequestTechInfoUpdate", {name:name} );
}

function UndateTechInfo(data){
	$("#TechName").text =$.Localize( "#"+data.name );
	$("#TechCost").text=$.Localize( "#studycost")+data.cost+" "+$.Localize( "#Tower_essence");
	$("#TechImg").abilityname=data.img;
	$("#TechReq").text="";
	$("#TechReqDetail").text="";
	if (data.req!=-1){
		$("#TechReq").text=$.Localize( "#studyreq" )
		for (var i=1;i<=data.req.length;i++);{
			$("#TechReqDetail").text=$("#TechReqDetail").text+$.Localize( "#"+data.req[i])+" \n ";
		}
	}
	$("#TechDes").text = $.Localize( "#"+data.des);
	if (data.cost==-1){
		$("#"+data.name).GetChild(1).SetHasClass("learned",true);
		$("#TechCost").text=$.Localize( "#techlv" );
	}
}

(function()
{
	$.Msg("TechUI.js is loaded");
	GameEvents.Subscribe( "OpenTechMenu", OpenTechMenu);
	GameEvents.Subscribe( "UndateTechInfo", UndateTechInfo);
	GameEvents.Subscribe( "UnlockTech", UnlockTech);
	GameEvents.Subscribe( "CloseTechMenu", CloseTechMenu);
	GameEvents.Subscribe( "ClosedAllUI", CloseTechMenu);
})();

