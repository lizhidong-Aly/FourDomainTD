function ChainLightling( keys)
	local caster = keys.caster
	local target = keys.target
	local playerid = caster:GetPlayerOwnerID()
	local abi=caster:FindAbilityByName("chain_lightling_dummy_hidden")
	if abi~=nil then
		print("chain lighting")
		abi:SetHidden(false)
		caster:CastAbilityOnTarget(target, abi,playerid)
		Timers:CreateTimer(0.05, function()
    		abi:SetHidden(true)
    	end
  		)
	end
end