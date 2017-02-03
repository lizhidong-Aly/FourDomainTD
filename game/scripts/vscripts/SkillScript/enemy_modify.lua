function IncreaseMaxHealth(keys)
	local unit=keys.target
	local hp_perc=unit:GetHealthPercent()/100
	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth()*(keys.hpinc/100+1))
end

function DecreaseMaxHealth(keys)
	local unit=keys.target
	local hp_perc=unit:GetHealthPercent()/100
	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth()/(keys.hpinc/100+1))
end

function OnEliteDied(keys)
	print("elite died")
	local unit=keys.caster
	local bounty=unit:GetGoldBounty()*RandomFloat(3,5)

	local gold=CreateItem("item_bag_of_gold",nil,nil)
	gold:SetCurrentCharges(math.floor(bounty))
	local coin=CreateItemOnPositionSync(GetRandomPositionAround(unit),gold)
	local scale=(bounty/1000)+0.5
	if scale>1 then
		scale=1
	end
	coin:SetModelScale(scale)
	
	if RandomFloat(0,1)<0.5 then 
		local energy=CreateItem("item_energy_orb",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),energy)
	end
	if RandomFloat(0,1)<0.5 then 
		local energy=CreateItem("item_energy_orb",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),energy)
	end
	if RandomFloat(0,1)<0.2 then 
		local essence=CreateItem("item_element_essence",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),essence)
	end
end

function OnBossDied(keys)
	print("boss died")
	local unit=keys.caster
	for i=1,RandomInt(2,4) do
		local crystal=CreateItem("item_element_crystal",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),crystal)
	end
	for i=1,RandomInt(1,3) do
		local energy=CreateItem("item_energy_orb",nil,nil)
		CreateItemOnPositionSync(GetRandomPositionAround(unit),energy)
	end
end

function GetRandomPositionAround(unit)
	local pos=unit:GetOrigin()
	pos[1]=pos[1]+RandomInt(-30,30)
	pos[2]=pos[2]+RandomInt(-30,30)
	return pos
end