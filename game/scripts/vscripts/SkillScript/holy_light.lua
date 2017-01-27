function HolyLight(keys)
	local hp=_G.Fountain:GetHealth()+keys.hpreg
	if hp>100 then
		hp=100
	end
	_G.Fountain:SetMaxHealth(100)
	_G.Fountain:SetHealth(hp)
	local f=Entities:FindByName(nil,"ent_dota_fountain_good")
	ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",PATTACH_OVERHEAD_FOLLOW,_G.Fountain)
	EmitGlobalSound("Hero_Omniknight.Purification")
end