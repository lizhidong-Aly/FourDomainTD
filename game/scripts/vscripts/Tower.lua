require("Parameter")
require("MergeUI")
function GetTowerTotalCost(unit)
	return unit:GetDeathXP()
end

function GetUpgradeCost(unit)
	return unit:GetBaseDayTimeVisionRange()
end

function GetBuildCost(name)
	if name==nil then
		return -1
	end
	local unit = CreateUnitByName(name,Entities:FindByName(nil,Domain[1]):GetOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)
	local cost = unit:GetDeathXP()
	unit:RemoveSelf()
	return cost
end


function GetNextLevelName(unit)
	local name=unit:GetUnitName()
	local length = string.len(name)
	return string.sub(name,1,length-1)..(string.sub(name,length)+1)
end

AL={
	S=3.5,
	A=2.6,
	B=2.0,
	C=1.6,
	D=1.3,
	E=1
}
SL={
	S=0.6,
	A=0.8,
	B=1.0,
	C=1.2,
	D=1.4,
	E=1.7
}
TowerInfo={
	CS01L0={AL.B,SL.B,"head_shoot",nil,"SellTower","Upgrade"},
	CS01L1={0.35,SL.S,"dragon_breath",nil,nil,nil},
	CS01L2={5,4.5,"earth_shot",nil,nil,nil},
	CS02L0={AL.E,1.3,"booty_gold",nil,"SellTower","Upgrade"},
	ES01L0={0,1,"earth_core_aura","earth_core_overload","SellTower","Upgrade"},
	WS01L0={0,1,"water_core_aura","water_core_overload","SellTower","Upgrade"},
	FS01L0={0,1,"fire_core_aura","fire_core_overload","SellTower","Upgrade"},
	AS01L0={0,1,"lightning_core_aura","lightning_core_overload","SellTower","Upgrade"},

	ET01L0={AL.B,SL.C,"splash_attack",nil,"SellTower","Upgrade"},
	ET02L0={AL.S,SL.E,"stun_hit",nil,"SellTower","Upgrade"},
	ET03L0={AL.D,SL.C,"earth_blessing",nil,"SellTower","Upgrade"},
	ET11L0={AL.C,SL.C,"brilliance_aura",nil,"SellTower","Upgrade"},
	ET12L0={AL.C,SL.C,"sandstorm",nil,"SellTower","Upgrade"},
	ET12L1={AL.C,SL.C,"sandstorm",nil,nil,nil},
	ET13L0={AL.B,SL.B,"battle_cry",nil,"SellTower","Upgrade"},
	ET21L0={AL.B,SL.C+0.3,"griavty_control",nil,"SellTower","Upgrade"},
	
	WT01L0={AL.D,SL.C,"water_mark",nil,"SellTower","Upgrade"},
	WT02L0={AL.E,SL.B,"erosion",nil,"SellTower","Upgrade"},
	WT03L0={AL.D,SL.C,"split_shot",nil,"SellTower","Upgrade","split_shot_dummy"},
	WT03L1={AL.D,SL.C,"split_shot","frost_attack",nil,nil,"split_shot_dummy"},
	WT11L0={AL.E,SL.D,"frost_curse_field",nil,"SellTower","Upgrade"},
	WT13L0={AL.B,SL.C,"ice_mark",nil,"SellTower","Upgrade"},
	WT21L0={AL.C,SL.C-0.05,"frost_nova_attack_passive","life_ritual","SellTower","Upgrade","ice_nova"},
	
	FT01L0={AL.C,SL.A,"critical_hit",nil,"SellTower","Upgrade"},
	FT02L0={AL.C,SL.B,"sunfire",nil,"SellTower","Upgrade"},
	FT03L0={AL.E,SL.D,"fire_ritual",nil,"SellTower","Upgrade"},
	FT03L1={AL.D,SL.D,"fire_ritual_e",nil,nil,nil},
	FT11L0={AL.B,SL.C,"flame_blood",nil,"SellTower","Upgrade"},
	FT12L0={AL.C,SL.B,"burning_soul",nil,"SellTower","Upgrade"},
	FT13L0={AL.A,SL.A,"thousand_faces_katana",nil,"SellTower","Upgrade"},
	
	AT01L0={AL.D,SL.C,"moon_glaive",nil,"SellTower","Upgrade"},
	AT02L0={AL.C,SL.B,"resonance",nil,"SellTower","Upgrade","resonance_dummy"},
	AT03L0={AL.C,SL.B,"ultra_voltage",nil,"SellTower","Upgrade"},
	AT11L0={AL.A,SL.C,"wind_bleesing",nil,"SellTower","Upgrade"},
	AT12L0={AL.B,SL.B,"storm_form",nil,"SellTower","Upgrade","storm_form_dummy","disable_move"},
	AT12L1={AL.C,SL.B,"storm_form_e",nil,nil,nil,"storm_form_dummy","disable_move"},
	AT13L0={AL.C,SL.C,"chain_lightling",nil,"SellTower","Upgrade","chain_lightling_dummy"},
}
function IniTower(playerid,unit,cost)
	if cost ~=nil then
		unit:SetDeathXP(cost)
	end
	local tname=unit:GetUnitName()
	local type=string.sub(tname,1,string.len(tname)-1)
	if TowerInfo[type]~=nil then
		AbilityInit(unit,type)
		AttackInit(unit,type,cost)
	end
	if playerid~=nil then
		local caster=PlayerResource:GetPlayer(playerid):GetAssignedHero()
		unit:SetControllableByPlayer(playerid, false )
		unit:SetOwner(caster)
		--unit:AddAbility("disable_move")
		--unit:FindAbilityByName("disable_move"):SetLevel(1)
		table.insert(alltower[playerid],unit)
		local tower={
			tower=unit:GetEntityIndex(),
			playerid=playerid
		}
		FireGameEvent( "tower_built", tower )
		MergeInit(unit)
	end	
end


function AbilityInit(unit,type)
	local none={
			"none_a",
			"none_b",
			"none_c",
			"none_d",
			"none_e",
			"none_f",
		}
	for i=1,#none do
		unit:AddAbility(none[i])
	end
	for i=3,6 do
		if TowerInfo[type][i]~=nil then
			unit:RemoveAbility(none[i-2])
			unit:AddAbility(TowerInfo[type][i])
		end
	end
	if GetUpgradeCost(unit)==0 then
		unit:RemoveAbility("Upgrade")
		unit:AddAbility(none[4])
	end
	for i=7,12 do
		unit:AddAbility(TowerInfo[type][i])
	end
	if unit:GetUnitName() == "ST02L03" then
		unit:RemoveAbility("none_b")
		unit:AddAbility("luck_gold")
	end
	for i=0,unit:GetAbilityCount()-1 do
		local abi=unit:GetAbilityByIndex(i)
		if abi~=nil then
			local l=unit:GetLevel()
			if l>abi:GetMaxLevel() then
				l=abi:GetMaxLevel()
			end
			abi:SetLevel(l)
		end
	end
	local label=unit:GetUnitLabel()
	if string.find(label,"W")~=nil then
		unit:AddAbility("water_mark_passive")
		unit:FindAbilityByName("water_mark_passive"):SetLevel(1)
	end
	if string.find(label,"I")~=nil then
		unit:AddAbility("ice_mark_passive")
		unit:FindAbilityByName("ice_mark_passive"):SetLevel(1)
	end
	unit:AddAbility("no_health_bar")
	unit:FindAbilityByName("no_health_bar"):SetLevel(1)
end

function AttackInit(unit,type,cost)
	unit:SetBaseDamageMin(cost*0.85*TowerInfo[type][1])
	unit:SetBaseDamageMax(cost*1.15*TowerInfo[type][1])
	unit:SetBaseAttackTime(TowerInfo[type][2])
end


