function ET31_Function( keys)
	local caster = keys.caster
	caster:RemoveAbility("griavty_control")
	caster:AddAbility("griavty_control_e"):SetLevel(caster:GetLevel())
end