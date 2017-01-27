function ModifyElementEssence(keys)
	print("ModifyElementEssence")
	local item=keys.ability
	local hero=keys.caster
	local player=_G.Player[hero:GetPlayerID()]
	player.TechTree:IncreaseTechPoint(1)
	--hero:EmitSoundParams("General.Sell",200,200,1)
	AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,{0,186,255},0 )
	hero:EmitSoundParams("Item.PickUpGemShop",200,200,1)
end