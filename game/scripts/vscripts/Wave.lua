require("Parameter")

function NextWave()
	_G.levelNo=_G.levelNo+1
	local lInfo=_G.levelInfo[_G.levelNo]
	CustomGameEventManager:Send_ServerToAllClients("SynchronizeTimer",{reset=true,delay=SPAWN_DELAY,lvNo=_G.levelNo})
	Timers:CreateTimer(function()
		CustomGameEventManager:Send_ServerToAllClients("SynchronizeTimer",{reset=false})
		if _G.isOnSpawn then
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
	if not _G.isOnSpawn and _G.unitRemaining==0 then
		WaveEnd()
	end
end

function WaveEnd()
	if _G.levelNo%10==0 then
		UnlockAbility()
	end
	if _G.levelNo==40 then
		print("Game End, Congrts, You Win")
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	else
		print("End Of This Wave, Prepare for Next Wave")
		GiveEndBouns()
		NextWave()
	end
end

function UnlockAbility()
	for i,v in _G.Player do
		local hero=v:GetAssignedHero()
		if hero~=nil then
			local seal_level_name="element_seal_".._G.levelNo/10
			local seal=hero:FindAbilityByName(seal_level_name)
			local new_ability_name=GetRandomSpecialAbility()
			hero:AddAbility(new_ability_name):SetLevel(1)
			new_ability:SetLevel(1)
			hero:SwapAbilities(new_ability_name,seal_level_name,true,true)
			hero:RemoveAbility(seal_level_name)
		end
	end
end

function GetRandomSpecialAbility()
	local i=RandomInt(1,#_G.HeroAbility)
	local name=_G.HeroAbility[i]
	table.remove(_G.HeroAbility,i)
	return name
end

function GiveEndBouns()
	local lInfo=_G.levelInfo[_G.levelNo]
	local bounty=_G.levelNo*50--lInfo.baseGoldBounty*_G.EnemyType[lInfo.type].amount
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