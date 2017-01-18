UnitSpawner={
	name=nil,
	pid=nil,
	pos=nil,
	levelNo=0,
	count_spawner=0,
	timer_spawner=nil,
	isOnSpawn=false,
}

UnitSpawner.__index = UnitSpawner

function UnitSpawner:new(a,pid)
	local pt={
		Earth=Vector(-4800,4096,128),
		Water=Vector(4096,4800,128),
		Fire=Vector(4800,-4096,128),
		Air=Vector(-4096,-4800,128),
	}
	local self={}
	setmetatable(self,UnitSpawner)
	self.name=a
	self.pos=pt[a]
	self.pid=pid
	return self
end

function UnitSpawner:Spawn()
	if self.levelNo==40 then
		return 0
	end
	self.levelNo=self.levelNo+1
	self.timer_spawner=Timers:CreateTimer(DoUniqueString(self.name),
	{
		endTime = SPAWN_DELAY,
		callback = 
		function()
			self.isOnSpawn=true
			self:OnSpawn()
     		return _G.levelInfo[self.levelNo].distance
    	end
	} )
end

function UnitSpawner:OnSpawn()
	self:CreateUnit(_G.levelInfo[self.levelNo])
	_G.unitRemaining=_G.unitRemaining+1
	self.count_spawner=self.count_spawner+1
	if self.count_spawner==_G.levelInfo[self.levelNo].amount then
		print("End Of This Level")
		self.isOnSpawn=false
		self.count_spawner=0
		Timers:RemoveTimer(self.timer_spawner)
	end
end

function UnitSpawner:CreateUnit(unitInfo)
	local unit=CreateUnitByName(unitInfo.name,self.pos,false,nil,nil,DOTA_TEAM_BADGUYS)
	unit:CreatureLevelUp(unitInfo.lv-unit:GetLevel())
	unit:SetBaseMaxHealth(unitInfo.hp)
	unit:SetPhysicalArmorBaseValue(unitInfo.armor)
	unit:SetBaseMagicalResistanceValue(unitInfo.magicRes)
	if unitInfo.magicImmnue then
		unit:AddNewModifier(nil, nil, "modifier_magic_immune", {})
	end
	unit:SetBaseMoveSpeed(unitInfo.moveSpeed)
	unit:SetBaseHealthRegen(unitInfo.hpRegen)
	unit:SetMinimumGoldBounty(unitInfo.baseGoldBounty)
	local order = 
		{                                       
        UnitIndex = unit:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        TargetIndex = nil, 
        AbilityIndex = 0, 
        Position = Vector(0,0,0),
        Queue = 0 
		}
	unit:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(order) end, 0.1)

	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=4})
	unit:AddNewModifier(nil, nil, "modifier_invulnerable", {duration=2})

	return unit
end
