function Recovery(keys)
	local hp=fountain:GetHealth()+keys.hpreg
	if hp>100 then
		hp=100
	end
	Fountain:SetHealth(hp)
	local f=Entities:FindByName(nil,"ent_dota_fountain_good")
	ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",PATTACH_ABSORIGIN,Fountain)
end