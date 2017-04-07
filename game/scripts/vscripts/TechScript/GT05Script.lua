function GT05_Function( keys)
	local unit = keys.unit
	if unit:GetTeamNumber()==DOTA_TEAM_BADGUYS then
		local attacker = keys.attacker
		local pid = attacker:GetPlayerOwnerID()
		local level = keys.ability:GetLevel()
		local chance = keys.arg * level
		if RandomFloat(0,100)<=chance then
			local essence=CreateItem("item_element_essence",nil,nil)
			CreateItemOnPositionSync(GetRandomPositionAround(unit),essence)
		end
	end
end