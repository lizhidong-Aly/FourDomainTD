function FT21_Function( keys)
	local caster = keys.caster
	caster:RemoveAbility("burning_soul")
	caster:AddAbility("burning_soul_e"):SetLevel(caster:GetLevel())
end