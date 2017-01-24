require ("UnitSpawner")
require ("BuildUI")
require ("Parameter")
require ("TechUI")
require ("Wave")
require ("timers")
require ("MergeUI")
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
	--modifier_adjust_attack_range = class({})
	--LinkLuaModifier( "ModifierScript/modifier_adjust_attack_range", LUA_MODIFIER_MOTION_NONE )
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
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TDGameMode,"OnGameRulesStateChange"), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(TDGameMode, 'OnDisconnect'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(TDGameMode, "OnEntityKilled"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TDGameMode, "OnNPCSpawned"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(TDGameMode, 'OnPlayerReconnect'), self)

	Convars:RegisterCommand( "TestComand_A", Dynamic_Wrap(TDGameMode, 'TestComand_A'), "Console Comand For Test", FCVAR_CHEAT )
end

function TDGameMode:TestComand_A()
	print("****************TestComand_A****************")
	--local kv=LoadKeyValues("scripts/npc/custom_tower.txt")
	print(GetRandomSpecialAbility())
	print("******************Test End******************")
end

function DrawAttackRange(index,keys)
	DebugDrawClear()
	if(keys.unit~=nil) then
		local unit=EntIndexToHScript(keys.unit)
		if unit~=nil and unit:IsAlive() and unit:IsTower() then
			DebugDrawCircle(unit:GetOrigin(), Vector(0,255,0),0, keys.range, true, 0.1)
		end
	end
end

function Notifier_LocalizeEndMsg(index,keys)
	_G.end_msg_left=keys.left
	_G.end_msg_right=keys.right
end

function ClosedAllUI(index,keys)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(keys.PlayerID),"ClosedAllUI",{})
end

function RandomHeroSelection()
	for i=0,3 do
		local player = PlayerResource:GetPlayer(i)
		if player~=nil and player:GetAssignedHero()==nil then
			player:MakeRandomHeroSelection()
		end
	end
end

function SetDifficulty(index,keys)
	vote[keys.PlayerID+1]=keys.data
	local count={0,0,0}
	for i,v in pairs(vote) do
		count[v]=count[v]+1
	end
	local currdif=1
	local x=-1
	for i=1,3 do
		if count[i]>x then
			x=count[i]
			currdif=i
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("CurrentDifficulty",{diff=currdif})
	DIFFICULTY=currdif
	if DIFFICULTY==1 then
		REFUND=1
	elseif DIFFICULTY==2 then
		REFUND=0.75
	elseif DIFFICULTY==3 then
		REFUND=0.5
	end
end


function TDGameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
    local newState = GameRules:State_Get()
    if newState==DOTA_GAMERULES_STATE_PRE_GAME then
    	InitMergeList()
		InitFountain()
		InitOutLands()
    end
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	if MODE==0 then
			TestMode()
        end
   		if MODE==1 then
        	NextWave()
        end
    end
end

function InitFountain()
	_G.Fountain=Entities:FindByName(nil,"68_good_filler_1")
	if Fountain==nil then
		print("nil ent")
	else
		print("fountain init")
		Fountain:SetTeam(DOTA_TEAM_GOODGUYS)
		local modi=Fountain:FindAllModifiers()
		for i,v in ipairs(modi) do
			print(v:GetName())
			v:Destroy()
		end
		Fountain:RemoveAbility("backdoor_protection_in_base")
		Fountain:RemoveAbility("filler_ability")
		Fountain:AddAbility("fountain_aura"):SetLevel(1)
		Fountain:SetMaxHealth(100)
		Fountain:SetHealth(100)
		Fountain:SetModelScale(2)
	end
end

function InitOutLands()
	local pos=Vector(-4000,2000,256)
	for i,v in ipairs(_G.levelInfo) do 
		print("Create : "..i)
		local u=UnitSpawner:CreateUnit(v,pos,nil)
		print(u:GetUnitName())
		pos[1]=pos[1]+128
	end
end

function TestMode()
	print("Now On Test Mode")
	local pos=Vector(1000,1000,128)
	pos[1]=pos[1]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]-400
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
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
		attacker:ModifyEnergy(u:GetLevel(),true)
	end
		IsEndOfCurrentWave()
	end
end
