"use strict";

var self_info;
var context=$.GetContextPanel();
var tech_name=context.id;
function SetTechInfo(tech_info){
	self_info=tech_info;
	$("#TechImage").abilityname=tech_info.img;
	for(var i=1;i<=tech_info.maxlv;i++){
		$("#LevelPoint_"+i).SetHasClass("show", true);
	}
	if(tech_info.current_lv!=-1){
		SetTechLevel(tech_info.current_lv);
	}
}

function GetTechInfo(){
	return self_info;
}

function ShowTechDes(){
	context.GetParent().GetParent().GetParent().GetParent().UpdateTechDes(tech_name);
}

function SetTechLevel(lv){
	Unlock();
	self_info.current_lv=lv;
	if(lv>0){
		for(var i=1;i<=lv;i++){
			$("#LevelPoint_"+i).SetHasClass("active", true);
		}
		ShowTechDes();
	}
}

function Unlock(){
	$("#TechLocker").SetHasClass("unlocked", true);
}

function UpgradeTech() {
	GameEvents.SendCustomGameEventToServer( "UpgradeTech", {name:tech_name} );
}

(function()
{
	context.SetTechInfo = SetTechInfo;
	context.SetTechLevel= SetTechLevel;
	context.GetTechInfo=GetTechInfo;
})();