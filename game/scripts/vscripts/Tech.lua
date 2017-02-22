Tech={
	name=nil,
	current_lv=0,
	isLocked=true,
	tech_tree={},
	pid=nil,
}

Tech.__index = Tech

function Tech:new(tech_name,tech_tree)
	self.name=tech_name
	self.current_lv=0
	self.tech_tree=tech_tree
	self.pid=tech_tree.pid
	self.isLocked=true
	if _G.TechInfo[tech_name].prerequest==nil then
		self.isLocked=false
	end
	return self
end

function Tech:GetCurrentLevel()
	return self.current_lv
end

function Tech:LevelUp()
	-------------------是否达到等级上限
	if self:GetCurrentLevel()>=self:GetMaxLevel() then
		ErrorMsg(self.pid,TECH_REACH_MAX_LEVEL)
		return false
	end
	------------------精化是否足够
	if self.tech_tree.TP<self:GetUpgradeEssenceNeeded() then
		ErrorMsg(self.pid,NOT_ENOUGH_TP)
		return false
	end
	------------------通过检定，升级科技
	self.current_lv=self.current_lv+1
	self.tech_tree.TP=self.tech_tree.TP-self:GetUpgradeEssenceNeeded()
	self:Activate()
	return true
end

function Tech:GetMaxLevel()
	return _G.TechInfo[self.name].maxlv
end

function Tech:GetUpgradeEssenceNeeded()
	return _G.TechInfo[self.name].upgrade_essence_needed[self.current_lv+1]
end

function Tech:Activate()
	local targets=self:GetEffectedTatgets()
	for i,v in pairs(targets) do
		TechFun[self.name](self,v)
	end
end

function Tech:GetEffectedTatgets()
	local t={}
	local target_filter=_G.TechInfo[self.name].target
	if target_filter=="all" then
		t=_G.Player[self.pid].TowerOwned
	end
	return t
end


TechFun={
GT01=(function(self,tower)
	TechFunType[ModifyTowerByAbility](tower,"GT01")
end),

GT02=(function(self,tower)
	TechFunType[ModifyTowerByAbility](tower,"GT02")
end),

GT03=(function(self,tower)
	TechFunType[ModifyTowerByAbility](tower,"GT03")
end),

ET01=(function(self,tower)
	TechFunType[ModifyTowerByAbility](tower,"ET01")
end),

ET02=(function(self,tower)
	
end),

ET03=(function(self,tower)
	
end),
}

TechFunType={
	ModifyTowerByAbility=(function(tower,tech_name)
		print("Modify tower"..tech_name)
		--[[
		local tech_ability=tower:FindAbilityByName(tech_name.."_ability")
		if tech_ability==nil then
			tech_ability=tower:AddAbility(tech_name.."_ability")
		end
		tech_ability:SetLevel(self:GetTechCurrentLevel(tech_name))]]--
	end)
}