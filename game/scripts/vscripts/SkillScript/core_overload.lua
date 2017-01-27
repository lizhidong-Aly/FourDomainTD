function ReturnCrystal(keys)
	local tower=keys.caster:ToTower()
	if tower~=nil then
		local player=_G.Player[tower.pid]
		player.eh_current=player.eh_current-tower.eh
	end
end