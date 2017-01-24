function LifeRitual(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	_G.Player[playerid].TechTree:IncreaseTechPoint(1)
	AMHC:CreateNumberEffect( keys.caster,1,2,AMHC.MSG_GOLD,"green",0 )
end