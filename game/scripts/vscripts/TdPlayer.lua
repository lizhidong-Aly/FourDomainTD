
TdPlayer={
	hero=nil,
	pid=nil,
	eh_current=0,
	eh_limit=INIT_EH_LIMIT,
	TechTree=nil,
	UnitSpawner=nil,
	TowerOwned={},
	towerBuilding="CS01L01",
	CPU=nil,
	all_units={},
	isAbandoned=false,
}
CDOTAPlayer.__index=CDOTAPlayer
TdPlayer.__index = TdPlayer
setmetatable(TdPlayer,CDOTAPlayer)

function TdPlayer:InitPlayer(pid)
	print("Init Player")
	local self = PlayerResource:GetPlayer(pid)
	setmetatable(self,TdPlayer)
	_G.Player[pid]=self
	self.UnitSpawner=UnitSpawner:new(pid)
	self.pid=pid
	self:InitHero()
	self:InitTechTree()
	self.TowerOwned={}
	self.all_units={}
	CustomGameEventManager:RegisterListener( "SendCurrentPortraitUnit", UpdateCurrentPortraitUnit )
  	Timers:CreateTimer({
   		useGameTime = false,
    	callback = function()
	      	self:UpdateUI()
	      	return 1/30
    	end})
	return self
end

function UpdateCurrentPortraitUnit(index,keys)
	--print("UpdateCurrentPortraitUnit")
	local pid=keys.PlayerID
	if pid~=nil and _G.Player[pid]~=nil then
		_G.Player[pid].CPU=keys.unit
	end
end

function TdPlayer:UpdateUI()
	--print("UpdateUI")
	if self.CPU~=nil then
		local unit=EntIndexToHScript(self.CPU)
		local rInfo={
				eh_limit=0,
				eh=0,
				tech=0,
				gold=0,
			}
		if unit~=nil then
			local ownerOfCPU=_G.Player[unit:GetPlayerOwnerID()]
			if ownerOfCPU~=nil then
				rInfo={
					eh_limit=ownerOfCPU.eh_limit,
					eh=ownerOfCPU.eh_current,
					tech=ownerOfCPU.TechTree.TP,
					gold=PlayerResource:GetGold(ownerOfCPU.pid),
				}
			end
		end
		--DeepPrintTable(rInfo)
		SendEventToPlayer(self.pid,"UpdateResourceInfo", rInfo )
------------------------------------------------------------------------------------------------------------
		local tInfo={
					totalcost=0,
					attribute="N",
					upcost="N/A",
					bat=0,
					eh=0,
					energy=0,
					baseRange=0,
					fund_return=0,
				}
-----------------------Unit is Tower--------------------------------------------------------
		if unit~=nil then
			if unit:IsTower() then
				local tower=unit:ToTower()
				if tower~=nil then
					tInfo={
							totalcost=tower.totalCost,
							attribute=_G.TowerInfo[tower.name].attribute,
							bat=tower:GetBaseAttackTime(),
							eh=tower.eh,
							energy=tower.energy,
							baseRange=_G.TowerInfo[tower.name].attRange,
							fund_return=math.ceil(tower.totalCost*REFUND),
						}
					if _G.TowerInfo[tower.name].upgradeTo~=nil then
						tInfo.upcost_gold=_G.TowerInfo[_G.TowerInfo[tower.name].upgradeTo].cost
						local changeOnEH=_G.TowerInfo[tower.nl].eh-tower.eh
						tInfo.upcost_eh=changeOnEH
					else
						tInfo.upcost="N/A"
					end
				end
			else
				tInfo.baseMovSpe=unit:GetBaseMoveSpeed()
				tInfo.movSpe=unit:GetMoveSpeedModifier(tInfo.baseMovSpe)
				tInfo.baseRange=unit:GetAttackRange()
				tInfo.bat=unit:GetBaseAttackTime()
			end
		end
-------------------------------------------------------------------------------------------------
		--DeepPrintTable(tInfo)
		SendEventToPlayer(self.pid, "UpdateTowerInfo", tInfo )
	end
end

function TdPlayer:InitHero()
	self.hero=PlayerResource:GetSelectedHeroEntity(self.pid)
	local hero=self.hero
	hero:SetOrigin(Vector((self.UnitSpawner.pos[1]/2),(self.UnitSpawner.pos[2]/2),256))
	PlayerResource:SetCameraTarget(self.pid,hero)
	Timers:CreateTimer(0.5, function()
    	PlayerResource:SetCameraTarget(self.pid,nil)
    end
  	)
	hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	hero:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	hero:SetBaseStrength(0)
	hero:SetBaseAgility(0)
	hero:SetBaseIntellect(0)
	hero:SetBaseMaxHealth(200)
	hero:AddNewModifier(nil, nil, "modifier_phased", {duration=-1})
	--hero:SetMana(200)
	hero:SetBaseMoveSpeed(550)
	hero:AddItemByName('item_blink')
	for i=0,12 do
		local ability = hero:GetAbilityByIndex(i)
		if ability~=nil then
			hero:RemoveAbility(ability:GetAbilityName())
		end
	end
	local abiList={
		'OpenBuildingMenu',
		'OpenTechMenu',
		'SelectPosition',
		'element_seal_1',
		'element_seal_2',
		'element_seal_3',
	}
	for i,v in pairs(abiList) do 
		hero:AddAbility(v):SetLevel(1)
	end
	hero:SetAbilityPoints(0)
	hero:SetGold(INIT_GOLD,false)
end

function TdPlayer:InitTechTree()
	self.TechTree=TechTree:new(self.pid)
	local tech_tree = self.TechTree
	local tehc_info = _G.TechInfo
	for i,v in pairs(_G.TechInfo) do
		v.current_lv=tech_tree:GetTech(i).current_lv
		v.isLocked=tech_tree:GetTech(i).isLocked
	end
	SendEventToPlayer(self.pid,"InitTechUI", tehc_info)
	--self.TechTree:UpdateTechTree()
	--self.TechTree:UpdateTechUI()
end

function TdPlayer:StartSpawn()
	if not self.isAbandoned then
		self.UnitSpawner:Spawn()
	end
end

function TdPlayer:ModifyCurrentCrystal(change)
	self.eh_current=self.eh_current+change
end