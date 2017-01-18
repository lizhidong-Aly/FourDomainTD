RANK_NORMAL=0
RANK_ELITE=1
RANK_MASTER=2
RANK_LEGEND=3

Tower={
	name=nil,
	pid=nil,
	totalCost=0,
	energy=0,
	nl=nil,
	upcost=nil,
	eh=0,
	rank=RANK_NORMAL
}

CDOTA_BaseNPC_Creature.__index = CDOTA_BaseNPC_Creature
Tower.__index = Tower
setmetatable(Tower,CDOTA_BaseNPC_Creature)

function Tower:new(tname,pos,pid,totalCost)
	local self=CreateUnitByName(tname,pos,false,nil,nil,DOTA_TEAM_GOODGUYS)
	self:AddNewModifier(nil, nil, "modifier_phased", {duration=4})
	setmetatable(self,Tower)
	self.name=tname
	self.pid=pid
	self.totalCost=totalCost
	self.nl=_G.TowerInfo[tname].upgradeTo
	if self.nl~=nil then
		self.upcost=_G.TowerInfo[self.nl].cost
	end
	self.eh=_G.TowerInfo[tname].eh
	self:Init()
	return self
end

function CDOTA_BaseNPC_Creature:IsTower()
	return _G.TowerInfo[self:GetUnitName()]~=nil
end

function CDOTA_BaseNPC_Creature:ToTower()
	if self:IsTower() then
		return _G.Player[self:GetPlayerOwnerID()].TowerOwned[self:entindex()]
	end
end


function Tower:Init()
	print("Init Tower")
	_G.Player[self.pid].TowerOwned[self:entindex()]=self
	self:SetBaseDamageMax(_G.TowerInfo[self.name].maxAttDmg)
	self:SetBaseDamageMin(_G.TowerInfo[self.name].minAttDmg)
	self:SetBaseAttackTime(_G.TowerInfo[self.name].attSpe)
	--self:SetBaseAttackRange(_G.TowerInfo[self.name].attRange)
	if self.pid~=nil then
		local hero=PlayerResource:GetPlayer(self.pid):GetAssignedHero()
		self:SetControllableByPlayer(self.pid, false )
		self:SetOwner(hero)
	end
	self:AbilityInit()
	self:MergeInit()
	local tower={
			tower=self:entindex(),
		}
	FireGameEvent( "tower_built", tower )
end

function Tower:AbilityInit()
	self:AddAbility("SellTower")
	self:FindAbilityByName("SellTower"):SetLevel(1)

	if(_G.TowerInfo[self.name].upgradeTo~=nil) then
		self:AddAbility("Upgrade")
		self:FindAbilityByName("Upgrade"):SetLevel(1)
	end
	for i,v in ipairs(_G.TowerInfo[self.name].abil) do 
		self:AddAbility(v)
		self:FindAbilityByName(v):SetLevel(self:GetLevel())
	end
---------------------水之印记/冰之印记 被动技能添加
	local label=_G.TowerInfo[self.name].attribute
	if string.find(label,"W")~=nil then
		self:AddAbility("water_mark_passive")
		self:FindAbilityByName("water_mark_passive"):SetLevel(1)
	end
	if string.find(label,"I")~=nil then
		self:AddAbility("ice_mark_passive")
		self:FindAbilityByName("ice_mark_passive"):SetLevel(1)
	end
---------------------------------------------------------------
	self:AddAbility("no_health_bar")
	self:FindAbilityByName("no_health_bar"):SetLevel(1)
end

--------------------融合系统---------------------------------------------

function Tower:MergeInit()
	if MergeList[self.name]~=nil then
		self:AddAbility("Merge")
		self:FindAbilityByName("Merge"):SetLevel(1)
	end
end

function Tower:MergeTest(target)
	if self.pid~=target.pid then
		ErrorMsg(pid,NOT_OWN_TARGET)
		self:Stop()
		return
	end

	local mIndex=-1
	for i=1,#MergeList[self.name] do
		if MergeList[self.name][i][3]==target.name then
			mIndex=i
		end
	end
	if mIndex==-1 then
		ErrorMsg(self.pid,NOT_OWN_TARGET)
		self:Stop()
		return
	end

	local mergeCost=MergeList[self.name][mIndex][1]
	if PlayerResource:GetGold(self.pid)<mergeCost then
		ErrorMsg(self.pid,NOT_ENOUGH_GOLD)
		self:Stop()
		return
	end
	local mName= MergeList[self.name][mIndex][2]
	local mEH=_G.TowerInfo[mName].eh
	local changeOnEH=mEH-self.eh-target.eh
	local player=_G.Player[self.pid]
	if (player.eh_current+changeOnEH)>player.eh_limit then
		self:Stop()
		ErrorMsg(self.pid,NOT_ENOUGH_CRYSTAL)
		return
	end

	PlayerResource:SpendGold(self.pid,mergeCost,0)
	player:ModifyCurrentCrystal(changeOnEH)
end

function Tower:Merge(target)
	local pid=self.pid
	local mIndex=-1
	for i=1,#MergeList[self.name] do
		if MergeList[self.name][i][3]==target.name then
			mIndex=i
		end
	end
	DeepPrintTable(MergeList)
	local mName=MergeList[self.name][mIndex][2]
	local mCost=MergeList[self.name][mIndex][1]
	local totalCost=self.totalCost+target.totalCost+mCost
	local pos=self:GetOrigin()
	self:Remove(true)
	target:Remove(true)
	local t=Tower:new(mName,pos,pid,totalCost)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "SelectNewTower", {old=self:entindex(),new=t:entindex()} )

	--[[
	local caster=keys.caster
	local target=keys.target
	local cname=caster:GetUnitName()
	local tname=target:GetUnitName()
	local pid=caster:GetPlayerOwnerID()
	local mIndex=-1
	for i=1,#MergeList[cname] do
		if MergeList[cname][i][3]==tname then
			mIndex=i
		end
	end
	if target:IsAlive() then
		local nlname = MergeList[cname][mIndex][2]
		local totalcost = GetTowerTotalCost(caster)+GetTowerTotalCost(target)+MergeList[cname][mIndex][1]
		local pos=caster:GetOrigin()
		caster:ForceKill(false)
		target:ForceKill(false)
		RemoveTowerFromTable(alltower[pid],caster)
		RemoveTowerFromTable(alltower[pid],target)
		caster:SetThink(function()  caster:RemoveSelf() return nil end, 0.02)
		local unit=CreateUnitByName(nlname,pos,false,nil,nil,DOTA_TEAM_GOODGUYS)
		CustomGameEventManager:Send_ServerToPlayer( caster:GetPlayerOwner(), "SelectNewTower", {old=caster:entindex(),newone=unit:entindex()} )
		IniTower(pid,unit,totalcost)
	end]]
end

function Tower:ReturnMergeCost(target)
	local pid=self.pid
	local player=_G.Player[self.pid]
	local mIndex=-1
	for i=1,#MergeList[self.name] do
		if MergeList[self.name][i][3]==target.name then
			mIndex=i
		end
	end
	local mName=MergeList[self.name][mIndex][2]
	local mCost=MergeList[self.name][mIndex][1]
	local mEH=_G.TowerInfo[mName].eh
	local changeOnEH=mEH-self.eh-target.eh
	PlayerResource:ModifyGold(pid,mCost,false,0)
	player:ModifyCurrentCrystal(-changeOnEH)
end

--------------------------------------------------------------------
function Tower:UpgradeTest()
	if self.pid~=self:GetMainControllingPlayer() then
		t:Stop()
		return
	end
	local gold = PlayerResource:GetGold(self.pid)
	local cost=self.upcost
	-------------金钱足够？--------------
	if gold < cost then
		ErrorMsg(self.pid,NOT_ENOUGH_GOLD)
		self:Stop()
		return
	end
	-------------水晶足够？----------------
	local different=_G.TowerInfo[self.nl].eh-self.eh
		if  (_G.Player[self.pid].eh_current+different)>_G.Player[self.pid].eh_limit  then
		self:Stop()
		ErrorMsg(self.pid,NOT_ENOUGH_CRYSTAL)
		return
	end
	----------------扣除资源---------------
	PlayerResource:SpendGold(self.pid,cost,0)
	_G.Player[self.pid].eh_current=_G.Player[self.pid].eh_current+different
end

function Tower:Upgrade()
	print("Upgrade Tower")
	local totalCost=self.totalCost+_G.TowerInfo[self.nl].cost
	local new = Tower:new(_G.TowerInfo[self.name].upgradeTo,self:GetOrigin(),self.pid,totalCost)
	new:ModifyEnergy(self.energy)
	self:Remove(true)
	CustomGameEventManager:Send_ServerToPlayer( self:GetPlayerOwner(), "SelectNewTower", {old=self:entindex(),new=new:entindex()} )
end

function Tower:ReturnUpgradeCost()
	local cost=self.upcost
	local different=_G.TowerInfo[self.nl].eh-self.eh
	PlayerResource:ModifyGold(self.pid,cost,false,0)
	_G.Player[self.pid].eh_current=_G.Player[self.pid].eh_current-different
end

function Tower:ModifyEnergy(e)
	self.energy=self.energy+e
	if 	(self.rank==RANK_NORMAL and self.energy>=50) then
		self:Advance()
	end 
	if	(self.rank==RANK_ELITE and self.energy>=250) then
		self:Advance()
	end 
	if	(self.rank==RANK_MASTER and self.energy>=750) then
		self:Advance()
	end
end

function Tower:Advance()
	print('Advance Tower')
	self.rank=self.rank+1
	if self.rank==RANK_ELITE then
		self:AddAbility("rank_elite_buff"):SetLevel(1)
	elseif self.rank==RANK_MASTER then
		self:AddAbility("rank_master_buff"):SetLevel(1)
	elseif self.rank==RANK_LEGEND then
		self:AddAbility("rank_legend_buff"):SetLevel(1)
	end
end

function Tower:Sell()
	print("Sell Tower")
	if self.pid~=self:GetMainControllingPlayer() then
		return
	end
	local fundreturn = self.totalCost
	PlayerResource:ModifyGold(self.pid,fundreturn,false,0)
	_G.Player[self.pid].eh_current=_G.Player[self.pid].eh_current-_G.TowerInfo[self:GetUnitName()].eh
	self:Remove(false)
end

function Tower:Remove(removeImmediate)
	print("Remove Tower")
	self:ForceKill(false)
	_G.Player[self.pid].TowerOwned[self:entindex()]=nil
	if removeImmediate then 
		self:SetThink(function()  self:RemoveSelf() return nil end, 0.02)
	end
end
