require("Parameter")

function InitFountain()
	local ent=Entities:FindByName(nil,"68_good_filler_1")
	if ent==nil then
		print("nil ent")
	else
		print("fountain init")

		ent:RemoveAbility("backdoor_protection_in_base")
		ent:RemoveAbility("filler_ability")
		
		local modi=ent:FindAllModifiers()
		for i,v in ipairs(modi) do
			print(v:GetName())
			v:Destroy()
		end
		ent:SetHealth(100)
		ent:SetMaxHealth(100)
		ent:SetModelScale(2)
	end
end

function NextWave()
	local lNo=_G.Player[0].UnitSpawner.levelNo
	local lInfo=_G.levelInfo[lNo]
	CustomGameEventManager:Send_ServerToAllClients("SynchronizeTimer",{reset=true,delay=SPAWN_DELAY,lvNo=lNo})
	Timers:CreateTimer(function()
		CustomGameEventManager:Send_ServerToAllClients("SynchronizeTimer",{reset=false})
		if _G.Player[0].UnitSpawner.isOnSpawn then
			return nil
		end
      	return 1
    end)
  	for i,v in pairs(_G.Player) do
		v:StartSpawn()
	end
end

function IsEndOfCurrentWave()
	_G.unitRemaining=_G.unitRemaining-1
	print(_G.unitRemaining)
	if not _G.Player[0].UnitSpawner.isOnSpawn and _G.unitRemaining==0 then
		WaveEnd()
	end
end

function WaveEnd()
	if _G.Player[0].UnitSpawner.levelNo==40 then
		print("Game End, Congrts, You Win")
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	else
		print("End Of This Wave, Prepare for Next Wave")
		GiveEndBouns()
		NextWave()
	end
end

function GiveEndBouns()
	local lInfo=_G.levelInfo[_G.Player[0].UnitSpawner.levelNo]
	local bounty=lInfo.baseGoldBounty*lInfo.amount
	for i,v in pairs(_G.Player) do
		local hero=v:GetAssignedHero()
		v.TechTree:IncreaseTechPoint(1)
		AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,"green",0 )
		hero:ModifyGold(bounty,false,0)
		hero:EmitSoundParams("General.Sell",200,300,1)
		AMHC:CreateNumberEffect( hero,bounty,2,AMHC.MSG_GOLD,"yellow",0 )
	end
	local end_msg=_G.end_msg_left.." "..bounty.." ".._G.end_msg_right
	GameRules:SendCustomMessage(end_msg, 0, 0)
	--[[
	for i=0,4 do
		if HPRelation[i]~=nil then
			local hero=HPRelation[i][1]
			if Tree[i]~=nil then
				Tree[i]:IncreaseTechPoint(1)
				AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,"green",0 )
			end
			hero:ModifyGold(bounty,false,0)
			hero:EmitSoundParams("General.Sell",200,300,1)
			AMHC:CreateNumberEffect( hero,bounty,2,AMHC.MSG_GOLD,"yellow",0 )
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0),"LevelEnd",{gold=bounty})]]--
end

function ReachEndPoint(trigger)
	local activator=trigger.activator
	local fountain=Entities:FindByName(nil,"68_good_filler_1")
	if activator:GetTeamNumber()==DOTA_TEAM_BADGUYS  then
		local dmg=activator:GetLevel()
		activator:RemoveSelf()
		AMHC:Damage(fountain,fountain,dmg,DAMAGE_TYPE_PURE,1)
		if not fountain:IsAlive() then
			GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
		end
		IsEndOfCurrentWave()
	end
end
------------------------------------------------------------------------------------------------------------------------
--[[]
function DistubuteGold()
	local bounty =0
	bounty=math.floor(totalgold[currentWave]*1.3)
	for i=0,4 do
		if HPRelation[i]~=nil then
			local hero=HPRelation[i][1]
			if Tree[i]~=nil then
				Tree[i]:IncreaseTechPoint(1)
				AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,"green",0 )
			end
			hero:ModifyGold(bounty,false,0)
			hero:EmitSoundParams("General.Sell",200,300,1)
			AMHC:CreateNumberEffect( hero,bounty,2,AMHC.MSG_GOLD,"yellow",0 )
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0),"LevelEnd",{gold=bounty})
end

-----------------------------------------------------------------------------------------------------------------------------
--Level Mode

function LevelMode()
	
	playernum=PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	InitDomainStatus()
	WaveSwaperForLevelMode()
	currentWave = currentWave +1
	ramingtime=60
	GameRules:GetGameModeEntity():SetThink(TimingforNextWaveForLevelMode,0)
	return nil
end

function InitDomainStatus()
	DomainStatus.Earth.player=0
	if PlayerResource:GetPlayer(1)~=nil then
		DomainStatus.Water.player=1
	end
	if PlayerResource:GetPlayer(2)~=nil then
		DomainStatus.Fire.player=2
	end
	if PlayerResource:GetPlayer(3)~=nil then
		DomainStatus.Air.player=3
	end
end


timeStoped=false

function TimeStop(keys)
	local caster=keys.caster
	print(timeStoped)
	timeStoped=true
	print(timeStoped)
	caster:SetThink(function()  timeStoped=false print(timeStoped) return nil end,keys.duration)
end


function WaveSwaperForLevelMode()
	local dummy = Entities:FindByName(nil,"WorldCentre")
	dummy:SetThink(function() 
		if GameRules:IsGamePaused() then
			return 0.1
		end
		if ramingtime>50 or timeStoped then 
			return 1
		end
		local wc=currentWave
		if GameRules:State_Get()==DOTA_GAMERULES_STATE_POST_GAME or wc==-1 then
			return nil
		end 
		local unitofthiswave=CreateUnit((currentWave),worldPoint:GetOrigin())
		local delay=unitofthiswave:GetAttackAnimationPoint()
		local delay=delay*1.5
		if delay<0.1 or delay>20 then
			delay=31
		end
		unitofthiswave:RemoveSelf()
		local goldbounty = math.ceil(totalgold[wc]/(80/delay))
		for d,v in pairs(DomainStatus) do     --d: Domain Name v: table value
			if v.player~=nil then 
				local unit = CreateUnit(wc,v.position)
				UnitMove(unit,"WorldCentre")
				unit:SetMinimumGoldBounty(goldbounty)
				unit:SetBaseMaxHealth(unit:GetHealth()*(1+currentWave/50))
				if unit:GetUnitLabel()=="1" then
					unit:AddNewModifier(nil, nil, "modifier_magic_immune", {})
				end
				if difficulty==2 then
					local dname=oriForSwaper[i]:GetName()
					if unit:FindAbilityByName(dname.."_Hell")==nil then
						unit:AddAbility(dname.."_Hell")
					end
					unit:FindAbilityByName(dname.."_Hell"):SetLevel(1)
				end
			end
		end
		return delay
	end)
end


function TimingforNextWaveForLevelMode()
	if GameRules:IsGamePaused() then
		return 0.8
	end
	if timeStoped then
		return 1
	end
	local unit=nil
	local mi=0
	local mr=0
	local ms=200
	if ramingtime==0 then
		if (currentWave+1) < #waveName then
			CustomGameEventManager:Send_ServerToAllClients("WaveAlert",{waveno=currentWave,mode="level"})
			currentWave = currentWave +1
			DistubuteGold()
			ramingtime=60
		elseif (currentWave+1) == #waveName then
			CustomGameEventManager:Send_ServerToAllClients("WaveAlert",{waveno=currentWave,mode="level"})
			currentWave = currentWave +1
			ramingtime=60
		elseif (currentWave+1) > #waveName then
			currentWave=-1
			GameRules:GetGameModeEntity():SetContextThink("EndCheck",EndCheck,0)
			return nil
		end
	end
	if (currentWave+1) < #waveName then
		unit = CreateUnit(currentWave+1,worldPoint:GetOrigin())
	end
	if unit~=nil then
		mi=(unit:GetUnitLabel()=="1")
		mr=unit:GetMagicalArmorValue()
		ms=unit:GetBaseMoveSpeed()
		unit:RemoveSelf()
	end
	ramingtime = ramingtime - 1 
	if (currentWave+1) > #waveName then
		CustomGameEventManager:Send_ServerToAllClients("TimingforNextWave",{rt=-1,mode="level"})
	else
		CustomGameEventManager:Send_ServerToAllClients("TimingforNextWave",{am=0,mi=mi,mr=mr,ms=ms,rt=ramingtime,mode="level"})
	end
	return 1
end

function EndCheck()
	local all=Entities:FindAllByClassname("npc_dota_creature")
	local clear=true
	for i,v in pairs(all) do
		if v:IsAlive() then
			local name=v:GetUnitName()
			if string.find(name,"level")~=nil then
				clear=false
			end
		end
	end
	if clear then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		return nil
	else
		return 1
	end
end]]--
