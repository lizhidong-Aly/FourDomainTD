var hudRoot;
var panel;

for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
	hudRoot=panel;
}
function InitResourcePanel(){
	SetUIComponentVisibility("stats",false)
	if(hudRoot.FindChildTraverse("CustomrResouseInfoPanel")==null){
		var panel = $.CreatePanel( "Panel", hudRoot.FindChildTraverse("inventory"), "" );
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
	DrawAttackRangeOfUnitSelected();
	UpdateUIbasedOnUnitType();
	$.Schedule(1/30,InstructionSendConstantly);
}
//Send info to server
function DrawAttackRangeOfUnitSelected(){
	var units=null;
	var range=null;
	var current=Players.GetLocalPlayerPortraitUnit();
	if(Entities.IsOwnedByAnyPlayer(current)){
		units=Players.GetSelectedEntities(Players.GetLocalPlayer());
		range=new Array();
		for(var i in units) {
			range[i]=Entities.GetAttackRange(units[i]);
		}
	}
	GameEvents.SendCustomGameEventToServer( "DrawAttackRange", {units:units,range:range});
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
	}else if(Entities.IsControllableByAnyPlayer(current) && !Entities.HasMovementCapability(current)){
		ChangeUISettingToTower()
	}else{
		ChangeUISettingToOthers()
	}
}

function ChangeUISettingToHero(){
	SetUIComponentVisibility("CustomTowerInfoPanel",false)
	SetUIComponentVisibility("InventoryContainer",true)
	SetUIComponentVisibility("StatBranch",true)
}

function ChangeUISettingToTower(){
	SetUIComponentVisibility("CustomTowerInfoPanel",true)
	SetUIComponentVisibility("InventoryContainer",false)
	SetUIComponentVisibility("StatBranch",false)
}

function ChangeUISettingToOthers(){
	SetUIComponentVisibility("CustomTowerInfoPanel",true)
	SetUIComponentVisibility("InventoryContainer",false)
	SetUIComponentVisibility("StatBranch",true)
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
//-------------------------------------------------------------------------------
(function()
{
	$.Msg("custom_status_panel.js is loaded")
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

	GameUI.SetMouseCallback( function( eventName, arg ) {
		var CONSUME_EVENT = true;
		var CONTINUE_PROCESSING_EVENT = false;

		if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE ){
			return CONTINUE_PROCESSING_EVENT;
		}
		if ( eventName == "pressed" ){
			// Left-click is move to position
			if ( arg === 0 ){
				GameEvents.SendCustomGameEventToServer( "ClosedAllUI",{});
			}
		}
		return CONTINUE_PROCESSING_EVENT;
	});
	for(panel=$.GetContextPanel();panel!=null;panel=panel.GetParent()){
		hudRoot=panel;
	}
	InstructionSendConstantly();
	InitResourcePanel();
	ModifyTooltipWidth();
	SetUIComponentVisibility("StatBranchDrawer",false)
	var lvPanel=hudRoot.FindChildTraverse("LevelPanel");
	if(lvPanel==null){
		lvPanel = $.CreatePanel( "Panel",hudRoot.FindChildTraverse("center_block"), "LevelPanel" );
		lvPanel.BLoadLayout( "file://{resources}/layout/custom_game/LevelPanel.xml", false, false );
	}
})();