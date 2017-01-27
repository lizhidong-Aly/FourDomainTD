function GiveEnergy(keys)
	print("GiveEnergy")
	local item=keys.ability
	local target=keys.target
	local hero=keys.caster
	local player=_G.Player[hero:GetPlayerID()]
	--hero:EmitSoundParams("General.Sell",200,200,1)
	if target~=nil and target:ToTower()~=nil then
		target:ToTower():ModifyEnergy(50,true)
		AMHC:CreateNumberEffect( target,50,2,AMHC.MSG_GOLD,"red",0 )
	end
end

function TowerCheck(keys)
	local target=keys.target
	if not target:IsTower() then
		keys.caster:Stop()
	end
end