require("TechTree")

function OpenTechMenu(keys)
	local pid = keys.caster:GetPlayerOwnerID()
	--InitTechTree()
	SendEventToPlayer(pid, "OpenTechMenu", {} )
	SendEventToPlayer(pid, "CloseBUI", {} )
	SendEventToPlayer(pid, "CloseInfo", {} )
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
	SendEventToPlayer(keys.PlayerID, "UndateTechInfo", info )
end

function UpgradeTech(index,keys)
	local pid=keys.PlayerID
	local tTree=_G.Player[pid].TechTree
	if tTree:UpgradeTech(keys.name) then
		UpdateTechInfo(nil,keys)
	end
end

function UnlockTechInUI(pid,name)
	SendEventToPlayer(pid,"UnlockTech", {name=name} )
end