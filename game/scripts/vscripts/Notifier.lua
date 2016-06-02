
BUILD_WRONG_POSITION=1
BUILD_NO_TOWER_SELCTED=2
NOT_ENOUGH_GOLD =3
TECH_REACH_MAX_LEVEL=4
TECH_NEED_UNLOCK=5
SPELL_CAN_NO_CAST_ON_POSITION=6
NOT_ENOUGH_TP=7
function ErrorMsg(playerid,err)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid),"ErrorMsg",{str=err})
end
