"use strict";
var rankInfo = [
{name:"rank_normal",low:0,high:50,color:"white"},
{name:"rank_elite",low:50,high:250,color:"green"},
{name:"rank_master",low:250,high:750,color:"purple"},
{name:"rank_legend",low:750,high:99999,color:"orange"},
];
var e=0;
var rank_global=0;
function RankUpdate(data){
	e=data.energy;
	for(var i in rankInfo){
		var rank=rankInfo[i]
		if(e>=rank.low && e<rank.high){
			if(rank.low==750){
				$("#low_name").text=$.Localize(rankInfo[i-1].name);
				$("#high_name").text=$.Localize(rank.name);
				$("#low_name").style.color=rankInfo[i-1].color;
				$("#high_name").style.color=rank.color;
				$("#energy_bar").style.height="44%";
				rank_global=i;
			}else{
				$("#low_name").text=$.Localize(rank.name);
				$("#high_name").text=$.Localize(rankInfo[i-1+2].name);
				$("#low_name").style.color=rank.color;
				$("#high_name").style.color="grey";
				var height=Math.round(((e-(rank.low))/rank.high)*440)/10;
				$("#energy_bar").style.height=height+"%";
				rank_global=i;
			}
		}
	}
}

function ShowRanKDetail(){
	$.Msg("123")
	var title="等阶";
	var des="";
	des="当前等阶:"+$("#low_name").text;
	des=des+"<br>"+"下一等阶:"+$("#high_name").text;
	des=des+"<br>"+"还需:"+(e-rankInfo[rank_global].low)+"/"+rankInfo[rank_global].high;
	if(rank_global==3){
	des="当前等阶:"+$("#high_name").text;
	des=des+"<br>"+"下一等阶:"+"无";
	des=des+"<br>"+"还需:"+"750"+"/"+"750";	
	}
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $.GetContextPanel(), title,des);
}

function HideRanKDetail(){
	$.DispatchEvent( "DOTAHideTitleTextTooltip")
}

(function()
{
	$.Msg("LevelPanel.js is loaded");
	GameEvents.Subscribe( "UpdateTowerInfo", RankUpdate);
})();



