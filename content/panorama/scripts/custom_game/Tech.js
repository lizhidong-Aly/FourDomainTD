"use strict";

var tech_info;
var context=$.GetContextPanel();
var tech_name=context.id;
function SetTechInfo(tech_info){
	tech_info=tech_info;
}

function GetTechInfo(){
	return tech_info;
}

function ShowTechDes(){
	//???
}

function SetTechLevle(lv){
	Unlock();
	tech_info.current_lv=lv;
}

function Unlock(){

}

function UpgradeTech() {
	GameEvents.SendCustomGameEventToServer( "UpgradeTech", {name:tech_name} );
}

(function()
{
	context.SetTech = SetTech;
	context.GetTechInfo=GetTechInfo;
})();