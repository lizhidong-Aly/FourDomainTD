require("TechTree")

function OpenTechMenu(keys)
	local pid = keys.caster:GetPlayerID()
	--InitTechTree()
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "OpenTechMenu", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseBUI", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseInfo", {} )
end

function UpdateTechInfo(index,keys)
	local pid=keys.PlayerID
	local tTree=_G.Player[pid].TechTree
	local tech=tTree:GetTech(keys.name)
	if tech==nil then 
		print("Request Tech do not exist")
		return
	end
	local info=tech:GetTechInfo(keys.name)
	if PlayerResource:GetPlayer(keys.PlayerID)==nil then
		print("PlayerID:"..keys.PlayerID.." : do not exist.")
		return
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "UndateTechInfo", info )
end

function UpgradeTech(index,keys)
	local pid=keys.PlayerID
	local tTree=_G.Player[pid].TechTree
	if tTree:UpgradeTech(keys.name) then
		UpdateTechInfo(nil,keys)
	end
end

function UnlockTechInUI(pid,name)
	if not (PlayerResource:GetPlayer(pid)==nil) then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UnlockTech", {name=name} )
	end
end