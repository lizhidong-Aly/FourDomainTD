lua_test_ability = class({})
LinkLuaModifier( "modifier_lua_test_ability", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lua_test_ability:GetAOERadius()
	print("mark 1")
	local nt = CustomNetTables:GetTableValue("merge_list","test_value_a")
	DeepPrintTable(nt)
	return 999
end

function lua_test_ability:GetAbilityDamage()
	print("mark 2")
	return 589
end

function lua_test_ability:GetIntrinsicModifierName()
	return "modifier_lua_test_ability"
end


--------------------------------------------------------------------------------
