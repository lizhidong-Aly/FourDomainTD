function Erosion(keys)
	local mark = keys.target:FindModifierByName("modifier_erosion_armordown")
	if (mark~=nil) then
		if mark:GetStackCount()<keys.limit then
			mark:IncrementStackCount()
		end
		mark:SetDuration(5,true)
	end
end