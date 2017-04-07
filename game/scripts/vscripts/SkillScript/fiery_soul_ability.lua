function FierySoul( keys )
	local caster=keys.caster
	local modifier=caster:FindModifierByName("modifier_fiery_soul_ability")
	local all=Entities:FindAllInSphere(Vector(0,0,128),10000)
	local count=0
	for i,v in pairs(all) do
		if v~=nil and v.IsTower and v:IsAlive() and v:IsTower() and v:ToTower():HasAttribute("F") then
			count=count+1
		end
	end
	modifier:SetStackCount(count)
end
