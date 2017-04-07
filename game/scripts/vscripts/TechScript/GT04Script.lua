function GT04_Function( keys)
	local unit = keys.unit
	if unit:GetTeamNumber()==DOTA_TEAM_BADGUYS then
		local attacker = keys.attacker
		local pid = attacker:GetPlayerOwnerID()
		local level = keys.ability:GetLevel()
		local bounty = unit:GetGoldBounty()
		local extra = bounty * level * keys.arg/100
		if extra<1 then
			extra=1
		end
		PlayerResource:ModifyGold(pid,extra,false,0)
		AMHC:CreateNumberEffect( unit,extra,1,AMHC.MSG_GOLD,"yellow",0 )
	end
end