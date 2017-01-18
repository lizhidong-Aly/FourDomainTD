SingleMergeList={
	{"ET01L03","ET12L03",3000,"ET12L11"},
	{"ET01L03","CS01L03",1500,"CS21L01"},
	{"WT03L03","WT11L03",3000,"WT03L11"},
	{"FT03L03","FT02L03",2000,"FT03L11"},
	{"AT12L03","AT03L03",4500,"AT12L11"},
	{"CS01L03","FT01L03",1500,"CS11L01"},
}
MergeList={}
for i=1,#SingleMergeList do 
	local ra=SingleMergeList[i][1]
	local rb=SingleMergeList[i][2]
	local cost=SingleMergeList[i][3]
	local be=SingleMergeList[i][4]
	if MergeList[ra]==nil then
		MergeList[ra]={}
	end
	if MergeList[rb]==nil then
		MergeList[rb]={}
	end
	table.insert(MergeList[ra],{cost,be,rb})
	table.insert(MergeList[rb],{cost,be,ra})
end

function InitMergeList()
	CustomNetTables:SetTableValue( "merge_list","SingleMegeList",SingleMergeList);
	for i,v in pairs(MergeList) do
		CustomNetTables:SetTableValue( "merge_list",i,v);
	end
end

function MergeCheck( keys )
	if keys.caster~=nil and keys.target~=nil then
		local caster=keys.caster:ToTower()
		local target=keys.target:ToTower()
		if caster~=nil and target~=nil then
			caster:MergeTest(target)
		end
	end
	--[[
	local caster=keys.caster
	local target=keys.target
	local pid=caster:GetPlayerOwnerID()
	local cname=caster:GetUnitName()
	local tname=target:GetUnitName()
	local totalcost = GetTowerTotalCost(caster)+GetTowerTotalCost(target)
	local mIndex=-1
	for i=1,#MergeList[cname] do
		if MergeList[cname][i][3]==tname then
			mIndex=i
		end
	end
	if mIndex~=-1 and pid==target:GetPlayerOwnerID() then
		local currentGold = PlayerResource:GetGold(pid)
		if currentGold >= MergeList[cname][mIndex][1] then
			PlayerResource:SpendGold(pid,MergeList[cname][mIndex][1],0)
		else
			ErrorMsg(pid,NOT_ENOUGH_GOLD)
			caster:Stop()
		end
	else
		caster:Stop()
	end]]
end

function ReturnMergeCost(keys)
	if keys.caster~=nil and keys.target~=nil then
		local caster=keys.caster:ToTower()
		local target=keys.target:ToTower()
		if caster~=nil and target~=nil then
			caster:ReturnMergeCost(target)
		end
	end
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
	local cost=MergeList[cname][mIndex][1]
	PlayerResource:ModifyGold(pid,cost,false,0)]]
end

function Merge(keys)
	if keys.caster~=nil and keys.target~=nil then
		local caster=keys.caster:ToTower()
		local target=keys.target:ToTower()
		if caster~=nil and target~=nil then
			caster:Merge(target)
		end
	end
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
	end]]--
end