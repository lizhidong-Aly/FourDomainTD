function ChainLightling( keys)
	local caster = keys.caster
	local target = keys.target
	local playerid = caster:GetPlayerOwnerID()
	local abi=caster:FindAbilityByName("chain_lightling_dummy_hidden")
	if abi~=nil then
		caster:CastAbilityOnTarget(target, abi,playerid)
	end
end