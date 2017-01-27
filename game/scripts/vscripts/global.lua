
function ClosedAllUI(index,keys)
	SendEventToPlayer(keys.PlayerID,"ClosedAllUI",{})
end

function GetRandomPositionAround(unit)
	local pos=unit:GetOrigin()
	pos[1]=pos[1]+RandomInt(-30,30)
	pos[2]=pos[2]+RandomInt(-30,30)
	return pos
end

function SendEventToPlayer(pid,event,args)
	local conn_state=PlayerResource:GetConnectionState(pid)
	if conn_state==2 then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), event, args )		
	end
end

function MakeUnitsUnselectable(pid)
	local player=_G.Player[pid]
	local hero=player.hero
	hero:FindAbilityByName("OpenBuildingMenu"):SetHidden(true)
	hero:FindAbilityByName("OpenTechMenu"):SetHidden(true)
	hero:FindAbilityByName("SelectPosition"):SetHidden(true)
	for i,v in pairs(player.all_units) do
		if (not v:IsNull()) and v:FindAbilityByName("unit_no_player_can_control")==nil then
			v:AddAbility("unit_no_player_can_control"):SetLevel(1)
		end
	end
end

function MakeUnitsSelectable(pid)
	local player=_G.Player[pid]
	local hero=player.hero
	hero:FindAbilityByName("OpenBuildingMenu"):SetHidden(false)
	hero:FindAbilityByName("OpenTechMenu"):SetHidden(false)
	hero:FindAbilityByName("SelectPosition"):SetHidden(false)
	for i,v in pairs(player.all_units) do
		if (not v:IsNull()) then
			v:RemoveAbility("unit_no_player_can_control")
			v:RemoveModifierByName("modifier_unit_no_player_can_control")
		end
	end
end