function ParameterInit()
	PRE_GAME_TIME=30
	INIT_GOLD=400
	INIT_TECH_POINT=0
	Mode=2
	Difficulty=0
	unitLeft = 0
	TowerType={}
	TowerBuilding={}
	unitEscaped = 0
	oriForSwaper = {}
	unitCreated = 0
	currentWave = 1
	allplayerid={}
	difficulty=0
	refund=1
	ramingtime=60
	vote={}
	alltower={}
	remain={}
	towerUnlocked={}
	Tree={}
	HPRelation={}
	totalgold = {
	0,
	100,
	100,
	200,
	200,
	400,
	
	150,
	200,
	250,
	300,
	700,
	
	350,
	400,
	450,
	500,
	1000,
	
	600,
	650,
	700,
	750,
	1200,
	
	900,
	950,
	1000,
	1050,
	1500,
	
	1300,
	1350,
	1400,
	1450,
	1750,
	
	1800,
	1900,
	2000,
	2100,
	2700,

	2500,
	2600,
	2700,
	2800,
	3500,
	
	3000,
	3100,
	3200,
	3300,
	10000,
	
	20000
	}
	Domain = {
		"Earth",
		"Air",
		"Water",
		"Fire"
	}
	DomainStatus={
		Earth={
			entity=Entities:FindByName(nil,"Earth"),
			position=Entities:FindByName(nil,"Earth"):GetOrigin(),
			player=nil,
		},
		Air={
			entity=Entities:FindByName(nil,"Air"),
			position=Entities:FindByName(nil,"Air"):GetOrigin(),
			player=nil,
		},
		Water={
			entity=Entities:FindByName(nil,"Water"),
			position=Entities:FindByName(nil,"Water"):GetOrigin(),
			player=nil,
		},
		Fire={
			entity=Entities:FindByName(nil,"Fire"),
			position=Entities:FindByName(nil,"Fire"):GetOrigin(),
			player=nil,
		},
	}
	waveName = {
		"TestOnly",
		"level01",
		"level02",
		"level03",
		"level04",
		"level05",
		"level06",
		"level07",
		"level08",
		"level09",
		"level10",
		"level11",
		"level12",
		"level13",
		"level14",
		"level15",
		"level16",
		"level17",
		"level18",
		"level19",
		"level20",
		"level21",
		"level22",
		"level23",
		"level24",
		"level25",
		"level26",
		"level27",
		"level28",
		"level29",
		"level30",
		"level31",
		"level32",
		"level33",
		"level34",
		"level35",
		"level36",
		"level37",
		"level38",
		"level39",
		"level40"
		
	}
	playernum=1
	worldPoint=Entities:FindByName(nil,"WorldPoint")
	for i=1,4 do
		CustomNetTables:SetTableValue( "domain_selected_list",Domain[i],{pid=-1});
	end
	local a=Entities:FindByName(nil,"ent_dota_fountain_good")
	--a:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)   --禁用中央泉水攻击能力
	fountain=CreateUnitByName("fountain",a:GetOrigin(),false,nil,nil,DOTA_TEAM_GOODGUYS)

end

function SetDifficulty(index,keys)
	vote[keys.PlayerID]=keys.data
	local count={0,0,0}
	for i=0,#vote do
		if vote[i]==0 then
			count[1]=count[1]+1
		elseif vote[i]==1 then
			count[2]=count[2]+1
		elseif vote[i]==2 then
			count[3]=count[3]+1
		end
	end
	local ma=0
	local currdif=0
	for i=1,3 do
		if (count[i]>ma) then
			ma=count[i];
			currdif=i-1;
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("CurrentDifficulty",{diff=currdif})
	
	difficulty=currdif
	if difficulty==0 then
		refund=1
	elseif difficulty==1 then
		refund=0.9
	elseif difficulty==2 then
		refund=0.6
	end
end

function CloseDomain(dname)
	DomainClosed[dname]=true
end