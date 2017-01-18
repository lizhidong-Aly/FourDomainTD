var builder;
var isMenuOpen=false;
var desPanelList=[];

function InitTowerList(){
	var towerInfo = {
		//Tower Info: Icon Name , Unlock/Lock , Resvered
		"CS01L01": ["npc_dota_hero_sniper",true,"3"],
		"CS02L01": ["npc_dota_hero_alchemist",true,"3"],

		"ET01L01": ["npc_dota_hero_earth_spirit",false,"3"],
		"ET02L01": ["npc_dota_hero_elder_titan",false,"3"],
		"ET03L01": ["npc_dota_hero_ogre_magi",false,"3"],
		"ET11L01": ["npc_dota_hero_earthshaker",false,"3"],
		"ET12L01": ["npc_dota_hero_sand_king",false,"3"],
		"ET13L01": ["npc_dota_hero_beastmaster",false,"3"],
		"ET21L01": ["npc_dota_hero_enigma",false,"3"],
		"ES01L01": ["tiny_avalanche",false,"3"],

		"WT01L01": ["npc_dota_hero_morphling",false,"3"],
		"WT02L01": ["npc_dota_hero_venomancer",false,"3"],
		"WT03L01": ["npc_dota_hero_medusa",false,"3"],
		"WT11L01": ["npc_dota_hero_ancient_apparition",false,"3"],
		"WT13L01": ["npc_dota_hero_tusk",false,"3"],
		"WT21L01": ["npc_dota_hero_lich",false,"3"],
		"WS01L01": ["lich_chain_frost",false,"3"],

		"FT01L01": ["npc_dota_hero_ember_spirit",false,"3"],
		"FT02L01": ["npc_dota_hero_phoenix",false,"3"],
		"FT03L01": ["npc_dota_hero_warlock",false,"3"],
		"FT11L01": ["npc_dota_hero_lina",false,"3"],
		"FT12L01": ["npc_dota_hero_huskar",false,"3"],
		"FT13L01": ["npc_dota_hero_juggernaut",false,"3"],
		"FS01L01": ["phoenix_supernova",false,"3"],

		"AT01L01": ["npc_dota_hero_skywrath_mage",false,"3"],
		"AT02L01": ["npc_dota_hero_queenofpain",false,"3"],
		"AT03L01": ["npc_dota_hero_razor",false,"3"],
		"AT11L01": ["npc_dota_hero_windrunner",false,"3"],
		"AT12L01": ["npc_dota_hero_storm_spirit",false,"3"],
		"AT13L01": ["npc_dota_hero_zuus",false,"3"],
		"AS01L01": ["disruptor_thunder_strike",false,"3"],
	};
	var l=["ES0","FS0","WS0","AS0"]
	for(var name in towerInfo){
		if(name[0]=="C"){
			for(var i in l){
				var tower = $.CreatePanel( "Panel", $("#"+l[i]), name );
				tower.BLoadLayout( "file://{resources}/layout/custom_game/Tower.xml", false, false );
				tower.SetTower(towerInfo[name][0],towerInfo[name][1]);
			}
		}else{
			var tower = $.CreatePanel( "Panel", $("#"+name.substring(0,3)), name );
			tower.BLoadLayout( "file://{resources}/layout/custom_game/Tower.xml", false, false );
			tower.SetTower(towerInfo[name][0],towerInfo[name][1]);
		}
	}
	
}

function MenuSwtich(){
	$("#Bmenu").SetHasClass("Show", !($("#Bmenu").BHasClass("Show")));
}
function CloseBUI(){
	$("#Bmenu").SetHasClass("Show", false);
}
function ShowSubMenu(name){
	$("#submenu_e").SetHasClass("Hidden",true);
	$("#submenu_w").SetHasClass("Hidden",true);
	$("#submenu_f").SetHasClass("Hidden",true);
	$("#submenu_a").SetHasClass("Hidden",true);
	$("#submenu_"+name).SetHasClass("Hidden", !($("#submenu_"+name).BHasClass("Hidden")));
}

function UnLockTower(name){
	$("#"+name).FindChildTraverse("TowerLocker").SetHasClass("enable",true);
	GameEvents.SendCustomGameEventToServer( "RequestTowerInfo", {type:name} );
}

function UnlockTowerLevel(data){
	for(var i=1;i<=4;i++){
		if(data[i]!=null){
			UnLockTower(data[i]);
		}
	}
}

function SelectNewTower(data){
	var unit=Players.GetSelectedEntities(Players.GetLocalPlayer())
	var current=Players.GetLocalPlayerPortraitUnit();
	for(var i=0;i<unit.length;i++){
		if (unit[i]==data.old){
			unit[i]=data.new;
			if(current==data.old){
				GameUI.SelectUnit(data.new,false)
				for(var j=0;j<unit.length;j++){
					if (unit[j]!=data.new){
						GameUI.SelectUnit(unit[j],true)
					}
				}
			}else{
				GameUI.SelectUnit(current,false)
				for(var j=0;j<unit.length;j++){
					if (unit[j]!=current){
						GameUI.SelectUnit(unit[j],true)
					}
				}
			}
		}
	}
}

(function()
{
	$.Msg("BuildUI.js is loaded");
	GameEvents.Subscribe( "MenuSwtich", MenuSwtich);
	GameEvents.Subscribe( "UnlockTower", UnlockTowerLevel);
	GameEvents.Subscribe( "CloseBUI", CloseBUI);
	GameEvents.Subscribe( "SelectNewTower", SelectNewTower);
	GameEvents.Subscribe( "ClosedAllUI", CloseBUI);
	InitTowerList();
})();
