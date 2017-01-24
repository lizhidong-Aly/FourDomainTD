function Invulnerable(keys)
	Fountain:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=keys.duration})
	AMHC:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",PATTACH_ABSORIGIN,true,Fountain,keys.duration)
end	
