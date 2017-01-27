function WaterMark(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	local mark = keys.unit:FindModifierByName("modifier_water_mark_buff")
	if (mark~=nil) then
		if mark:GetCaster()==nil then
			mark:Destroy()
			return
		end
		local level=mark:GetCaster():GetLevel()
		local dc=30
		if level==1 then
			dc=30
		elseif level==2 then
			dc=60
		elseif level==3 then
			dc=90
		end
		mark:IncrementStackCount()
		local dmg=mark:GetStackCount()*dc
		local caster=keys.caster
		caster:Damage(keys.unit,dmg,DAMAGE_TYPE_PHYSICAL,1)
		mark:SetDuration(keys.duration,true)
	end
end