function ModifyGold(keys)
	print("bag of gold")
	local item=keys.ability
	local hero=keys.caster
	local gold=item:GetCurrentCharges()
	hero:ModifyGold(gold,false,0)
	hero:EmitSoundParams("General.Sell",200,200,1)
	AMHC:CreateNumberEffect( hero,gold,2,AMHC.MSG_GOLD,{255,255,100},0 )
	item:SetCurrentCharges(1)
end