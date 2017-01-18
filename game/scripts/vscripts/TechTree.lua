require("Tech")
require("Link")
require("BuildUI")
TechTree={
	AllTech={},
	pid=nil,
	TP=0
}

TechTree.__index = TechTree

function TechTree:new(pid)
	local self={}
	setmetatable(self,TechTree)
	self.pid=pid
	self.AllTech=TechTree:InitContent()
	self.TP=INIT_TECH_POINT
	return self
end

function TechTree:InitContent()
	local all={}
	all[1]=Tech:new("ET01","earth_spirit_boulder_smash",1,3,nil)
	all[2]=Tech:new("ET11","earth_spirit_boulder_smash",1,5,{Link:new(all[1],1)})
	all[3]=Tech:new("ET21","earth_spirit_boulder_smash",1,7,{Link:new(all[2],1)})
	all[4]=Tech:new("ET31","earth_spirit_boulder_smash",1,9,{Link:new(all[3],1)})
	
	all[5]=Tech:new("WT01","invoker_quas",1,3,nil)
	all[6]=Tech:new("WT11","invoker_quas",1,5,{Link:new(all[5],1)})
	all[7]=Tech:new("WT21","invoker_quas",1,7,{Link:new(all[6],1)})
	all[8]=Tech:new("WT31","invoker_quas",1,9,{Link:new(all[7],1)})
	
	all[9]=Tech:new("FT01","invoker_exort",1,3,nil)
	all[10]=Tech:new("FT11","invoker_exort",1,5,{Link:new(all[9],1)})
	all[11]=Tech:new("FT21","invoker_exort",1,7,{Link:new(all[10],1)})
	all[12]=Tech:new("FT31","invoker_exort",1,9,{Link:new(all[11],1)})
	
	all[13]=Tech:new("AT01","skywrath_mage_concussive_shot",1,3,nil)
	all[14]=Tech:new("AT11","skywrath_mage_concussive_shot",1,5,{Link:new(all[13],1)})
	all[15]=Tech:new("AT21","skywrath_mage_concussive_shot",1,7,{Link:new(all[14],1)})
	all[16]=Tech:new("AT31","skywrath_mage_concussive_shot",1,9,{Link:new(all[15],1)})
	
	all[17]=Tech:new("ET12","sandking_sand_storm",1,5,{Link:new(all[2],1)})
	all[18]=Tech:new("AT02","razor_unstable_current",1,2,{Link:new(all[13],1)})
	all[19]=Tech:new("FT12","huskar_berserkers_blood",1,2,{Link:new(all[10],1)})
	all[20]=Tech:new("ET22","enigma_black_hole",1,3,{Link:new(all[3],1)})
	all[21]=Tech:new("WT02","tidehunter_gush",1,2,{Link:new(all[5],1)})
	all[22]=Tech:new("WT12","tusk_frozen_sigil",1,2,{Link:new(all[6],1)})
	all[23]=Tech:new("FT02","shadow_demon_disruption",1,3,{Link:new(all[9],1)})

	all[24]=Tech:new("ET02","tiny_avalanche",1,1,{Link:new(all[1],1)})
	all[25]=Tech:new("WT03","lich_chain_frost",1,1,{Link:new(all[5],1)})
	all[26]=Tech:new("FT03","phoenix_supernova",1,1,{Link:new(all[9],1)})
	all[27]=Tech:new("AT03","disruptor_thunder_strike",1,1,{Link:new(all[13],1)})

	return all
end



function TechTree:UpdateTechTree()
	for i=1,#self.AllTech do
		if self.AllTech[i]:CanUpgrade() then
			UnlockTechInUI(self.pid,self.AllTech[i]:GetName())
		end
	end
end

function TechTree:UpgradeTech(name)
	for i=1,#self.AllTech do
		if self.AllTech[i]:GetName() == name then
			if self.AllTech[i]:CanUpgrade() then
				local cost=self.AllTech[i]:GetUpgradeCost()
				if self.AllTech[i]:CanLevelUp() then
					if self:UseTechPoint(cost) then
						self.AllTech[i].lvl=self.AllTech[i].lvl+1
						self:Activate(self.AllTech[i]:GetName())
						self:UpdateTechTree()
						return true
					else
						ErrorMsg(self.pid,NOT_ENOUGH_TP)
					end
				else
					ErrorMsg(self.pid,TECH_REACH_MAX_LEVEL)
				end
			else
				ErrorMsg(self.pid,TECH_NEED_UNLOCK)
			end
		end
	end
end

function TechTree:IncreaseTechPoint(n)
	self.TP=self.TP+n
end

function TechTree:UseTechPoint(p)
	if self.TP>=p then
		self.TP=self.TP-p
		return true
	else 
		return false
	end
end

function TechTree:GetTech(name)
	for i=1,#self.AllTech do
		if self.AllTech[i]:GetName() == name then
			return self.AllTech[i]
		end
	end
end

function TechTree:GetAllTowerByName(name)
	local pid = self.pid
	local alltower=_G.Player[pid].TowerOwned
	local t={}
	if not (alltower==nil) then
		for i,v in pairs(alltower) do 
			if not (string.find(v:GetUnitName(),name)==nil) then
					print("PlyarID:"..pid.."     GetAllTowerByName work:   "..v:GetUnitName())
					table.insert(t,v)
			end
		end
	end
	return t
end


function TechTree:GetAllTowerByLabel(label)
	local pid = self.pid
	local alltower=_G.Player[pid].TowerOwned
	local t={}
	if not (alltower==nil) then
		for i,v in pairs(alltower) do
			if not v:IsNull() then
				if not (string.find(v:GetUnitLabel(),label)==nil) then
					print("PlyarID:"..pid.."     GetAllTowerByName work:   "..v:GetUnitLabel())
					table.insert(t,v)
				end
			end
		end
	end
	return t
end

function TechTree:ModifyTower(name,level,tech)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name=name,entry=level,tech=tech})
	local tow=self:GetAllTowerByLabel(name)
	for i=1,#tow do
		if not tow[i]:IsNull() then
			local abi=tow[i]:FindAbilityByName("attribute_bouns".."_"..name)
			if abi==nil then
				tow[i]:AddAbility("attribute_bouns".."_"..name)
				abi=tow[i]:FindAbilityByName("attribute_bouns".."_"..name)
			end
			abi:SetLevel(level)
		end
	end
end


TechFun={
ET01=(function(self)
	local towerList={"ET01L01","ET02L01","ET03L01"}
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

ET02=(function(self)
	local towerList={"ES01L01"}
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

ET11=(function(self)
	local towerList={"ET11L01","ET12L01","ET13L01"}

	self:ModifyTower("E",2,"ET11")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

ET12=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="ET12L",tech="ET12"})
	local tow=self:GetAllTowerByName("ET12")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:RemoveAbility("sandstorm")
			tow[i]:AddAbility("sandstorm_e")
			tow[i]:FindAbilityByName("sandstorm_e"):SetLevel(tow[i]:GetLevel())
		end
	end
end),

ET21=(function(self)
	local towerList={"ET21L01"}

	self:ModifyTower("E",3,"ET21")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

ET22=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="ET21L03",tech="ET22"})
	local tow=self:GetAllTowerByName("ET21L03")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:RemoveAbility("griavty_control")
			tow[i]:AddAbility("griavty_control_e")
			tow[i]:FindAbilityByName("griavty_control_e"):SetLevel(tow[i]:GetLevel())
		end
	end
end),


ET31=(function(self)
	self:ModifyTower("E",4,"ET31")
end),




WT01=(function(self)
	local towerList={"WT02L01","WT01L01","WT03L01"}

	self:ModifyTower("W",1,"WT01")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

WT02=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="WT01L0",tech="WT02"})
	local tow=self:GetAllTowerByName("WT01")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:RemoveAbility("water_mark")
			tow[i]:AddAbility("water_mark_e")
			tow[i]:FindAbilityByName("water_mark_e"):SetLevel(tow[i]:GetLevel())
		end
	end
end),

WT03=(function(self)
	local towerList={"WS01L01"}

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

WT11=(function(self)
	local towerList={"WT11L01","WT13L01"}

	self:ModifyTower("W",2,"WT11")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

WT12=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="WT13L0",tech="WT12"})
	local tow=self:GetAllTowerByName("WT13")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:RemoveAbility("ice_mark")
			tow[i]:AddAbility("ice_mark_e")
			tow[i]:FindAbilityByName("ice_mark_e"):SetLevel(tow[i]:GetLevel())
		end
	end
end),

WT21=(function(self)
	local towerList={"WT21L01"}

	self:ModifyTower("W",3,"WT21")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

WT31=(function(self)
	self:ModifyTower("W",4,"WT31")
end),



FT01=(function(self)
	local towerList={"FT01L01","FT02L01","FT03L01"} 

	self:ModifyTower("F",1,"FT01")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList)
end),

FT02=(function(self)
	print("FT02 NOW WORK")
end),

FT03=(function(self)
	local towerList={"FS01L01"}

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

FT11=(function(self)
	local towerList={"FT11L01","FT12L01","FT13L01"}

	self:ModifyTower("F",2,"FT11")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

FT12=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="FT12L0",tech="FT12"})
	local tow=self:GetAllTowerByName("FT12")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:RemoveAbility("burning_soul")
			tow[i]:AddAbility("burning_soul_e")
			tow[i]:FindAbilityByName("burning_soul_e"):SetLevel(tow[i]:GetLevel())
		end
	end
end),

FT21=(function(self)
	self:ModifyTower("F",3,"FT21")
end),

FT31=(function(self)
	self:ModifyTower("F",4,"FT31")
end),



AT01=(function(self)
	local towerList={"AT02L01","AT03L01","AT01L01"}

	self:ModifyTower("A",1,"AT01")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),


AT02=(function(self)
	ListenerIndex=ListenToGameEvent("tower_built", Dynamic_Wrap(TechTree, "TechListener"), {pid=self.pid,name="AT03L0",tech="AT02"})
	local tow=self:GetAllTowerByName("AT03")
	for i=1,#tow do
		if not tow[i]:IsNull() then
			tow[i]:SetBaseAttackTime(0.7)
		end
	end
end),


AT03=(function(self)
	local towerList={"AS01L01"}

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList )
end),

AT11=(function(self)
	local towerList={"AT11L01","AT12L01","AT13L01"} 

	self:ModifyTower("A",2,"AT11")
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(self.pid), "UnlockTower", towerList)
end),

AT21=(function(self)
	self:ModifyTower("A",3,"AT21")
end),

AT31=(function(self)
	self:ModifyTower("A",4,"AT31")
end),
}

function TechTree:Activate(name)
	TechFun[name](self)
end


function TechTree:TechListener(keys)
	local unit=EntIndexToHScript(keys.tower)
	local pid=unit:GetPlayerOwnerID()
	if unit:IsCreature() then
		if pid==self.pid then
			if not (string.find(_G.TowerInfo[unit:GetUnitName()].attribute,self.name)==nil) then
				if self.entry~=nil then
					abil=unit:FindAbilityByName("attribute_bouns".."_"..self.name)
					if abil==nil then
						unit:AddAbility("attribute_bouns".."_"..self.name)
					end
					unit:FindAbilityByName("attribute_bouns".."_"..self.name):SetLevel(self.entry)
				end
			end
			if not (string.find(unit:GetUnitName(),self.name)==nil) then
				local list={
						{"ET12","sandstorm"},
						{"ET22","griavty_control"},
						{"FT12","burning_soul"},
						{"WT02","water_mark"},
						{"WT12","ice_mark"},
					}
				for i=1,#list do
					if self.tech==list[i][1] then
						unit:RemoveAbility(list[i][2])
						if unit:FindAbilityByName(list[i][2].."_e")==nil then
							unit:AddAbility(list[i][2].."_e")
						end
						unit:FindAbilityByName(list[i][2].."_e"):SetLevel(unit:GetLevel())
					end
				end
				if self.tech=="AT02" then
					unit:SetThink(function() unit:SetBaseAttackTime(0.7) return nil end, 0.01)
				end
			end
		end
	end
end

