"use strict";

var info=null;
var attack_range_indicator=null;
function UpdateData(data){
	info=data
	var panel=$.GetContextPanel().FindChildTraverse("CustomTowerInfoPanel")
	if(panel!=null && panel.visible){
		var u =Players.GetLocalPlayerPortraitUnit();
		if(Entities.IsEnemy(u)){
			info.armor=Entities.GetPhysicalArmorValue(u);
			info.magicArmor=Math.round(Entities.GetMagicalArmorValue(u)*100);
			info.moveSpe=Math.round(data.movSpe)
			info.changeOnMoveSpe=info.moveSpe-info.baseMovSpe;
			info.armorChange=Entities.GetBonusPhysicalArmor(u);
			info.resistancePhy=Math.round(Entities.GetArmorReductionForDamageType(u,DAMAGE_TYPES.DAMAGE_TYPE_PHYSICAL)*100)
			SetStatusMode("def");
			$("#label_a_data").text=info.armor;
			$("#label_b_data").text=info.magicArmor+"%";
			$("#label_c_data").text=info.moveSpe;
		}else if(Entities.GetAbilityByName(u,"base_passive")!=-1 || !Entities.IsControllableByAnyPlayer(u)){
			SetStatusMode("att");
			$("#label_a_data").text=0;
			$("#label_b_data").text=0;
			$("#label_c_data").text=0;	
		}else{
			SetStatusMode("att");
			info.minDmg=Entities.GetDamageMin(u);
			info.maxDmg=Entities.GetDamageMax(u);
			info.extraDmg=Entities.GetDamageBonus(u);
			info.spe=Entities.GetAttackSpeed(u);
			info.range=Entities.GetAttackRange(u);
			info.rangeChange=info.range-info.baseRange;
			$("#label_a_data").text=(info.minDmg+info.maxDmg)/2+info.extraDmg;
			$("#label_b_data").text=Math.round(info.spe*100);
			$("#label_c_data").text=info.range;
		}
			$("#cost_data").text=info.totalcost;
			$("#upcost_data").text=info.upcost_gold;
			if(info.upcost=="N/A"){
				$("#upcost_data").text="N/A"
			}
			$("#attribute_data").text=DecodeAttribute(info.attribute);
		//$.Msg(Entities.IsOwnedByAnyPlayer( u ))
	}
}

function DecodeAttribute(attribute){
	var text='';
	for(var i=0;i<attribute.length;i++){
		text=text+$.Localize( "#"+attribute[i] );
		if(i<attribute.length-1){
			text=text+"-";
		}
	}
	return text;
}

function ShowDetailedInfo(data){
	var des=null;
	var tittle=$.Localize( "#status_detail" );
	var context=$.GetContextPanel().FindChildTraverse("TowerDmgInfo");
	var u =Players.GetLocalPlayerPortraitUnit();
	if(info!=null){
		if(data=="a"){
			var u =Players.GetLocalPlayerPortraitUnit();
			if(Entities.IsEnemy(u)){
				des=$.Localize( "#status_armor" )+MakeTextColor((info.armor-info.armorChange),"white");
				if(info.armorChange>0){
					des=des+"("+MakeTextColor("+"+info.armorChange,"green")+")";
				}else if(info.armorChange<0){
					des=des+"("+MakeTextColor(info.armorChange,"red")+")"
				}
				des=des+'<br>'+$.Localize( "#status_resistance_phy" )+MakeTextColor(info.resistancePhy+"%","white");
				des=des+'<br>'+$.Localize( "#status_magic_armor" )+MakeTextColor(info.magicArmor+"%","white");
				des=des+'<br>'+$.Localize( "#status_movespe" )+MakeTextColor(info.baseMovSpe,"white");
				if(info.changeOnMoveSpe>0){
					des=des+"("+MakeTextColor("+"+info.changeOnMoveSpe,"green")+")";
				}else if(info.changeOnMoveSpe<0){
					des=des+"("+MakeTextColor(info.changeOnMoveSpe,"red")+")"
				}
			}else if(Entities.GetAbilityByName(u,"base_passive")!=-1 || !Entities.IsControllableByAnyPlayer(u)){
				des=$.Localize( "#status_dmage" )+MakeTextColor(0,"white");
				des=des+'<br>'+$.Localize( "#status_speed" )+MakeTextColor(0,"white");
				des=des+'<br>'+$.Localize( "#status_range" )+MakeTextColor(0,"white");
			}
			else{
				des=$.Localize( "#status_dmage" )+MakeTextColor(info.minDmg+'-'+info.maxDmg,"white");
				if(info.extraDmg>0){
					des=des+"("+MakeTextColor("+"+info.extraDmg,"green")+")";
				}else if(info.extraDmg<0){
					des=des+"("+MakeTextColor(info.extraDmg,"red")+")"
				}
				var attInterval=Math.round((info.bat/info.spe)*100)/100
				var spedes=MakeTextColor(Math.round(info.spe*100),"white")+'('+MakeTextColor(attInterval+$.Localize( "#status_speed_suffix" ),"white")+')'
				des=des+'<br>'+$.Localize( "#status_speed" )+spedes;
				des=des+'<br>'+$.Localize( "#status_range" )+MakeTextColor(info.baseRange,"white");
				if(info.rangeChange>0){
					des=des+"("+MakeTextColor("+"+info.rangeChange,"green")+")";
				}else if(info.rangeChange<0){
					des=des+"("+MakeTextColor(info.rangeChange,"red")+")"
				}
				DrawAttackRangeForUnit();
			}
			$.DispatchEvent( "DOTAShowTitleTextTooltip", $("#TowerDmgInfo"), tittle,des);
		}else{
			context=$.GetContextPanel().FindChildTraverse("TowerCostInfo");
			des=$.Localize( "#status_total_cost" )+MakeTextColor(info.totalcost,"gold");
			des=des+'<br>'+$.Localize( "#status_fund_return" )+MakeTextColor(info.fund_return,"gold")
			des=des+'<br>'+$.Localize( "#status_up_cost" )
			if(info.upcost=="N/A"){
				des=des+"N/A"
			}
			else{
				des=des+MakeTextColor(info.upcost_gold,"gold");
				if(info.upcost_eh!=0){
					des=des+"&"+MakeTextColor(info.upcost_eh,"#b72cff")
				}
			}
			des=des+'<br>'+$.Localize( "#status_crystal_used" )+MakeTextColor(info.eh,"#b72cff");
			des=des+'<br>'+$.Localize( "#status_attribute" )+DecodeAttribute(info.attribute);
			$.DispatchEvent( "DOTAShowTitleTextTooltip", $("#TowerCostInfo"), tittle,des);
		}
	}
}

function SetStatusMode(mode){
	if(mode=="def"){
		$("#status_label_a").text=$.Localize("#status_armor");
		$("#status_label_b").text=$.Localize("#status_magic_armor_short");
		$("#status_label_c").text=$.Localize("#status_movespe");
	}else{
		$("#status_label_a").text=$.Localize("#status_dmage");
		$("#status_label_b").text=$.Localize("#status_speed_short");
		$("#status_label_c").text=$.Localize("#status_range_short");
	}
}

function HideToolTips(){
	//GameEvents.SendCustomGameEventToServer( "ClearAttackRange", {} );
	RemoveAttackRangeIndicator();
	$.DispatchEvent( "DOTAHideTitleTextTooltip");
}

function DrawAttackRangeForUnit(){
	var unit=Players.GetLocalPlayerPortraitUnit();
	var range=Entities.GetAttackRange(unit);
	attack_range_indicator=Particles.CreateParticle("particles/custom_effect/attack_range_circle.vpcf",ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW,unit)
	Particles.SetParticleControl( attack_range_indicator,1,[range,0,0]);
}

function RemoveAttackRangeIndicator(){
	Particles.DestroyParticleEffect(attack_range_indicator,true);
	Particles.ReleaseParticleIndex(attack_range_indicator)	
	attack_range_indicator=null;
}

function MakeTextColor(text,color){
	return "<font color='"+color+"'>"+text+"</font>";
}

(function()
{
	GameEvents.Subscribe( "UpdateTowerInfo", UpdateData);
	$.Msg("custom_status_panel.js is loaded")
})();
//url("s2r://panorama/images/hud/reborn/inventory_bg_bg_psd.vtex"