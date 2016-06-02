function TelePointTest(keys)
	print("123testnc sjdnvjksw")

end


function Recovery(keys)
	local hp=fountain:GetHealth()+keys.hpreg
	if hp>100 then
		hp=100
	end
	fountain:SetHealth(hp)
	local f=Entities:FindByName(nil,"ent_dota_fountain_good")
	ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",PATTACH_ABSORIGIN,f)
end

function Invulnerable(keys)
	fountain:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=keys.duration})
	local f=Entities:FindByName(nil,"ent_dota_fountain_good")
	AMHC:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf",PATTACH_ABSORIGIN,true,f,keys.duration)
end	

function BootyGold(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local gold = keys.bouns
	if keys.unit:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		if not AMHC:IsAlive(keys.unit) then
			if(PlayerResource:GetPlayer(playerid)~=nil) then
				local modi=keys.caster:FindModifierByName("modifier_extra_gold_count")
				modi:SetStackCount(modi:GetStackCount()+gold)
				PlayerResource:ModifyGold(playerid,gold,false,0)
				keys.caster:EmitSoundParams("General.Sell",200,200,1)
				AMHC:CreateNumberEffect( keys.caster,gold,1,AMHC.MSG_GOLD,"yellow",0 )
			end
		end
	end
end


function LuckGold(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local gold = currentWave
	if(PlayerResource:GetPlayer(playerid)~=nil) then
		local modi=keys.caster:FindModifierByName("modifier_extra_gold_count")
		modi:SetStackCount(modi:GetStackCount()+gold)
		PlayerResource:ModifyGold(playerid,gold,false,0)
		keys.caster:EmitSoundParams("General.Sell",200,300,1)
		AMHC:CreateNumberEffect( keys.caster,gold,1,AMHC.MSG_GOLD,"yellow",0 )
	end
end


function Resonance(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local abil=keys.caster:FindAbilityByName("resonance_dummy")
	keys.caster:CastAbilityImmediately(abil,playerid)

end

function ForestNova(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local abil=keys.caster:FindAbilityByName("forestnova")
	keys.caster:CastAbilityOnPosition(keys.target:GetOrigin(),abil,playerid)
end

function BlackHole(keys)
	local center=keys.target:GetOrigin()
	local pid=keys.caster:GetMainControllingPlayer()
	local dummy=CreateUnitByName("block_hole_dummy",center,false,nil,nil,DOTA_TEAM_GOODGUYS)
	local abil=dummy:FindAbilityByName("black_hole")
	dummy:SetThink(function() 
			dummy:CastAbilityOnPosition(center,abil,pid) 
			return nil 
		end, 0.01)
	keys.caster:SetThink(function()  dummy:RemoveSelf() return nil end, 10)
end

function CheckPosition(pos)
	return (pos[3]<380 or pos[3]>388)
end


function OpenTransformMenu(keys)
	print("open transform menu")
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "OpenTransformMenu", {unit=keys.caster_entindex} )
end


function Transform(index,keys)

	local caster = EntIndexToHScript(keys.unit)
	local playerid = caster:GetMainControllingPlayer()
	local nlname = keys.form
	local totalcost = GetTowerTotalCost(caster)
	caster:ForceKill(false)
	RemoveTowerFromTable(alltower[playerid],caster)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.01)
	local unit=CreateUnitByName(nlname,caster:GetOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
	IniTower(playerid,unit,totalcost)
	
end


function WaterMark(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local mark = keys.unit:FindModifierByName("modifier_water_mark_buff")
	if (mark~=nil) then
		if mark:GetCaster()==nil then
			mark:Destroy()
			return
		end
		local level=mark:GetCaster():GetLevel()
		local dc=20
		if level==1 then
			dc=20
		elseif level==2 then
			dc=60
		elseif level==3 then
			dc=180
		end
		mark:IncrementStackCount()
		local dmg=mark:GetStackCount()*dc
		local caster=PlayerResource:GetPlayer(playerid):GetAssignedHero()
		caster:Damage(keys.unit,dmg,DAMAGE_TYPE_PHYSICAL,1)
		mark:SetDuration(keys.duration,true)
	end
end


function IceMark(keys)
	local mark = keys.unit:FindModifierByName("modifier_ice_mark_buff")
	if (mark~=nil) then
		mark:IncrementStackCount()
		mark:SetDuration(keys.duration,true)
	end
end

function StartSplitShot(keys)
	local caster=keys.caster
	local playerid = caster:GetMainControllingPlayer()
	local ss=caster:FindAbilityByName("split_shot_dummy")
	if not ss:IsCooldownReady() then
		return 
	end
	caster:CastAbilityImmediately(ss,playerid)
end

function SplitShot(keys)
	local caster=keys.caster
	local playerid = caster:GetMainControllingPlayer()
	local target=Entities:FindAllInSphere(caster:GetOrigin(),caster:GetAttackRange())
	for i=1,#target do
		if target[i]:GetClassname()=="npc_dota_creature" then
			if target[i]:GetTeamNumber()==DOTA_TEAM_BADGUYS then
				if target[i]:IsAlive() then
					if target[i]~=caster:GetAttackTarget() then
						caster:PerformAttack(target[i],false,false,true,false,true)
					end
				end
			end
		end
	end
end


function Erosion(keys)
	local mark = keys.target:FindModifierByName("modifier_erosion_armordown")
	if (mark~=nil) then
		if mark:GetStackCount()<6 then
			mark:IncrementStackCount()
		end
		mark:SetDuration(5,true)
	end
end


function BattleCry(keys)
	local target=keys.target_entities
	for i=1,#target do
		local mark = target[i]:FindModifierByName("modifier_battle_cry_buff")
		if mark ~= nil then
			print(keys.limit)
		if mark:GetStackCount()<keys.limit then
			if mark:GetStackCount()==0 then
				mark:IncrementStackCount()
			end
			mark:IncrementStackCount()
		end
		end
	end
end

function FireRitual(keys)
	local pid=keys.caster:GetPlayerOwnerID()
	local target=keys.target
	if target:IsAlive()==false then
		local lvl=keys.caster:GetLevel()
		local lv=Tree[pid]:GetTech("FT02"):GetLevel()
		for i=0,lv do
			local unit=CreateUnitByName("fire_dummy_"..lvl,target:GetOrigin(), true, keys.caster, keys.caster, DOTA_TEAM_GOODGUYS)
			unit:SetControllableByPlayer(pid, false )
			unit:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero())
			unit:AddNewModifier(caster, nil, "modifier_kill", {duration = 30})
			local tower={
				tower=unit:GetEntityIndex(),
				playerid=pid
			}
			FireGameEvent( "tower_built", tower )
		end
	end
end

function Katana(keys)
	local caster=keys.caster
	local buff=caster:FindModifierByName("modifier_thousand_faces_katana_buff")
	if buff:GetStackCount()<keys.limit then
		buff:IncrementStackCount()
	end
end

function StormForm(keys)
	local caster=keys.caster
	local point=keys.target_points[1]
	local playerid = caster:GetMainControllingPlayer()
	local abil=caster:FindAbilityByName("storm_form_dummy")
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
	caster:CastAbilityOnPosition(point,abil,playerid)
	local a=caster:FindAbilityByName("storm_form_e")
	if a~=nil then
		a:OnOwnerSpawned()
		local modi=caster:FindModifierByName("modifier_storm_form_e_aura")
		local o=caster:GetOrigin()
		local distance=math.sqrt(math.pow(o[1]-point[1],2)+math.pow(o[2]-point[2],2))
		local duration=distance/4000
		modi:SetDuration(duration+0.1,false)
	end
end

function NormalizePosition(pos)
	pos[1]=math.ceil(math.floor(pos[1]/64)/2)*128
	pos[2]=math.ceil(math.floor(pos[2]/64)/2)*128
	local new=GetGroundPosition(pos,nil)
	return not (new[3]<510 or new[3]>514)
end

function ChainLightling( keys)
	local caster = keys.caster
	local target = keys.target
	local playerid = caster:GetPlayerOwnerID()
	local abi=caster:FindAbilityByName("chain_lightling_dummy")
	if abi~=nil then
		caster:CastAbilityOnTarget(target, abi,playerid)
	end
end

function FlameHit( keys )
	local caster=keys.caster
	local target=keys.target
	local dmg=caster:GetAverageTrueAttackDamage()
	local totaldmg=dmg*(keys.dc/100)
	AMHC:Damage(caster,target,dmg,DAMAGE_TYPE_PHYSICAL,(keys.dc/100)-1)
	AMHC:CreateNumberEffect( caster,totaldmg,2,AMHC.MSG_DAMAGE,"red",0 )
end

function SplashAttack( keys )
	local target=keys.target_entities
	local caster=keys.caster
	local dmg=caster:GetAverageTrueAttackDamage()
	for i=1,#target do
		if target[i]~=caster:GetAttackTarget() then
			AMHC:Damage(caster,target[i],dmg,DAMAGE_TYPE_MAGICAL,1)
		end
	end
end

function FrostNovaAttack( keys )
	local playerid = keys.caster:GetMainControllingPlayer()
	local abil=keys.caster:FindAbilityByName("ice_nova")
	keys.caster:CastAbilityOnTarget(keys.target, abil, playerid)
end


function LifeRitual(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	Tree[playerid]:IncreaseTechPoint(1)
	AMHC:CreateNumberEffect( keys.caster,1,2,AMHC.MSG_GOLD,"green",0 )
end