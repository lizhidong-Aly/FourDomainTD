
function ClosedAllUI(index,keys)
	SendEventToPlayer(keys.PlayerID,"ClosedAllUI",{})
end

function GetRandomPositionAround(unit)
	local pos=unit:GetOrigin()
	pos[1]=pos[1]+RandomInt(-64,64)
	pos[2]=pos[2]+RandomInt(-64,64)
	return pos
end

function SendEventToPlayer(pid,event,args)
	local conn_state=PlayerResource:GetConnectionState(pid)
	if conn_state==2 then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), event, args )		
	end
end

function SendEventToAllPlayer(event,args)
	for i,v in pairs(_G.Player) do
		SendEventToPlayer(v.pid,event,args)
	end
end

function MakeUnitsUnselectable(pid)
	local player=_G.Player[pid]
	local hero=player.hero
	hero:AddAbility("hero_freezed"):SetLevel(1)
	for i,v in pairs(player.all_units) do
		if (not v:IsNull()) and v:FindAbilityByName("unit_no_player_can_control")==nil then
			v:AddAbility("unit_no_player_can_control"):SetLevel(1)
		end
	end
end

function MakeUnitsSelectable(pid)
	local player=_G.Player[pid]
	local hero=player.hero
	hero:RemoveAbility("hero_freezed")
	hero:RemoveModifierByName("modifier_hero_freezed")
	for i,v in pairs(player.all_units) do
		if (not v:IsNull()) then
			v:RemoveAbility("unit_no_player_can_control")
			v:RemoveModifierByName("modifier_unit_no_player_can_control")
		end
	end
end