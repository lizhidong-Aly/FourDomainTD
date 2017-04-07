
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
		"G",
		"E",
		"W",
		"F",
		"A"
	]
	for(var i in tech_list){
		for(var t=0;t<=4;t++){
			for(var n=1;n<=9;n++){
				var tech_name=tech_list[i]+"T"+t+n;
				var tech_info=data[tech_name]
				if(tech_info!=null){
					var tech = $.CreatePanel( "Panel", $("#"+tech_name.substring(0,2)), tech_name );
					tech.BLoadLayout( "file://{resources}/layout/custom_game/Tech.xml", false, false );
					tech.SetTechInfo(tech_info);
				}
			}
		}
	}
}

function UndateTechInfo(data){
	var tech=$("#"+data.tech);
	tech.SetTechLevel(data.lv);
}

function UpdateTechDes(tech_name){
	var tech_info=$("#"+tech_name).GetTechInfo();
	$("#TechName").text =$.Localize( "#DOTA_Tooltip_ability_"+tech_name );
	$("#TechImg").abilityname=tech_info.img;
	if(tech_info.current_lv==-1){
		$("#TechReq").style.visibility="visible";
		$("#TechReqDetail").style.visibility="visible";
		$("#TechLevel").style.visibility="collapse";
		$("#TechCost").style.visibility="collapse";
		$("#TechReq").text="";
		$("#TechReqDetail").text="";

		$("#TechReq").text=$.Localize( "#studyreq" );
		for(var i in tech_info.prerequest){
			$("#TechReqDetail").text=$("#TechReqDetail").text+$.Localize( "#DOTA_Tooltip_ability_"+tech_info.prerequest[i].tech_name)+" Lv"+tech_info.prerequest[i].lv_needed;
			if(tech_info.prerequest[i+1]==null){
				$("#TechReqDetail").text=$("#TechReqDetail").text+"\n";
			}
		}
	}else{
		$("#TechReq").style.visibility="collapse";
		$("#TechReqDetail").style.visibility="collapse";
		$("#TechLevel").style.visibility="visible";
		$("#TechCost").style.visibility="visible";
		$("#TechCost").text="";
		$("#TechLevel").text="";

		$("#TechLevel").text=$.Localize( "#tech_level")+tech_info.current_lv;
		$("#TechCost").text=$.Localize( "#studycost")+tech_info.upgrade_essence_needed[tech_info.current_lv+1]+" "+$.Localize( "#Tower_essence");
		if(tech_info.current_lv==tech_info.maxlv){
			$("#TechCost").text=$.Localize( "#reach_max_lv");
		}
	}
	$("#TechDes").text = $.Localize( "#DOTA_Tooltip_ability_"+tech_name+"_Description")+"\n";
	if(tech_info.tower_unlock){
		var t=tech_info.tower_unlock[tech_info.current_lv+1]
		if(tech_info.current_lv==-1){
			t=tech_info.tower_unlock[tech_info.current_lv+2]
		}
		if(t){
			$("#TechDes").text=$("#TechDes").text+$.Localize( "#next_level_unlock");
			for(var i in t){
				$("#TechDes").text=$("#TechDes").text+"["+$.Localize( "#"+t[i]).slice(0,-4)+"]";
				if(t[Number(i)+1]){
					$("#TechDes").text=$("#TechDes").text+", ";
				}
			}
		}
	}
	var before="DOTA_Tooltip_ability_"+tech_name+"_Description_"+tech_info.current_lv;
	var after= $.Localize("#"+before);
	if(before!=after){
		$("#TechDes").text=$("#TechDes").text+after;
	}
	/*
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
	}*/
}

(function()
{
	$.Msg("TechUI.js is loaded");
	GameEvents.Subscribe( "OpenTechMenu", OpenTechMenu);
	GameEvents.Subscribe( "UndateTechInfo", UndateTechInfo);
	GameEvents.Subscribe( "InitTechUI", InitTechUI);
	GameEvents.Subscribe( "CloseTechMenu", CloseTechMenu);
	GameEvents.Subscribe( "ClosedAllUI", CloseTechMenu);
	$.GetContextPanel().UpdateTechDes=UpdateTechDes;
	RequestInitTechUI();
})();

