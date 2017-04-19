require("Tech")

function OpenTechMenu(keys)
	local pid = keys.caster:GetPlayerOwnerID()
	--InitTechTree()
	SendEventToPlayer(pid, "OpenTechMenu", {} )
	SendEventToPlayer(pid, "CloseBUI", {} )
	SendEventToPlayer(pid, "CloseInfo", {} )
end

function UpgradeTech(index,keys)
	local pid=keys.PlayerID
	local tech_tree=_G.Player[pid].TechTree
	tech_tree:UpgradeTech(keys.name)
end

function InitTechUI(index,keys)
	local pid = keys.PlayerID
	if _G.Player[pid]~=nil then 
		local tech_tree = _G.Player[pid].TechTree
		local tehc_info = _G.TechInfo
		for i,v in pairs(_G.TechInfo) do
			v.current_lv=tech_tree:GetTech(i).current_lv
		end
		SendEventToPlayer(pid,"InitTechUI", tehc_info)
	end
end

TechTree={
	all_tech={},
	pid=nil,
	TP=0,
	listener=nil,
}

TechTree.__index = TechTree

function TechTree:new(pid)
	local self={}
	setmetatable(self,TechTree)
	self.pid=pid
	self.TP=INIT_TECH_POINT
	self.all_tech={}
	self.listener=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), self)
	for i,v in pairs(_G.TechInfo) do
		self.all_tech[i]=Tech:new(i,self)
	end
	return self
end

function TechTree:GetTech(tech_name)
	return self.all_tech[tech_name]
end

function TechTree:UpgradeTech(tech_name)
	local tech=self:GetTech(tech_name)
	if tech:LevelUp() then
		self:UpdateTechUI(tech)
	end
end

function TechTree:UpdateTechUI(tech)
	if tech~=nil then
		SendEventToPlayer(self.pid,"UndateTechInfo", {tech=tech.name,lv=tech:GetCurrentLevel()})
	end
	for i,v in pairs(self.all_tech) do
		if v.current_lv==-1 and _G.TechInfo[i].prerequest~=nil then
			local unlock_flag=true
			for index,prerequest in pairs(_G.TechInfo[i].prerequest) do
				if self:GetTech(prerequest.tech_name):GetCurrentLevel()<prerequest.lv_needed then
					unlock_flag=false
				end
			end
			if unlock_flag then
				v.current_lv=0
				SendEventToPlayer(self.pid,"UndateTechInfo", {tech=v.name,lv=0})
			end
		end
	end
end

function TechTree:IncreaseTechPoint(n)
	self.TP=self.TP+n
end

function TechTree:TechListener(keys)
	local unit=EntIndexToHScript(keys.tower)
	local pid=unit:GetPlayerOwnerID()
	if self.pid==pid then
		local tower=unit:ToTower()
		for i,v in pairs(self.all_tech) do
			if  v:GetCurrentLevel()>0 and v:IsTowerTarget(tower) then
				v:ModifyTowerByAbility(tower)
			end
		end
	end
end
