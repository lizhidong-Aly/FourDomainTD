function FireRitual(keys)
	local pid=keys.caster:GetPlayerOwnerID()
	local target=keys.target
	if target:IsAlive()==false then
		local lvl=keys.caster:GetLevel()
		local lv=_G.Player[pid].TechTree:GetTech("FT12"):GetCurrentLevel()
		if lv==-1 then
			lv=0
		end
		for i=0,lv do
			local unit=CreateUnitByName("fire_dummy_"..lvl,target:GetOrigin(), true, keys.caster, keys.caster, DOTA_TEAM_GOODGUYS)
			unit:SetControllableByPlayer(pid, false )
			unit:SetOwner(_G.Player[pid].hero)
			unit:AddNewModifier(caster, nil, "modifier_kill", {duration = 30})
		end
	end
end