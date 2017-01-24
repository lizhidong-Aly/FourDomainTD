function BlackHole(keys)
	local center=keys.target:GetOrigin()
	local pid=keys.caster:GetMainControllingPlayer()
	local dummy=CreateUnitByName("block_hole_dummy",center,false,nil,nil,DOTA_TEAM_GOODGUYS)
	local abil=dummy:FindAbilityByName("black_hole")
	dummy:SetThink(function() 
			dummy:CastAbilityOnPosition(center,abil,pid) 
			return nil 
		end, 0.01)
	keys.caster:SetThink(function()  dummy:RemoveSelf() return nil end, 10)
end
