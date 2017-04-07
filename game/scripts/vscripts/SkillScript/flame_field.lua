function FlameField( keys )
	local target=keys.target
	if target:IsTower() then
		local tower=target:ToTower()
		if string.find(tower.attribute,"F")~=nil then
			tower:AddNewModifier(keys.caster,nil,"modifier_flame_field_aura_passive_buff",nil)

			print("FlameField: "..tower:GetUnitName())
		end
	end
end

function FlameFieldFilter(keys)
	print("filter")
	for i,v in pairs(keys) do
		print(i)
	end
	return true
end