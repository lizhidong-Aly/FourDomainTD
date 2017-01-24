function SplashAttack( keys )
	local target=keys.target_entities
	local caster=keys.caster
	local dmg=caster:GetAverageTrueAttackDamage(caster)
	for i=1,#target do
		if target[i]~=caster:GetAttackTarget() then
			AMHC:Damage(caster,target[i],dmg,DAMAGE_TYPE_MAGICAL,1)
		end
	end
end