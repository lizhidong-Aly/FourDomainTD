function RequestExchange(option){
	GameEvents.SendCustomGameEventToServer( "MarketRequest", {order:option} );
}

function UpdateMarketValue(data){
	$("#EssenceCost").text=data.essence
	$("#EssencePrice").text=data.essence+50
	$("#CrystalCost").text=data.crystal
	$("#CrystalPrice").text=data.crystal+100
}

function ShowMarketTip(option){
	var context = $.GetContextPanel()
	var tittle=$.Localize( "#market");
	var des=""
	if(option==1){
		des = $.Localize( "#Market_sell") +MakeTextColor("1","#00baff") + $.Localize( "#Tower_essence") + ", " + $.Localize( "#Market_get") + MakeTextColor($("#EssenceCost").text,"gold") +  $.Localize( "#Tower_gold")
	}else if(option==2){
		des = $.Localize( "#Market_spend") + MakeTextColor($("#EssencePrice").text,"gold") + $.Localize( "#Tower_gold") + ", " + $.Localize( "#Market_get") + MakeTextColor("1","#00baff") +  $.Localize( "#Tower_essence")
	}else if(option==3){
		des = $.Localize( "#Market_sell") +MakeTextColor("1","#b72cff") + $.Localize( "#Tower_crystal") + ", " + $.Localize( "#Market_get") + MakeTextColor($("#CrystalCost").text,"gold") +  $.Localize( "#Tower_gold")
	}else if(option==4){
		des = $.Localize( "#Market_spend") + MakeTextColor($("#CrystalPrice").text,"gold") + $.Localize( "#Tower_gold") + ", " + $.Localize( "#Market_get") +  MakeTextColor("1","#b72cff") +  $.Localize( "#Tower_crystal")
	}
	$.DispatchEvent( "DOTAShowTitleTextTooltip", context, tittle,des);
}

function HideMarketTip(option){
	var context = $.GetContextPanel()
	$.DispatchEvent( "DOTAHideTitleTextTooltip",context);
}

function EmidSound(data){
	Game.EmitSound(data.sname)
}

function MakeTextColor(text,color){
	return "<font color='"+color+"'>"+text+"</font>";
}

(function()
{
	$.Msg("resource_market.js is loaded");
	GameEvents.Subscribe( "UpdateMarketValue", UpdateMarketValue);
	GameEvents.Subscribe( "EmidSound", EmidSound);
})();