function FrostNovaAttack( keys )
	local playerid = keys.caster:GetPlayerOwnerID()
	local abil=keys.caster:FindAbilityByName("ice_nova_hidden")
	keys.caster:CastAbilityOnTarget(keys.target, abil, playerid)
end
