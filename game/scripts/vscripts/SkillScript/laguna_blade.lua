function LagunaBlade( keys )
	local caster=keys.caster
	local target=keys.target
	local pid=caster:GetPlayerOwnerID()
	local all=Entities:FindAllInSphere(Vector(0,0,128),10000)
	local count=0
	for i,v in pairs(all) do
		if v.IsTower and v:IsTower() and v:ToTower():HasAttribute("F") then
			count=count+1
		end
	end
	local dmg=keys.dmg_a+keys.dmg_b*count
	caster:Damage(target,dmg,DAMAGE_TYPE_PURE,1)
end
