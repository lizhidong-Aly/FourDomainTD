Tech={
	name=nil,
	current_lv=-1,
	tech_tree={},
	pid=nil,
	filter=nil,
}

Tech.__index = Tech

function Tech:new(tech_name,tech_tree)
	local self={}
	setmetatable(self,Tech)
	self.name=tech_name
	self.tech_tree=tech_tree
	self.pid=tech_tree.pid
	self.isLocked=true
	self.filter=_G.TechInfo[tech_name].target
	if _G.TechInfo[tech_name].prerequest==nil then
		self.current_lv=0
	end
	return self
end

function Tech:GetCurrentLevel()
	return self.current_lv 
end

function Tech:LevelUp()
	-------------------是否已解锁
	if self:GetCurrentLevel()==-1 then
		ErrorMsg(self.pid,TECH_NEED_UNLOCK)
		return false
	end
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
	self.tech_tree.TP=self.tech_tree.TP-self:GetUpgradeEssenceNeeded()
	self.current_lv=self.current_lv+1
	self:Activate()
	return true
end

function Tech:GetMaxLevel()
	return _G.TechInfo[self.name].maxlv
end

function Tech:GetUpgradeEssenceNeeded()
	return _G.TechInfo[self.name].upgrade_essence_needed[tostring(self.current_lv+1)]
end

function Tech:Activate()
	if self.filter~=nil then
		for i,v in pairs(_G.Player[self.pid].TowerOwned) do
			if self:IsTowerTarget(v) then
				self:ModifyTowerByAbility(v)
			end
		end
	end
	local unlock_table=_G.TechInfo[self.name].tower_unlock
	if unlock_table~=nil then
		local towerList=unlock_table[tostring(self:GetCurrentLevel())]
		if towerList~=nil then
			SendEventToPlayer(self.pid, "UnlockTower", towerList )
		end
	end
	if TechFun[self.name]~=nil then
		TechFun[self.name](self)
	end
end

function Tech:IsTowerTarget(tower)
	if self.filter==nil then
		return false
	end
	------------------作用于全部防御塔
	if self.filter=="all" then
		return true
	end
	------------------作用于特定属性的防御塔
	if string.len(self.filter)==1 then
		if string.find(tower.attribute,self.filter)~=nil then
			return true
		end
	end
	------------------作用于特定种类的防御塔
	if string.len(self.filter)==4 then
		if string.sub(tower.name,1,4)==self.filter then
			return true
		end
	end
	------------------作用于特定种类特定等级的防御塔
	if string.len(self.filter)==7 then
		if tower.name==self.filter then
			return true
		end
	end
	return false
end


TechFun={
-----------------通用科技行为定义

GT07=(function(self)
	_G.Fountain:SetMaxHealth(_G.Fountain:GetMaxHealth()+5)
	_G.Fountain:SetHealth(_G.Fountain:GetHealth()+5)
end),

-----------------地科技行为定义


-----------------水科技行为定义


-----------------火科技行为定义


-----------------气科技行为定义


}

function Tech:ModifyTowerByAbility(tower)
	local tech_ability=tower:FindAbilityByName(self.name)
	if tech_ability==nil then
		tech_ability=tower:AddAbility(self.name)
	end
	if tech_ability~=nil then 
		tech_ability:SetLevel(self:GetCurrentLevel())
	end
end
