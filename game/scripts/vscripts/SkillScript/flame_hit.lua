function FlameHit( keys )
	local caster=keys.caster
	local target=keys.target
	local dmg=caster:GetAverageTrueAttackDamage()
	--local totaldmg=dmg*(keys.dc/100)
	AMHC:Damage(caster,target,dmg,DAMAGE_TYPE_PHYSICAL,(keys.dc/100)-1)
	AMHC:CreateNumberEffect( caster,totaldmg,2,AMHC.MSG_DAMAGE,"red",0 )
end