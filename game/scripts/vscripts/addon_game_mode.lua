require ("UnitSpawner")
require ("BuildUI")
require ("Parameter")
require ("TechUI")
require ("Wave")
require ("timers")
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
			TestMode()
        elseif Mode==1 then
        	RandomHeroSelection()
        	InitUnitSpwaner()
        end
    end
end

function TestMode()
	print("Now On Test Mode")
	local dummy = Entities:FindByName(nil,"WorldCentre")
	local pos=dummy:GetOrigin()
	pos[1]=pos[1]+200
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]+200
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]-400
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
end

function InitUnitSpwaner()
	print("Now Start InitUnitSpwaner")
	_G.Spawner = UnitSpawner:new("Earth",0)
	Spawner:Spawn()
end

function RandomHeroSelection()
	for i=0,3 do
		local player = PlayerResource:GetPlayer(i)
		if player~=nil and player:GetAssignedHero()==nil then
			player:MakeRandomHeroSelection()
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
		if Mode==1 then
			if IsEndOfCurrentWave() then
				WaveEnd()
			end
		end
	end
end

function SendTowerUnlocked(index,keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"InitUnlock",towerUnlocked[keys.PlayerID])
end