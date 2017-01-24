--[[
	- A simple AI script example for the Troll Summoner boss in Adventure Example that allows him to cast abilities
	- This is not designed to be applied to any unit with abilities and is rather specific to this addon
	- The npc does not act like a neutral and will pursue heroes for infinite distance, additional script would need to control
		this behavior
]]

-- Store all the ability names in a table on the entity running this script

thisEntity.bHasSummoned = false
abilityList={
	{"flame_blood","modifier_ogre_magi_bloodlust"},
	{"water_mark","modifier_water_mark_buff"},
	{"water_mark_e","modifier_water_mark_buff"},
	{"ice_mark","modifier_ice_mark_buff"},
	{"ice_mark_e","modifier_ice_mark_buff"},
	{"earth_blessing","modifier_earth_blessing_buff"},
	{"fire_ritual","none"},
	{"fire_ritual_e","none"},
	{"life_ritual","none"},
}


-- When the unit spawns into the world, setup the thinker
function Spawn( entityKeyValues )
	SetUpAIThink()
end


function SetUpAIThink()
	thisEntity:SetContextThink( "AIThink", AIThink, 0 )
end


-- Main think function for this unit
function AIThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	local ability=nil
	local modname=nil
	for i=1,#abilityList do
		if ability==nil then
			ability = thisEntity:FindAbilityByName( abilityList[i][1] )
			modname = abilityList[i][2]
		end
	end
	
	if ability==nil then
		return nil
	end
	
	if not ability:GetAutoCastState() then
		return 1.0
	end
	
	local target=Entities:FindAllInSphere(thisEntity:GetOrigin(),ability:GetCastRange())
	for i,v in pairs(target) do
		if v~=nil and v:GetClassname()=="npc_dota_creature" and v:IsAlive() then
			local caster_pos=thisEntity:GetOrigin()
			local target_pos=v:GetOrigin()
			local distance=math.sqrt(math.pow(caster_pos[1]-target_pos[1],2)+math.pow(caster_pos[2]-target_pos[2],2))
			if distance<ability:GetCastRange() then
				local team=ability:GetAbilityTargetTeam()
				if team==DOTA_UNIT_TARGET_TEAM_FRIENDLY and v:GetTeamNumber()==thisEntity:GetTeamNumber() then
					if v:IsAttacking() then
						local modi=v:FindModifierByName(modname)
						if modi==nil then
							CastAbilities( ability,v )
							return 1.0
						end
					end	
				elseif team==DOTA_UNIT_TARGET_TEAM_ENEMY and v:GetTeamNumber()~=thisEntity:GetTeamNumber() then
					local magicimmnue=(ability:GetAbilityTargetFlags()==DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
					if magicimmnue or (not v:IsMagicImmune())then
						local modi=v:FindModifierByName(modname)
						if modi==nil then
							CastAbilities( ability,v )
							return 1.0
						end
					end
				end
			end
		end
	end
	return 1.0
end

-- Attempt to cast any abilities that are on the unit
function CastAbilities(ability,target )
	--print("Cast:"..ability:GetAbilityName().."  To Target:"..target:GetUnitName())
	-- If the ability is being channelled exit the function
	if ability:IsChanneling() then
		return
	end

	-- Check mana requirements
	if not ability:IsOwnersManaEnough() then
		return
	end

	if not ability:IsCooldownReady() then
		return
	end
	-- Which ability is being cast?  Each one requires a different type of function call (target versus no target in this example)

	thisEntity:CastAbilityOnTarget( target, ability, -1 )
end





	-- Print the contents of a table which is useful for debugging
	--[[
		for k,v in pairs( table ) do
			print( string.format( "%s = %s", k, v ) )
		end
	]]