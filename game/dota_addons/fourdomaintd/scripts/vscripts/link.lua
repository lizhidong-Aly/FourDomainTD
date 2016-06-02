
Link={
	lowlevel,
	requirelevel=0
}

Link.__index=Link

function Link:new(ll,rl)
	local self={}
	setmetatable(self,Link)
	self.lowlevel=ll
	self.requirelevel=rl
	return self
end


function Link:CanUpgrade()
	return self.lowlevel:GetLevel() >= self.requirelevel
end

function Link:GetLowTechName()
	return self.lowlevel:GetName()
end