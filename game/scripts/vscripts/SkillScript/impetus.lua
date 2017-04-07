function Impetus(keys)
	local caster = keys.caster
	local target = keys.target
	local pid = caster:GetPlayerOwnerID()
	local arg_a = keys.arg_a
	local distance=math.sqrt(math.pow(caster:GetOrigin()[1]-target:GetOrigin()[1],2)+math.pow(caster:GetOrigin()[2]-target:GetOrigin()[2],2))
	local dmg = distance * arg_a
	if dmg>keys.arg_b then
		dmg=keys.arg_b 
	end
	AMHC:Damage(caster,target,dmg,DAMAGE_TYPE_PURE,1)
	AMHC:CreateNumberEffect( target,dmg,2,AMHC.MSG_DAMAGE,"white",0 )
end