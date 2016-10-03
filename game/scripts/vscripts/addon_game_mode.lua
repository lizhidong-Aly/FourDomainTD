require ("Wave")
require ("BuildUI")
require ("Parameter")
require ("TechUI")
require	("SkillScript")
if TDGameMode == nil then
        TDGameMode = class({})
end

function Precache( context )
	local unitlist={
		"npc_dota_hero_luna",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_zuus",
		}
	for i=1,#unitlist do
		PrecacheUnitByNameSync(unitlist[i], context)
	end
	local kv_files = {
		"scripts/npc/npc_units_custom.txt",
		"scripts/npc/npc_abilities_custom.txt",
		"scripts/npc/npc_abilities_override.txt",
		--"scripts/npc/npc_heroes_custom.txt",
		}
	for _, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
			table.foreach(kvs, function(i, v)
				if v~="REMOVE" and i~="Version" then
					if _==1 then
						print("BEGIN TO PRECACHE RESOURCE: "..i)
						PrecacheUnitByNameSync(i, context)
					elseif _==2 or _==3 then
						print("BEGIN TO PRECACHE RESOURCE: "..i)
						PrecacheItemByNameSync(i, context)
					end
				end
			end)
		end
	end
  	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	PrecacheResource( "model", "models/props_structures/structure_fountain_radiant_basic.vmdl", context )
end

function Activate()
        TDGameMode:InitGameMode()
end
  
function TDGameMode:InitGameMode()
    print( "Four Domain TD is loaded." )
	require("amhc_library/amhc")
	AMHCInit()
	ParameterInit()
	InitMergeList()
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	CustomGameEventManager:RegisterListener( "SetTowerType", SetTowerType )
	CustomGameEventManager:RegisterListener( "SetDifficulty", SetDifficulty )
	CustomGameEventManager:RegisterListener( "RequestTowerInfo", SendTowerInfo )
	CustomGameEventManager:RegisterListener( "RequestTechInfoUpdate", UpdateTechInfo )
	CustomGameEventManager:RegisterListener( "UpgradeTech", UpgradeTech )
	CustomGameEventManager:RegisterListener( "RequestAps", SendAps )
	CustomGameEventManager:RegisterListener( "DisplayMessage", DisplayMessage )
	CustomGameEventManager:RegisterListener( "ClosedAllUI", ClosedAllUI )
	CustomGameEventManager:RegisterListener( "Transform", Transform )
	CustomGameEventManager:RegisterListener( "SetDomainForPlayer", SetDomainForPlayer )
	CustomGameEventManager:RegisterListener( "RequestTowerUpdate", SendTowerUnlocked )
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TDGameMode,"OnGameRulesStateChange"), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(TDGameMode, 'OnDisconnect'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TDGameMode, "OnNPCSpawned"), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(TDGameMode, "OnEntityKilled"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(TDGameMode, 'OnPlayerReconnect'), self)
end

function DisplayMessage(index,keys)
	GameRules:SendCustomMessage(keys.text, 0, 0)
end

function ClosedAllUI(index,keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"ClosedAllUI",{})
end

function SetDomainForPlayer(index,keys)
	local data=CustomNetTables:GetTableValue("domain_selected_list",keys.domain)
	local point=Entities:FindByName(nil,keys.domain)
	local pos=point:GetOrigin()
	local pid=keys.PlayerID
	if data.pid==-1 then
		SetOriForSwaper(keys.domain)
		CustomNetTables:SetTableValue("domain_selected_list",keys.domain,{pid=pid,pos=pos})
	end
end

function SendAps(index,keys)
	local unit=EntIndexToHScript(keys.name)
	local aps=unit:GetAttacksPerSecond()
	local cost=GetTowerTotalCost(unit)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"UpdateState",{aps=aps,cost=cost})
end



function TDGameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
    local newState = GameRules:State_Get()

    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	CustomGameEventManager:Send_ServerToAllClients("SelectDomainRandom",nil)
    	InitTechTree()
    	if Mode==0 then
			Test()
		elseif Mode==1 then
        	NextWave()
        elseif Mode==2 then
        	LevelMode()
        end
    end
end

function TDGameMode:OnDisconnect( keys )
	DeepPrintTable(keys)
	print("On Disconnect")
	local name = keys.name
	local networkid = keys.networkid
	local reason = keys.reason
	local userID = keys.userid
  	local playerID = self.vUserIds[userID]:GetPlayerID()
  	print("Disconnect Player ID: "..playerID)
  	for i,v in pairs(Domain) do
  		local data=CustomNetTables:GetTableValue("domain_selected_list",v)
  		if v.pid==playerID then
  			CloseDomain(v)
  		end
  	end
end

function TDGameMode:OnPlayerReconnect(keys)
	print( '[BAREBONES] OnPlayerReconnect' )
	for i,v in pairs(keys) do
  		print(i,v)
  	end
end


function TDGameMode:OnNPCSpawned( keys )
	local unit = EntIndexToHScript(keys.entindex)
	if unit:IsHero() then
		unitInit(unit)
	end
end

function TDGameMode:OnEntityKilled( keys )
	local u=EntIndexToHScript(keys.entindex_killed)
	if u:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		CustomGameEventManager:Send_ServerToAllClients("UpdateKillBoard",nil)
		if Mode==2 then
			if isThisWaveFinished() then
				WaveFinished()
			end
		end
	end
end

function SendTowerUnlocked(index,keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"InitUnlock",towerUnlocked[keys.PlayerID])
end