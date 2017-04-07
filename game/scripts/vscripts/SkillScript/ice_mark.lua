
function IceMark(keys)
	local mark = keys.target:FindModifierByName("modifier_ice_mark_buff")
	if (mark~=nil) then
		mark:IncrementStackCount()
		mark:SetDuration(keys.duration,true)
	end
end