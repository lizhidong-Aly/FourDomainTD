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
	eh=0, --element heart or crystal 水晶/人口
	rank=RANK_NORMAL,
	attribute="N",
}

CDOTA_BaseNPC_Creature.__index = CDOTA_BaseNPC_Creature
Tower.__index = Tower
setmetatable(Tower,CDOTA_BaseNPC_Creature)

function Tower:new(tname,pos,pid,totalCost)
	local self=CreateUnitByName(tname,pos,false,nil,nil,DOTA_TEAM_GOODGUYS)
	self:AddNewModifier(nil, nil, "modifier_phased", {duration=-1})
	setmetatable(self,Tower)
	self.name=tname
	self.pid=pid
	self.totalCost=totalCost
	self.nl=_G.TowerInfo[tname].upgradeTo
	if self.nl~=nil then
		self.upcost=_G.TowerInfo[self.nl].cost
	end
	self.eh=_G.TowerInfo[tname].eh
	self.attribute=_G.TowerInfo[tname].attribute
	self:Init()
	return self
end

function CDOTA_BaseNPC_Creature:IsTower()
	return _G.TowerInfo[self:GetUnitName()]~=nil and self:FindAbilityByName("base_passive")==nil
end

function CDOTA_BaseNPC_Creature:ToTower()
	if self:IsTower() then
		local player=_G.Player[self:GetPlayerOwnerID()]
		if player~=nil then
			return player.TowerOwned[self:entindex()]
		end
	end
end


function Tower:Init()
	print("Init Tower")
	_G.Player[self.pid].TowerOwned[self:entindex()]=self
	local tInfo=_G.TowerInfo[self.name]
	local lv=tInfo.lv
	if lv~=nil then
		self:CreatureLevelUp(lv-1)
	else
		self:CreatureLevelUp(string.sub(self.name,7)-1)
	end
	self:SetBaseMaxHealth(100)
	self:SetBaseHealthRegen(0)
	self:SetBaseManaRegen(1)
	self:AddNewModifier(nil, nil, "modifier_rooted", {duration=-1})
	local avgDmg=tInfo.dmgCoefficient*self.totalCost
	local maxDmg=math.floor(avgDmg*1.15)
	local minDmg=math.ceil(avgDmg*0.85)
	self:SetBaseDamageMax(maxDmg)
	self:SetBaseDamageMin(minDmg)
	self:SetBaseAttackTime(tInfo.attSpe)
	self:SetAcquisitionRange(tInfo.attRange)
	if self.pid~=nil then
		local hero=_G.Player[self.pid].hero
		self:SetControllableByPlayer(self.pid, false )
		table.insert(_G.Player[self.pid].all_units,self)
		self:SetOwner(hero)
	end
	self:AbilityInit()
	--Fire game event, will received by the Tech Listener for Tech modify
	FireGameEvent( "tower_built", {tower=self:entindex()} )
end

function Tower:AbilityInit()
	self:AddAbility("SellTower"):SetLevel(1)
	if(_G.TowerInfo[self.name].upgradeTo~=nil) then
		self:AddAbility("Upgrade"):SetLevel(1)
	end
	if MergeList[self.name]~=nil then
		self:AddAbility("Merge"):SetLevel(1)
	end
	for i,v in ipairs(_G.TowerInfo[self.name].abil) do
		local abi= self:AddAbility(v)
		abi:SetLevel(self:GetLevel())
		if bit.band(abi:GetBehavior(),DOTA_ABILITY_BEHAVIOR_TOGGLE)~=0 then
			abi:ToggleAbility()
		end
		if bit.band(abi:GetBehavior(),DOTA_ABILITY_BEHAVIOR_AUTOCAST)~=0 then
			abi:ToggleAutoCast()
		end
	end
---------------------水之印记/冰之印记 被动技能添加
	local label=_G.TowerInfo[self.name].attribute
	if string.find(label,"W")~=nil then
		self:AddAbility("water_mark_passive"):SetLevel(1)
	end
	if string.find(label,"I")~=nil then
		self:AddAbility("ice_mark_passive"):SetLevel(1)
	end
---------------------------------------------------------------
	self:AddAbility("no_health_bar"):SetLevel(1)
end

--------------------融合系统---------------------------------------------

function Tower:MergeTest(target)
---------------------检测是否属同一玩家-----------------------------
	if self.pid~=target.pid then
		ErrorMsg(pid,NOT_OWN_TARGET)
		self:Stop()
		return
	end
---------------------检测是否可融合-----------------------------
	local mIndex=-1
	for i,v in pairs(MergeList[self.name]) do
		if MergeList[self.name][i][3]==target.name then
			mIndex=i
		end
	end
	if mIndex==-1 then
		ErrorMsg(self.pid,NOT_LEGAL_TARGET)
		self:Stop()
		return
	end
---------------------检测金钱是否足够-----------------------------
	local mergeCost=MergeList[self.name][mIndex][1]
	if PlayerResource:GetGold(self.pid)<mergeCost then
		ErrorMsg(self.pid,NOT_ENOUGH_GOLD)
		self:Stop()
		return
	end
---------------------检测水晶是否足够-----------------------------
	local name_new_tower=MergeList[self.name][mIndex][2]
	local eh_new_tower=_G.TowerInfo[name_new_tower].eh
	local changeOnEH=eh_new_tower-self.eh-target.eh
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
	local mName=MergeList[self.name][mIndex][2]
	local mCost=MergeList[self.name][mIndex][1]
	local totalCost=self.totalCost+target.totalCost+mCost
	local pos=self:GetOrigin()
	local energy_a=self.energy
	local energy_b=target.energy
	local player=_G.Player[pid]
	local t=Tower:new(mName,pos,pid,totalCost)
	if(self.rank<RANK_LEGEND and target.rank<RANK_LEGEND and t.rank==RANK_LEGEND) then
		player.eh_limit=player.eh_limit+12
	end
	if(self.rank<RANK_MASTER and target.rank<RANK_MASTER and t.rank==RANK_MASTER) then
		player.eh_limit=player.eh_limit+3
	end
	t:ModifyEnergy(energy_a+energy_b,false)
	SendEventToPlayer(pid,"SelectNewTower", {old=self:entindex(),new=t:entindex()} )
	self:Remove(true)
	target:Remove(true)
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
	local name_new_tower=MergeList[self.name][mIndex][2]
	local cost_new_tower=MergeList[self.name][mIndex][1]
	local eh_new_tower=_G.TowerInfo[name_new_tower].eh
	local changeOnEH=eh_new_tower-self.eh-target.eh

	PlayerResource:ModifyGold(pid,cost_new_tower,false,0)
	player:ModifyCurrentCrystal(-changeOnEH)
end

--------------------------------------------------------------------
function Tower:UpgradeTest()
	local gold = PlayerResource:GetGold(self.pid)
	local cost=self.upcost
	local player=_G.Player[self.pid] 
	-------------金钱足够？--------------
	if gold < cost then
		ErrorMsg(self.pid,NOT_ENOUGH_GOLD)
		self:Stop()
		return
	end
	-------------水晶足够？----------------
	local changeOnEH=_G.TowerInfo[self.nl].eh-self.eh
		if  (player.eh_current+changeOnEH)>player.eh_limit  then
		self:Stop()
		ErrorMsg(self.pid,NOT_ENOUGH_CRYSTAL)
		return
	end
	----------------扣除资源---------------
	PlayerResource:SpendGold(self.pid,cost,0)
	player:ModifyCurrentCrystal(changeOnEH)
end

function Tower:Upgrade()
	print("Upgrade Tower")
	local totalCost=self.totalCost+_G.TowerInfo[self.nl].cost
	local new = Tower:new(_G.TowerInfo[self.name].upgradeTo,self:GetOrigin(),self.pid,totalCost)
	new:ModifyEnergy(self.energy,false)
	SendEventToPlayer(self.pid,"SelectNewTower", {old=self:entindex(),new=new:entindex()} )
	self:Remove(true)
end

function Tower:ReturnUpgradeCost()
	local player=_G.Player[self.pid]
	local cost=self.upcost
	local different=_G.TowerInfo[self.nl].eh-self.eh
	local changeOnEH=_G.TowerInfo[self.nl].eh-self.eh
	PlayerResource:ModifyGold(self.pid,cost,false,0)
	player:ModifyCurrentCrystal(-changeOnEH)
end

function Tower:ModifyEnergy(e,crystalFlag)
	self.energy=self.energy+e
	local player=_G.Player[self.pid]
	if 	(self.rank==RANK_NORMAL and self.energy>=50) then
		self:Advance()
	end 
	if	(self.rank==RANK_ELITE and self.energy>=250) then
		self:Advance()
		if crystalFlag then
			player.eh_limit=player.eh_limit+3
		end
	end 
	if	(self.rank==RANK_MASTER and self.energy>=750) then
		self:Advance()
		if crystalFlag then
			player.eh_limit=player.eh_limit+12
		end
	end
end 

function Tower:Advance()
	print('Advance Tower')
	self.rank=self.rank+1
	if self.rank==RANK_ELITE then
		self:AddAbility("rank_elite_buff"):SetLevel(1)
	elseif self.rank==RANK_MASTER then
		self:RemoveAbility("rank_elite_buff")
		self:RemoveModifierByName("modifier_rank_elite_buff")
		self:AddAbility("rank_master_buff"):SetLevel(1)
	elseif self.rank==RANK_LEGEND then
		self:RemoveAbility("rank_elite_buff")
		self:RemoveModifierByName("modifier_rank_elite_buff")
		self:RemoveAbility("rank_master_buff")
		self:RemoveModifierByName("modifier_rank_master_buff")
		self:AddAbility("rank_legend_buff"):SetLevel(1)
	end
end

function Tower:Sell()
	print("Sell Tower")
	for i=1,8 do
		local a=self:GetAbilityByIndex(i)
		if a~=nil then
			if not a:IsCooldownReady() then
				self:Stop()
				ErrorMsg(self.pid,OTHER_ABILITY_ON_COOLDOWN)
				return
			end
		end
	end
	local fundreturn = math.ceil(self.totalCost*_G.REFUND)
	PlayerResource:ModifyGold(self.pid,fundreturn,false,0)
	local player=_G.Player[self.pid]
	player.eh_current=player.eh_current-self.eh
	self:Remove(false)
end

function Tower:Remove(removeImmediate)
	print("Remove Tower")
	self:ForceKill(false)
	_G.Player[self.pid].TowerOwned[self:entindex()]=nil
	if removeImmediate then 
		self:RemoveSelf()
	end
end
