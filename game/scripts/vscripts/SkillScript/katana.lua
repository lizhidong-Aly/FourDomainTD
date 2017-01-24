function Katana(keys)
	local caster=keys.caster
	local buff=caster:FindModifierByName("modifier_thousand_faces_katana_buff")
	if buff:GetStackCount()<keys.limit then
		buff:IncrementStackCount()
	end
end
