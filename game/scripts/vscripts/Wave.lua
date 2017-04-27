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
	if _G.levelNo==40 then
		print("Game End, Congrts, You Win")
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	else
		print("End Of This Wave, Prepare for Next Wave")
		if _G.levelNo%10==0 then
			UnlockAbility()
		end
		GiveEndBouns()
		NextWave()
	end
end

function UnlockAbility()
	for i,v in pairs(_G.Player) do
		local hero=v.hero
		if hero~=nil then
			local seal=nil
			for i=1,3 do
				if seal==nil then
					seal=hero:FindAbilityByName("element_seal_"..i)
				end
			end
			if seal~=nil then
				local new=hero:AddAbility(GetRandomAbilityFromList(_G.HeroAbility))
				new:SetLevel(1)
				hero:SwapAbilities(new:GetAbilityName(),seal:GetAbilityName(),true,true)
				hero:RemoveAbility(seal:GetAbilityName())
				ParticleManager:CreateParticle("particles/econ/events/ti6/hero_levelup_ti6.vpcf",PATTACH_ABSORIGIN,hero)
				EmitSoundOn("compendium_levelup",hero)
			end
		end
	end
end

function GetRandomAbilityFromList(abiList)
	local i=RandomInt(1,#abiList)
	local name=abiList[i]
	table.remove(abiList,i)
	return name
end

function GiveEndBouns()
	local lInfo=_G.levelInfo[_G.levelNo]
	local bounty=_G.levelNo*40--lInfo.baseGoldBounty*_G.EnemyType[lInfo.type].amount
	for i,v in pairs(_G.Player) do
		local hero=v.hero
		if hero~=null then
			v.TechTree:IncreaseTechPoint(1)
			AMHC:CreateNumberEffect( hero,1,2,AMHC.MSG_GOLD,"green",0 )
			hero:ModifyGold(bounty,false,0)
			hero:EmitSoundParams("General.Sell",200,300,1)
			AMHC:CreateNumberEffect( hero,bounty,2,AMHC.MSG_GOLD,"yellow",0 )
		end
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
		if not _G.IsFountainInvulnerable then
			AMHC:Damage(fountain,fountain,dmg,DAMAGE_TYPE_PURE,1)
		end
		if not fountain:IsAlive() then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		end
		IsEndOfCurrentWave()
	end
end