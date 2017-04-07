function ET21_Function( keys)
	local caster = keys.caster
	caster:RemoveAbility("sandstorm")
	caster:AddAbility("sandstorm_e"):SetLevel(caster:GetLevel())
end