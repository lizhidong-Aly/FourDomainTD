function StartSplitShot(keys)
	local caster=keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local ss=caster:FindAbilityByName("split_shot_dummy_hidden")
	if not ss:IsCooldownReady() then
		return 
	end
	caster:CastAbilityImmediately(ss,playerid)
end

function SplitShot(keys)
	local caster=keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local target=Entities:FindAllInSphere(caster:GetOrigin(),caster:GetAttackRange())
	local amount=1
	for i,v in pairs(target) do
		if 	v:GetClassname()=="npc_dota_creature" 
			and v:GetTeamNumber()==DOTA_TEAM_BADGUYS 
			and v:IsAlive() 
			and v~=caster:GetAttackTarget() then
			
			local caster_pos=caster:GetOrigin()
			local target_pos=v:GetOrigin()
			local distance=math.sqrt(math.pow(caster_pos[1]-target_pos[1],2)+math.pow(caster_pos[2]-target_pos[2],2))
			if distance<caster:GetAttackRange() then
				caster:PerformAttack(target[i], false,false, true,true, true, false, false)
				amount=amount+1
				if amount >=keys.amount then
					return
				end
			end
		end
	end
end