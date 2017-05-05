var hudRoot;
var panel;
//var attack_range_indicators=new Array();
for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
	hudRoot=panel;
}
function InitResourcePanel(){
	SetUIComponentVisibility("stats",true)
	if(hudRoot.FindChildTraverse("CustomrResousePanel")==null){
		var panel = $.CreatePanel( "Panel", hudRoot.FindChildTraverse("inventory"), "CustomrResousePanel" );
		panel.BLoadLayout( "file://{resources}/layout/custom_game/custom_resouse_panel.xml", false, false );
	}
	if(hudRoot.FindChildTraverse("CustomTowerInfoPanel")==null){
		var panel = $.CreatePanel( "Panel", hudRoot.FindChildTraverse("inventory_items"), "" );
		panel.BLoadLayout( "file://{resources}/layout/custom_game/custom_status_panel.xml", false, false );
	}
}

function SetUIComponentVisibility(name,visiable){
	if (hudRoot!=null){
		var comp=hudRoot.FindChildTraverse(name)
		if (comp!=null){
			if (visiable){
				comp.style.visibility="visible";
			}else{
				comp.style.visibility="collapse";
			}
		}
	}
}
//-----------------------------------------------------------------------
//Run 30 times per sec, use to keep constant communacation with server and updata ui componment
function InstructionSendConstantly(){
	SendCurrentPortraitUnit();
	//DrawAttackRangeOfUnitSelected();
	UpdateUIbasedOnUnitType();
	$.Schedule(1/30,InstructionSendConstantly);
}
//Send info to server
function DrawAttackRangeOfUnitSelected(){
	var portrait_unit=Players.GetLocalPlayerPortraitUnit();
	if(!Entities.IsOwnedByAnyPlayer(portrait_unit)){
		for(var i in attack_range_indicators){
			if(attack_range_indicators[i].indicator!=null){
				RemoveAttackRangeIndicatorForUnit(i)
			}
		}
		return
	}
	var current=Players.GetSelectedEntities(Players.GetLocalPlayer());
	for(var i in current){
		if(	Entities.IsOwnedByAnyPlayer(current[i]) 
			&& !Entities.IsHero(current[i]) ) {
			DrawAttackRangeIndicatorForUnit(current[i])
		}
	}
	for(var i in attack_range_indicators){
		if(attack_range_indicators[i].indicator!=null){
			var exist=false
			for(var j in current){
				if(current[j]==i){
					exist=true
					break;
				}
			}
			if(!exist){
				RemoveAttackRangeIndicatorForUnit(i)
			}
		}
	}
}

function DrawAttackRangeIndicatorForUnit(unit){
	var range=Entities.GetAttackRange(unit);
	var a=[range,0,0];
	if(attack_range_indicators[unit]==null){
		attack_range_indicators[unit]={};
	}
	if(attack_range_indicators[unit].indicator==null){
		attack_range_indicators[unit].range=range;
		attack_range_indicators[unit].indicator=Particles.CreateParticle("particles/custom_effect/attack_range_circle.vpcf",ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW,unit)
		Particles.SetParticleControl( attack_range_indicators[unit].indicator,1,a);
	}else if(attack_range_indicators[unit].range!=range){
		RemoveAttackRangeIndicatorForUnit(unit);
		DrawAttackRangeIndicatorForUnit(unit);
	}		
}

function RemoveAttackRangeIndicatorForUnit(unit){
	Particles.DestroyParticleEffect(attack_range_indicators[unit].indicator,true);
	Particles.ReleaseParticleIndex(attack_range_indicators[unit].indicator)	
	attack_range_indicators[unit].indicator=null;
	attack_range_indicators[unit].range=null;
}

function SendCurrentPortraitUnit(){
	var current=Players.GetLocalPlayerPortraitUnit();
	if(current!=null){
		GameEvents.SendCustomGameEventToServer( "SendCurrentPortraitUnit", {unit:current} );
	}
}
//Update Ui
function UpdateUIbasedOnUnitType(){
	var current=Players.GetLocalPlayerPortraitUnit();
	if(Entities.IsHero(current)){
		ChangeUISettingToHero()
	}else if(Entities.IsControllableByAnyPlayer(current) && Entities.IsRooted(current)){
		ChangeUISettingToTower()
	}else{
		ChangeUISettingToOthers()
	}
}

function ChangeUISettingToHero(){
	SetUIComponentVisibility("CustomTowerInfoPanel",false)
	SetUIComponentVisibility("InventoryContainer",true)
	SetUIComponentVisibility("LevelPanel",false)
	SetUIComponentVisibility("inventory_backpack_list",false)
	hudRoot.FindChildTraverse("inventory").style["width"]="202px";
	hudRoot.FindChildTraverse("center_block").style.width=104+202+159+352+"px";
	//hudRoot.FindChildTraverse("AbilitiesAndStatBranch").style.width="2000px";
	hudRoot.FindChildTraverse("HealthManaContainer").style.width="328px";
	hudRoot.FindChildrenWithClassTraverse("AbilityInsetShadowRight")[0].style["margin-right"]="253px";
}

function ChangeUISettingToTower(){
	SetUIComponentVisibility("CustomTowerInfoPanel",true)
	SetUIComponentVisibility("InventoryContainer",false)
	SetUIComponentVisibility("LevelPanel",true)
	hudRoot.FindChildTraverse("inventory").style["width"]="252px";
	hudRoot.FindChildTraverse("center_block").style.width=104+252+159+302+"px";
	//hudRoot.FindChildTraverse("AbilitiesAndStatBranch").style.width="288px";
	hudRoot.FindChildTraverse("HealthManaContainer").style.width="278px";
	hudRoot.FindChildrenWithClassTraverse("AbilityInsetShadowRight")[0].style["margin-right"]="303px";
}

function ChangeUISettingToOthers(){
	SetUIComponentVisibility("CustomTowerInfoPanel",true)
	SetUIComponentVisibility("InventoryContainer",false)
	SetUIComponentVisibility("LevelPanel",false)
	hudRoot.FindChildTraverse("inventory").style["width"]="252px";
	hudRoot.FindChildTraverse("center_block").style.width=104+252+159+302+"px";
	//hudRoot.FindChildTraverse("AbilitiesAndStatBranch").style.width="288px";
	hudRoot.FindChildTraverse("HealthManaContainer").style.width="278px";
	hudRoot.FindChildrenWithClassTraverse("AbilityInsetShadowRight")[0].style["margin-right"]="303px";
}

function ModifyTooltipWidth(){
	var Tooltip=hudRoot.FindChildTraverse("TitleTextTooltip")
	if(Tooltip!=null){
		var s=Tooltip.FindChildTraverse('Contents')
		s.style['max-width']='400px';
	}else{
		$.Schedule(1/30,ModifyTooltipWidth);
	}
}

function InitUIComponment(){
	InstructionSendConstantly();
	InitResourcePanel();
	ModifyTooltipWidth();
	SetUIComponentVisibility("StatBranchDrawer",false)
	SetUIComponentVisibility("StatBranch",false)
	SetUIComponentVisibility("stats_container",false)
	SetUIComponentVisibility("PortraitBacker",true)
	SetUIComponentVisibility("PortraitBackerColor",true)
	var lvPanel=hudRoot.FindChildTraverse("LevelPanel");
	if(lvPanel==null){
		lvPanel = $.CreatePanel( "Panel",hudRoot.FindChildTraverse("center_block"), "LevelPanel" );
		lvPanel.BLoadLayout( "file://{resources}/layout/custom_game/LevelPanel.xml", false, false );
	}
	hudRoot.FindChildTraverse("AbilitiesAndStatBranch").style["min-width"]="720px";
}

//-------------------------------------------------------------------------------
(function()
{
	$.Msg("global.js is loaded")
	// Turn off some default UI
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );

	// Turn off the top part of the HUD, and remove the inset so the game renders to the top of the screen
	GameUI.SetRenderTopInsetOverride( 0 );

	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_MENU_BUTTONS, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false );
	//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false );
	// Uncomment this to remove the bottom part of the HUD
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, true );		
	/*
	GameUI.SetRenderBottomInsetOverride( 0 );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false );
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false );
	*/

	for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
		hudRoot=panel;
	}
	InitUIComponment();
})();