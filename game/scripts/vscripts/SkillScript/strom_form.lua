
function StormForm(keys)
	local caster=keys.caster
	local point=keys.target_points[1]
	local playerid = caster:GetPlayerOwnerID()
	local abil=caster:FindAbilityByName("storm_form_dummy_hidden")
	if not NormalizePosition(point) then
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		caster:Stop()
		local a=caster:FindAbilityByName("storm_form")
		if a==nil then
			a=caster:FindAbilityByName("storm_form_e")
		end
		a:EndCooldown()
		return
	end
	local unitaround=Entities:FindByClassnameNearest("npc_dota_creature",point,40)
	if	unitaround~=nil and not unitaround:IsAlive() then
			unitaround=nil;
	end
	if((point[2]<3840 and point[2]>3200) or (point[1]<3840 and point[1]>3072) or (point[2]>-3840 and point[2]<-3200)) then
			unitaround=1
	end
	if	unitaround~=nil then
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		caster:Stop()
		local a=caster:FindAbilityByName("storm_form")
		if a==nil then
			a=caster:FindAbilityByName("storm_form_e")
		end
		a:EndCooldown()
		return
	end
	abil:SetHidden(false)
	caster:CastAbilityOnPosition(point,abil,playerid)
	--abil:SetHidden(true)
	Timers:CreateTimer(0.1, function()
		abil:SetHidden(true)
    	end
  	)
	local o=caster:GetOrigin()
	local distance=math.sqrt(math.pow(o[1]-point[1],2)+math.pow(o[2]-point[2],2))
	local duration=(distance/4000)+0.1
	local a=caster:FindAbilityByName("storm_form_e")
	if a~=nil then
		a:OnOwnerSpawned()
		local modi=caster:FindModifierByName("modifier_storm_form_e_aura")
		modi:SetDuration(duration,false)
	end
	Timers:CreateTimer(duration, function()
		caster:SetOrigin(point)
	end)
end

function NormalizePosition(pos)
	pos[1]=math.floor(pos[1]/128)*128+64
	pos[2]=math.floor(pos[2]/128)*128+64
	return pos[3]==256
end
