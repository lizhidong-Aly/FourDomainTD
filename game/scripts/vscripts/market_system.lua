
function InitMarketSystem()
	_G.MARKET_VALUE_ESSENCE=100
	_G.MARKET_VALUE_CRYSTAL=300
	CustomGameEventManager:RegisterListener( "MarketRequest", RequestHandler )
	UpdateMarketValue()
end

function RequestHandler(index,keys)
	local order = keys.order
	local pid = keys.PlayerID
	local player = _G.Player[pid]
	OrderFunc[order](player)
	UpdateMarketValue()
end

function UpdateMarketValue()
	CustomGameEventManager:Send_ServerToAllClients("UpdateMarketValue",{essence=_G.MARKET_VALUE_ESSENCE,crystal=_G.MARKET_VALUE_CRYSTAL})
end

OrderFunc={
	(function(player)
		--Sell Essence
		if player.TechTree.TP>0 then
			player.TechTree.TP = player.TechTree.TP -1
			PlayerResource:ModifyGold(player.pid,_G.MARKET_VALUE_ESSENCE,true,0)
			if _G.MARKET_VALUE_ESSENCE > 50 then
				_G.MARKET_VALUE_ESSENCE = _G.MARKET_VALUE_ESSENCE - 25
			end
			CustomGameEventManager:Send_ServerToPlayer(player,"EmidSound",{sname="General.Sell"})
		else
			ErrorMsg(player.pid,NOT_ENOUGH_TP)
		end
	end),
	(function(player)
		--Buy Essence
		if PlayerResource:GetGold(player.pid)>=_G.MARKET_VALUE_ESSENCE+50 then
			player.TechTree.TP = player.TechTree.TP + 1
			PlayerResource:SpendGold(player.pid,_G.MARKET_VALUE_ESSENCE+50,0)
			_G.MARKET_VALUE_ESSENCE = _G.MARKET_VALUE_ESSENCE + 25
			CustomGameEventManager:Send_ServerToPlayer(player,"EmidSound",{sname="General.Buy"})
		else
			ErrorMsg(player.pid,NOT_ENOUGH_GOLD)
		end
	end),
	(function(player)
		--Sell Crystal
		if (player.eh_limit-player.eh_current)>0 then
			player.eh_limit = player.eh_limit - 1
			PlayerResource:ModifyGold(player.pid,_G.MARKET_VALUE_CRYSTAL,true,0)
			CustomGameEventManager:Send_ServerToPlayer(player,"EmidSound",{sname="General.Sell"})
			if _G.MARKET_VALUE_CRYSTAL > 200 then
				_G.MARKET_VALUE_CRYSTAL = _G.MARKET_VALUE_CRYSTAL - 75
			end
		else
			ErrorMsg(player.pid,NOT_ENOUGH_CRYSTAL)
		end
	end),
	(function(player)
		--Buy Crystal
		if PlayerResource:GetGold(player.pid)>=_G.MARKET_VALUE_CRYSTAL+100 then
			player.eh_limit = player.eh_limit + 1
			PlayerResource:SpendGold(player.pid,_G.MARKET_VALUE_CRYSTAL+100,0)
			_G.MARKET_VALUE_CRYSTAL = _G.MARKET_VALUE_CRYSTAL + 75
			CustomGameEventManager:Send_ServerToPlayer(player,"EmidSound",{sname="General.Buy"})
		else
			ErrorMsg(player.pid,NOT_ENOUGH_GOLD)
		end
	end),
}