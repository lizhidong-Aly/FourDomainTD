require("Parameter")
require("Wave")

function KeepGoingA(trigger)
	if trigger.activator:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		UnitMove(trigger.activator,"waypointB")
	end
end

function KeepGoingB(trigger)
	if trigger.activator:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		UnitMove(trigger.activator,"FinalDomain")
	end
end


function SetSpeed(unit,diff)
	local speed=unit:GetBaseMoveSpeed()*(1+0.2*diff)
	unit:SetBaseMoveSpeed(speed)
end


function EnterFinalDomain(trigger)
	local activator=trigger.activator
	if activator:GetTeamNumber()~=DOTA_TEAM_GOODGUYS  then
		local dmg=activator:GetLevel()
		local hp=fountain:GetHealth()
		local chp=hp-dmg
		local data=100-chp
		AMHC:Damage(fountain,fountain,dmg,DAMAGE_TYPE_PURE,1)
		activator:RemoveSelf()
		if fountain~=nil then
			data=100-fountain:GetHealth()
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(0),"UnitEscaped",{num=data})
		if chp<=0 then
			if fountain~=nil then
				fountain:RemoveSelf()
			end
			GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS)
		end
		--CustomGameEventManager:Send_ServerToAllClients("UnitEscaped",{num=unitEscaped})
		if Mode==1 then
			if isThisWaveFinished() then
				WaveFinished()
			end
		end
	end
end