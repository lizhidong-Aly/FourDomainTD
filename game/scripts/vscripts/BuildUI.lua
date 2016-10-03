require("Tower")
require("Notifier")
function unitInit( unit )
	for i=0,4 do
		local ability = unit:GetAbilityByIndex(i)
		if ability~=nil then
			ability:SetLevel(1)
		end
	end
	unit:SetAbilityPoints(0)
	unit:SetGold(INIT_GOLD,false)
	local pid=unit:GetPlayerID()
	HPRelation[pid]={unit,nil,false}
	alltower[pid]={}
	Tree[pid]=TechTree:new(pid)
	Tree[pid]:UpdateTechTree()
	towerUnlocked[pid]={}
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdateTechPoint", {point=Tree[pid]:GetTechPoint()} )
end

function OpenBuildingMenu(keys)
	local pid=keys.caster:GetPlayerID()
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "MenuSwtich", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseTechMenu", {} )
	--CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "setbuilder", {num=keys.caster_entindex} )
end

function SendTowerInfo(index,keys)
	if keys.type=="none" then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"MergeTargetInfoSent",{none=true})
		return
	end
	print(keys.type)
	local unit = CreateUnitByName(keys.type,Entities:FindByName(nil,Domain[1]):GetOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
	local cost = GetTowerTotalCost(unit)
	IniTower(nil,unit,cost)
	local abilityname={}
	for i=0,4 do
		local a = unit:GetAbilityByIndex(i)
		if a~=nil then
			local b = a:GetBehavior()
			if DOTA_ABILITY_BEHAVIOR_HIDDEN ~= bit.band( DOTA_ABILITY_BEHAVIOR_HIDDEN, b ) then
				local name = a:GetAbilityName()
				if name~="SellTower" and name~="Upgrade" and string.find(name,"none")==nil then
					table.insert(abilityname,name)
				end
			end
		end
	end
	local info=
		{
			aname=abilityname,
			attri=unit:GetUnitLabel(),
			name=keys.type,
			cost=cost,
			dmg=unit:GetBaseDamageMin().."-"..unit:GetBaseDamageMax(),
			range=unit:GetAttackRange(),
			spe=unit:GetBaseAttackTime(),
			entry=keys.entry
		}
	if keys.entry=="Merge" then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"MergeTargetInfoSent",info)
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"TowerInfoSent",info)
	end
	unit:RemoveSelf()
end

function SetTowerType(index,keys)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "MenuSwtich", {} )
	TowerType[keys.PlayerID]=keys.type
end
----------------------------------------------------------------Build Tower----------------------------------------------------------------
function Build(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local caster=keys.caster
	local buildcost=caster:GetDeathXP()
	local type=caster:GetUnitName()
	local center=caster:GetOrigin()
	NormalizePosition(center)
	local unit=CreateUnitByName(type,center,false,nil,nil,DOTA_TEAM_GOODGUYS)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerid), "SelectNewTower", {old=caster:entindex(),newone=unit:entindex()} )
	IniTower(playerid,unit,buildcost)
	caster:ForceKill(false)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
end

function BuildTest(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	TowerBuilding[playerid]=TowerType[playerid]
	local center=keys.target_points[1]
	local cost = GetBuildCost(TowerBuilding[playerid])
	if not NormalizePosition(center) then
		keys.caster:Stop()
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		return
	end
	local unitaround=Entities:FindByClassnameNearest("npc_dota_creature",center,40)
	if	unitaround~=nil and not unitaround:IsAlive() then
			unitaround=nil
	end
	if((center[2]<3840 and center[2]>3200) or (center[1]<3840 and center[1]>3072) or (center[2]>-3840 and center[2]<-3200)) then
			unitaround=1
	end
	if unitaround~=nil then
		keys.caster:Stop()
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		return
	elseif TowerBuilding[playerid]==nil then
		keys.caster:Stop()
		ErrorMsg(playerid,BUILD_NO_TOWER_SELCTED)
		return
	elseif not(isGoldEnough(playerid,cost)) then
		if not keys.caster:IsHero() then
			return
		end
		keys.caster:Stop()
		ErrorMsg(playerid,NOT_ENOUGH_GOLD)
		return
	end
	if not keys.caster:IsHero() then
		return
	end
	local base=CreateUnitByName("tower_base",center,false,nil,nil,DOTA_TEAM_GOODGUYS)
	base:SetControllableByPlayer(playerid, false )
	base:SetOwner(caster)
	PlayerResource:SpendGold(playerid,cost,0)
	base:SetUnitName(TowerBuilding[playerid])
	base:SetDeathXP(cost)
	local buildabi=base:FindAbilityByName("BuildTower")
	base:SetThink(function() 
			base:CastAbilityNoTarget(buildabi, playerid)
			return nil 
		end)
	--local particleID = AMHC:CreateParticle(keys.effect_name,PATTACH_ABSORIGIN,true,keys.caster,2.5,nil)
    --ParticleManager:SetParticleControl(particleID,0,center)
end

function RefundBuildCost(keys)
	local caster = keys.caster
	local cost=caster:GetDeathXP()
	local playerid = caster:GetMainControllingPlayer()
	PlayerResource:ModifyGold(playerid,cost,false,0)
	caster:ForceKill(false)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
end
----------------------------------------------------------------Upgrade Tower----------------------------------------------------------------
function Upgrade(keys)
	local caster = keys.caster
	local playerid = caster:GetPlayerOwnerID()
	local nlname = GetNextLevelName(caster)
	local totalcost = GetTowerTotalCost(caster)+ GetUpgradeCost(caster)
	local buffa=caster:FindModifierByName("modifier_thousand_faces_katana_buff")
	local buffb=caster:FindModifierByName("modifier_extra_gold_count")
	caster:CreatureLevelUp(1)
	caster:ForceKill(false)
	RemoveTowerFromTable(alltower[playerid],caster)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
	local unit=CreateUnitByName(nlname,keys.target_points[1],false,nil,nil,DOTA_TEAM_GOODGUYS)
	CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner(), "SelectNewTower", {old=caster:entindex(),newone=unit:entindex()} )
	IniTower(playerid,unit,totalcost)
	if buffa~=nil then
		unit:FindModifierByName("modifier_thousand_faces_katana_buff"):SetStackCount(buffa:GetStackCount())
	end
	if buffb~=nil then
		unit:FindModifierByName("modifier_extra_gold_count"):SetStackCount(buffb:GetStackCount())
	end
end

function UpgradeTest(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	if playerid~=keys.caster:GetMainControllingPlayer() then
		keys.caster:Stop()
		return
	end
	local gold = PlayerResource:GetGold(playerid)
	local cost=GetUpgradeCost(keys.caster)
	if gold < cost then
		ErrorMsg(playerid,NOT_ENOUGH_GOLD)
		keys.caster:Stop()
	else 
		PlayerResource:SpendGold(playerid,cost,0)
	end
end

function ReturnUpgradeCost(keys)
	local cost=GetUpgradeCost(keys.caster)
	local playerid = keys.caster:GetMainControllingPlayer()
	PlayerResource:ModifyGold(playerid,cost,false,0)
end


----------------------------------------------------------------Sell Tower----------------------------------------------------------------
function SellTower(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	if playerid~=keys.caster:GetMainControllingPlayer() then
		return
	end
	local totalcost=GetTowerTotalCost(keys.caster)
	local fundreturn =totalcost*refund
	fundreturn = fundreturn-fundreturn%1
	PlayerResource:ModifyGold(playerid,fundreturn,false,0)
	keys.caster:ForceKill(false)
	RemoveTowerFromTable(alltower[playerid],keys.caster)
end




function NormalizePosition(pos)
	pos[1]=math.ceil(math.floor(pos[1]/64)/2)*128
	pos[2]=math.ceil(math.floor(pos[2]/64)/2)*128
	local new=GetGroundPosition(pos,nil)
	return not (new[3]<510 or new[3]>514)
end




function RemoveTowerFromTable(tab,tow)
	for i=1,#tab do
		if not tab[i]==nil then
			if tab[i]:GetEntityIndex()==tow:GetEntityIndex() then	
				table.remove(tab,i)
				return
			end
		end
	end 
end

function isGoldEnough(playerid,cost)
	local currentGold = PlayerResource:GetGold(playerid)
	return currentGold >= cost
end