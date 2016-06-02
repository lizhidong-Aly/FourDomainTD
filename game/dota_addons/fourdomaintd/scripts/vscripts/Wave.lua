require("Parameter")


function NextWave()
	local unitofthiswave=CreateUnit((currentWave+1),worldPoint)
	local delay=unitofthiswave:GetAttackAnimationPoint()
	local upl=unitofthiswave:GetAttackRange()
	unitofthiswave:RemoveSelf()
	if delay<0.1 or delay>10 then
		delay=0.6
	end
	if upl<1 or upl>30 then
		upl=20
	end
	playernum=PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	for i=1,playernum do
		allplayerid[i]=PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS,i)
	end
	WaveSwaper(currentWave,playernum,upl,delay)
	CustomGameEventManager:Send_ServerToAllClients("WaveAlert",{waveno=currentWave})
	currentWave = currentWave +1
	return nil
end

function WaveSwaper(wc,pc,upl,delay)
	local dummy = Entities:FindByName(nil,"ent_dota_fountain_good")
	unitLeft = upl*pc
	if pc >4 then
		pc=4
	end
	wc=wc+1
	dummy:SetThink(function() 
		if GameRules:IsGamePaused() then
		return 0.1
		end
		local goldbounty = math.ceil(totalgold[wc]/(upl/0.5))
		for i=1,pc do
			local unit = CreateUnit(wc,oriForSwaper[i])
			UnitMove(unit,"FinalDomain")
			unit:SetMinimumGoldBounty(goldbounty)
			if unit:GetUnitLabel()=="1" then
				unit:AddNewModifier(nil, nil, "modifier_magic_immune", {})
			end
		end
		if upl~=nil then
			unitCreated = unitCreated+1
			if unitCreated == upl then
				unitCreated = 0
				--Entities:FindByName(nil,"ent_dota_fountain_good"):SetContextThink("IsWaveFinished",IsWaveFinished,0)
				return nil
			else
				return delay
			end
		end
	end)
end




function PathInit()
	for i=1,4 do
		basePoint[i]=Entities:FindByName(nil,table.remove(pos,math.random(#pos)))
	end
	math.randomseed(n)
	n = math.random(1000)
end	


function CreateUnit(wIndex,ori)
	local unit=CreateUnitByName(waveName[wIndex],ori:GetOrigin(),false,nil,nil,DOTA_TEAM_BADGUYS)
	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=4})
	unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=2})
	SetHp(unit,difficulty)
	return unit
end


function SetHp(unit,diff)
	if(difficulty>0) then
		unit:SetBaseMaxHealth(unit:GetHealth()*(1+0.3))
	end
end



function Test()
	local dummy = Entities:FindByName(nil,"WorldPoint")
	--CreateUnitByName("earth_buffer",dummy:GetOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
	CreateUnit(currentWave,dummy)
	local pos=dummy:GetOrigin()
	pos[1]=pos[1]+200
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]+200
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	pos[2]=pos[2]-400
	CreateUnitByName(waveName[currentWave],pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	--for i=1,#waveName do
	--	local unit = CreateUnit(i,worldPoint)
	--	UnitMove(unit,"WorldPoint")
	--end
end


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



function UnitMove(unit,desname)
	local des=Entities:FindByName(nil,desname)
	local order = 
		{                                       
        UnitIndex = unit:entindex(), 
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        TargetIndex = nil, 
        AbilityIndex = 0, 
        Position = des:GetOrigin(),
        Queue = 0 
		}
		unit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(order) end, 0.1)
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
end

function isThisWaveFinished()
	unitLeft = unitLeft - 1
	return unitLeft<=0
end


--[[function IsWaveFinished()
	local list=Entities:FindAllByClassname("npc_dota_creature")
	print(#list)
	for i=1,#list do
		print(string.find(list[i]:GetUnitName(),"level")~=nil)
		if string.find(list[i]:GetUnitName(),"level")~=nil then
			return 0.5
		end
	end
	WaveFinished()
	return nil
end]]--


function WaveFinished()
	if currentWave==#waveName then
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	else 
		DistubuteGold()
		GameRules:GetGameModeEntity():SetThink(TimingforNextWave,0)
		CustomGameEventManager:Send_ServerToAllClients("WaveAlert",{waveno=-1})
	end
end

function TimingforNextWave()
	if GameRules:IsGamePaused() then
		return 0.8
	end
	local unit = CreateUnit(currentWave+1,worldPoint)
	local mi=(unit:GetUnitLabel()=="1")
	local mr=unit:GetMagicalArmorValue()
	local ms=unit:GetBaseMoveSpeed()
	local am=unit:GetAttackRange()
	unit:RemoveSelf()
	if ramingtime==0 then
		NextWave()
		CustomGameEventManager:Send_ServerToAllClients("TimingforNextWave",{rt=ramingtime})
		ramingtime=16
		return nil
	else
		ramingtime = ramingtime - 1 
		CustomGameEventManager:Send_ServerToAllClients("TimingforNextWave",{am=am,mi=mi,mr=mr,ms=ms,rt=ramingtime})
		return 1
	end
end




-----------------------------------------------------------------------------------------------------------------------------
--Level Mode

function LevelMode()
	playernum=PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	for i=1,playernum do
		allplayerid[i]=PlayerResource:GetNthPlayerIDOnTeam(DOTA_TEAM_GOODGUYS,i)
	end
	WaveSwaperForLevelMode(playernum)
	currentWave = currentWave +1
	ramingtime=60
	GameRules:GetGameModeEntity():SetThink(TimingforNextWaveForLevelMode,0)
	return nil
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
	local dummy = Entities:FindByName(nil,"ent_dota_fountain_good")
	dummy:SetThink(function() 
		if GameRules:IsGamePaused() then
			return 0.1
		end
		if ramingtime>50 then 
			return 1
		end
		if timeStoped then
			return 1
		end
		if GameRules:State_Get()==DOTA_GAMERULES_STATE_POST_GAME then
			return nil
		end 
		local wc=currentWave
		if wc==-1 then
			return nil
		end
		local unitofthiswave=CreateUnit((currentWave),worldPoint)
		local delay=unitofthiswave:GetAttackAnimationPoint()
		local delay=delay*1.5
		if delay<0.1 or delay>20 then
			delay=31
		end
		unitofthiswave:RemoveSelf()
		local goldbounty = math.ceil(totalgold[wc]/(80/delay))
		for i=1,#oriForSwaper do
			if not DomainClosed[oriForSwaper[i]:GetName()] then
				local unit = CreateUnit(wc,oriForSwaper[i])
				UnitMove(unit,"FinalDomain")
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
		unit = CreateUnit(currentWave+1,worldPoint)
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
end