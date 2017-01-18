require ("UnitSpawner")
require ("BuildUI")
require ("Parameter")
require ("TechUI")
require ("Wave")
require ("timers")
require ("MergeUI")
require	("SkillScript")
require ("TdPlayer")
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
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	CustomGameEventManager:RegisterListener( "SetTowerType", SetTowerType )
	CustomGameEventManager:RegisterListener( "SetDifficulty", SetDifficulty )
	CustomGameEventManager:RegisterListener( "RequestTowerInfo", SendTowerInfo )
	CustomGameEventManager:RegisterListener( "RequestTechInfoUpdate", UpdateTechInfo )
	CustomGameEventManager:RegisterListener( "UpgradeTech", UpgradeTech )
	CustomGameEventManager:RegisterListener( "Notifier_LocalizeEndMsg", Notifier_LocalizeEndMsg )
	CustomGameEventManager:RegisterListener( "ClosedAllUI", ClosedAllUI )
	CustomGameEventManager:RegisterListener( "DrawAttackRange", DrawAttackRange )
	CustomGameEventManager:RegisterListener( "AdvanceTower", AdvanceTower )
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TDGameMode,"OnGameRulesStateChange"), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(TDGameMode, 'OnDisconnect'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(TDGameMode, "OnEntityKilled"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TDGameMode, "OnNPCSpawned"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(TDGameMode, 'OnPlayerReconnect'), self)
end

function AdvanceTower(index,keys)
	local tower=EntIndexToHScript(keys.tower):ToTower()
	tower:Advance()
end

function DrawAttackRange(index,keys)
	DebugDrawClear()
	if(keys.units~=nil) then
		for i,v in pairs(keys.units) do
			local unit=EntIndexToHScript(v)
			if unit~=nil and _G.TowerInfo[unit:GetUnitName()]~=nil then
				--Circle(Vector_1,Quaternion_2,float_3,int_4,int_5,int_6,int_7,bool_8,float_9)
				DebugDrawCircle(unit:GetOrigin(), Vector(0,255,0),0, keys.range[i], true, -1)
			end
		end
	end
	--DebugDrawSphere(self:GetOrigin(), Vector(0,255,0),0.1,1000,false,10)
end

function Notifier_LocalizeEndMsg(index,keys)
	_G.end_msg_left=keys.left
	_G.end_msg_right=keys.right
end

function ClosedAllUI(index,keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"ClosedAllUI",{})
end

function TestMode()
	print("Now On Test Mode")
	--DeepPrintTable(CDOTA_BaseNPC)
	local pos=Vector(1000,1000,128)
	pos[1]=pos[1]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]-400
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
end

function PlayMode()
    print("Now On Play Mode")
    NextWave()
end

function RandomHeroSelection()
	for i=0,3 do
		local player = PlayerResource:GetPlayer(i)
		if player~=nil and player:GetAssignedHero()==nil then
			player:MakeRandomHeroSelection()
		end
	end
end

function TDGameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
    local newState = GameRules:State_Get()
    if newState==DOTA_GAMERULES_STATE_PRE_GAME then
    	InitMergeList()
		InitFountain()
    end
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	if MODE==0 then
			TestMode()
        end
   		if MODE==1 then
        	PlayMode()
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

function TDGameMode:OnNPCSpawned(keys)
	local u=EntIndexToHScript(keys.entindex)
	if(u~=nil and u:IsHero()) then
		Timers:CreateTimer(0.1, function()
    		TdPlayer:InitPlayer(u:GetPlayerID())
    	end
  		)
	end
end

function TDGameMode:OnEntityKilled( keys )
	local u=EntIndexToHScript(keys.entindex_killed)
	if u:GetTeamNumber()==DOTA_TEAM_BADGUYS and u:IsCreature() then
	local attacker=EntIndexToHScript(keys.entindex_attacker)
	if attacker:ToTower() ~=nil then
		attacker:ModifyEnergy(u:GetLevel())
	end
		IsEndOfCurrentWave()
	end
end
