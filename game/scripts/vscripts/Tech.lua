Tech={
	name="",
	img="",
	lvl=0,
	maxlvl=10000,
	cost=0,       --gold require to upgrade
	des="",
	canupgrade=false,
	link={}
}

Tech.__index = Tech

function Tech:new(n,i,l,g,lr)
	local self={}
	setmetatable(self,Tech)
	self.name=n
	self.img=i
	self.maxlvl=l
	self.cost=g
	self.des=n.."DES"
	self.link=lr
	return self
end

function Tech:GetName()
	return self.name
end

function Tech:GetImgName()
	return self.img
end

function Tech:GetLevel()
	return self.lvl
end

function Tech:GetDes()
	return self.des
end

function Tech:GetUpgradeCost()
	return self.cost
end


function Tech:CanUpgrade()
	self.canupgrade=true
	if not (self.link[1]==nil) then
		for i=1,#self.link do 
			if not self.link[i]:CanUpgrade() then
				self.canupgrade=false
			end
		end
	end
	return self.canupgrade
end

function Tech:GetRequiredTech()
	if self.link[1]==nil then
		return -1
	end
	local rtn={}
	for i=1,#self.link do
		rtn[i]=self.link[i]:GetLowTechName()
	end
	return rtn
end


function Tech:CanLevelUp()
	if self.lvl <self.maxlvl then
		return true
	else
		return false
	end
end

function Tech:GetTechInfo()
	local info={
		name=self.name,
		img=self.img,
		req=self:GetRequiredTech(),
		cost=self.cost,
		des=self.des
		} 
	if self.lvl>0 then
		info.cost=-1
	end
	if self:CanUpgrade() then
		info.req=-1
	end
	return info
end