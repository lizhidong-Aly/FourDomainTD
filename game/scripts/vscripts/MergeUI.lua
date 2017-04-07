SingleMergeList={
	{"ET01L03","ET12L03",2000,"ET12L11"},
	{"ET01L03","CS01L03",600,"CS21L01"},
	{"WT03L03","WT11L03",2000,"WT03L11"},
	{"FT03L03","FT02L03",2000,"FT03L11"},
	{"AT21L03","AT03L03",3000,"AT21L11"},
	{"CS01L03","FT01L03",400,"CS11L01"},
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
end

function ReturnMergeCost(keys)
	if keys.caster~=nil and keys.target~=nil then
		local caster=keys.caster:ToTower()
		local target=keys.target:ToTower()
		if caster~=nil and target~=nil then
			caster:ReturnMergeCost(target)
		end
	end
end

function Merge(keys)
	if keys.caster~=nil and keys.target~=nil then
		local caster=keys.caster:ToTower()
		local target=keys.target:ToTower()
		if caster~=nil and target~=nil then
			caster:Merge(target)
		end
	end
end