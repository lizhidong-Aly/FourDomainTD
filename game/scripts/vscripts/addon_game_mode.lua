require ("UnitSpawner")
require ("BuildUI")
require ("Parameter")
require ("TechUI")
require ("Wave")
require ("timers")
require ("MergeUI")
require ("TdPlayer")
require ("global")
require("amhc_library/amhc")
require ("statcollection/init")
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
		"scripts/npc/npc_items_custom.txt",
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
					else
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
	AMHCInit()
	GameRules:GetGameModeEntity().player=_G.Player
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	GameRules:SetHeroSelectionTime(15)
	GameRules:SetStrategyTime(10)
	GameRules:SetShowcaseTime(0)
	CustomGameEventManager:RegisterListener( "SetTowerType", SetTowerType )
	CustomGameEventManager:RegisterListener( "SetDifficulty", SetDifficulty )
	CustomGameEventManager:RegisterListener( "RequestTowerInfo", SendTowerInfo )
	CustomGameEventManager:RegisterListener( "RequestTechInfoUpdate", UpdateTechInfo )
	CustomGameEventManager:RegisterListener( "UpgradeTech", UpgradeTech )
	CustomGameEventManager:RegisterListener( "Notifier_LocalizeEndMsg", Notifier_LocalizeEndMsg )
	CustomGameEventManager:RegisterListener( "ClosedAllUI", ClosedAllUI )
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap(TDGameMode,"OnGameRulesStateChange"), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(TDGameMode, 'OnDisconnect'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(TDGameMode, "OnEntityKilled"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(TDGameMode, "OnNPCSpawned"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(TDGameMode, 'OnPlayerReconnect'), self)

	Convars:RegisterCommand( "TestComand_A", Dynamic_Wrap(TDGameMode, 'TestComand_A'), "Console Comand For Test", FCVAR_CHEAT )
	Convars:RegisterCommand( "TestComand_B", Dynamic_Wrap(TDGameMode, 'TestComand_B'), "Console Comand For Test", FCVAR_CHEAT )
end

function TDGameMode:TestComand_A( arg_a )
	print("****************TestComand_A****************")
	--DeepPrintTable(CDOTAGamerules)
	CustomNetTables:SetTableValue( "merge_list","test_value_a",_G.Player[0]);
	--_G.AbilityTestValue=arg_a
	--DeepPrintTable(CDOTA_Ability_Lua)
	--DeepPrintTable(CDOTA_Ability_Lua)
	print("******************Test End******************")
end

function TDGameMode:TestComand_B(...)
	print("****************TestComand_B****************")
	--DeepPrintTable(CDOTAPlayer)

	--kv=LoadKeyValues("scripts/npc/custom_tower.txt")
	print("******************Test End******************")
end

function Notifier_LocalizeEndMsg(index,keys)
	_G.end_msg_left=keys.left
	_G.end_msg_right=keys.right
end

function SetDifficulty(index,keys)
	_G.VOTE[keys.PlayerID+1]=keys.data
	local count={0,0,0}
	for i,v in pairs(_G.VOTE) do
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
	_G.DIFFICULTY=currdif
	if _G.DIFFICULTY==1 then
		_G.REFUND=1
		_G.ENEMY_ELITE_CHANCE=0.01
	elseif _G.DIFFICULTY==2 then
		_G.REFUND=0.75
		_G.ENEMY_ELITE_CHANCE=0.08
	elseif _G.DIFFICULTY==3 then
		_G.REFUND=0.5
		_G.ENEMY_ELITE_CHANCE=0.25
	end
end


function TDGameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
    local newState = GameRules:State_Get()
    if newState==DOTA_GAMERULES_STATE_STRATEGY_TIME then
    	RandomHeroSelection()
    end
    if newState==DOTA_GAMERULES_STATE_PRE_GAME then
    	InitMergeList()
		InitFountain()
    end
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    	if _G.TESTMODE then
			TestMode()
			return
        end
        NextWave()
    end
end

function RandomHeroSelection()
	for i=0,3 do
		local player = PlayerResource:GetPlayer(i)
		if player~=nil and (not PlayerResource:HasSelectedHero(i)) then
			print("random select hero for player: ",i)
			player:MakeRandomHeroSelection()
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
			v:Destroy()
		end
		Fountain:RemoveAbility("backdoor_protection_in_base")
		Fountain:RemoveAbility("filler_ability")
		Fountain:AddAbility("fountain_aura"):SetLevel(1)
		Fountain:SetHealth(100)
		Fountain:SetMaxHealth(100)
		Fountain:SetModelScale(2)
	end
end

function InitOutLands()
	local pos=Vector(-4000,2000,256)
	for i,v in ipairs(_G.levelInfo) do 
		--print("Create : "..i)
		local u=UnitSpawner:CreateUnit(v,pos,nil)
		--print(u:GetUnitName())
		pos[1]=pos[1]+128
	end
end

function TestMode()
	print("Now On Test Mode")
	InitOutLands()
	local pos=Vector(1000,1000,128)
	pos[1]=pos[1]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]+200
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]-400
	CreateUnitByName("TestOnly",pos,false,nil,nil,DOTA_TEAM_BADGUYS)
end

function TDGameMode:OnDisconnect( keys )
	print("On Player Disconnect")
	local pid=keys.PlayerID
	local player=_G.Player[pid]

	--let no one can control the units of this player
	MakeUnitsUnselectable(pid)

	--check if the player abandoned,if not after 3 min, if player still disconnected, remove all his unit\
	player.disconn_time=0
	player.disconnect_timer=Timers:CreateTimer(DoUniqueString("disconnect_timer"),
	{
		callback = 
		function()
			player.disconn_time=player.disconn_time+1
			local conn_state=PlayerResource:GetConnectionState(pid)
			if player.disconn_time==180 or conn_state==DOTA_CONNECTION_STATE_ABANDONED then
				print("Sell All tower and remove all unit of this player")
				player.isAbandoned=true
				player.TowerOwned={}
				for i,v in pairs(player.all_units) do
					if not v:IsNull() then
						if v:GetPlayerOwnerID()==player.pid then
							v:RemoveSelf()
						end
					end
				end
				Timers:RemoveTimer(player.disconnect_timer)
			end
			return 1
    	end
	} )

end

function TDGameMode:OnPlayerReconnect(keys)
	print("On Player Reconnect")
	local pid=keys.PlayerID
	local player=_G.Player[pid]
	--cancel disconn timer for this player 
	Timers:RemoveTimer(player.disconnect_timer)
	player.isAbandoned=false
	--give back the abilit to control all his units
	MakeUnitsSelectable(pid)
end

function TDGameMode:OnNPCSpawned(keys)
	local u=EntIndexToHScript(keys.entindex)
	if(u~=nil and u:IsHero()) then
		Timers:CreateTimer(0.05, function()
    		TdPlayer:InitPlayer(u:GetPlayerID(),u)
    	end
  		)
	end
end

function TDGameMode:OnEntityKilled( keys )
	local u=EntIndexToHScript(keys.entindex_killed)
	if u:GetTeamNumber()==DOTA_TEAM_BADGUYS and u:IsCreature() then
		if u:FindAbilityByName("enemy_elite")==nil and u:FindAbilityByName("enemy_boss")==nil then
			OnNormalEnemyDied(u)
		end
		local attacker=EntIndexToHScript(keys.entindex_attacker)
		if attacker:ToTower() ~=nil then
			attacker:ModifyEnergy(u:GetLevel(),true)
		end
		IsEndOfCurrentWave()
	end
end

function OnNormalEnemyDied(unit)
	if RandomFloat(0,1)<=0.003 then
		local energy=CreateItem("item_energy_orb",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),energy)
	end
	if RandomFloat(0,1)<=0.003 then
		local essence=CreateItem("item_element_essence",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),essence)
	end
	if RandomFloat(0,1)<=0.006 then
		local crystal=CreateItem("item_element_crystal",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),crystal)
	end
	if RandomFloat(0,1)<=0.003 then
		local gold=CreateItem("item_bag_of_gold",nil,nil)
		gold:SetCurrentCharges(500)
		local coin=CreateItemOnPositionSync(GetRandomPositionAround(unit),gold)
		coin:SetModelScale(1)
	end
end
