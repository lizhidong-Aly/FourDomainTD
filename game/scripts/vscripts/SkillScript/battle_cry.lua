function BattleCry(keys)
	local target=keys.target_entities
	for i=1,#target do
		local mark = target[i]:FindModifierByName("modifier_battle_cry_buff")
		if mark ~= nil then
			print(keys.limit)
		if mark:GetStackCount()<keys.limit then
			if mark:GetStackCount()==0 then
				mark:IncrementStackCount()
			end
			mark:IncrementStackCount()
		end
		end
	end
end
