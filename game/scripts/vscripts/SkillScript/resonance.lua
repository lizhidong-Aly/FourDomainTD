function Resonance(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	local abil=keys.caster:FindAbilityByName("resonance_dummy_hidden")
	keys.caster:CastAbilityImmediately(abil,playerid)

end
