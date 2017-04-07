function WT21_Function( keys)
	local caster = keys.caster
	caster:RemoveAbility("ice_mark")
	caster:AddAbility("ice_mark_e"):SetLevel(caster:GetLevel())
end