require("Tower")
require("Notifier")

function OpenBuildingMenu(keys)
	local pid=keys.caster:GetPlayerID()
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "MenuSwtich", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseTechMenu", {} )
	--CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "setbuilder", {num=keys.caster_entindex} )
end

function SendTowerInfo(index,keys)
	local tname=keys.type
	if tname=="none" then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"MergeTargetInfoSent",{none=true})
		return
	end
	local abilities={}
	for i,v in ipairs(_G.TowerInfo[tname].abil) do 
		if string.find(v,"hidden")==nil then
			table.insert(abilities, v)
		end
	end
	local info=
		{
			aname=abilities,
			attri=_G.TowerInfo[tname].attribute,
			name=tname,
			cost=_G.TowerInfo[tname].cost,
			dmg=_G.TowerInfo[tname].minAttDmg.."-".._G.TowerInfo[tname].maxAttDmg,
			range=_G.TowerInfo[tname].attRange,
			spe=_G.TowerInfo[tname].attSpe,
			eh=_G.TowerInfo[tname].eh,
			entry=keys.entry
		}
	if keys.entry=="Merge" then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"MergeTargetInfoSent",info)
	else
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"TowerInfoSent",info)
	end
end

function SetTowerType(index,keys)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "MenuSwtich", {} )
	_G.Player[keys.PlayerID].towerBuilding=keys.type
end
----------------------------------------------------------------Build Tower----------------------------------------------------------------
function Build(keys)
	local playerid = keys.caster:GetMainControllingPlayer()
	local caster=keys.caster
	local type=caster:GetUnitName()
	local center=caster:GetOrigin()
	NormalizePosition(center)
	local t=Tower:new(type,center,playerid,_G.TowerInfo[type].cost)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerid), "SelectNewTower", {old=caster:entindex(),new=t:entindex()} )
	caster:ForceKill(false)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
end

function BuildTest(keys)
	local playerid = keys.caster:GetPlayerOwnerID()
	local tb=_G.Player[playerid].towerBuilding
	local center=keys.target_points[1]
	--------------修正目标地点----------------
	if not NormalizePosition(center) then
		keys.caster:Stop()
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		return
	end
	----------------确认周围无其他单位------------------------
	local unitaround=Entities:FindByClassnameNearest("npc_dota_creature",center,63)
	if	unitaround~=nil and not unitaround:IsAlive() then
			unitaround=nil
	end
	if unitaround~=nil then
		keys.caster:Stop()
		ErrorMsg(playerid,SPELL_CAN_NO_CAST_ON_POSITION)
		return
	end
	--------------------是否选择了要召唤的元素-------------------------------------
	if tb==nil then
		keys.caster:Stop()
		ErrorMsg(playerid,BUILD_NO_TOWER_SELCTED)
		return
	end
	-----------------------金钱是否足够---------------------------------------------
	local cost = _G.TowerInfo[tb].cost
	if not(PlayerResource:GetGold(playerid) >= cost) then
		keys.caster:Stop()
		ErrorMsg(playerid,NOT_ENOUGH_GOLD)
		return
	end
	-------------------------水晶是否足够------------------------------------------
	if  (_G.Player[playerid].eh_current+_G.TowerInfo[tb].eh)>_G.Player[playerid].eh_limit  then
		keys.caster:Stop()
		ErrorMsg(playerid,NOT_ENOUGH_CRYSTAL)
		return
	end
	-----------------------------通过所有检定，开始召唤------------------------------------------------
	------扣除金钱
	PlayerResource:SpendGold(playerid,cost,0)
	------扣除水晶
	_G.Player[playerid].eh_current=_G.Player[playerid].eh_current+_G.TowerInfo[tb].eh
	------召唤
	local base=CreateUnitByName("tower_base",center,false,nil,nil,DOTA_TEAM_GOODGUYS)
	base:SetControllableByPlayer(playerid, false )
	local hero=PlayerResource:GetPlayer(playerid):GetAssignedHero()
	base:SetOwner(hero)
	base:SetUnitName(tb)
	base:SetDeathXP(cost)
	local buildabi=base:FindAbilityByName("BuildTower")
	base:SetThink(function() 
			base:CastAbilityNoTarget(buildabi, playerid)
			return nil 
		end)
end

function RefundBuildCost(keys)
	local caster = keys.caster
	local cost=caster:GetDeathXP()
	local playerid = caster:GetMainControllingPlayer()
	PlayerResource:ModifyGold(playerid,cost,false,0)
	_G.Player[playerid].eh_current=_G.Player[playerid].eh_current-_G.TowerInfo[caster:GetUnitName()].eh
	caster:ForceKill(false)
	caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
end
----------------------------------------------------------------Upgrade Tower----------------------------------------------------------------
function Upgrade(keys)
	local t=keys.caster:ToTower()
	t:Upgrade()
end

function UpgradeTest(keys)
	local tower=keys.caster:ToTower()
	tower:UpgradeTest()
end

function ReturnUpgradeCost(keys)
	local tower=keys.caster:ToTower()
	tower:ReturnUpgradeCost()

end


----------------------------------------------------------------Sell Tower----------------------------------------------------------------
function SellTower(keys)
	local t=keys.caster:ToTower()
	t:Sell()
end

function NormalizePosition(pos)
	pos[1]=math.floor(pos[1]/128)*128+64
	pos[2]=math.floor(pos[2]/128)*128+64
	return pos[3]==256
end
