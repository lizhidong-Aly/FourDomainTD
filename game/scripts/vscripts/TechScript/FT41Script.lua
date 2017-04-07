function FT41_Function( keys)
	print("ft41")
	local caster = keys.caster
	caster:AddAbility("fiery_soul"):SetLevel(1)
	local a=caster:GetAbilityByIndex(2)
	caster:SwapAbilities(a:GetAbilityName(),"fiery_soul",true,true)
end

function FierySoul(keys)
	local caster = keys.caster:ToTower()
	local pid = caster:GetPlayerOwnerID()
	local player = _G.Player[pid]
	local gold_cost = 20000
	local crystal_cost = 8

	if PlayerResource:GetGold(pid)<gold_cost then
		ErrorMsg(pid,NOT_ENOUGH_GOLD)
		caster:Stop()
		return
	end

	if (player.eh_current+crystal_cost)>player.eh_limit then
		ErrorMsg(pid,NOT_ENOUGH_CRYSTAL)
		caster:Stop()
		return
	end

	local all=Entities:FindAllInSphere(Vector(0,0,128),10000)
	for i,v in pairs(all) do
		if v.IsTower and v:GetUnitName()=="FT11L04" then
			ErrorMsg(pid,SAME_TYPE_EXIST)
			caster:Stop()
			return
		end
	end

	PlayerResource:SpendGold(pid,gold_cost,0)
	player:ModifyCurrentCrystal(crystal_cost)
	
	local t=Tower:new("FT11L04",caster:GetOrigin(),pid,21800)
	t:ModifyEnergy(caster.energy,false)
	SendEventToPlayer(pid,"SelectNewTower", {old=caster:entindex(),new=t:entindex()} )
	caster:Remove(true)
end