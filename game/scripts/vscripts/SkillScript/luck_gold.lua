function LuckGold(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	local gold = _G.levelNo
	local modi=keys.caster:FindModifierByName("modifier_extra_gold_count")
	modi:SetStackCount(modi:GetStackCount()+gold)
	PlayerResource:ModifyGold(playerid,gold,false,0)
	keys.caster:EmitSoundParams("General.Sell",200,300,1)
	AMHC:CreateNumberEffect( keys.caster,gold,1,AMHC.MSG_GOLD,"yellow",0 )
end
