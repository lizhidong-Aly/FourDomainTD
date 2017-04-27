function FinalShield(keys)
	_G.Fountain:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=keys.duration})
	AMHC:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",PATTACH_OVERHEAD_FOLLOW,true,_G.Fountain,keys.duration)
	EmitGlobalSound("Hero_Abaddon.BorrowedTime")
end	
