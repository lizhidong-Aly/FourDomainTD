function BootyGold(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local gold = keys.bouns
	if keys.unit:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		if not AMHC:IsAlive(keys.unit) then
			if(PlayerResource:GetPlayer(playerid)~=nil) then
				local modi=keys.caster:FindModifierByName("modifier_extra_gold_count")
				modi:SetStackCount(modi:GetStackCount()+gold)
				PlayerResource:ModifyGold(playerid,gold,false,0)
				keys.caster:EmitSoundParams("General.Sell",200,200,1)
				AMHC:CreateNumberEffect( keys.caster,gold,1,AMHC.MSG_GOLD,"yellow",0 )
			end
		end
	end
end