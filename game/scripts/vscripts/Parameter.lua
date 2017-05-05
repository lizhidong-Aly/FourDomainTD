_G.VERSION="1.1"
PRE_GAME_TIME=15
INIT_GOLD=400
INIT_TECH_POINT=100
INIT_EH_LIMIT=50
SPAWN_DELAY=10
_G.TESTMODE=true
_G.DIFFICULTY=1
_G.REFUND=1
_G.ENEMY_ELITE_CHANCE=0.015
_G.VOTE={}
_G.isOnSpawn=false
_G.levelNo=0
_G.Player={}
_G.unitRemaining=0
_G.SpawnPosition={
	Vector(-4800,4096,128),
	Vector(4096,4800,128),
	Vector(4800,-4096,128),
	Vector(-4096,-4800,128),
}
_G.TowerInfo={}
--eh=element heart 人口占用
	-------------------通用-------------------
	--矮人火枪手
	_G.TowerInfo.CS01L01={dmgCoefficient=2.2,attSpe=1.6,attRange=900,cost=30,attribute="N",eh=1,abil={"head_shoot"},upgradeTo="CS01L02"}
	_G.TowerInfo.CS01L02={dmgCoefficient=1.9,attSpe=1.6,attRange=1000,cost=90,attribute="N",eh=1,abil={"head_shoot"},upgradeTo="CS01L03"}
	_G.TowerInfo.CS01L03={dmgCoefficient=1.7,attSpe=1.6,attRange=1100,cost=180,attribute="N",eh=1,abil={"head_shoot"},upgradeTo=nil}
	--炼金术师
	_G.TowerInfo.CS02L01={dmgCoefficient=1.4,attSpe=1.5,attRange=1000,cost=50,attribute="N",eh=1,abil={"booty_gold"},upgradeTo="CS02L02"}
	_G.TowerInfo.CS02L02={dmgCoefficient=1.3,attSpe=1.45,attRange=1000,cost=150,attribute="N",eh=1,abil={"booty_gold"},upgradeTo="CS02L03"}
	_G.TowerInfo.CS02L03={dmgCoefficient=1.2,attSpe=1.4,attRange=1000,cost=450,attribute="N",eh=2,abil={"booty_gold","luck_gold"},upgradeTo=nil}
-------------------地-------------------
	--核心
	_G.TowerInfo.ES01L01={dmgCoefficient=0,attSpe=0,attRange=0,cost=300,attribute="E",eh=1,abil={"earth_core_aura","earth_core_overload"},upgradeTo="ES01L02"}
	_G.TowerInfo.ES01L02={dmgCoefficient=0,attSpe=0,attRange=0,cost=600,attribute="E",eh=2,abil={"earth_core_aura","earth_core_overload"},upgradeTo="ES01L03"}
	_G.TowerInfo.ES01L03={dmgCoefficient=0,attSpe=0,attRange=0,cost=2000,attribute="E",eh=3,abil={"earth_core_aura","earth_core_overload"},upgradeTo=nil}
	--大地之灵
	_G.TowerInfo.ET01L01={dmgCoefficient=1.5,attSpe=1.8,attRange=1000,cost=200,attribute="E",eh=1,abil={"splash_attack"},upgradeTo="ET01L02"}
	_G.TowerInfo.ET01L02={dmgCoefficient=1.2,attSpe=1.8,attRange=1200,cost=400,attribute="E",eh=1,abil={"splash_attack"},upgradeTo="ET01L03"}
	_G.TowerInfo.ET01L03={dmgCoefficient=0.9,attSpe=1.8,attRange=1400,cost=600,attribute="E",eh=2,abil={"splash_attack"},upgradeTo=nil}
	--上古泰坦
	_G.TowerInfo.ET02L01={dmgCoefficient=3,attSpe=2.5,attRange=800,cost=180,attribute="E",eh=1,abil={"stun_hit"},upgradeTo="ET02L02"}
	_G.TowerInfo.ET02L02={dmgCoefficient=2.7,attSpe=2.5,attRange=800,cost=280,attribute="E",eh=1,abil={"stun_hit"},upgradeTo="ET02L03"}
	_G.TowerInfo.ET02L03={dmgCoefficient=2.4,attSpe=2.5,attRange=800,cost=800,attribute="E",eh=2,abil={"stun_hit"},upgradeTo=nil}
	--食人魔法师
	_G.TowerInfo.ET03L01={dmgCoefficient=1.2,attSpe=1.7,attRange=1000,cost=250,attribute="E",eh=1,abil={"earth_blessing"},upgradeTo="ET03L02"}
	_G.TowerInfo.ET03L02={dmgCoefficient=1,attSpe=1.7,attRange=1000,cost=400,attribute="E",eh=1,abil={"earth_blessing"},upgradeTo="ET03L03"}
	_G.TowerInfo.ET03L03={dmgCoefficient=0.8,attSpe=1.7,attRange=1000,cost=750,attribute="E",eh=2,abil={"earth_blessing"},upgradeTo=nil}
	--撼地者
	_G.TowerInfo.ET11L01={dmgCoefficient=2,attSpe=1.6,attRange=1300,cost=400,attribute="E",eh=2,abil={"brilliance_aura"},upgradeTo="ET11L02"}
	_G.TowerInfo.ET11L02={dmgCoefficient=1.6,attSpe=1.6,attRange=1300,cost=600,attribute="E",eh=2,abil={"brilliance_aura"},upgradeTo="ET11L03"}
	_G.TowerInfo.ET11L03={dmgCoefficient=1.2,attSpe=1.6,attRange=1300,cost=900,attribute="E",eh=3,abil={"brilliance_aura"},upgradeTo=nil}
	--沙王
	_G.TowerInfo.ET12L01={dmgCoefficient=1.1,attSpe=1.4,attRange=1000,cost=750,attribute="E",eh=2,abil={"sandstorm"},upgradeTo="ET12L02"}
	_G.TowerInfo.ET12L02={dmgCoefficient=0.9,attSpe=1.4,attRange=1000,cost=1400,attribute="E",eh=2,abil={"sandstorm"},upgradeTo="ET12L03"}
	_G.TowerInfo.ET12L03={dmgCoefficient=0.7,attSpe=1.4,attRange=1000,cost=2500,attribute="E",eh=3,abil={"sandstorm"},upgradeTo=nil}
	--兽王
	_G.TowerInfo.ET13L01={dmgCoefficient=1.5,attSpe=1.6,attRange=1000,cost=1000,attribute="E",eh=3,abil={"battle_cry"},upgradeTo="ET13L02"}
	_G.TowerInfo.ET13L02={dmgCoefficient=1.2,attSpe=1.6,attRange=1100,cost=1600,attribute="E",eh=3,abil={"battle_cry"},upgradeTo="ET13L03"}
	_G.TowerInfo.ET13L03={dmgCoefficient=0.9,attSpe=1.6,attRange=1200,cost=2800,attribute="E",eh=4,abil={"battle_cry"},upgradeTo=nil}
	--谜团
	_G.TowerInfo.ET21L01={dmgCoefficient=2,attSpe=1.8,attRange=1000,cost=3000,attribute="E",eh=4,abil={"griavty_control"},upgradeTo="ET21L02"}
	_G.TowerInfo.ET21L02={dmgCoefficient=1.5,attSpe=1.8,attRange=1000,cost=5000,attribute="E",eh=5,abil={"griavty_control"},upgradeTo="ET21L03"}
	_G.TowerInfo.ET21L03={dmgCoefficient=1,attSpe=1.8,attRange=1000,cost=7000,attribute="E",eh=6,abil={"griavty_control"},upgradeTo=nil}
-------------------水-------------------
	--核心
	_G.TowerInfo.WS01L01={dmgCoefficient=0,attSpe=0,attRange=0,cost=300,attribute="W",eh=1,abil={"water_core_aura","water_core_overload"},upgradeTo="WS01L02"}
	_G.TowerInfo.WS01L02={dmgCoefficient=0,attSpe=0,attRange=0,cost=700,attribute="W",eh=2,abil={"water_core_aura","water_core_overload"},upgradeTo="WS01L03"}
	_G.TowerInfo.WS01L03={dmgCoefficient=0,attSpe=0,attRange=0,cost=1900,attribute="W",eh=3,abil={"water_core_aura","water_core_overload"},upgradeTo=nil}
	--变体精灵
	_G.TowerInfo.WT01L01={dmgCoefficient=0.9,attSpe=1.7,attRange=900,cost=200,attribute="W",eh=1,abil={"water_mark"},upgradeTo="WT01L02"}
	_G.TowerInfo.WT01L02={dmgCoefficient=0.8,attSpe=1.7,attRange=900,cost=300,attribute="W",eh=1,abil={"water_mark"},upgradeTo="WT01L03"}
	_G.TowerInfo.WT01L03={dmgCoefficient=0.7,attSpe=1.7,attRange=900,cost=400,attribute="W",eh=1,abil={"water_mark"},upgradeTo=nil}
	--剧毒术士
	_G.TowerInfo.WT02L01={dmgCoefficient=1.1,attSpe=1.6,attRange=1200,cost=250,attribute="W",eh=2,abil={"erosion"},upgradeTo="WT02L02"}
	_G.TowerInfo.WT02L02={dmgCoefficient=0.9,attSpe=1.6,attRange=1200,cost=400,attribute="W",eh=2,abil={"erosion"},upgradeTo="WT02L03"}
	_G.TowerInfo.WT02L03={dmgCoefficient=0.7,attSpe=1.6,attRange=1200,cost=600,attribute="W",eh=2,abil={"erosion"},upgradeTo=nil}
	--美杜莎
	_G.TowerInfo.WT03L01={dmgCoefficient=1,attSpe=1.65,attRange=800,cost=500,attribute="W",eh=2,abil={"split_shot","split_shot_dummy_hidden"},upgradeTo="WT03L02"}
	_G.TowerInfo.WT03L02={dmgCoefficient=0.9,attSpe=1.65,attRange=850,cost=700,attribute="W",eh=2,abil={"split_shot","split_shot_dummy_hidden"},upgradeTo="WT03L03"}
	_G.TowerInfo.WT03L03={dmgCoefficient=0.8,attSpe=1.65,attRange=900,cost=900,attribute="W",eh=3,abil={"split_shot","split_shot_dummy_hidden"},upgradeTo=nil}
	--极寒幽魂
	_G.TowerInfo.WT11L01={dmgCoefficient=1.2,attSpe=1.6,attRange=1200,cost=600,attribute="WI",eh=2,abil={"frost_curse_field"},upgradeTo="WT11L02"}
	_G.TowerInfo.WT11L02={dmgCoefficient=1.1,attSpe=1.6,attRange=1200,cost=1000,attribute="WI",eh=2,abil={"frost_curse_field"},upgradeTo="WT11L03"}
	_G.TowerInfo.WT11L03={dmgCoefficient=1,attSpe=1.6,attRange=1200,cost=1400,attribute="WI",eh=3,abil={"frost_curse_field"},upgradeTo=nil}
	--巨牙海民
	_G.TowerInfo.WT13L01={dmgCoefficient=1.8,attSpe=1.7,attRange=800,cost=500,attribute="WI",eh=2,abil={"ice_mark"},upgradeTo="WT13L02"}
	_G.TowerInfo.WT13L02={dmgCoefficient=1.4,attSpe=1.7,attRange=800,cost=1000,attribute="WI",eh=3,abil={"ice_mark"},upgradeTo="WT13L03"}
	_G.TowerInfo.WT13L03={dmgCoefficient=1,attSpe=1.7,attRange=800,cost=2000,attribute="WI",eh=4,abil={"ice_mark"},upgradeTo=nil}
	--巫妖
	_G.TowerInfo.WT21L01={dmgCoefficient=2,attSpe=1.8,attRange=1000,cost=2500,attribute="WI",eh=3,abil={"frost_nova_attack_passive","life_ritual","ice_nova_hidden"},upgradeTo="WT21L02"}
	_G.TowerInfo.WT21L02={dmgCoefficient=1.7,attSpe=1.8,attRange=1000,cost=5000,attribute="WI",eh=4,abil={"frost_nova_attack_passive","life_ritual","ice_nova_hidden"},upgradeTo="WT21L03"}
	_G.TowerInfo.WT21L03={dmgCoefficient=1.4,attSpe=1.8,attRange=1000,cost=7500,attribute="WI",eh=5,abil={"frost_nova_attack_passive","life_ritual","ice_nova_hidden"},upgradeTo=nil}
-------------------火-------------------
	--核心
	_G.TowerInfo.FS01L01={dmgCoefficient=0,attSpe=0,attRange=0,cost=250,attribute="F",eh=1,abil={"fire_core_aura","fire_core_overload"},upgradeTo="FS01L02"}
	_G.TowerInfo.FS01L02={dmgCoefficient=0,attSpe=0,attRange=0,cost=550,attribute="F",eh=2,abil={"fire_core_aura","fire_core_overload"},upgradeTo="FS01L03"}
	_G.TowerInfo.FS01L03={dmgCoefficient=0,attSpe=0,attRange=0,cost=1200,attribute="F",eh=3,abil={"fire_core_aura","fire_core_overload"},upgradeTo=nil}
	--灰烬之灵
	_G.TowerInfo.FT01L01={dmgCoefficient=1.2,attSpe=1,attRange=600,cost=150,attribute="F",eh=1,abil={"critical_hit"},upgradeTo="FT01L02"}
	_G.TowerInfo.FT01L02={dmgCoefficient=1.15,attSpe=1,attRange=600,cost=300,attribute="F",eh=1,abil={"critical_hit"},upgradeTo="FT01L03"}
	_G.TowerInfo.FT01L03={dmgCoefficient=1.1,attSpe=1,attRange=600,cost=600,attribute="F",eh=2,abil={"critical_hit"},upgradeTo=nil}
	--凤凰
	_G.TowerInfo.FT02L01={dmgCoefficient=1.2,attSpe=1.7,attRange=1000,cost=200,attribute="F",eh=1,abil={"sunfire"},upgradeTo="FT02L02"}
	_G.TowerInfo.FT02L02={dmgCoefficient=1.0,attSpe=1.7,attRange=1000,cost=400,attribute="F",eh=1,abil={"sunfire"},upgradeTo="FT02L03"}
	_G.TowerInfo.FT02L03={dmgCoefficient=0.8,attSpe=1.7,attRange=1000,cost=900,attribute="F",eh=2,abil={"sunfire"},upgradeTo=nil}
	--术士
	_G.TowerInfo.FT03L01={dmgCoefficient=1.4,attSpe=1.6,attRange=1100,cost=250,attribute="F",eh=1,abil={"fire_ritual"},upgradeTo="FT03L02"}
	_G.TowerInfo.FT03L02={dmgCoefficient=1.45,attSpe=1.6,attRange=1100,cost=400,attribute="F",eh=1,abil={"fire_ritual"},upgradeTo="FT03L03"}
	_G.TowerInfo.FT03L03={dmgCoefficient=1.5,attSpe=1.6,attRange=1100,cost=800,attribute="F",eh=2,abil={"fire_ritual"},upgradeTo=nil}
	--火女
	_G.TowerInfo.FT11L01={dmgCoefficient=1.6,attSpe=1.3,attRange=900,cost=300,attribute="F",eh=2,abil={"flame_blood"},upgradeTo="FT11L02"}
	_G.TowerInfo.FT11L02={dmgCoefficient=1.3,attSpe=1.3,attRange=900,cost=600,attribute="F",eh=3,abil={"flame_blood"},upgradeTo="FT11L03"}
	_G.TowerInfo.FT11L03={dmgCoefficient=1,attSpe=1.3,attRange=900,cost=900,attribute="F",eh=4,abil={"flame_blood"},upgradeTo=nil}
	_G.TowerInfo.FT11L04={dmgCoefficient=0.7,attSpe=1.2,attRange=1000,cost=20000,attribute="F",eh=12,abil={"fiery_soul_ability","flame_field","laguna_blade"},upgradeTo=nil,can_not_sell=true}
	
	--神灵武士
	_G.TowerInfo.FT12L01={dmgCoefficient=1,attSpe=1.1,attRange=800,cost=350,attribute="F",eh=2,abil={"burning_soul"},upgradeTo="FT12L02"}
	_G.TowerInfo.FT12L02={dmgCoefficient=0.8,attSpe=1.1,attRange=800,cost=700,attribute="F",eh=2,abil={"burning_soul"},upgradeTo="FT12L03"}
	_G.TowerInfo.FT12L03={dmgCoefficient=0.6,attSpe=1.1,attRange=800,cost=1000,attribute="F",eh=3,abil={"burning_soul"},upgradeTo=nil}
	--主宰
	_G.TowerInfo.FT13L01={dmgCoefficient=1.9,attSpe=1.2,attRange=1000,cost=800,attribute="F",eh=2,abil={"thousand_faces_katana"},upgradeTo="FT13L02"}
	_G.TowerInfo.FT13L02={dmgCoefficient=1.5,attSpe=1.2,attRange=1000,cost=1200,attribute="F",eh=2,abil={"thousand_faces_katana"},upgradeTo="FT13L03"}
	_G.TowerInfo.FT13L03={dmgCoefficient=1.1,attSpe=1.2,attRange=1000,cost=1400,attribute="F",eh=3,abil={"thousand_faces_katana"},upgradeTo=nil}
-------------------气-------------------
	--核心
	_G.TowerInfo.AS01L01={dmgCoefficient=0,attSpe=0,attRange=0,cost=400,attribute="A",eh=1,abil={"lightning_core_aura","lightning_core_overload"},upgradeTo="AS01L02"}
	_G.TowerInfo.AS01L02={dmgCoefficient=0,attSpe=0,attRange=0,cost=800,attribute="A",eh=2,abil={"lightning_core_aura","lightning_core_overload"},upgradeTo="AS01L03"}
	_G.TowerInfo.AS01L03={dmgCoefficient=0,attSpe=0,attRange=0,cost=2000,attribute="A",eh=3,abil={"lightning_core_aura","lightning_core_overload"},upgradeTo=nil}
	--天怒
	_G.TowerInfo.AT01L01={dmgCoefficient=1.6,attSpe=1.6,attRange=1200,cost=250,attribute="A",eh=1,abil={"moon_glaive"},upgradeTo="AT01L02"}
	_G.TowerInfo.AT01L02={dmgCoefficient=1.3,attSpe=1.6,attRange=1300,cost=400,attribute="A",eh=1,abil={"moon_glaive"},upgradeTo="AT01L03"}
	_G.TowerInfo.AT01L03={dmgCoefficient=1.0,attSpe=1.6,attRange=1400,cost=550,attribute="A",eh=2,abil={"moon_glaive"},upgradeTo=nil}
	--痛苦女王
	_G.TowerInfo.AT02L01={dmgCoefficient=1.5,attSpe=1.4,attRange=900,cost=300,attribute="A",eh=1,abil={"resonance","resonance_dummy_hidden"},upgradeTo="AT02L02"}
	_G.TowerInfo.AT02L02={dmgCoefficient=1.3,attSpe=1.4,attRange=900,cost=500,attribute="A",eh=1,abil={"resonance","resonance_dummy_hidden"},upgradeTo="AT02L03"}
	_G.TowerInfo.AT02L03={dmgCoefficient=1.1,attSpe=1.4,attRange=900,cost=700,attribute="A",eh=2,abil={"resonance","resonance_dummy_hidden"},upgradeTo=nil}
	--闪电幽魂
	_G.TowerInfo.AT03L01={dmgCoefficient=0.9,attSpe=1.0,attRange=1000,cost=500,attribute="A",eh=1,abil={"ultra_voltage"},upgradeTo="AT03L02"}
	_G.TowerInfo.AT03L02={dmgCoefficient=0.8,attSpe=1.0,attRange=1000,cost=1000,attribute="A",eh=1,abil={"ultra_voltage"},upgradeTo="AT03L03"}
	_G.TowerInfo.AT03L03={dmgCoefficient=0.7,attSpe=1.0,attRange=1000,cost=1500,attribute="A",eh=2,abil={"ultra_voltage"},upgradeTo=nil}
	--风行者
	_G.TowerInfo.AT11L01={dmgCoefficient=1.2,attSpe=1.4,attRange=1500,cost=800,attribute="A",eh=2,abil={"wind_bleesing"},upgradeTo="AT11L02"}
	_G.TowerInfo.AT11L02={dmgCoefficient=1,attSpe=1.4,attRange=1500,cost=1600,attribute="A",eh=3,abil={"wind_bleesing"},upgradeTo="AT11L03"}
	_G.TowerInfo.AT11L03={dmgCoefficient=0.8,attSpe=1.4,attRange=1500,cost=2000,attribute="A",eh=3,abil={"wind_bleesing"},upgradeTo=nil}
	--森之魔女
	_G.TowerInfo.AT12L01={dmgCoefficient=1,attSpe=1.7,attRange=1200,cost=900,attribute="A",eh=2,abil={"impetus"},upgradeTo="AT12L02"}
	_G.TowerInfo.AT12L02={dmgCoefficient=0.8,attSpe=1.7,attRange=1200,cost=1800,attribute="A",eh=2,abil={"impetus"},upgradeTo="AT12L03"}
	_G.TowerInfo.AT12L03={dmgCoefficient=0.6,attSpe=1.7,attRange=1200,cost=3600,attribute="A",eh=3,abil={"impetus"},upgradeTo=nil}
	--宙斯
	_G.TowerInfo.AT13L01={dmgCoefficient=1.6,attSpe=1.5,attRange=900,cost=1000,attribute="A",eh=2,abil={"chain_lightling","chain_lightling_dummy_hidden"},upgradeTo="AT13L02"}
	_G.TowerInfo.AT13L02={dmgCoefficient=1.4,attSpe=1.5,attRange=900,cost=2000,attribute="A",eh=2,abil={"chain_lightling","chain_lightling_dummy_hidden"},upgradeTo="AT13L03"}
	_G.TowerInfo.AT13L03={dmgCoefficient=1.2,attSpe=1.5,attRange=900,cost=4000,attribute="A",eh=3,abil={"chain_lightling","chain_lightling_dummy_hidden"},upgradeTo=nil}

	--风暴之灵
	_G.TowerInfo.AT21L01={dmgCoefficient=1.8,attSpe=1.2,attRange=800,cost=2500,attribute="A",eh=3,abil={"storm_form","storm_form_dummy_hidden"},upgradeTo="AT21L02"}
	_G.TowerInfo.AT21L02={dmgCoefficient=1.6,attSpe=1.2,attRange=800,cost=5000,attribute="A",eh=4,abil={"storm_form","storm_form_dummy_hidden"},upgradeTo="AT21L03"}
	_G.TowerInfo.AT21L03={dmgCoefficient=1.4,attSpe=1.2,attRange=800,cost=7500,attribute="A",eh=5,abil={"storm_form","storm_form_dummy_hidden"},upgradeTo=nil}

	_G.TowerInfo.CS21L01={
		dmgCoefficient=3.5,attSpe=12,attRange=1800,
		cost=600
		+_G.TowerInfo.CS01L01.cost+_G.TowerInfo.CS01L02.cost+_G.TowerInfo.CS01L03.cost
		+_G.TowerInfo.ET01L01.cost+_G.TowerInfo.ET01L02.cost+_G.TowerInfo.ET01L03.cost,
		attribute="E",eh=4,eh_needed=1,abil={"earth_shot"},upgradeTo=nil
		}
	_G.TowerInfo.CS11L01={
		dmgCoefficient=0.3,attSpe=1,attRange=500,
		cost=400
		+_G.TowerInfo.CS01L01.cost+_G.TowerInfo.CS01L02.cost+_G.TowerInfo.CS01L03.cost
		+_G.TowerInfo.FT01L01.cost+_G.TowerInfo.FT01L02.cost+_G.TowerInfo.FT01L03.cost,
		attribute="F",eh=4,eh_needed=1,abil={"dragon_breath"},upgradeTo=nil}
	_G.TowerInfo.ET12L11={
		lv=4,dmgCoefficient=0.6,attSpe=1.4,attRange=1200,
		cost=2000
		+_G.TowerInfo.ET12L01.cost+_G.TowerInfo.ET12L02.cost+_G.TowerInfo.ET12L03.cost
		+_G.TowerInfo.ET01L01.cost+_G.TowerInfo.ET01L02.cost+_G.TowerInfo.ET01L03.cost,
		attribute="E",eh=6,eh_needed=1,abil={"sandstorm"},upgradeTo=nil}
	_G.TowerInfo.WT03L11={
		lv=4,dmgCoefficient=0.8,attSpe=1.6,attRange=1000,
		cost=2000
		+_G.TowerInfo.WT03L01.cost+_G.TowerInfo.WT03L02.cost+_G.TowerInfo.WT03L03.cost
		+_G.TowerInfo.WT11L01.cost+_G.TowerInfo.WT11L02.cost+_G.TowerInfo.WT11L03.cost,
		attribute="WI",eh=7,eh_needed=1,abil={"split_shot","frost_attack","split_shot_dummy_hidden"},upgradeTo=nil}
	_G.TowerInfo.FT03L11={
		lv=4,dmgCoefficient=1.2,attSpe=1.6,attRange=1100,
		cost=2000
		+_G.TowerInfo.FT03L01.cost+_G.TowerInfo.FT03L02.cost+_G.TowerInfo.FT03L03.cost
		+_G.TowerInfo.FT02L01.cost+_G.TowerInfo.FT02L02.cost+_G.TowerInfo.FT02L03.cost,
		attribute="F",eh=5,eh_needed=1,abil={"fire_ritual_e"},upgradeTo=nil}
	_G.TowerInfo.AT21L11={
		dmgCoefficient=1.2,attSpe=1.1,attRange=900,
		cost=3000
		+_G.TowerInfo.AT21L01.cost+_G.TowerInfo.AT21L02.cost+_G.TowerInfo.AT21L03.cost
		+_G.TowerInfo.AT03L01.cost+_G.TowerInfo.AT03L02.cost+_G.TowerInfo.AT03L03.cost,
		attribute="A",eh=8,eh_needed=1,abil={"storm_form_e","storm_form_dummy_hidden"},upgradeTo=nil}

_G.EnemyType={
	ARMY={amount=40,distance=0.5,lv=1},
	NORMAL={amount=20,distance=1,lv=2},
	ELITE={amount=5,distance=6,lv=6},
	BOSS={amount=1,distance=1,lv=25},
}
_G.levelInfo={
	{name="level01",hp=100,armor=1,magicRes=0,moveSpeed=350,hpRegen=1,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level02",hp=200,armor=3,magicRes=0,moveSpeed=450,hpRegen=2,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level03",hp=400,armor=6,magicRes=0,moveSpeed=390,hpRegen=4,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level04",hp=800,armor=10,magicRes=0,moveSpeed=340,hpRegen=10,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level05",hp=2500,armor=25,magicRes=50,moveSpeed=270,hpRegen=1,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level06",hp=1300,armor=12,magicRes=0,moveSpeed=430,hpRegen=8,abi={},baseGoldBounty=1,type="ARMY"},
	{name="level07",hp=2500,armor=20,magicRes=0,moveSpeed=410,hpRegen=12,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level08",hp=3000,armor=32,magicRes=20,moveSpeed=380,hpRegen=10,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level09",hp=7500,armor=25,magicRes=40,moveSpeed=350,hpRegen=20,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level10",hp=15000,armor=60,magicRes=100,moveSpeed=360,hpRegen=10,abi={"enemy_boss","enemy_magic_immune"},baseGoldBounty=1,type="BOSS"},
	{name="level11",hp=4000,armor=10,magicRes=20,moveSpeed=450,hpRegen=14,abi={},baseGoldBounty=1,type="ARMY"},
	{name="level12",hp=6000,armor=20,magicRes=0,moveSpeed=400,hpRegen=10,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level13",hp=10000,armor=80,magicRes=0,moveSpeed=300,hpRegen=50,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level14",hp=8000,armor=20,magicRes=75,moveSpeed=300,hpRegen=20,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level15",hp=12000,armor=80,magicRes=75,moveSpeed=250,hpRegen=30,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level16",hp=9000,armor=60,magicRes=100,moveSpeed=420,hpRegen=0,abi={"enemy_magic_immune"},baseGoldBounty=1,type="NORMAL"},
	{name="level17",hp=10000,armor=15,magicRes=0,moveSpeed=550,hpRegen=10,abi={},baseGoldBounty=1,type="ARMY"},
	{name="level18",hp=14500,armor=40,magicRes=75,moveSpeed=530,hpRegen=20,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level19",hp=25000,armor=100,magicRes=20,moveSpeed=300,hpRegen=50,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level20",hp=60000,armor=200,magicRes=100,moveSpeed=370,hpRegen=100,abi={"enemy_boss",},baseGoldBounty=1,type="BOSS"},
	{name="level21",hp=20000,armor=100,magicRes=10,moveSpeed=380,hpRegen=40,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level22",hp=35000,armor=20,magicRes=20,moveSpeed=400,hpRegen=1500,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level23",hp=32000,armor=90,magicRes=50,moveSpeed=550,hpRegen=0,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level24",hp=30000,armor=70,magicRes=100,moveSpeed=340,hpRegen=20,abi={"enemy_magic_immune"},baseGoldBounty=1,type="NORMAL"},
	{name="level25",hp=75000,armor=150,magicRes=100,moveSpeed=420,hpRegen=100,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level26",hp=40000,armor=110,magicRes=0,moveSpeed=440,hpRegen=80,abi={},baseGoldBounty=1,type="ARMY"},
	{name="level27",hp=70000,armor=100,magicRes=0,moveSpeed=300,hpRegen=20,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level28",hp=65000,armor=80,magicRes=100,moveSpeed=380,hpRegen=40,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level29",hp=80000,armor=200,magicRes=40,moveSpeed=250,hpRegen=400,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level30",hp=200000,armor=300,magicRes=100,moveSpeed=300,hpRegen=1,abi={"enemy_boss","enemy_magic_immune"},baseGoldBounty=1,type="BOSS"},
	{name="level31",hp=75000,armor=120,magicRes=30,moveSpeed=300,hpRegen=500,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level32",hp=80000,armor=150,magicRes=0,moveSpeed=520,hpRegen=20,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level33",hp=98000,armor=200,magicRes=0,moveSpeed=440,hpRegen=100,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level34",hp=100000,armor=250,magicRes=-50,moveSpeed=300,hpRegen=0,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level35",hp=120000,armor=300,magicRes=50,moveSpeed=250,hpRegen=1000,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level36",hp=110000,armor=120,magicRes=20,moveSpeed=550,hpRegen=10,abi={},baseGoldBounty=1,type="ARMY"},
	{name="level37",hp=140000,armor=150,magicRes=0,moveSpeed=550,hpRegen=800,abi={},baseGoldBounty=1,type="NORMAL"},
	{name="level38",hp=180000,armor=200,magicRes=70,moveSpeed=400,hpRegen=0,abi={"enemy_move_speed_constant"},baseGoldBounty=1,type="ELITE"},
	{name="level39",hp=200000,armor=400,magicRes=80,moveSpeed=550,hpRegen=1400,abi={},baseGoldBounty=1,type="ELITE"},
	{name="level40",hp=600000,armor=1000,magicRes=95,moveSpeed=233,hpRegen=3000,abi={"enemy_boss","enemy_move_speed_constant"},baseGoldBounty=1,type="BOSS"},
}

_G.HeroAbility={
	"hero_special_earth_lv1_blessing",
	"hero_special_water_lv1_blessing",
	"hero_special_fire_lv1_blessing",
	"hero_special_air_lv1_blessing",
	"hero_special_earth_lv2_blessing",
	"hero_special_water_lv2_blessing",
	"hero_special_fire_lv2_blessing",
	"hero_special_air_lv2_blessing",
	"hero_special_earth_great_power",
	"hero_special_absolute_zero",
	"hero_special_flame_outbrust",
	"hero_special_tornado_field",
	"hero_special_holy_light",
	"hero_special_final_shield",
	--"hero_special_ice_curse",
	"hero_special_nature_root",
	--"hero_special_alchemy",
}
_G.EnemyEliteAbility={
	"enemy_guard_aura",
	"enemy_speed_aura",
	"enemy_life_aura",
	"enemy_resistance_aura",
	"enemy_sacrifice_guard",
	"enemy_sacrifice_charge",
	"enemy_sacrifice_heal",
	"enemy_sacrifice_antimagi",
}

_G.TechInfo = LoadKeyValues('scripts/vscripts/tech_info.kv')
