"use strict";
var rankInfo = [
{name:"rank_normal",low:0,high:50,color:"white"},
{name:"rank_elite",low:50,high:250,color:"green"},
{name:"rank_master",low:250,high:750,color:"purple"},
{name:"rank_legend",low:750,high:99999,color:"orange"},
];
var e=0;
var rank_current=0;
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
				rank_current=i;
			}else{
				$("#low_name").text=$.Localize(rank.name);
				$("#high_name").text=$.Localize(rankInfo[i-1+2].name);
				$("#low_name").style.color=rank.color;
				$("#high_name").style.color="grey";
				var height=Math.round(((e-(rank.low))/rank.high)*440)/10;
				$("#energy_bar").style.height=height+"%";
				rank_current=i;
			}
		}
	}
}

function ShowRanKDetail(){
	var title=$.Localize( "#rank" );
	var des="";
	if(rank_current==3){
		des=$.Localize( "#rank_current" )+MakeTextColor($("#high_name").text,rankInfo[rank_current].color);
		des=des+"<br>"+$.Localize( "#rank_next" )+$.Localize("#rank_none");
		des=des+"<br>"+$.Localize( "#rank_needed" )+MakeTextColor(e-250,"white")+"/"+MakeTextColor("500","white");
		des=des+"<br>"+$.Localize( "#rank_help" )
	}else{
		des=$.Localize( "#rank_current" )+MakeTextColor($("#low_name").text,rankInfo[rank_current].color);
		des=des+"<br>"+$.Localize( "#rank_next" )+MakeTextColor($("#high_name").text,rankInfo[rank_current-1+2].color);
		des=des+"<br>"+$.Localize( "#rank_needed" )+MakeTextColor((e-rankInfo[rank_current].low),"white")+"/"+MakeTextColor(rankInfo[rank_current].high,"white");
		des=des+"<br>"+$.Localize( "#rank_help" )
	}
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $.GetContextPanel(), title,des);
}

function HideRanKDetail(){
	$.DispatchEvent( "DOTAHideTitleTextTooltip")
}

function MakeTextColor(text,color){
	return "<font color='"+color+"'>"+text+"</font>";
}

(function()
{
	$.Msg("LevelPanel.js is loaded");
	GameEvents.Subscribe( "UpdateTowerInfo", RankUpdate);
})();



