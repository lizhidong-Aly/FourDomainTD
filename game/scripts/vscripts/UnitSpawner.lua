UnitSpawner={
	pid=nil,
	pos=nil,
	count_spawner=0,
	timer_spawner=nil,
}

UnitSpawner.__index = UnitSpawner

function UnitSpawner:new(pid)
	local self={}
	setmetatable(self,UnitSpawner)
	self.pos=_G.SpawnPosition[pid+1]
	self.pid=pid
	return self
end

function UnitSpawner:Spawn()
	if _G.levelNo>40 then
		return 0
	end
	self.timer_spawner=Timers:CreateTimer(DoUniqueString("Timer_Spawner"),
	{
		endTime = SPAWN_DELAY,
		callback = 
		function()
			_G.isOnSpawn=true
			self:OnSpawn()
     		return _G.EnemyType[_G.levelInfo[_G.levelNo].type].distance
    	end
	} )
end

function UnitSpawner:OnSpawn()
	if _G.Player[self.pid].isAbandoned then
		Timers:RemoveTimer(self.timer_spawner)
	end
	self:CreateUnit(_G.levelInfo[_G.levelNo],self.pos,Vector(0,0,0))
	_G.unitRemaining=_G.unitRemaining+1
	self.count_spawner=self.count_spawner+1
	if self.count_spawner==_G.EnemyType[_G.levelInfo[_G.levelNo].type].amount then
		print("End Of This Level")
		_G.isOnSpawn=false
		self.count_spawner=0
		Timers:RemoveTimer(self.timer_spawner)
	end
end

function UnitSpawner:CreateUnit(unitInfo,pos,targetPos)
	local unit=CreateUnitByName(unitInfo.name,pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	unit:CreatureLevelUp(_G.EnemyType[unitInfo.type].lv-1)
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
	unit:SetBaseMaxHealth(unitInfo.hp)
	unit:SetPhysicalArmorBaseValue(unitInfo.armor)
	unit:SetBaseMagicalResistanceValue(unitInfo.magicRes)
	unit:SetBaseMoveSpeed(unitInfo.moveSpeed)
	unit:SetBaseHealthRegen(unitInfo.hpRegen)
	local goldBounty=(_G.levelNo*40)/(_G.EnemyType[unitInfo.type].amount)
	unit:SetMinimumGoldBounty(goldBounty*0.7)
	unit:SetMaximumGoldBounty(goldBounty*1.3)
	if unitInfo.type~="BOSS" and RandomFloat(0,1)<_G.ENEMY_ELITE_CHANCE then
		unit:CreatureLevelUp(unit:GetLevel()*3)
		unit:SetBaseMaxHealth(unitInfo.hp)
		MakeElite(unit)
	end
	for i,v in pairs(unitInfo.abi) do
		unit:AddAbility(v):SetLevel(1)
	end
	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=4})
	unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=2})
	if targetPos~=nil then
		local order = 
			{                                       
	        UnitIndex = unit:entindex(),
	        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
	        TargetIndex = nil, 
	        AbilityIndex = moveTo, 
	        Position =targetPos,
	        Queue = 0 
			}
		unit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(order) end, 0.1)
	end
	return unit
end

function MakeElite(unit)
	unit:AddAbility("enemy_elite"):SetLevel(1)
	local abi_index_a=RandomInt(1,#_G.EnemyEliteAbility)
	unit:SetModelScale(	unit:GetModelScale()*1.2)
	unit:AddAbility(_G.EnemyEliteAbility[abi_index_a]):SetLevel(1)
	if RandomFloat(0,1)<0.5 then
		local abi_index_b=RandomInt(1,#_G.EnemyEliteAbility)
		while abi_index_a==abi_index_b do
			abi_index_b=RandomInt(1,#_G.EnemyEliteAbility)
		end
		unit:AddAbility(_G.EnemyEliteAbility[abi_index_b]):SetLevel(1)
	end
end