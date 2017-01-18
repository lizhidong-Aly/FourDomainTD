
BUILD_WRONG_POSITION="#wrongposition"
BUILD_NO_TOWER_SELCTED="#notower"
NOT_ENOUGH_GOLD ="#nogold"
TECH_REACH_MAX_LEVEL="#maxlevel"
TECH_NEED_UNLOCK="#needunlock"
SPELL_CAN_NO_CAST_ON_POSITION="#wrongspellpos"
NOT_ENOUGH_TP="#notp"
NOT_ENOUGH_CRYSTAL="#nocrystal"
NOT_OWN_TARGET="#notowntarget"
function ErrorMsg(playerid,err)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerid),"ErrorMsg",{err=err})
end
