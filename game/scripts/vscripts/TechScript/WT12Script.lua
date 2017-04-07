function WT12_Function( keys)
	local caster = keys.caster
	caster:RemoveAbility("water_mark")
	caster:AddAbility("water_mark_e"):SetLevel(caster:GetLevel())
end