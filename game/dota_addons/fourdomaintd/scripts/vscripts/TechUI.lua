require("TechTree")

function OpenTechMenu(keys)
	local pid = keys.caster:GetPlayerID()
	--InitTechTree()
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "OpenTechMenu", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseBUI", {} )
	CustomGameEventManager:Send_ServerToPlayer( keys.caster:GetPlayerOwner(), "CloseInfo", {} )
end

function InitTechTree()
	if Tree[0]==nil then
		playernum=PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
		for i=1,playernum do
			Tree[i-1]=TechTree:new(i-1)
			Tree[i-1]:UpdateTechTree()
			towerUnlocked[i-1]={}
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i-1), "UpdateTechPoint", {point=Tree[i-1]:GetTechPoint()} )
		end
	end
end

function UpdateTechInfo(index,keys)
	local tech=Tree[keys.PlayerID]:GetTech(keys.name)
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
	if Tree[keys.PlayerID]:UpgradeTech(keys.name) then
		UpdateTechInfo(nil,keys)
	end
end

function UnlockTechInUI(pid,name)
	if not (PlayerResource:GetPlayer(pid)==nil) then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UnlockTech", {name=name} )
	end
end