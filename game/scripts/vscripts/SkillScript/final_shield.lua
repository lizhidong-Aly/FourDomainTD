function FinalShield(keys)
	_G.IsFountainInvulnerable=true
	Timers:CreateTimer(DoUniqueString("Timer"),
	{
		endTime = keys.duration,
		callback = 
		function()
			_G.IsFountainInvulnerable=false
    	end
	} )
	AMHC:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",PATTACH_OVERHEAD_FOLLOW,true,_G.Fountain,keys.duration)
	EmitGlobalSound("Hero_Abaddon.BorrowedTime")
end	
