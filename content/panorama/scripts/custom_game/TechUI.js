
function OpenTechMenu(){
	$("#TechMenu").SetHasClass("Hidden", !($("#TechMenu").BHasClass("Hidden")));
}
function CloseTechMenu(){
	$("#TechMenu").SetHasClass("Hidden", true);
}

function RequestInitTechUI(){
	GameEvents.SendCustomGameEventToServer( "InitTechUI", {} );
}

function InitTechUI(data){
	$.Msg("Init Tech UI");
	var tech_list=[
		"GT01",
		"GT02",
		"GT03",
		"ET01",
		"ET02",
		"ET03",
	]
	for(var i in tech_list){
		var tech_name=tech_list[i];
		var tech_info=data[tech_list[i]]
		//var tech = $.CreatePanel( "Panel", $("#"+tech_name.substring(0,2)), tech_name );
		//tech.BLoadLayout( "file://{resources}/layout/custom_game/Tech.xml", false, false );
		//tech.SetTechInfo(tech_info);
	}
}

function UndateTechInfo(data){
	var tech=$("#"+data.tech)
	tech.SetTechLevel(data.lv);
	/**
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
	}**/
}

(function()
{
	$.Msg("TechUI.js is loaded");
	GameEvents.Subscribe( "OpenTechMenu", OpenTechMenu);
	GameEvents.Subscribe( "UndateTechInfo", UndateTechInfo);
	GameEvents.Subscribe( "InitTechUI", InitTechUI);
	GameEvents.Subscribe( "CloseTechMenu", CloseTechMenu);
	GameEvents.Subscribe( "ClosedAllUI", CloseTechMenu);
	RequestInitTechUI();
})();

