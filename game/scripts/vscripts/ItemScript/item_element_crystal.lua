function ModifyCrystal(keys)
	print("ModifyCrystal")
	local item=keys.ability
	local hero=keys.caster
	local player=_G.Player[hero:GetPlayerID()]
	player.eh_limit=player.eh_limit+1
	--hero:EmitSoundParams("General.Sell",200,200,1)
	AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,{183,44,255},0 )
	hero:EmitSoundParams("Item.PickUpGemShop",200,200,1)
end