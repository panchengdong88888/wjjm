--[[
MainLeftBottom(2).lua 作者级明文恢复汇总稿
生成：2026-11-10 | GitHub checkpoint 212
用途：将现有普通Lua候选集中到一个文件，并建立110原型的权威路径/状态索引。
重要：这是“源码恢复汇总稿/静态候选集”，不是已验证可直接运行的最终脚本。
- 根模块主体仍有分段记录；闭包工厂必须按真实upvalue顺序绑定。
- 已恢复的函数体保留为独立词法块，供后续按prototype_index合并到根作用域。
- 未完成函数不伪造空实现；未闭合槽位保留TODO/占位。
- runtime_verified 全部为 false；没有进行目标游戏运行时验证。
- 新框架API以《新框架(3_40_xx).zip》为接口参考；只将文档明确的API标为DOCUMENTED。
- 诸如 actor:GetOwnerID()/actor:IsDie()/global.gamePlayerController:GetMainPlayerID()
  是脚本中观察到的宿主对象方法；开发包未检索到这些精确方法名，不擅自宣称文档已定义。
]]
local MainLeftBottomRecovered = { sources = {}, prototype_index = {} }
_G.MainLeftBottomRecovered = MainLeftBottomRecovered

-- API调用边界：
-- DOCUMENTED：SL:GetMetaValue及元变量MAP_ID/MAP_NAME/IN_SAFE_AREA/SCREEN_WIDTH/
-- SCREEN_HEIGHT/MAIN_ACTOR_ID/ACTOR_IS_HERO/ACTOR_MASTER_ID/ACTOR_NAME/ACTOR_HP/
-- BAG_DATA/ITEM_IS_BIND/ITEM_INDEX_BY_NAME/ITEM_COUNT；SL:FindMonsterInCurrViewField、
-- SL:Schedule、SL:ScheduleOnce、SL:UnSchedule、SL:JsonDecode、SL:UseItemByIndex；
-- GUI.Attach_UITop及GUI常用控件方法。
-- HOST_METHOD_OBSERVED：actor:GetOwnerID()/IsDie()/GetID()/GetName()、
-- global.gamePlayerController:GetMainPlayerID()、global.dropItemManager:
-- FindDropItemInCurrViewFieldAll()、NPCStorageProxy/QuickUseProxy等代理方法。
-- SCRIPT_PROTOTYPE：GetMainPlayerID/GetMapId/GetMapName/PlayerPos等若在原型索引中
-- 有对应root.children[n]，它们是本Lua文件定义的包装函数，不是引擎内部实现。
--
MainLeftBottomRecovered.prototype_index = {
  ["root.children[0]"] = { name="FileExistCheck_pcall_wrapper", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十八批.lua", instructions=32, runtime_verified=false },
  ["root.children[13]"] = { name="GetMapId", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=9, runtime_verified=false },
  ["root.children[16]"] = { name="PrintLog", status="complete_static_reconstruction", source_file="04_源码候选/PrintLog_日志辅助函数_第七批.lua", instructions=38, runtime_verified=false },
  ["root.children[17]"] = { name="PCallHelper", status="complete_static_reconstruction", source_file="04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua", instructions=14, runtime_verified=false },
  ["root.children[17].children[0]"] = { name="Nested_tostring", status="complete_static_reconstruction", source_file="04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua", instructions=14, runtime_verified=false },
  ["root.children[18]"] = { name="GetPlayerPosition", status="complete_static_reconstruction", source_file="04_源码候选/位置读取函数_第五批草稿.lua", instructions=19, runtime_verified=false },
  ["root.children[19]"] = { name="InitGatherMonsters", status="complete_static_reconstruction", source_file="04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua", instructions=36, runtime_verified=false },
  ["root.children[19].children[0]"] = { name="Nested_MainLoop", status="complete_static_reconstruction", source_file="04_源码候选/短闭包辅助函数_第三批草稿.lua", instructions=3, runtime_verified=false },
  ["root.children[20]"] = { name="ShowLocalNoticeByType", status="complete_static_reconstruction", source_file="04_源码候选/其他短辅助函数_第二批草稿.lua", instructions=15, runtime_verified=false },
  ["root.children[21]"] = { name="PickUpItems", status="complete_static_reconstruction", source_file="04_源码候选/PickUpItems_拾取流程_第十批.lua", instructions=172, runtime_verified=false },
  ["root.children[21].children[0]"] = { name="Nested_dist", status="complete_static_reconstruction", source_file="04_源码候选/PickUpItems_距离比较闭包_第九批.lua", instructions=19, runtime_verified=false },
  ["root.children[21].children[1]"] = { name="Nested_dist_2", status="complete_static_reconstruction", source_file="04_源码候选/PickUpItems_距离比较闭包_第九批.lua", instructions=8, runtime_verified=false },
  ["root.children[25].children[0]"] = { name="Nested_RequestAddBlacklistByName", status="complete_static_reconstruction", source_file="04_源码候选/短闭包辅助函数_第三批草稿.lua", instructions=6, runtime_verified=false },
  ["root.children[28]"] = { name="FindMonsterCandidates", status="complete_static_reconstruction", source_file="04_源码候选/root28_FindMonsterCandidates.lua", instructions=102, runtime_verified=false },
  ["root.children[28].children[0]"] = { name="Nested_distance", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=8, runtime_verified=false },
  ["root.children[29]"] = { name="IsDie", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=7, runtime_verified=false },
  ["root.children[30]"] = { name="GetMapName", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=9, runtime_verified=false },
  ["root.children[32]"] = { name="AnonymousHelper_32", status="complete_static_reconstruction", source_file="04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua", instructions=6, runtime_verified=false },
  ["root.children[33]"] = { name="AnonymousHelper_33", status="complete_static_reconstruction", source_file="04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua", instructions=5, runtime_verified=false },
  ["root.children[39]"] = { name="GetMainPlayerID", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=6, runtime_verified=false },
  ["root.children[4]"] = { name="GetDroppedItems", status="complete_static_reconstruction", source_file="04_源码候选/其他短辅助函数_第二批草稿.lua", instructions=8, runtime_verified=false },
  ["root.children[42].children[0]"] = { name="Nested_find", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第五十二批.lua", instructions=46, runtime_verified=false },
  ["root.children[42].children[1]"] = { name="Nested_SL_2", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第六十八批.lua", instructions=33, runtime_verified=false },
  ["root.children[42].children[1].children[0]"] = { name="Nested_LuaSendMsg", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第六十八批.lua", instructions=22, runtime_verified=false },
  ["root.children[42].children[10]"] = { name="Nested_shiquTimer", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十二批.lua", instructions=25, runtime_verified=false },
  ["root.children[42].children[11]"] = { name="Nested_Helper_4", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十五批.lua", instructions=12, runtime_verified=false },
  ["root.children[42].children[11].children[0]"] = { name="Nested_Helper_5", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十批.lua", instructions=35, runtime_verified=false },
  ["root.children[42].children[12]"] = { name="Nested_04d_02d_02d", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十三批.lua", instructions=43, runtime_verified=false },
  ["root.children[42].children[13]"] = { name="Nested_Helper_6", status="complete_static_reconstruction", source_file="04_源码候选/短闭包辅助函数_第三批草稿.lua", instructions=6, runtime_verified=false },
  ["root.children[42].children[14]"] = { name="Nested_Helper_7", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十五批.lua", instructions=12, runtime_verified=false },
  ["root.children[42].children[14].children[0]"] = { name="Nested_Helper_8", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十批.lua", instructions=34, runtime_verified=false },
  ["root.children[42].children[15]"] = { name="Nested_Helper_9", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十五批.lua", instructions=30, runtime_verified=false },
  ["root.children[42].children[16]"] = { name="Nested_ITEM_INDEX_BY_NAME", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十四批.lua", instructions=26, runtime_verified=false },
  ["root.children[42].children[17]"] = { name="Nested_blacklistTimer", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十二批.lua", instructions=28, runtime_verified=false },
  ["root.children[42].children[19]"] = { name="Nested_TakeItems", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第二十三批.lua", instructions=29, runtime_verified=false },
  ["root.children[42].children[2]"] = { name="Nested_Helper", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十七批.lua", instructions=21, runtime_verified=false },
  ["root.children[42].children[20]"] = { name="Nested_s", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十七批.lua", instructions=21, runtime_verified=false },
  ["root.children[42].children[21]"] = { name="Nested_dropTimer", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第二十批.lua", instructions=29, runtime_verified=false },
  ["root.children[42].children[22].children[0]"] = { name="Nested_str", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十七批.lua", instructions=27, runtime_verified=false },
  ["root.children[42].children[22].children[0].children[0]"] = { name="Nested_match", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十七批.lua", instructions=50, runtime_verified=false },
  ["root.children[42].children[22].children[0].children[0].children[0]"] = { name="Nested_Helper_11", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十七批.lua", instructions=4, runtime_verified=false },
  ["root.children[42].children[3].children[0]"] = { name="Nested_Helper_2", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第六十九批.lua", instructions=35, runtime_verified=false },
  ["root.children[42].children[3].children[1]"] = { name="Nested_string", status="complete_static_reconstruction", source_file="04_源码候选/资源统计刷新链_第六十四批.lua", instructions=46, runtime_verified=false },
  ["root.children[42].children[3].children[2]"] = { name="Nested_FFFFFF", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第五十六批.lua", instructions=65, runtime_verified=false },
  ["root.children[42].children[3].children[3]"] = { name="Nested_Helper_3", status="complete_static_reconstruction", source_file="04_源码候选/资源统计刷新链_第六十四批.lua", instructions=168, runtime_verified=false },
  ["root.children[42].children[3].children[4]"] = { name="Nested_UnSchedule", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十五批.lua", instructions=20, runtime_verified=false },
  ["root.children[42].children[4]"] = { name="Nested_OnGameLeaveWorld", status="complete_static_reconstruction", source_file="04_源码候选/短闭包辅助函数_第三批草稿.lua", instructions=5, runtime_verified=false },
  ["root.children[42].children[5]"] = { name="Nested_ffffff", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十三批.lua", instructions=41, runtime_verified=false },
  ["root.children[42].children[6]"] = { name="Nested_StopGatherMonsters", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第六十七批.lua", instructions=31, runtime_verified=false },
  ["root.children[42].children[7]"] = { name="Nested_InitGatherMonsters", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十二批.lua", instructions=17, runtime_verified=false },
  ["root.children[42].children[8]"] = { name="Nested_SL_3", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十二批.lua", instructions=29, runtime_verified=false },
  ["root.children[42].children[9]"] = { name="Nested_Button_setTitleFontSize", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十一批.lua", instructions=50, runtime_verified=false },
  ["root.children[42].children[9].children[0]"] = { name="Nested_Button_setTitleText", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第七十一批.lua", instructions=48, runtime_verified=false },
  ["root.children[43]"] = { name="GetOwnerDescription", status="complete_static_reconstruction", source_file="04_源码候选/root43_GetOwnerDescription.lua", instructions=20, runtime_verified=false },
  ["root.children[44]"] = { name="GetPlayerMapPosition", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十七批.lua", instructions=17, runtime_verified=false },
  ["root.children[46]"] = { name="DiuItems", status="complete_static_reconstruction", source_file="04_源码候选/root46_DiuItems.lua", instructions=169, runtime_verified=false },
  ["root.children[46].children[0]"] = { name="Nested_string_2", status="complete_static_reconstruction", source_file="04_源码候选/小型辅助函数_首批草稿.lua", instructions=20, runtime_verified=false },
  ["root.children[48]"] = { name="PCallHelper_2", status="complete_static_reconstruction", source_file="04_源码候选/代理与回调短函数_第四批.lua", instructions=10, runtime_verified=false },
  ["root.children[48].children[0]"] = { name="Nested_FriendProxy", status="complete_static_reconstruction", source_file="04_源码候选/代理与回调短函数_第四批.lua", instructions=9, runtime_verified=false },
  ["root.children[57]"] = { name="PlayerPos", status="complete_static_reconstruction", source_file="04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua", instructions=10, runtime_verified=false },
  ["root.children[45]"] = { name="MainLoop", status="complete_static_reconstruction", source_file="04_源码候选/root45_MainLoop.lua", instructions=417, runtime_verified=false },
  ["root.children[35]"] = { name="SetTargetID", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十二批.lua", instructions=26, runtime_verified=false },
  ["root.children[7]"] = { name="GetOwnerIDText", status="complete_static_reconstruction", source_file="04_源码候选/root7_GetOwnerIDText.lua", instructions=31, runtime_verified=false },
  ["root.children[38]"] = { name="GetOwnerID", status="complete_static_reconstruction", source_file="04_源码候选/root38_GetOwnerID.lua", instructions=31, runtime_verified=false },
  ["root.children[11]"] = { name="DistanceCalculation", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十二批.lua", instructions=25, runtime_verified=false },
  ["root.children[10]"] = { name="SetButtonVisibilityState", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十三批.lua", instructions=15, runtime_verified=false },
  ["root.children[26]"] = { name="ResetGatherMonsterData", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十三批.lua", instructions=20, runtime_verified=false },
  ["root.children[27]"] = { name="StopGatherMonsters", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十三批.lua", instructions=25, runtime_verified=false },
  ["root.children[37]"] = { name="DestroyUI", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十四批.lua", instructions=31, runtime_verified=false },
  ["root.children[40]"] = { name="ShowHideAllButtons", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十四批.lua", instructions=47, runtime_verified=false },
  ["root.children[31]"] = { name="IsInWhitelistMap", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十二批.lua", instructions=28, runtime_verified=false },
  ["root.children[24]"] = { name="UseItemByIndex", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十一批.lua", instructions=33, runtime_verified=false },
  ["root.children[55].children[1]"] = { name="Nested_ID", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root55_children_drafts.lua", instructions=27, runtime_verified=false },
  ["root.children[55]"] = { name="AccountIDValidation", status="complete_static_reconstruction", source_file="04_源码候选/root55_children_drafts.lua", instructions=64, runtime_verified=false },
  ["root.children[55].children[0]"] = { name="Nested_Panel_mini_chat", status="complete_static_reconstruction", source_file="04_源码候选/root55_children_drafts.lua", instructions=24, runtime_verified=false },
  ["root.children[15].children[0]"] = { name="Nested_SL", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十五批.lua", instructions=13, runtime_verified=false },
  ["root.children[0].children[0]"] = { name="Nested_removeFile", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第十五批.lua", instructions=5, runtime_verified=false },
  ["root.children[50].children[1]"] = { name="Nested_Anonymous_2", status="complete_static_reconstruction", source_file="04_源码候选/root50_Nested_Anonymous_2.lua", instructions=27, runtime_verified=false },
  ["root.children[50].children[0]"] = { name="Nested_isOutputted", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第三十四批.lua", instructions=52, runtime_verified=false },
  ["root.children[36]"] = { name="GetAvailableStoragePage", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第十四批.lua", instructions=51, runtime_verified=false },
  ["root.children[6]"] = { name="InstallDamageHook", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第三十九批.lua", instructions=40, runtime_verified=false },
  ["root.children[52].children[0]"] = { name="Nested_JsonDecode", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十批.lua", instructions=6, runtime_verified=false },
  ["root.children[2]"] = { name="GetWritablePath", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十一批.lua", instructions=10, runtime_verified=false },
  ["root.children[42].children[22]"] = { name="Nested_Anonymous", status="first_pass_draft_pending_VM_T_slot_mapping_and_T2_producer_not_runtime_verified", source_file="04_源码候选/Nested_Anonymous_第七十八批.lua", instructions=8, runtime_verified=false },
  ["root.children[8]"] = { name="FormatStateChange", status="conservative_first_pass_draft_argument_slots_pending_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十三批.lua", instructions=10, runtime_verified=false },
  ["root.children[9]"] = { name="ReadNumericConfig", status="first_pass_draft_vararg_declaration_pending_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十四批.lua", instructions=45, runtime_verified=false },
  ["root.children[23]"] = { name="Builtsetting", status="first_pass_draft_UPVALUE_0_business_semantics_pending_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十五批.lua", instructions=55, runtime_verified=false },
  ["root.children[25]"] = { name="DeathAutoBlacklist", status="first_pass_draft_upvalue_business_names_pending_not_runtime_verified", source_file="04_源码候选/短函数草稿_第四十九批.lua", instructions=47, runtime_verified=false },
  ["root.children[12]"] = { name="LuaSendMsg", status="first_pass_draft_revised_checkpoint_190_parameter_mapping_blocklist_hook_flow_pending_capture_names_host_runtime_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十批.lua", instructions=92, runtime_verified=false },
  ["root.children[22]"] = { name="GetMapData2DPtr", status="conservative_first_pass_draft_map_traversal_and_return_contract_pending_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十一批.lua", instructions=144, runtime_verified=false },
  ["root.children[3]"] = { name="MoveTo", status="first_pass_draft_move_notification_and_distance_checks_pending_return_polarity_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十三批.lua", instructions=51, runtime_verified=false },
  ["root.children[15]"] = { name="ClearBlacklistItems", status="first_pass_draft_blacklist_collection_and_async_removal_pending_key_value_capture_identity_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十四批.lua", instructions=63, runtime_verified=false },
  ["root.children[52]"] = { name="onDamageMsg", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十六批.lua", instructions=72, runtime_verified=false },
  ["root.children[1]"] = { name="GetStorageItemData", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十六批.lua", instructions=77, runtime_verified=false },
  ["root.children[5]"] = { name="TakeItems", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十七批.lua", instructions=99, runtime_verified=false },
  ["root.children[47]"] = { name="BlacklistPlayerDetection", status="first_pass_draft_pending_static_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十九批.lua", instructions=216, runtime_verified=false },
  ["root.children[50]"] = { name="StorageItems", status="first_pass_ordinary_lua_body_draft_recovered_checkpoint_189_pending_parent_capture_names_and_server_protocol_semantics_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十批.lua", instructions=224, runtime_verified=false },
  ["root.children[42]"] = { name="doInit_UI", status="first_pass_draft_revised_checkpoint_187_pending_attach_arguments_and_remaining_capture_review_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十三批.lua", instructions=419, runtime_verified=false },
  ["root.children[41]"] = { name="MoveItemToQuickUse", status="first_pass_ordinary_lua_body_draft_recovered_checkpoint_191_caller_arguments_closed_proxy_boolean_semantics_host_runtime_pending", source_file="04_源码候选/短函数草稿_第六十一批.lua", instructions=133, runtime_verified=false },
  ["root"] = { name="MainLeftBottom_Module", status="partial_ordinary_lua_draft", source_file="04_源码候选/root_MainLeftBottom_Module.lua", instructions=412, runtime_verified=false },
  ["root.children[6].children[0]"] = { name="Nested_onDamageMsg", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第三十九批.lua", instructions=18, runtime_verified=false },
  ["root.children[14]"] = { name="FindMonsterInCurrViewField", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第十三批.lua", instructions=27, runtime_verified=false },
  ["root.children[34]"] = { name="AnonymousHelper_33", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua", instructions=7, runtime_verified=false },
  ["root.children[42].children[3]"] = { name="Nested_FFFF00", status="ordinary_lua_draft_pending_host_semantics", source_file="04_源码候选/短函数草稿_第六十三批.lua", instructions=320, runtime_verified=false },
  ["root.children[42].children[18]"] = { name="Nested_Helper_10", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十三批.lua", instructions=39, runtime_verified=false },
  ["root.children[49]"] = { name="AnonymousHelper_49", status="complete_static_reconstruction_not_runtime_verified", source_file="", instructions=5, runtime_verified=false },
  ["root.children[51]"] = { name="FindBlacklistPlayer", status="complete_static_reconstruction_not_runtime_verified", source_file="", instructions=35, runtime_verified=false },
  ["root.children[53]"] = { name="ScheduleOnce", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/verified_helpers_batches_1_3.lua", instructions=7, runtime_verified=false },
  ["root.children[54]"] = { name="AnonymousHelper_54", status="complete_static_reconstruction_not_runtime_verified", source_file="", instructions=6, runtime_verified=false },
  ["root.children[56]"] = { name="ClearTargetID_2", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root56_root57_short_functions.lua", instructions=22, runtime_verified=false },

}

-- ============================================================================
-- 来源文件：04_源码候选/root_MainLeftBottom_Module.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- MainLeftBottom(2).lua 根模块首段普通 Lua 草稿
-- 原型：root / MainLeftBottom_Module
-- 规范路径：root
-- 规模：412条物理指令、109常量、58个直接子原型
-- 检查点192-198：根模块分段普通Lua草稿，PC1-PC412均已建立分段记录；非作者原文逐字恢复，未运行时验证。
-- 状态：不是完整根模块源码，尚未运行时验证。

local MainLeftBottom = {}
_G.MainLeftBottom = MainLeftBottom

-- PC3-PC16：主模块a表及版本、屏幕尺寸。
MainLeftBottom.a = {
    version = "10000",
    screenW = SL:GetMetaValue("SCREEN_WIDTH"),
    screenH = SL:GetMetaValue("SCREEN_HEIGHT")
}

-- PC17-PC29：a表中的钩子容器和界面状态。
MainLeftBottom.a.Blocklist = {1.0, 9.0, 10.0, 60000.0}
MainLeftBottom.a.SendHookList = {}
MainLeftBottom.a.RecvHookList = {}
MainLeftBottom.a.isHidden = true
MainLeftBottom.a.hidebut = nil

-- PC30-PC41：建立b表、z表，并初始化六个状态字段。
MainLeftBottom.b = {}
MainLeftBottom.z = {
    isPaused = false,
    isRunning = false,
    isStoring = false,
    isTaking = false,
    isDiuing = false,
    isOutputted = false
}

-- PC42-PC412已按检查点193-198分段整理。
-- 本文件不是完整、可直接运行的原始Lua文件。


-- 检查点193：PC42-PC85，根模块辅助闭包创建与导出。
-- PC42：创建一个新的表寄存器；其后续业务用途尚未由本段闭合，不擅自命名。
-- PC43-PC45：创建 root.children[16] PrintLog 闭包，并赋值给 _G.log。
-- PC46：创建 root.children[20] ShowLocalNoticeByType 闭包，捕获父 T[0]；
-- 本段没有观察到其全局导出，暂不臆测其最终持有位置。
-- PC48-PC51：创建 root.children[12] LuaSendMsg 闭包，捕获父 T[0]、T[4]，
-- 并将该闭包写入 PC3-PC5 创建的 MainLeftBottom.a.LuaSendMsg。
-- PC52-PC54：依次创建 ScheduleOnce、Schedule、GetMapId 三个闭包；
-- GetMapId 在 PC55 导出为全局 GetMapId。ScheduleOnce/Schedule 在此段未见全局赋值。
-- PC56-PC63：创建并导出全局 GetMapName、PlayerPos、GetDroppedItems、MoveTo。
-- PC64-PC67：创建 root.children[46] DiuItems，按捕获描述捕获父 T[2]、T[5]，
-- 随后导出为全局 DiuItems。
-- PC68-PC70：创建 root.children[36] GetAvailableStoragePage，捕获父 T[4]，
-- 并导出为全局 GetAvailableStoragePage。
-- PC71-PC73：创建 root.children[1] GetStorageItemData，捕获父 T[4]，
-- 并导出为全局 GetStorageItemData。
-- PC74-PC78：创建 root.children[50] StorageItems，按序捕获父 T[2]、T[4]、T[5]，
-- 并导出为全局 StorageItems。
-- PC79-PC82：创建 root.children[5] TakeItems，按序捕获父 T[2]、T[5]，
-- 并导出为全局 TakeItems。
-- PC83-PC85：创建 root.children[21] PickUpItems，捕获父 T[5]，
-- 并导出为全局 PickUpItems。
--
-- 注意：OP_387 后续记录是闭包捕获描述，不是独立业务语句。
-- 所有子原型实现均保留在各自源码文件；本根模块只记录闭包创建、
-- 捕获顺序和导出位置。


-- 检查点194：PC86-PC167 配置表与奖励记录表构造。
-- PC86-PC89：创建供采集逻辑读取的配置表；root.children[28] FindMonsterCandidates
-- 在父root PC194创建时捕获该表为UPVALUE[4]，因此这里按已核实用途命名。
local gatherConfig = {
    GATHER_THRESHOLD = 10,
    CHECK_INTERVAL = 0.5,
    ATTACK_WAIT_TIME = 1
}

-- PC90-PC95：计算 math.floor(3600 / 0.2)，结果为18000。
-- root PC408将该值捕获给doInit_UI的UPVALUE[17]；其在UI中的具体用途尚未闭合。

-- PC96-PC167：先创建空表，再逐项构造14条三元素奖励记录。
-- 前7项为累计登录天数记录，后7项为在线时长记录。
-- PC167将R13-R26按顺序组装进R12；PC409随后将R12捕获给
-- root.children[42] doInit_UI，捕获槽位为UPVALUE[18]。
-- 数字ID、文字标签和末尾数值均保留原始位置，不擅自解释其协议字段含义。
local loginAndOnlineRewardEntries = {
    {56061, "累计登录 1 天", 18},
    {56061, "累计登录 2 天", 18},
    {56061, "累计登录 3 天", 18},
    {56061, "累计登录 4 天", 18},
    {56061, "累计登录 5 天", 18},
    {56061, "累计登录 6 天", 18},
    {56061, "累计登录 7 天", 18},
    {56011, "在线时长5分钟", 19},
    {56011, "在线时长10分钟", 20},
    {56011, "在线时长20分钟", 20},
    {56011, "在线时长30分钟", 20},
    {56011, "在线时长60分钟", 20},
    {56011, "在线时长90分钟", 20},
    {56011, "在线时长120分钟", 21}
}

-- 上述奖励表由doInit_UI闭包捕获；其GUI展示/领取语义及三列字段的
-- 宿主协议含义仍待结合doInit_UI调用点与运行环境验证。


-- 检查点195：PC168-PC200，采集状态、共享状态单元及辅助闭包注册。
-- PC168-PC171：状态文字常量表；PC172以IDLE作为currentState初值。
local gatherStatusText = {
    IDLE = "空闲状态",
    GATHERING = "引怪中",
    ATTACKING = "攻击中"
}
local currentState = gatherStatusText.IDLE

-- PC173-PC180：根模块共享状态单元的初始值。
-- 仅将后续已闭合用途的槽位命名；其余保持中性名称，避免猜测业务字段。
local resettableTable = {}
local resetSlot16 = 0
local resetSlot17 = 0
local isGatherRunning = false
local resetSlot19 = false
local resetSlot20 = 0
local resetSlot21 = nil
local resetSlot22 = ""

-- PC181：创建root.children[8] / FormatStateChange闭包。
-- UPVALUE[0]捕获root T[4]=PrintLog；UPVALUE[1]捕获root T[14]=currentState共享单元。
-- 子原型在PrintLog正常返回后写回该共享单元；不得用值传参的独立局部变量替代共享cell。

-- PC184-PC193：依序创建无捕获辅助闭包：
-- PC184 root.children[35] SetTargetID
-- PC185 root.children[56] ClearTargetID_2
-- PC186 root.children[39] GetMainPlayerID
-- PC187 root.children[18] GetPlayerPosition
-- PC188 root.children[44] GetPlayerMapPosition
-- PC189 root.children[11] DistanceCalculation
-- PC190 root.children[29] IsDie
-- PC191 root.children[7] GetOwnerIDText
-- PC192 root.children[38] GetOwnerID
-- PC193 root.children[43] GetOwnerDescription
-- 这些闭包在root帧中创建为寄存器值，后续由MainLoop/其他闭包捕获；
-- 本文件不虚构它们的定义或全局导出。

-- PC194-PC199：创建root.children[28] / FindMonsterCandidates并按序捕获：
-- UPVALUE[0]=root T[27] GetPlayerPosition；
-- UPVALUE[1]=root T[30] IsDie；
-- UPVALUE[2]=root T[28] GetPlayerMapPosition；
-- UPVALUE[3]=root T[29] DistanceCalculation；
-- UPVALUE[4]=root T[8] gatherConfig。

-- PC200-PC209：创建root.children[26] / ResetGatherMonsterData并捕获九个共享单元：
-- UPVALUE[0]=root T[15] 空表；[1]=T[16]初值0；[2]=T[17]初值0；
-- [3]=T[25]预停止回调（业务身份保留中性名）；
-- [4]=T[19]初值false；[5]=T[20]初值0；[6]=T[21]初值nil；
-- [7]=T[22]初值空字符串；[8]=T[4] PrintLog。
-- 该子原型的复位写入顺序和回调调用契约已在检查点162独立闭合。


-- 检查点196：PC201-PC270，采集/主循环/界面控制闭包注册与捕获。
-- PC201-PC209：ResetGatherMonsterData的九项捕获描述，见检查点195/162；
-- 此处不将捕获描述误写成业务语句。

-- PC210：创建root.children[14] / ClearBlacklistItems，捕获数1；
-- PC211：捕获父帧T[30]（IsDie闭包）。子函数主体已独立恢复，不在根模块重复转写。

-- PC212-PC213：创建root.children[31] / IsInWhitelistMap（无捕获），
-- 并将闭包导出为全局IsInWhitelistMap。

-- PC214-PC236：创建root.children[45] / MainLoop，捕获数22。
-- 按字节码顺序捕获的父root T寄存器为：
-- [18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8]。
-- 与检查点158已闭合的MainLoop 22项upvalue语义顺序一致：
-- 运行标记、currentState、状态常量、PrintLog、FormatStateChange、
-- ResetGatherMonsterData、GetMainPlayerID、FindMonsterCandidates、
-- 目标ID数组、GetOwnerID、扫描游标、自己归属计数、等待标志、
-- 截止时间、等待名称、FindMonsterInCurrViewField、等待目标ID、
-- GetOwnerIDText、IsDie、GetOwnerDescription、SetTargetID、gatherConfig。
-- PC237将闭包导出为全局MainLoop；不重复转写其已完整静态恢复的函数体。

-- PC238-PC245：创建root.children[19] / InitGatherMonsters，捕获数7；
-- 按顺序捕获父root T[3],T[18],T[23],T[13],T[35],T[8],T[4]。
-- PC246将闭包导出为全局InitGatherMonsters。
-- PC247-PC254：创建root.children[27] / StopGatherMonsters，捕获数7；
-- 按顺序捕获父root T[18],T[3],T[25],T[23],T[13],T[35],T[4]。
-- PC255将闭包导出为全局StopGatherMonsters。
-- 两个子函数主体已在既有检查点独立静态恢复；此处仅记录父级捕获和导出。

-- PC256-PC257：创建root.children[23] / Builtsetting，捕获父root T[5]；
-- PC258将闭包导出为全局Builtsetting。

-- PC259-PC260：创建无捕获root.children[41] / MoveItemToQuickUse，
-- 并导出为全局MoveItemToQuickUse。函数体普通Lua草稿见检查点191。

-- PC261-PC264：创建root.children[37] / DestroyUI，捕获顺序为
-- [T[0],T[3],T[1]]，即UI状态对象、定时器状态对象、按钮映射表。
-- 此捕获映射与检查点164修正结果一致。

-- PC265：将闭包R37写入当前模块表的hide字段。
-- PC266：创建root.children[10] / SetButtonVisibilityState，捕获顺序为[T[0],T[1]]；
-- PC267-PC268为两项捕获描述。函数体已在检查点161完整静态恢复。
-- PC269：将闭包R37写入当前模块表的show字段。
-- PC270：创建root.children[40] / ShowHideAllButtons，捕获数3；
-- 后续捕获描述跨出本批范围，留待下一检查点继续核对（PC271起）。


-- 检查点197：PC271-PC340，UI导出、账号验证闭包、黑名单状态及配置初始化。
-- PC271-PC273：ShowHideAllButtons（root.children[40]）的三个捕获描述，
-- 按序捕获父root T[3]、T[1]、T[0]；对应定时器状态、按钮映射表、UI状态对象。
-- 该顺序与子函数已静态恢复的UPVALUE[0..2]一致。
-- PC274：将该闭包写入模块表的destroy字段（R0为MainLeftBottom模块表）。
-- 因此当前已确认模块表的hide/show/destroy三个字段分别在PC265/269/274写入。

-- PC275：重新读取_ENV.MainLeftBottom。
-- PC276-PC278：创建root.children[55] / AccountIDValidation，捕获父root T[4]与T[5]；
-- 即PrintLog与ShowLocalNoticeByType两个已建立的回调闭包。
-- PC279：将AccountIDValidation闭包写入MainLeftBottom.main字段。
-- 这里仅记录字段赋值和捕获关系，不推断main字段是否为唯一入口或具体触发时机。

-- PC280-PC282：构造单元素名称数组，内容为“随机传送石”。
-- 该数组后续在PC355-PC356被捕获给root.children[24] / UseItemByIndex。
local randomTeleportItemNames = { "随机传送石" }

-- PC283-PC285：装载三个数值常量：2.0、0.01、30.0。
-- 它们在PC368-PC381被BlacklistPlayerDetection按UPVALUE[6]/[9]/[11]捕获；
-- 机器状态与闭包映射已将其用途分别记录为节流阈值、短重试延迟、无道具重试延迟。
local blacklistAlertThreshold = 2.0
local blacklistShortRetryDelay = 0.01
local blacklistNoItemRetryDelay = 30.0

-- PC286-PC293：创建黑名单运行状态表并初始化字段。
-- PC294将同一表写入MainLeftBottom.blacklist；root.children[47] BlacklistPlayerDetection
-- 后续捕获该表为UPVALUE[2]，onDamageMsg也共享同一状态表。
local blacklistState = {
    lastAttacker = nil,   -- VM dump 的 ["unknown",2] 是 nil 序列化标记
    lastHp = nil,
    deathHandled = false,
    alertAt = 0.0,
    nextTryAt = 0.0,
    noStoneWarned = false,
    distance = nil
}

-- PC295-PC296：两个配置文件名常量。
local blacklistDistanceConfigFile = "blacklist_distance.txt"
local gatherMonsterCountConfigFile = "gather_monster_count.txt"

-- PC297：创建root.children[2] / GetWritablePath（无捕获）。
-- PC298-PC299：创建root.children[9] / ReadNumericConfig，捕获R44=GetWritablePath。
-- PC300-PC301：创建root.children[17] / PCallHelper，捕获同一R44；
-- 子原型及其嵌套写文件回调的完整语义见函数状态CSV和既有审计。
-- PC302-PC303：创建root.children[0] / FileExistCheck_pcall_wrapper，捕获R44。
-- 上述三个闭包捕获的是同一父帧寄存器值；此处不把捕获描述重复写成普通业务调用。

-- PC304-PC306：创建root.children[49] / AnonymousHelper_49；
-- UPVALUE[0]=R45（ReadNumericConfig闭包），UPVALUE[1]=R42（blacklist_distance.txt）。
-- 该辅助闭包调用ReadNumericConfig并转发结果，细节见检查点178。

-- PC307-PC309：创建root.children[32]，捕获R46与R42。
-- PC310-PC312：创建root.children[33]，捕获R45与R43。
-- 这两个短闭包的寄存器捕获关系按物理PC记录；其槽位用途不在本批扩大推断。
-- PC313-PC315：创建root.children[54] / AnonymousHelper_54；
-- UPVALUE[0]=R46（PCallHelper），UPVALUE[1]=R43（gather_monster_count.txt）。
-- 其调用参数顺序及多返回值转发已由检查点125闭合。

-- PC316-PC340：开始构造R52所指向的二维数值表。
-- 已观察到六个二元素子表依次由寄存器构造：
--   {1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}。
-- 本段只记录字节码直接构造出的数值，不擅自赋予方向、坐标偏移等业务含义。
-- PC341-PC348还需补齐后两个二元素子表，PC349再组装外层八项数组；
-- 因此本检查点不将R52标记为完整初始化。
-- PC350将R52捕获给root.children[22]；该函数UPVALUE在其活动路径中未读取
-- （检查点184），不据此推断该表参与距离计算。



-- 检查点198：PC341-PC412，根模块剩余数组、黑名单闭包及doInit_UI注册。
-- PC341-PC348完成R52最后两个二元素子表，PC349组装八项外层表。
-- 以下数值完全按字节码构造顺序记录；R52业务用途未知，不命名为方向/寻路表。
local opaquePairTable = {
    {  1,  0 }, { -1,  0 },
    {  0,  1 }, {  0, -1 },
    {  1,  1 }, {  1, -1 },
    { -1,  1 }, { -1, -1 }
}

-- PC350-PC351：创建root.children[22] / GetMapData2DPtr，捕获R52。
-- 检查点184确认该子函数活动路径不读取此UPVALUE。
-- PC352：创建root.children[48] / PCallHelper_2（无捕获）。
-- PC353-PC354：创建root.children[51] / FindBlacklistPlayer，捕获PCallHelper_2。
-- PC355-PC356：创建root.children[24] / UseItemByIndex，捕获randomTeleportItemNames。
-- PC357-PC358：创建root.children[52] / onDamageMsg，捕获blacklistState。
-- PC359：MainLeftBottom.onDamageMsg = onDamageMsg。

-- PC360-PC362：创建root.children[6] / InstallDamageHook，捕获父T[0]、T[4]。
-- 这两个父级捕获槽位按顺序保留；子闭包Nested_onDamageMsg的捕获另见检查点179。
-- PC363-PC367：创建root.children[25] / DeathAutoBlacklist，捕获：
-- [T[41], T[4], T[55], T[5]]。
-- PC368-PC381：创建root.children[47] / BlacklistPlayerDetection，按序捕获：
-- [T[2], T[57], T[41], T[58], T[55], T[53], T[38],
--  T[4], T[56], T[39], T[5], T[40], T[37]]。
-- PC382：将该闭包导出为全局BlacklistItems。
-- 13项捕获的逐槽用途见检查点186；此处不重复展开已恢复函数主体。

-- PC383-PC387：创建root.children[15] / ClearBlacklistItems，捕获：
-- [T[54], T[4], T[5], T[41]]。
-- PC388：导出全局ClearBlacklistItems。

-- PC389：重新读取全局MainLeftBottom。
-- PC390-PC410：创建root.children[42] / doInit_UI，捕获20项父root寄存器：
-- [T[4], T[2], T[3], T[0], T[1], T[41], T[48], T[7], T[8], T[50],
--  T[49], T[5], T[44], T[42], T[51], T[43], T[47], T[11], T[12], T[9]]。
-- 这是父级捕获顺序，不代表所有槽位业务身份均已确认。
-- doInit_UI本体419条，已有首版普通Lua草稿（检查点187）；
-- GUI宿主语义、Attach_UITop七实参、Nested_Anonymous三个T槽来源等仍待复审。
-- PC411：MainLeftBottom.doInit = doInit_UI。
-- PC412：根模块return。

-- 根模块PC1-PC412至此均有分段源码记录。
-- “PC范围已覆盖”不等于根模块已完成作者级源码恢复，也不等于运行时验证。



----------------------------------------------------------------
-- 检查点211：root.children[41] MoveItemToQuickUse 无捕获主体接入
--
-- 原型：root.children[41] / legacy root/42；133条物理指令，0项upvalue。
-- 函数主体取自短函数草稿_第六十一批.lua（检查点191），保持其普通Lua
-- 控制流和原始代理调用参数。该函数无父级捕获，可直接放入根模块作用域。
-- SetQuickUsePosData布尔参数、Bag返回表[1]语义及宿主代理行为仍待验证。
-- 本段为已计入72项草稿中的同一函数之整合副本，不重复计数。
local function MoveItemToQuickUse(itemIndex, targetPos)
    -- PC1-PC14：分别取得QuickUseProxy与Bag代理。
    local quickUseProxy = global.Facade:retrieveProxy(
        global.ProxyTable.QuickUseProxy
    )
    local bagProxy = global.Facade:retrieveProxy(
        global.ProxyTable.Bag
    )

    -- PC15-PC21：任一代理缺失均返回false和固定提示。
    if not quickUseProxy or not bagProxy then
        return false, "参数无效"
    end

    -- PC22-PC30：检查目标位置范围[1, GetQuickUseSize()]。
    local quickUseSize = quickUseProxy:GetQuickUseSize()
    if targetPos < 1 or targetPos > quickUseSize then
        return false, "目标位置超出范围"
    end

    -- PC31-PC35：取得快捷栏数据，按pairs遍历位置与条目。
    local quickUseData = quickUseProxy:GetQuickUseData()

    -- PC36-PC90：查找物品是否已经存在于快捷栏。
    for position, quickUseEntry in pairs(quickUseData) do
        if quickUseEntry.Index == itemIndex then
            -- PC42-PC46：物品已经处于目标位置。
            if position == targetPos then
                return false, "物品已在目标位置"
            end

            -- PC47-PC49：读取目标位置当前条目。
            local targetEntry =
                quickUseProxy:GetQucikUseDataByPos(targetPos)

            -- PC50-PC54：先按原始调用顺序写回当前位置条目。
            -- 第三个显式参数为true；其宿主含义未知，按原值保留。
            quickUseProxy:SetQuickUsePosData(
                position,
                quickUseEntry,
                true
            )

            if targetEntry then
                -- PC55-PC66：目标位置已有条目，执行双位置交换。
                quickUseProxy:SetQuickUsePosData(
                    targetPos,
                    quickUseEntry,
                    false
                )
                quickUseProxy:SetQuickUsePosData(
                    position,
                    targetEntry,
                    false
                )

                -- PC67-PC74：返回成功状态及“交换”格式提示。
                return true, string.format(
                    "快捷栏交换: %d ↔ %d",
                    position,
                    targetPos
                )
            end

            -- PC75-PC88：目标位置无条目，写入目标位置并返回移动提示。
            quickUseProxy:SetQuickUsePosData(
                targetPos,
                quickUseEntry,
                true
            )
            return true, string.format(
                "快捷栏移动: %d → %d",
                position,
                targetPos
            )
        end
    end

    -- PC89-PC103：快捷栏中未找到该Index，转查背包。
    local itemDataList =
        bagProxy:GetItemDataByItemIndex(itemIndex)

    -- PC94-PC103：不仅检查返回值truthy，还调用next确认表非空。
    if not itemDataList or not next(itemDataList) then
        return false, "物品不存在"
    end

    -- PC104-PC106：读取目标快捷栏位置原有条目。
    local targetEntry =
        quickUseProxy:GetQucikUseDataByPos(targetPos)

    if targetEntry then
        -- PC107-PC116：目标位置原有条目时，按原始顺序写入并退回背包。
        quickUseProxy:SetQuickUsePosData(
            targetPos,
            targetEntry,
            true
        )
        bagProxy:addItemData(targetEntry)
    end

    -- PC117-PC125：取返回表的第1项，按原始顺序删除并写入目标位置。
    -- 保留itemDataList[1]，不擅自改写为.Index或MakeIndex。
    local itemEntry = itemDataList[1]
    quickUseProxy:DelItemData(itemEntry)
    quickUseProxy:SetQuickUsePosData(
        targetPos,
        itemEntry,
        false
    )

    -- PC126-PC132：返回成功状态及背包移入快捷栏提示。
    return true, string.format(
        "已从背包移动到快捷栏位置%d",
        targetPos
    )
end

-- root PC259-PC260：该原型无捕获，根模块创建后立即导出全局函数。
_G.MoveItemToQuickUse = MoveItemToQuickUse



----------------------------------------------------------------
-- 检查点210：第一阶段根模块装配接口（可执行普通Lua骨架）
--
-- 用途：把已单独恢复的子原型接回根模块的真实导出位置。
-- prototypes中的函数必须是已完成父级捕获绑定的闭包实例；本接口不
-- 伪造VM upvalue，也不代替各子原型的函数体。
-- 未提供的项目保持原样，不以空函数冒充恢复结果。
--
-- 这是第一阶段装配骨架，不是完整原始模块；尚未完成的父级闭包创建、
-- 部分本地辅助函数和宿主运行时验证仍需后续补齐。
local function AttachRecoveredPrototypes(prototypes)
    assert(type(prototypes) == "table",
        "AttachRecoveredPrototypes expects a table of recovered closures")

    local function exportGlobal(globalName, prototypeName)
        local fn = prototypes[prototypeName]
        if fn ~= nil then
            _G[globalName] = fn
        end
    end

    -- root PC43-PC85：基础辅助函数和物品/仓库流程导出。
    exportGlobal("GetMapId", "GetMapId")
    exportGlobal("GetMapName", "GetMapName")
    exportGlobal("PlayerPos", "PlayerPos")
    exportGlobal("GetDroppedItems", "GetDroppedItems")
    exportGlobal("MoveTo", "MoveTo")
    exportGlobal("DiuItems", "DiuItems")
    exportGlobal("GetAvailableStoragePage", "GetAvailableStoragePage")
    exportGlobal("GetStorageItemData", "GetStorageItemData")
    exportGlobal("StorageItems", "StorageItems")
    exportGlobal("TakeItems", "TakeItems")
    exportGlobal("PickUpItems", "PickUpItems")

    if prototypes.LuaSendMsg ~= nil then
        MainLeftBottom.a.LuaSendMsg = prototypes.LuaSendMsg
    end

    -- root PC212-PC258：采集控制相关全局入口。
    exportGlobal("IsInWhitelistMap", "IsInWhitelistMap")
    exportGlobal("MainLoop", "MainLoop")
    exportGlobal("InitGatherMonsters", "InitGatherMonsters")
    exportGlobal("StopGatherMonsters", "StopGatherMonsters")
    exportGlobal("Builtsetting", "Builtsetting")

    -- root PC259-PC274：模块表上的界面控制闭包。
    if prototypes.DestroyUI ~= nil then
        MainLeftBottom.hide = prototypes.DestroyUI
    end
    if prototypes.SetButtonVisibilityState ~= nil then
        MainLeftBottom.show = prototypes.SetButtonVisibilityState
    end
    if prototypes.ShowHideAllButtons ~= nil then
        MainLeftBottom.destroy = prototypes.ShowHideAllButtons
    end
    exportGlobal("MoveItemToQuickUse", "MoveItemToQuickUse")

    -- root PC275-PC279：账号验证入口。
    if prototypes.AccountIDValidation ~= nil then
        MainLeftBottom.main = prototypes.AccountIDValidation
    end

    -- root PC350-PC388：伤害回调与黑名单功能入口。
    if prototypes.onDamageMsg ~= nil then
        MainLeftBottom.onDamageMsg = prototypes.onDamageMsg
    end
    exportGlobal("BlacklistItems", "BlacklistPlayerDetection")
    exportGlobal("ClearBlacklistItems", "ClearBlacklistItems")

    -- root PC389-PC411：主界面初始化入口。
    if prototypes.doInit_UI ~= nil then
        MainLeftBottom.doInit = prototypes.doInit_UI
    end

    return MainLeftBottom
end

-- 第一阶段接入约定：
-- 1. prototypes的键使用本文件中列出的重建名称。
-- 2. 带父级upvalue的子原型必须由调用方先按反汇编捕获顺序绑定。
-- 3. 不存在或未恢复的键不会被覆盖，也不会自动填入空函数。
-- 4. 本接口只解决“已恢复闭包接回根模块”的装配问题；根模块PC1-PC412
--    的完整逐语句源码重建仍未完成。

  local __exports = {}
  if MoveItemToQuickUse ~= nil then __exports["MoveItemToQuickUse"] = MoveItemToQuickUse end
  if AttachRecoveredPrototypes ~= nil then __exports["AttachRecoveredPrototypes"] = AttachRecoveredPrototypes end
  if MainLeftBottom ~= nil then __exports["MainLeftBottom"] = MainLeftBottom end
  MainLeftBottomRecovered.sources["04_源码候选/root_MainLeftBottom_Module.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root45_MainLoop.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- MainLeftBottom(2).lua VM recovery candidate
-- Prototype: root.children[45] (legacy root/46)
-- 417 physical VM instructions; 41 constants; no child prototypes.
--
-- STATUS: first-pass ordinary Lua draft. This is NOT original author source,
-- NOT a complete CFG proof, and NOT runtime validated.
-- Confirmed parent-capture mapping (zero-based UPVALUE slots):
--   UPVALUE_0  = running flag (root T[18], InitGatherMonsters sets true,
--                StopGatherMonsters sets false)
--   UPVALUE_1  = current state cell (root T[14], initially stateConstants.IDLE)
--   UPVALUE_2  = state constants table (root T[13]: IDLE/GATHERING/ATTACKING)
--   UPVALUE_3  = PrintLog (root.children[16], root T[4])
--   UPVALUE_4  = FormatStateChange (root.children[8], root T[23])
--   UPVALUE_5  = ResetGatherMonsterData (root.children[26], root T[35])
--   UPVALUE_6  = GetMainPlayerID (root.children[39], root T[26])
--   UPVALUE_7  = FindMonsterCandidates (root.children[28], root T[34])
--   UPVALUE_8  = mutable target-ID array (root T[15], initially {})
--   UPVALUE_9  = GetOwnerID (root.children[38], root T[32])
--   UPVALUE_10 = current target-list cursor (root T[17], initially 0)
--   UPVALUE_11 = self-owned target counter (root T[16], initially 0)
--   UPVALUE_12 = pending owner-change flag (root T[19], initially false)
--   UPVALUE_13 = owner-change deadline (root T[20], initially 0)
--   UPVALUE_14 = pending monster name (root T[22], initially "")
--   UPVALUE_15 = FindMonsterInCurrViewField (root.children[14], root T[36])
--   UPVALUE_16 = pending target ID (root T[21], initially nil)
--   UPVALUE_17 = GetOwnerIDText (root.children[7], root T[31])
--   UPVALUE_18 = IsDie/alive wrapper (root.children[29], root T[30])
--   UPVALUE_19 = GetOwnerDescription (root.children[43], root T[33])
--   UPVALUE_20 = SetTargetID (root.children[35], root T[24])
--   UPVALUE_21 = configuration table (root T[8]: GATHER_THRESHOLD,
--                CHECK_INTERVAL, ATTACK_WAIT_TIME)
--
-- The 22 captured parent T-registers are ordered:
--   18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8.
-- The identities above are grounded in root closure descriptors, helper creation
-- sites, function-state records, and the root/19 + root/27 state-helper captures.

local function make_MainLoop(UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4, UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9, UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14, UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19, UPVALUE_20, UPVALUE_21)
    local function MainLoop()
    if not UPVALUE_0 then
        return
    end

    -- White-list map: leave the gather state machine and reset its data.
    if IsInWhitelistMap() then
        if UPVALUE_1 ~= UPVALUE_2.IDLE then
            UPVALUE_3("在白名单地图, 停止引怪")
            UPVALUE_4(UPVALUE_2.IDLE)
            UPVALUE_5()
        end
        return
    end

    --------------------------------------------------------------------------
    -- IDLE: collect candidate monster IDs.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.IDLE then
        UPVALUE_3("扫描怪物中")

        local candidates = UPVALUE_7()
        if #candidates == 0 then
            UPVALUE_3("视野内没有可攻击怪物")
            return
        end

        UPVALUE_8 = {}
        local mainPlayerID = UPVALUE_6()

        for _, actor in ipairs(candidates) do
            -- Preserve the captured GetOwnerID predicate and its truth value.
            if not UPVALUE_9(actor, mainPlayerID) then
                table.insert(UPVALUE_8, actor:GetID())
            end
        end

        if #UPVALUE_8 == 0 then
            UPVALUE_3("没有可攻击的怪物")
            return
        end

        UPVALUE_10 = 1
        UPVALUE_11 = 0
        UPVALUE_3(string.format("开始引怪，目标数量: %d", #UPVALUE_8))
        UPVALUE_4(UPVALUE_2.GATHERING)
        return
    end

    --------------------------------------------------------------------------
    -- GATHERING: resume a pending owner wait, then scan the target list.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.GATHERING then
        UPVALUE_3("引怪中")

        if UPVALUE_12 then
            local now = os.time()

            if now < UPVALUE_13 then
                UPVALUE_3(string.format(
                    "等待归属变更中: %s (还剩 %d 秒)",
                    UPVALUE_14,
                    UPVALUE_13 - now
                ))
                return
            end

            -- Confirmed helper: FindMonsterInCurrViewField has no formal
            -- parameters and returns an ID-keyed actor map. This call site passes
            -- UPVALUE_12 as an extra argument; the helper does not read it.
            -- The VM call site supplies two register slots here; their values are not
            -- semantically consumed by the zero-parameter helper. Keep the
            -- recovered helper invocation itself argument-free in this draft.
            local actorMap = UPVALUE_15()
            local actor = actorMap and actorMap[UPVALUE_16]
            local mainPlayerID = UPVALUE_6()

            if actor and UPVALUE_17(actor, mainPlayerID) then
                UPVALUE_3(string.format(
                    "怪物 %s 归属已变更为自己",
                    UPVALUE_14
                ))
            else
                UPVALUE_3(string.format(
                    "怪物 %s 归属未变更或已离开视野",
                    UPVALUE_14
                ))
            end

            UPVALUE_12 = false
            UPVALUE_13 = 0
            UPVALUE_16 = 0
            UPVALUE_14 = ""
            UPVALUE_10 = UPVALUE_10 + 1
        end

        -- PC159-PC160 passes UPVALUE_12 as one extra argument. The helper has
        -- no formal parameters and ignores it, but retain the call-site value.
        local actorMap = UPVALUE_15(UPVALUE_12)
        local mainPlayerID = UPVALUE_6()
        local allOwnersResolved = true -- PC161; PC263 clears this on an unowned target.

        for index = UPVALUE_10, #UPVALUE_8 do
            local targetID = UPVALUE_8[index]
            local actor = actorMap and actorMap[targetID]

            if not actor then
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 不在视野内，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10 = index + 1

            elseif not UPVALUE_18(actor) then
                -- This wrapper is truthy for a living actor in this call path.
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 已死亡，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10 = index + 1

            else
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                local ownerID, ownerDescription =
                    UPVALUE_19(actor, mainPlayerID)

                if UPVALUE_9(actor, mainPlayerID) then
                    UPVALUE_3(string.format(
                        "怪物 %d (%s, ID: %s) 归属属于其他玩家(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    UPVALUE_10 = index + 1

                elseif UPVALUE_17(actor, mainPlayerID) then
                    UPVALUE_3(string.format(
                        "怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    UPVALUE_11 = UPVALUE_11 + 1
                    UPVALUE_10 = index + 1

                else
                    allOwnersResolved = false

                    -- PC264 stores the current index before attempting to lock;
                    -- PC310-PC311 advance it after either the success or failure path.
                    UPVALUE_10 = index
                    UPVALUE_3(string.format(
                        "锁定怪物 %d: %s (ID: %s, 归属: %s)",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerDescription)
                    ))

                    -- Confirmed helper: SetTargetID(targetID). It returns false
                    -- when Facade/PlayerInputProxy is unavailable; on success it
                    -- calls proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND).
                    local accepted = UPVALUE_20(targetID)

                    if accepted then
                        UPVALUE_12 = true
                        UPVALUE_13 = os.time()
                            + UPVALUE_21.ATTACK_WAIT_TIME
                        UPVALUE_16 = targetID
                        UPVALUE_14 = monsterName

                        UPVALUE_3(string.format(
                            "开始等待 %s 归属变更 (等待 %d 秒)",
                            monsterName,
                            UPVALUE_21.ATTACK_WAIT_TIME
                        ))
                    else
                        UPVALUE_3(string.format(
                            "锁定怪物 %s 失败",
                            monsterName
                        ))
                    end

                    -- Both SetTargetID outcomes advance the cursor and let the
                    -- numeric for-loop continue; neither branch returns here.
                    UPVALUE_10 = index + 1
                end
            end
        end

        -- PC166 prepares the numeric loop counter (UPVALUE_10 - 1); PC313
        -- increments/tests it and repeats at PC167. The loop therefore visits
        -- UPVALUE_10..#UPVALUE_8. The R2 flag starts true at PC161 and is cleared
        -- at PC263 when an unowned target is encountered.
        if allOwnersResolved then
            if UPVALUE_10 > #UPVALUE_8 then
                UPVALUE_3("所有怪物归属已获取，切换到攻击状态")
                UPVALUE_10 = 1
                UPVALUE_4(UPVALUE_2.ATTACKING)
                return
            end
        elseif UPVALUE_10 > #UPVALUE_8 then
            UPVALUE_3("怪物列表处理完毕但未全部获取归属，重新扫描")
            UPVALUE_4(UPVALUE_2.IDLE)
            UPVALUE_5()
            return
        end

        return
    end

    --------------------------------------------------------------------------
    -- ATTACKING: locate the next surviving actor by its stored target ID.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.ATTACKING then
        UPVALUE_3("攻击中")

        local actorMap = UPVALUE_15()
        -- PC354 initializes the no-living-target flag; PC359/405 form the
        -- numeric for-loop over UPVALUE_10..#UPVALUE_8.

        for index = UPVALUE_10, #UPVALUE_8 do
            local targetID = UPVALUE_8[index]
            local actor = actorMap and actorMap[targetID]

            if actor and UPVALUE_18(actor) then
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                UPVALUE_3(string.format(
                    "攻击怪物 %d: %s (ID: %s)",
                    index,
                    monsterName,
                    tostring(targetID)
                ))

                -- Confirmed SetTargetID(targetID); this branch ignores its
                -- boolean result and returns immediately after the call.
                UPVALUE_20(targetID)
                return
            end

            UPVALUE_3(string.format(
                "怪物 %d (ID: %s) 已死亡或离开视野",
                index,
                tostring(targetID)
            ))
            UPVALUE_10 = index + 1
        end

        UPVALUE_3("所有目标怪物已死亡或离开视野，切换到空闲状态")
        UPVALUE_4(UPVALUE_2.IDLE)
        UPVALUE_5()
        return
    end
end

    return MainLoop
end
  local __exports = {}
  if make_MainLoop ~= nil then __exports["make_MainLoop"] = make_MainLoop end
  MainLeftBottomRecovered.sources["04_源码候选/root45_MainLoop.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root46_DiuItems.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[46] / legacy root/47
-- Reconstruction name: DiuItems
-- 169 physical VM instructions; one nested keyword-matcher prototype.
-- Status: complete static reconstruction after independent review (checkpoint 89).
-- Not original source text; not runtime-validated. Names such as state/candidates are
-- readable reconstruction names, not recovered original local-variable identifiers.

local function make_DiuItems(state, ShowLocalNoticeByType)
    -- Factory parameters model the two captured upvalues, not original Lua arguments.
    -- state is UP[0] (module state table); ShowLocalNoticeByType is UP[1].
    return function DiuItems()
    local MAX_GROUND_ITEMS = 35

    -- PC 2-8: re-entry guard. A caller that did not acquire the flag must not clear it.
    if state.isDiuing then
        return
    end
    state.isDiuing = true

    -- PC 9-13: GetDroppedItems returns (items, count); only the second result is used.
    local _, groundItemCount = GetDroppedItems()
    groundItemCount = groundItemCount or 0

    -- PC 14-26: reject an already-overfull ground-item field.
    if MAX_GROUND_ITEMS < groundItemCount then
        ShowLocalNoticeByType(
            "地面物品(" .. groundItemCount .. ")超过上限(" .. MAX_GROUND_ITEMS .. ")"
        )
        state.isDiuing = false
        return
    end

    -- PC 27-35: obtain the current bag data.
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        state.isDiuing = false
        return
    end

    -- PC 36-68: the VM also constructs a keyword table and its nested matcher closure.
    -- However, the only matcher call is in PC 91-95, which the constant-true
    -- branch at PC 89-90 skips on the observed path. The unused construction is
    -- therefore omitted from this readable draft rather than inventing an effect.

    -- PC 69-114: collect unbound, named, indexed bag items.
    local candidates = {}
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            if not SL:GetMetaValue("ITEM_IS_BIND", item) then
                -- PC 99-112:
                candidates[#candidates + 1] = {
                    makeIndex = item.MakeIndex,
                    count = item.OverLap or 1,
                    name = item.Name,
                }
            end
        end
    end

    -- PC 115-123: empty candidate list has its own notice/cleanup path.
    if #candidates == 0 then
        ShowLocalNoticeByType("背包无可丢弃物品")
        state.isDiuing = false
        return
    end

    -- PC 124-160: send one discard message per candidate until the ground cap.
    local sentCount = 0
    for _, candidate in ipairs(candidates) do
        if MAX_GROUND_ITEMS <= groundItemCount then
            -- PC 131-137: this text uses the fixed limit (35), not the live count.
            ShowLocalNoticeByType("地面物品已满" .. MAX_GROUND_ITEMS .. "件，停止丢弃")
            break
        end

        -- PC 138-142: per-item notice.
        ShowLocalNoticeByType("丢: " .. candidate.name)

        -- PC 143-156: LuaSendMsg packet arguments, in exact recovered order.
        LuaSendMsg(
            global.MsgType.MSG_CS_MAP_ITEM_DISCARD,
            candidate.makeIndex,
            candidate.count,
            0,
            0,
            candidate.name,
            string.len(candidate.name)
        )

        -- PC 157-158: count sends and advance the local ground-item count.
        sentCount = sentCount + 1
        groundItemCount = groundItemCount + 1
    end

    -- PC 161-169: report message-send count, clear the re-entry flag, return.
    ShowLocalNoticeByType("共丢弃 " .. sentCount .. " 件物品")
    state.isDiuing = false
    end
end

-- Static reconstruction notes:
-- * UP[0] is the module state table; UP[1] is ShowLocalNoticeByType.
-- * No pcall/xpcall/finally cleanup exists in this prototype. If an external
--   helper/API raises, isDiuing may remain true, matching the visible bytecode.
-- * The VM's pairs iterator checks the first return (key) for termination and
--   takes the second return as item. The ipairs iterator checks index for nil.
-- * Runtime behavior and exact external API side effects remain unverified.

  local __exports = {}
  if make_DiuItems ~= nil then __exports["make_DiuItems"] = make_DiuItems end
  MainLeftBottomRecovered.sources["04_源码候选/root46_DiuItems.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root47_BlacklistPlayerDetection.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[47] / legacy root/48
-- Reconstruction name: BlacklistPlayerDetection
-- 216 physical VM instructions; no child prototypes.
-- Status: complete static reconstruction (checkpoint 186); NOT runtime-validated.
-- Local names are reconstruction labels, not recovered original identifiers.
--
-- Captures (checkpoint 146):
--   UP[0]  module feature state (isBlacklisting)
--   UP[1]  root.children[52] onDamageMsg callback
--   UP[2]  blacklist-player state table
--   UP[3]  death -> auto-blacklist callback
--   UP[4]  blacklist actor lookup helper (returns match flag and display name)
--   UP[5]  root.children[22] helper (VM index label GetMapData2DPtr);
--          reachable PC1-PC37 computes a Chebyshev distance with maxDistance
--   UP[6]  2.0 second alert threshold
--   UP[7]  PrintLog wrapper
--   UP[8]  random-teleport item lookup/use helper
--   UP[9]  0.01 second retry delay after successful teleport
--   UP[10] local notice wrapper
--   UP[11] 30.0 second retry delay when no usable teleport item exists
--   UP[12] { "随机传送石" }
--
-- Important: the VM dump's ["unknown",2] is a serialized nil sentinel, not
-- a literal string. This draft uses nil in the corresponding comparisons.
-- The complete 216-PC control flow and 13 parent captures were reconciled
-- at checkpoint 186. Local identifiers remain reconstruction labels, not
-- recovered author-original names. Do not treat this as runtime-validated.

local function make_BlacklistPlayerDetection(
    featureState,
    onDamageMsg,
    blacklistState,
    onDeathAutoBlacklist,
    findBlacklistActor,
    distanceCalculation,
    alertInterval,
    PrintLog,
    findAndUseRandomTeleport,
    successRetryDelay,
    ShowLocalNotice,
    noStoneRetryDelay,
    randomTeleportNames
)
    return function BlacklistPlayerDetection()
        featureState.isBlacklisting = true
        onDamageMsg()

        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        local hp = tonumber(SL:GetMetaValue("HP")) or 0.0
        local previousHP = blacklistState.lastHp

        if previousHP == nil then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = (hp <= 0)
        elseif hp > 0 then
            blacklistState.lastHp = hp
            blacklistState.deathHandled = false
        elseif previousHP > 0 and not blacklistState.deathHandled then
            blacklistState.deathHandled = true
            blacklistState.lastHp = 0.0
            onDeathAutoBlacklist()
        end

        if hp <= 0 then
            return
        end

        if IsInWhitelistMap() then
            return
        end

        -- The VM call captures two return values: player list and count.
        local players, playerCount = SL:GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
        if not players then
            return
        end
        if not playerCount then
            return
        end
        if playerCount <= 0 then
            return
        end

        -- PC74-PC77 initializes a numeric 1..playerCount loop.
        -- The action path is inside this loop, not after it.
        for index = 1, playerCount do
            local actorID = players[index]

            if actorID and actorID ~= mainActorID then
                local isBlacklisted, blacklistDisplayName = findBlacklistActor(actorID)

                if isBlacklisted then
                    local actorName = blacklistDisplayName
                    if not actorName then
                        actorName = SL:GetMetaValue("ACTOR_NAME", actorID)
                    end
                    if not actorName then
                        actorName = "黑名单玩家"
                    end

                    -- A false/nil configured distance bypasses coordinate
                    -- reads and the helper call; the later log formats it as 0.
                    local distance
                    local distanceAccepted = true
                    local configuredDistance = blacklistState.distance

                    if configuredDistance then
                        local mainX = SL:GetMetaValue("ACTOR_MAP_X", mainActorID)
                        local mainY = SL:GetMetaValue("ACTOR_MAP_Y", mainActorID)
                        local actorX = SL:GetMetaValue("ACTOR_MAP_X", actorID)
                        local actorY = SL:GetMetaValue("ACTOR_MAP_Y", actorID)

                        distance = distanceCalculation(
                            mainX, mainY, actorX, actorY, configuredDistance
                        )
                        distanceAccepted = (distance ~= nil)
                    end

                    -- PC136-PC141: nil from the helper skips this actor and
                    -- reaches the numeric-loop tail; a non-nil result enters
                    -- the alert/retry/teleport path below.
                    if distanceAccepted then
                        local now = os.time()
                        local lastAlertAt = blacklistState.alertAt or 0
                        local elapsed = now - lastAlertAt

                        if alertInterval <= elapsed then
                            blacklistState.alertAt = now
                            PrintLog(
                                "野外观测到黑名单玩家：%s（%d格）",
                                actorName,
                                distance or 0.0
                            )
                        end

                        -- PC160-PC163: a pending retry deadline exits the
                        -- entire callback, not merely this loop iteration.
                        if (blacklistState.nextTryAt or 0) > now then
                            return
                        end

                        local usedTeleportItemName = findAndUseRandomTeleport()
                        if usedTeleportItemName then
                            blacklistState.nextTryAt = now + successRetryDelay
                            blacklistState.noStoneWarned = false

                            ShowLocalNotice(string.format(
                                "黑名单玩家：%s（%d格），飞随机",
                                actorName,
                                distance or 0.0
                            ))

                            PrintLog(
                                "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                                actorName,
                                distance or 0.0,
                                usedTeleportItemName
                            )
                        else
                            blacklistState.nextTryAt = now + noStoneRetryDelay

                            if not blacklistState.noStoneWarned then
                                blacklistState.noStoneWarned = true
                                ShowLocalNotice("没有随机传送石，黑名单玩家传送暂停")
                                PrintLog(
                                    "没有可用的随机传送道具（%s）",
                                    table.concat(randomTeleportNames, "/")
                                )
                            end
                        end

                        -- Success and failure paths both leave via PC216.
                        return
                    end
                end
            end
        end
    end
end


-- Review notes (checkpoint 186):
-- * PC63-PC73 captures both returns from FIND_IN_VIEW_PLAYER_LIST: the player list and its explicit count; PC74-PC77 loops from 1 through that returned count.
-- * Nil actors and actorID == mainActorID are skipped.
-- * UP[4](actorID) supplies (isBlacklisted, displayName); only the first
--   return controls entry. displayName falls back to ACTOR_NAME, then the
--   literal 黑名单玩家.
-- * If blacklistState.distance is truthy, four map coordinates are read and
--   UP[5] is called with mainX, mainY, actorX, actorY, configuredDistance.
--   A nil result skips this actor and loops; a false/nil configured distance
--   bypasses coordinate reads/helper and the displayed distance defaults to 0.
-- * The alert/retry/teleport logic is inside the numeric loop. The first
--   blacklisted actor that passes the configured-distance gate is processed.
--   A pending nextTryAt exits the callback. Both teleport success and failure
--   also exit the callback; they do not continue scanning later actors.
-- * Only actors rejected by the distance helper continue to the next loop
--   iteration. There is no post-loop aggregation/currentTarget cache.
-- * UP[5] points to root.children[22], whose reachable PC1-PC37 path computes
--   Chebyshev distance and applies maxDistance; its PC38-PC144 tail is dead.
-- * All 216 physical PCs and the 13 parent captures have been reconciled.
-- * This is complete static reconstruction, not runtime-validated; host
--   contracts and full-project integration remain untested.

  local __exports = {}
  if make_BlacklistPlayerDetection ~= nil then __exports["make_BlacklistPlayerDetection"] = make_BlacklistPlayerDetection end
  MainLeftBottomRecovered.sources["04_源码候选/root47_BlacklistPlayerDetection.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root25_DeathAutoBlacklist.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[25] / legacy root/26 / DeathAutoBlacklist
-- 47 physical instructions; complete static reconstruction, not runtime-validated.
-- Captures, in order:
--   UP[0] = blacklistState (root T[41])
--   UP[1] = PrintLog (root T[4])
--   UP[2] = FindBlacklistPlayer (root T[55])
--   UP[3] = ShowLocalNoticeByType (root T[5])

local function make_DeathAutoBlacklist(
    blacklistState,
    printLog,
    findBlacklistPlayer,
    showLocalNotice
)
    return function()
        -- PC 1-4: take the current record, then clear the shared field immediately.
        local lastAttacker = blacklistState.lastAttacker
        blacklistState.lastAttacker = nil

        -- PC 5-16: missing record/name produces one log message and returns.
        if not lastAttacker or not lastAttacker.name or lastAttacker.name == "" then
            printLog("本次死亡没记录到凶手，跳过自动拉黑")
            return
        end

        -- PC 17-26: an existing blacklist entry is logged and stops this path.
        if findBlacklistPlayer(lastAttacker.id) then
            printLog("凶手已在黑名单中：%s", lastAttacker.name)
            return
        end

        -- PC 27-35: log the attacker and show the local notice.
        printLog("被 %s 击杀，自动加入黑名单", lastAttacker.name)
        showLocalNotice("自动拉黑：" .. lastAttacker.name)

        -- PC 36-47: schedule six attempts, at 0.5-second intervals from 0 to 2.5.
        for retryIndex = 0, 5 do
            SL:ScheduleOnce(function()
                SL:RequestAddBlacklistByName(lastAttacker.name)
            end, 0.5 * retryIndex)
        end
    end
end

-- Static reconstruction notes:
-- * lastAttacker is copied to a local before the shared state field is cleared.
-- * FindBlacklistPlayer receives lastAttacker.id; only its first return value
--   controls the already-blacklisted branch.
-- * Each scheduled child closure captures the lastAttacker record table and
--   reads its .name when the callback runs.
-- * The function does not return the ScheduleOnce handles or wait for attempts.
-- * No target-runtime validation.

  local __exports = {}
  if make_DeathAutoBlacklist ~= nil then __exports["make_DeathAutoBlacklist"] = make_DeathAutoBlacklist end
  MainLeftBottomRecovered.sources["04_源码候选/root25_DeathAutoBlacklist.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root52_onDamageMsg.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[52] / legacy root/53 / onDamageMsg
-- 72 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = blacklistState (root T[41]); the same table is exposed as MainLeftBottom.blacklist.

local function make_onDamageMsg(blacklistState)
    return function(messageJson, ...)
        -- PC 1-5: reject a false/nil or empty first argument.
        if not messageJson or messageJson == "" then
            return
        end

        -- PC 6-16: decode the JSON under pcall; require a table result.
        local function decodeMessage()
            return SL:JsonDecode(messageJson)
        end

        local decodeOk, message = pcall(decodeMessage)
        if not decodeOk or type(message) ~= "table" then
            return
        end

        -- PC 18-27: require a truthy main actor ID and ignore messages from self.
        local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
        if not mainActorID then
            return
        end

        if message.UserID == mainActorID then
            return
        end

        -- PC 28-33: require an attacker ID different from the main actor ID.
        local attackerID = message.AttackUserID
        if not attackerID or attackerID == mainActorID then
            return
        end

        -- PC 34-47: for hero actors, prefer a truthy master actor ID.
        local isHero = SL:GetMetaValue("ACTOR_IS_HERO", attackerID)
        if isHero then
            local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", attackerID)
            if masterActorID then
                attackerID = masterActorID
            end
        end

        -- PC 48-56: obtain a non-false, non-empty actor name.
        local attackerName = SL:GetMetaValue("ACTOR_NAME", attackerID)
        if not attackerName or attackerName == "" then
            return
        end

        -- PC 57-66: reject names containing the literal substring "分身".
        if string.find(attackerName, "分身", 1, true) then
            return
        end

        -- PC 67-72: record the effective attacker identity.
        blacklistState.lastAttacker = {
            id = attackerID,
            name = attackerName
        }
    end
end

-- Static reconstruction boundaries:
-- * The callback reads only the first explicit argument (messageJson); the
--   second argument and any extra varargs are not read.
-- * Nested_JsonDecode captures the first argument in parent T[1], calls
--   SL:JsonDecode(messageJson), and returns the decoder's values to pcall.
-- * The callback stores only blacklistState.lastAttacker; it does not itself
--   request blacklist insertion or schedule any action.
-- * No runtime validation; SL metadata and JSON decoder behavior are host-dependent.

  local __exports = {}
  if make_onDamageMsg ~= nil then __exports["make_onDamageMsg"] = make_onDamageMsg end
  MainLeftBottomRecovered.sources["04_源码候选/root52_onDamageMsg.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root28_FindMonsterCandidates.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[28] / legacy root/29
-- Reconstruction name: FindMonsterCandidates
-- 102 physical VM instructions; one nested distance comparator.
-- Static reconstruction only; runtime validation has not been performed.

local function make_FindMonsterCandidates(GetPlayerPosition, IsDie, GetPlayerMapPosition, DistanceCalculation, config)
    return function FindMonsterCandidates()
    local monsters = SL.FindMonsterInCurrViewField()
    if not monsters or #monsters == 0 then
        return {}
    end

    local ignoreSetting = GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)
    local ignoredNames = {}

    if ignoreSetting and type(ignoreSetting[1]) == "table" then
        for name, enabled in pairs(ignoreSetting[1]) do
            if enabled == true then
                ignoredNames[name] = true
            end
        end
    end

    local playerPosition = GetPlayerPosition()
    local candidates = {}

    for _, actor in ipairs(monsters) do
        if IsDie(actor) then
            local name = actor:GetName() or "未知怪物"

            if not ignoredNames[name] then
                local actorPosition = GetPlayerMapPosition(actor)
                actor._distance = DistanceCalculation(playerPosition, actorPosition)
                table.insert(candidates, actor)
            end
        end
    end

    table.sort(candidates, function(a, b)
        return a._distance < b._distance
    end)

    local result = {}
    local gatherThreshold = config.GATHER_THRESHOLD

    for index, actor in ipairs(candidates) do
        if index > gatherThreshold then
            break
        end
        table.insert(result, actor)
    end

    return result
    end
end

  local __exports = {}
  if make_FindMonsterCandidates ~= nil then __exports["make_FindMonsterCandidates"] = make_FindMonsterCandidates end
  MainLeftBottomRecovered.sources["04_源码候选/root28_FindMonsterCandidates.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第六十三批.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
普通Lua主体草稿（检查点187/199/200/201/203/204/208；复审PC1-PC419；修正PC180/183均只传T[7]一个实参，RequestStorageData和Attach_UITop同参；未运行时验证。T[7]由PC133的ipairs(T[6])第三返回值产生，宿主值未验证；Nested_Anonymous的T槽及unknown哨兵仍待核验。
本文件已内嵌Nested_find、Nested_Anonymous及Nested_FFFF00资源统计相关闭包工厂；其余子原型继续复用独立候选。
]]
-- root.children[42].children[0] / Nested_find：46条，无捕获。
-- 从BAG_DATA按pairs遍历，纯文本匹配名称，排除绑定物品，累计OverLap or 1。
local function Nested_find(searchText)
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then return 0 end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex
            and string.find(item.Name, searchText, 1, true)
            and not SL:GetMetaValue("ITEM_IS_BIND", item) then
            totalCount = totalCount + (item.OverLap or 1)
        end
    end
    return totalCount
end


-- ---------------------------------------------------------------------------
-- doInit_UI 子闭包工厂：将父帧捕获槽显式转换为普通 Lua 闭包参数。
-- 以下函数体复用已完成静态恢复的子原型；UPVALUE 名称仅描述行为。
-- ---------------------------------------------------------------------------

local function make_Nested_Helper(checkCallback, checkArgument, notify, printLog)
    return function Nested_Helper()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空怪物阈值")
            printLog("已清空怪物阈值存档：%s", detail)
        else
            notify("清空怪物阈值失败")
            printLog("清空怪物阈值失败：%s", detail)
        end
    end
end

local function make_Nested_s(checkCallback, checkArgument, notify, printLog)
    return function Nested_s()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空黑名单距离")
            printLog("已清空黑名单距离存档：%s", detail)
        else
            notify("清空黑名单距离失败")
            printLog("清空黑名单距离失败：%s", detail)
        end
    end
end

local function make_Nested_Helper_5(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveDistance, setButtonState
)
    return function Nested_Helper_5(value)
        if not validateValue(value) then
            notify("黑名单距离保存失败")
            formatCallback(
                "黑名单距离保存失败，路径：%s",
                resolveFailureContext(failureContext)
            )
            return
        end

        notify("黑名单距离已保存：" .. value .. " 格")
        formatCallback("黑名单距离已保存：%d 格", value)
        if not saveDistance(value) then return end
        setButtonState("blacklistbut", true)
    end
end

local function make_Nested_Helper_8(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveThreshold, setButtonState
)
    return function Nested_Helper_8(value)
        if not validateValue(value) then
            notify("怪物阈值保存失败")
            formatCallback(
                "怪物阈值保存失败，路径：%s",
                resolveFailureContext(failureContext)
            )
            return
        end

        notify("怪物阈值已保存：" .. value)
        formatCallback("怪物阈值已保存：%d", value)
        if not saveThreshold(value) then return end
        setButtonState("yinguaibut", true)
    end
end

local function make_Nested_Helper_4(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveDistance, setButtonState
)
    return function Nested_Helper_4()
        local callback = make_Nested_Helper_5(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveDistance, setButtonState
        )
        openDialog("请输入黑名单的距离格子（数字，按线路计算）", callback)
    end
end

local function make_Nested_Helper_7(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveThreshold, setButtonState
)
    return function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveThreshold, setButtonState
        )
        openDialog("请输入拉怪的怪物数量阈值（数字）", callback)
    end
end

-- ---------------------------------------------------------------------------
-- root.children[42].children[22] / Nested_Anonymous (第七十八批主体并入)
-- 8条父原型指令；child0 Nested_str 27条；其内含4条 Nested_Helper_11。
-- T[0]/T[1]/T[2]的具体来源仍未闭合，故明确保留占位，不作为可运行实现。
-- ---------------------------------------------------------------------------
local function make_Nested_Anonymous(PrintLog)
    return function Nested_Anonymous(...)
        -- Checkpoint 204: PC130 builds R4 from T[5]..T[8]; PC133 calls ipairs with T[6],
        -- then writes the third return value into T[7]. The runtime value of T[6]
        -- and therefore the concrete T[7] value remain unresolved; do not assign a semantic name. No later explicit T[7] write was found through PC183.
        -- Checkpoint 209 caller/capture trace:
        -- doInit_UI PC248 creates this closure (root/43/23), capturing UP[0]=PrintLog.
        -- doInit_UI PC250 creates root/43/12 (Nested_Helper_4) with this closure as UP[0].
        -- root/43/19 PC27 invokes Nested_Helper_4 with no arguments; the recovered
        -- Nested_Helper_4 body builds a prompt and Nested_Helper_5 success callback,
        -- then calls its openDialog capture with those two explicit values.
        -- Usage identifies T[0] as the dialog prompt (dialogParams.str) and T[1]
        -- as the success callback (called with numericValue).
        -- T[2] is separately captured and invoked by Nested_Helper_11 with the
        -- fixed format-error message, but no third explicit producer was found
        -- in the traced wrapper call. Keep T[2] unresolved; do not invent a callback.
        -- Exact VM frame-slot offset and T[2]'s runtime value remain unproven.
        local T0_SLOT_UNRESOLVED = nil
        local T1_SLOT_UNRESOLVED = nil
        local T2_SLOT_UNRESOLVED = nil

        -- Child root.children[42].children[22].children[0] capture order:
        -- UP[0] <- current T[0]
        -- UP[1] <- current UP[0] (PrintLog)
        -- UP[2] <- current T[2]
        -- UP[3] <- current T[1]
        local function Nested_str(...)
            local optionalSuffix = ...

            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = {
                    inputMode = 2,
                    maxLength = 6,
                },
            }

            local initialText = T0_SLOT_UNRESOLVED
            if optionalSuffix then
                initialText = initialText .. "\n" .. optionalSuffix
            end
            dialogParams.str = initialText

            local function Nested_match(status, result)
                if status ~= 1 then
                    return
                end

                local editStr = result and result.editStr or ""
                local normalized = tostring(editStr):gsub("%s", "")
                local isDigits = string.match(normalized, "^%d+$")
                local numericValue

                if isDigits then
                    numericValue = tonumber(normalized)
                end

                if numericValue then
                    T1_SLOT_UNRESOLVED(numericValue)
                    return
                end

                PrintLog(
                    "%s：参数格式不对（%s）",
                    initialText,
                    tostring(editStr)
                )

                local function Nested_Helper_11()
                    -- Existing child prototype; its sole capture is Nested_match UP[2].
                    T2_SLOT_UNRESOLVED("参数格式不对，请输入数字")
                end

                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- PC6-PC7 copy the just-created child closure and invoke it with zero args.
        -- Therefore Nested_str's optional vararg suffix is absent on this path.
        Nested_str()
        return
    end
end


-- ---------------------------------------------------------------------------
-- root.children[42].children[3] / Nested_FFFF00资源统计窗口及完整静态子依赖
-- 来源：第六十二批父函数、第六十四批刷新链、第六十五批资源行构造。
-- 各函数均为静态恢复草稿，GUI宿主语义及unknown哨兵仍需运行时确认。
-- ---------------------------------------------------------------------------

-- child0 Nested_Helper_2：35条，无捕获；资源数值缩写格式化。
local function Nested_Helper_2(value)
    if not value then
        return 0.0
    end

    if value < 100000.0 then
        return tostring(value)
    end

    if value < 100000000.0 then
        return tostring(math.floor(value / 10000.0)) .. "万"
    end

    local rounded = math.floor((value / 100000000.0) * 10.0) / 10.0
    return string.format("%.1f亿", rounded)
end

-- child1 Nested_string：46条，无捕获。
local function Nested_string(...)
    local searchName = ...
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then return 0 end

    local totalCount = 0
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            if string.find(item.Name, searchName, 1, true) then
                if not SL:GetMetaValue("ITEM_IS_BIND", item) then
                    totalCount = totalCount + (item.OverLap or 1)
                end
            end
        end
    end
    return totalCount
end

-- child4 Nested_UnSchedule：20条，捕获[printLog,timerState,moduleState]。
local function make_Nested_UnSchedule(printLog, timerState, moduleState)
    return function Nested_UnSchedule()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            -- VM dump中的['unknown',2]尚未确认等价nil；保留占位。
            timerState.resTimer = UNKNOWN_VALUE_SENTINEL
        end

        GUI:Win_Close(moduleState.resWin)
    end
end

-- child2 Nested_FFFFFF：65条，捕获[resList,screenW*0.6]。
local function make_Nested_FFFFFF(listView, cellWidth)
    return function Nested_FFFFFF(resourceNames, layoutOption, rowType)
        local rowTextByName = {}
        local gui = GUI
        local cellNameSuffix = math.ceil(15 / layoutOption)

        for groupStart = 1, #resourceNames, layoutOption do
            local cellName = rowType .. "_cell_" .. cellNameSuffix
            local cellLayout = gui:Layout_Create(
                listView, cellName, 0, 0, cellWidth, 35, 1
            )

            for columnIndex = 1, layoutOption do
                local resourceIndex = groupStart + columnIndex - 1
                local resourceName = resourceNames[resourceIndex]

                if resourceName then
                    local textName = "2_text_0.5_" .. columnIndex
                    local textX = cellWidth * (columnIndex - 0.5) / 1
                    local textNode = gui:Text_Create(
                        cellLayout, textName, textX, 15, 30,
                        "#FFFFFF", resourceName .. ":--"
                    )

                    if textNode then
                        gui:setAnchorPoint(textNode, 0.5, 0.5)
                        rowTextByName[resourceName] = textNode
                    end
                end
            end
        end

        return rowTextByName
    end
end

-- child3 Nested_Helper_3：168条，捕获10项。
local function make_Nested_Helper_3(
    moduleState, timerState, curTimeText, durTimeText, initState,
    moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
)
    return function Nested_Helper_3()
        local gui = GUI

        -- PC1-PC19：窗口无效时取消已有定时器、清空句柄并退出。
        if not gui:Win_IsNotNull(moduleState.resWin) then
            if timerState.resTimer then
                SL:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
            end
            return
        end

        -- PC20-PC38：取时失败会跳过时间显示，但仍继续刷新资源行。
        local now
        if os and os.time then
            local timeOK, timeValue = pcall(os.time)
            if timeOK and timeValue then now = timeValue end
        end

        if now then
            -- PC39-PC58：日期格式化失败时显示“--”。
            local dateText
            if os and os.date then
                local dateOK, value = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
                if dateOK then dateText = value end
            end
            gui:Text_setString(curTimeText, "当前时间:" .. (dateText or "--"))

            -- PC59-PC94：初始时间大于0时更新历时。
            local initTime = initState.initTime
            if initTime and initTime > 0 then
                local elapsed = now - initTime
                local hours = math.floor(elapsed / 3600)
                local minutes = math.floor((elapsed % 3600) / 60)
                gui:Text_setString(
                    durTimeText,
                    "历时:" .. formatNumber(hours) .. "小时"
                        .. formatNumber(minutes) .. "分钟"
                )
            end
        end

        -- 跨函数键值对照：doInit_UI PC85将初始货币数量写入initSnapshot[name]；
        -- 本回调PC106读取initSnapshot[moneyId]。两端键表达式确实不同。
        -- MoneyProxy:GetMoneyIdByName的宿主返回语义未在仓库实现中定义，
        -- 因此保留字节码两端各自的访问方式，不擅自改写为同一键。
        -- PC95-PC137：moneyRows以资源名称为键；快照以moneyId为键。
        for moneyName, textNode in pairs(moneyRows) do
            local moneyId = moneyProxy:GetMoneyIdByName(moneyName)
            if moneyId then
                local currentCount = moneyProxy:GetMoneyCountById(moneyId) or 0
                local initialCount = initState.initSnapshot[moneyId] or 0
                gui:Text_setString(
                    textNode,
                    formatNumber(currentCount) .. ":"
                        .. formatNumber(currentCount - initialCount)
                )
            end
        end

        -- PC138-PC167：itemRows以资源名称为键；快照以物品名称为键。
        for itemName, textNode in pairs(itemRows) do
            local currentCount = getItemCount(itemName)
            local initialCount = initState.initSnapshot[itemName] or 0
            gui:Text_setString(
                textNode,
                formatNumber(currentCount) .. ":"
                    .. formatNumber(currentCount - initialCount)
            )
        end
    end

-- 父原型Nested_FFFF00：320条，捕获[moduleState,printLog,timerState,initState]。检查点207逐PC复审PC1-PC320，修正五处Text_Create返回值门控。
local function make_Nested_FFFF00(moduleState, printLog, timerState, initState)
    return function Nested_FFFF00()
        local gui = GUI
        local sl = SL

        -- PC1-PC27：窗口已存在则关闭；resTimer取消后写入unknown哨兵而非nil。
        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = UNKNOWN_VALUE_SENTINEL
            end
            gui:Win_Close(moduleState.resWin)
            return
        end

        -- PC28-PC46：Win_Create显式保留nil参数槽及最后的999。
        local resWin = gui:Win_Create(
            "resWin",
            0, 0,
            moduleState.screenW, moduleState.screenH,
            false, true, true, true, true,
            nil, 999
        )
        moduleState.resWin = resWin

        -- PC47-PC72：根Layout和空白点击关闭回调。
        local rootLayout = gui:Layout_Create(
            resWin, "closeResWin", 0, 0,
            moduleState.screenW, moduleState.screenH, true
        )
        gui:setTouchEnabled(rootLayout, true)

        -- child4在父PC68-PC71捕获[printLog,timerState,moduleState]。
        local closeCallback =
            make_Nested_UnSchedule(printLog, timerState, moduleState)
        gui:addOnClickEvent(rootLayout, closeCallback)

        -- PC73-PC117：ListView几何、锚点及背景参数。
        local screenW = moduleState.screenW
        local screenH = moduleState.screenH
        local listWidth = screenW * 0.6
        local resList = gui:ListView_Create(
            resWin, "resList",
            (screenW - 1) / 2, screenH / 2,
            listWidth, screenH * 0.6, 1.0
        )
        gui:setAnchorPoint(resList, 0, 0.5)
        gui:ListView_setBackGroundColorType(resList, 1)
        gui:ListView_setBackGroundColor(resList, "#CEB5F7")
        gui:ListView_setBackGroundColorOpacity(resList, 255)

        -- PC118-PC264：标题、初始时间、当前时间、历时、备注五组区域。
        local titleCell = gui:Layout_Create(resList, "titleCell", 0, 0, 1, 30, 1)
        local titleText = gui:Text_Create(
            titleCell, "titleText", 0.5, 15, 20, "#FF0000", "资源统计"
        )
        if titleText then
            gui:setAnchorPoint(titleText, 0.5, 0.5)
        end

        local initTimeCell = gui:Layout_Create(resList, "initTimeCell", 0, 0, 1, 30, 1)
        local initTimeText = gui:Text_Create(
            initTimeCell, "initTimeText", 0.5, 15, 20, "#00FF00",
            "初始时间:" .. tostring(initState.initTimeStr or "--")
        )
        if initTimeText then
            gui:setAnchorPoint(initTimeText, 0.5, 0.5)
        end

        local curTimeCell = gui:Layout_Create(resList, "curTimeCell", 0, 0, 1, 30, 1)
        local curTimeText = gui:Text_Create(
            curTimeCell, "curTimeText", 0.5, 15, 20, "#00FF00", "当前时间:--"
        )
        if curTimeText then
            gui:setAnchorPoint(curTimeText, 0.5, 0.5)
        end

        local durTimeCell = gui:Layout_Create(resList, "durTimeCell", 0, 0, 1, 30, 1)
        local durTimeText = gui:Text_Create(
            durTimeCell, "durTimeText", 0.5, 15, 20, "#00FF00", "历时:--"
        )
        if durTimeText then
            gui:setAnchorPoint(durTimeText, 0.5, 0.5)
        end

        local noteCell = gui:Layout_Create(resList, "noteCell", 0, 0, 1, 30, 1)
        local noteText = gui:Text_Create(
            noteCell, "noteText", 0.5, 15, 20, "#FFFF00",
            "（括号内数量为非绑定资源的收益）"
        )
        if noteText then
            gui:setAnchorPoint(noteText, 0.5, 0.5)
        end

        -- PC265-PC267创建child2：捕获resList与listWidth。
        local updateResourceRows = make_Nested_FFFFFF(resList, listWidth)

        -- PC268-PC281：两组资源名称。
        local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
        local resourceNames = {
            "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
        }

        -- PC282-PC291：child2两次调用，实参为(names,2,"money"/"item")。
        local moneyRows = updateResourceRows(moneyNames, 2, "money")
        local itemRows = updateResourceRows(resourceNames, 2, "item")

        -- PC292：child1 Nested_string无捕获；PC293-PC299随后获取MoneyProxy。
        local getItemCount = Nested_string
        local moneyProxy = global.Facade:retrieveProxy(
            global.ProxyTable.MoneyProxy
        )

        -- PC300-PC310创建child3，10项捕获顺序按闭包描述显式传入。
        local formatNumber = Nested_Helper_2
        local refreshResourceStatistics = make_Nested_Helper_3(
            moduleState, timerState, curTimeText, durTimeText, initState,
            moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
        )

        -- PC311-PC312先立即刷新一次；PC313-PC319再安排1秒周期并保存句柄。
        refreshResourceStatistics()
        timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)

        -- PC320：无显式返回值。
        return
    end
end


local function make_Nested_StopGatherMonsters(
    timerState, notify, canStartGather, logNotice,
    openThresholdInput, applyGatherState
)
    return function Nested_StopGatherMonsters()
        if timerState.gatherTimer then
            notify("关闭引怪功能")
            StopGatherMonsters()
            return true
        end

        local ready = canStartGather()
        if not ready then
            logNotice("路径中没有怪物数量阈值，弹出输入框")
            openThresholdInput()
            return false
        end

        notify("开启引怪功能")
        applyGatherState(ready)
        return true
    end
end

local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    return function Nested_LuaSendMsg()
        counter = counter + 1
        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]
        if not entry then return end

        LuaSendMsg(9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3])
    end
end

local function make_Nested_SL_2(timerState, notify, modulus, messageEntries, scheduleContext)
    return function Nested_SL_2()
        if timerState.rewardTimer then
            notify("关闭奖励功能")
            SL:UnSchedule(timerState.rewardTimer)
            timerState.rewardTimer = nil
            return true
        end

        notify("开启奖励功能")
        local callback = make_Nested_LuaSendMsg(0, modulus, messageEntries)
        timerState.rewardTimer = SL:Schedule(0, callback, scheduleContext)
        return true
    end
end

local function make_Nested_ClearBlacklistItems(notify)
    return function Nested_ClearBlacklistItems()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
end

local function make_Nested_blacklistTimer(
    config, getDistance, timerState, schedule, formatNotice
)
    return function Nested_blacklistTimer(distance)
        if not distance then
            distance = getDistance()
        end
        config.distance = distance
        if not config.distance then return false end

        BlacklistItems()
        timerState.blacklistTimer = schedule(BlacklistItems, 0.1)
        formatNotice("开启黑名单功能，距离格子：%d", config.distance)
        return true
    end
end

local function make_Nested_Helper_10(
    timerState, notify, moduleState, readBlacklistDistance,
    openBlacklistDistanceInput, startBlacklistTimer
)
    return function Nested_Helper_10()
        if timerState.blacklistTimer then
            notify("关闭黑名单功能")
            SL:UnSchedule(timerState.blacklistTimer)
            timerState.blacklistTimer = nil
            moduleState.isBlacklisting = false
            return true
        end

        local distance = readBlacklistDistance()
        if distance > 0 then
            notify(string.format("开启黑名单功能，距离格子：%d", distance))
            startBlacklistTimer(distance)
            return true
        end

        notify("路径中没有黑名单的距离格子，弹出输入框")
        openBlacklistDistanceInput()
        return false
    end
end

local function make_Nested_SL_3(timerState, notify, featureState, schedule)
    return function Nested_SL_3()
        if timerState.storageTimer then
            notify("关闭存仓功能")
            SL:UnSchedule(timerState.storageTimer)
            timerState.storageTimer = nil
            featureState.isStoring = false
            return
        end
        notify("开启存仓功能")
        StorageItems()
        timerState.storageTimer = schedule(StorageItems, 1.0)
    end
end

local function make_Nested_TakeItems(timerState, notify, featureState, schedule)
    return function Nested_TakeItems()
        if timerState.takeTimer then
            notify("关闭取物功能")
            SL:UnSchedule(timerState.takeTimer)
            timerState.takeTimer = nil
            featureState.isTaking = false
            return
        end
        notify("开启取物功能")
        TakeItems()
        timerState.takeTimer = schedule(TakeItems, 1.0)
    end
end

local function make_Nested_shiquTimer(timerState, notify, schedule)
    return function Nested_shiquTimer()
        if timerState.shiquTimer then
            notify("关闭拾取物品")
            SL:UnSchedule(timerState.shiquTimer)
            timerState.shiquTimer = nil
            return
        end
        notify("开启拾取物品")
        timerState.shiquTimer = schedule(PickUpItems, 0.01)
    end
end

local function make_Nested_dropTimer(timerState, notify, featureState, schedule)
    return function Nested_dropTimer()
        if timerState.dropTimer then
            notify("关闭丢弃物品")
            SL:UnSchedule(timerState.dropTimer)
            timerState.dropTimer = nil
            featureState.isDiuing = false
            return
        end
        notify("开启丢弃物品")
        DiuItems()
        timerState.dropTimer = schedule(DiuItems, 1.0)
    end
end

local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

local function make_Nested_Helper_9(uiState, notify)
    return function Nested_Helper_9()
        if uiState.isHidden then
            notify("隐藏所有按钮")
            uiState.hide()
            GUI:setOpacity(uiState.hidebut, 0)
            return
        end
        notify("显示所有按钮")
        uiState.show()
        GUI:setOpacity(uiState.hidebut, 255)
    end
end

local function make_Nested_InitGatherMonsters(config, getThreshold)
    return function Nested_InitGatherMonsters(threshold)
        if not threshold then threshold = getThreshold() end
        config.GATHER_THRESHOLD = threshold
        if not config.GATHER_THRESHOLD then return false end
        InitGatherMonsters()
        return true
    end
end

local function make_Nested_04d_02d_02d(lastSentDate, messageSender, notify)
    return function Nested_04d_02d_02d()
        local dateParts = os.date("*t")
        if not dateParts then return end

        local secondsOfDay =
            dateParts.hour * 3600 + dateParts.min * 60 + dateParts.sec
        if secondsOfDay < 79205 or secondsOfDay > 79208 then
            return
        end

        local dateKey = string.format(
            "%04d%02d%02d",
            dateParts.year, dateParts.month, dateParts.day
        )
        if dateKey == lastSentDate then return end

        -- PC29先写日期标记，再发送协议；即使发送失败，同日也不重试。
        lastSentDate = dateKey
        messageSender.LuaSendMsg(9002, 55556, 1, 2, 3, "", 0)
        notify("到达 22:00:05，发送开启巡航协议")
    end
end

local function make_Nested_ffffff(buttonConfigs, buttonByKey)
    return function Nested_ffffff(key, toggled)
        local matchedConfig
        for _, config in ipairs(buttonConfigs) do
            if config.key == key then
                matchedConfig = config
                config.toggled = toggled
            end
        end

        local button = buttonByKey[key]
        if not button or not matchedConfig or not matchedConfig.toggle then
            return
        end

        local title = toggled and matchedConfig.toggle or matchedConfig.name
        GUI:Button_setTitleText(button, title)
        GUI:Button_setTitleColor(button, toggled and "#ff0000" or "#ffffff")
    end
end

local function make_doInit_UI(UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4, UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9, UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14, UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19)
    -- 装配适配层：按root闭包捕获顺序接收20个值，构造0基UP槽位表。
    -- 该表只是恢复代码的显式依赖容器，不是声称原作者使用了此表。
    local UP = { [0] = UPVALUE_0, [1] = UPVALUE_1, [2] = UPVALUE_2, [3] = UPVALUE_3, [4] = UPVALUE_4, [5] = UPVALUE_5, [6] = UPVALUE_6, [7] = UPVALUE_7, [8] = UPVALUE_8, [9] = UPVALUE_9, [10] = UPVALUE_10, [11] = UPVALUE_11, [12] = UPVALUE_12, [13] = UPVALUE_13, [14] = UPVALUE_14, [15] = UPVALUE_15, [16] = UPVALUE_16, [17] = UPVALUE_17, [18] = UPVALUE_18, [19] = UPVALUE_19 }
    return function doInit_UI()
    -- PC390在root创建本闭包时明确捕获20个父级T寄存器。
    -- UP[0..19]依次对应父root的T[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]。
    -- 可直接确认的身份：UP[0]=PrintLog函数；UP[1]与UP[3]均引用MainLeftBottom模块表；
    -- UP[2]是root PC42创建的独立状态表，本函数在其中读写cruiseTimer；
    -- UP[5]是root创建并挂到MainLeftBottom.blacklist的黑名单状态表；
    -- UP[8]是含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；
    -- UP[11]是root PC46创建的ShowLocalNoticeByType闭包；
    -- UP[13]/UP[15]分别是黑名单距离/拉怪数量配置文件路径；
    -- UP[17]=math.floor；UP[19]=0.2。其余槽位保持编号，不猜业务名称。
    local UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4 =
        UP[0], UP[1], UP[2], UP[3], UP[4]
    local UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9 =
        UP[5], UP[6], UP[7], UP[8], UP[9]
    local UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14 =
        UP[10], UP[11], UP[12], UP[13], UP[14]
    local UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19 =
        UP[15], UP[16], UP[17], UP[18], UP[19]

    -- PC1-PC3：初始化完成通知。
    UPVALUE_0("插件初始化完成")

    -- PC4-PC17：货币与资源名称常量。
    local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
    local resourceNames = {
        "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
    }

    -- PC19-PC58：时间状态初始化；os.time/os.date 均在 pcall 路径中调用。
    UPVALUE_1.initTime = 0
    UPVALUE_1.initTimeStr = "--"
    if os and os.time and os.date and pcall then
        local okTime, now = pcall(os.time)
        if okTime and now then
            UPVALUE_1.initTime = now
            local okDate, dateText = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
            if okDate and dateText then
                UPVALUE_1.initTimeStr = dateText
            end
        end
    end
    UPVALUE_1.initSnapshot = {}

    -- PC59-PC99：MoneyProxy及两组名称循环，建立资源数量初始快照。
    local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    if moneyProxy then
        for _, name in ipairs(moneyNames) do
            local id = moneyProxy:GetMoneyIdByName(name)
            if id then
                local count = moneyProxy:GetMoneyCountById(id)
                -- PC82-PC85：false和nil均进入0回退分支。
                if not count then count = 0 end
                UPVALUE_1.initSnapshot[name] = count
            end
        end
    end

    -- PC88-PC99是独立的第二个ipairs循环，不受MoneyProxy是否存在的门控。
    -- 第二组是背包资源，不走MoneyProxy：调用无捕获child0 Nested_find(name)，
    -- 并以资源名称作为initSnapshot键；BAG_DATA缺失时返回0。
    for _, name in ipairs(resourceNames) do
        UPVALUE_1.initSnapshot[name] = Nested_find(name)
    end

    -- PC100-PC101。
    Builtsetting()

    -- PC102-PC130：四组传送道具槽位配置。每组包含slot与names数组，
    -- 其数组成员由相邻寄存器表构造指令确定。
    local itemSlotConfig = {
        {slot=1, names={"永久回城石", "盟重回城石", "盟重传送石"}},
        {slot=2, names={"永久随机石", "随机传送石"}},
        {slot=3, names={"大陆传送石"}},
        {slot=4, names={"免战回城石"}},
    }

    -- PC131-PC145：逐组创建child16（Nested_ITEM_INDEX_BY_NAME）并调用SL:ScheduleOnce。
    -- child16捕获当前slotConfig及UP[0]（PrintLog）；它遍历slotConfig.names，
    -- 通过SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)查询索引。
    -- 若索引存在，则调用MoveItemToQuickUse(itemIndex, slotConfig.slot)，
    -- 将第二返回值交给PrintLog；若第一返回值成功则提前结束该组回调，
    -- 否则继续尝试该组的下一个名称。
    for slotIndex, slotConfig in ipairs(itemSlotConfig) do
        local callback = function()
            for _, name in ipairs(slotConfig.names) do
                local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)
                if itemIndex then
                    local succeeded, message =
                        MoveItemToQuickUse(itemIndex, slotConfig.slot)
                    PrintLog(message)
                    if succeeded then
                        return
                    end
                end
            end
        end
        SL:ScheduleOnce(callback, slotIndex * 0.1)
    end

    -- PC146-PC166：替换cruiseTimer并建立周期任务。
    if UPVALUE_2.cruiseTimer then
        SL:UnSchedule(UPVALUE_2.cruiseTimer)
        UPVALUE_2.cruiseTimer = {"unknown", 2}
    end
    -- PC145清空父帧T[5]；PC160-PC163随后以该cell创建child12。
    -- 检查点111已闭合：R5是同日发送标记，另捕获UP[3]发送对象、UP[0]通知回调。
    local lastSentDate = nil
    local dailyCallback = make_Nested_04d_02d_02d(
        lastSentDate, UPVALUE_3, UPVALUE_0
    )
    UPVALUE_2.cruiseTimer = SL:Schedule(dailyCallback, 1.0)

    -- PC181-PC195：GUI.Attach_UITop调用实参物理来源未闭合。
    -- 当前草稿把调用错误写成七个nil实参；检查点208依据OP_358/OP_068调用展开规则纠正：
    -- PC180 RequestStorageData与PC183 Attach_UITop均只传T[7]这一个显式实参。
    -- PC133是调用前最后一次写入T[7]的位置：ipairs(T[6])的第三返回值。
    -- T[6]的运行时值及ENV.ipairs宿主行为未验证，因此T[7]只保留中性占位。
    local T7_SLOT_UNRESOLVED = nil -- PC133: third return from ipairs(T[6]); runtime value unresolved
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData(T7_SLOT_UNRESOLVED)
    end

    local uiParent = GUI:Attach_UITop(T7_SLOT_UNRESOLVED)

    -- PC184-PC195：读取mini-chat位置/尺寸；xBase/yBase随后由T[22]/T[23]捕获。
    local mainProperty = MainProperty
    local miniChat = mainProperty._ui.Panel_mini_chat
    local miniChatPosition = miniChat:getWorldPosition()
    local miniChatSize = miniChat:getContentSize()
    local miniChatRight = miniChatPosition.x + miniChatSize.width
    local miniChatY = miniChatPosition.y

    -- PC196-PC235：实际按钮配置是三组数组，结构由VM的表构造/数组写入指令确定。
    local buttonGroups = {
        {
            {key="yinguaibut", name="开拉怪", toggle="关拉怪"},
            {key="blacklistbut", name="开黑名单", toggle="关黑名单"},
            {key="clearblacklistbut", name="清黑名单"},
            {key="moneybut", name="资源统计"},
        },
        {
            {key="shiqubut", name="开拾取", toggle="关拾取"},
            {key="diuqibut", name="开丢物品", toggle="关丢物品"},
            {key="xiaotuibut", name="快速小退"},
        },
        {
            {key="clearmonsterbut", name="清怪物值"},
            {key="cleardistancebut", name="清距离值"},
            {key="rewardbut", name="开奖励", toggle="关奖励"},
        },
    }

    -- PC236-PC337：按实际父帧捕获顺序建立子闭包工厂。
    local syncButtonState = make_Nested_ffffff(buttonGroups, UPVALUE_4)

    -- PC239-PC244：child17 Nested_blacklistTimer捕获[UP5,UP6,UP2,UP7,UP0]。
    local blacklistTimerCallback = make_Nested_blacklistTimer(
        UPVALUE_5, UPVALUE_6, UPVALUE_2, UPVALUE_7, UPVALUE_0
    )
    -- PC245-PC247：child7 Nested_InitGatherMonsters捕获[UP8,UP9]。
    local initGatherCallback = make_Nested_InitGatherMonsters(
        UPVALUE_8, UPVALUE_9
    )

    -- PC248：child22 Nested_Anonymous仅捕获UP0(PrintLog)；主体已并入上方工厂，T[0]/T[1]/T[2]仍待追踪。
    -- PC250-PC258：child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]。
    local nestedAnonymous = make_Nested_Anonymous(UPVALUE_0) -- child22主体已并入；三个T捕获槽仍是未解析占位
    local openBlacklistDistanceInput = make_Nested_Helper_4(
        nestedAnonymous, UPVALUE_10, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_13, blacklistTimerCallback, syncButtonState
    ) -- TODO: child11主体未合并
    -- PC259-PC267：child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]。
    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous, UPVALUE_14, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_15, initGatherCallback, syncButtonState
    ) -- TODO: child14主体未合并

    -- PC269-PC276：child6捕获[UP2,UP11,UP9,UP0,R20,R17]。
    local stopGatherCallback = make_Nested_StopGatherMonsters(
        UPVALUE_2, UPVALUE_11, UPVALUE_9, UPVALUE_0,
        openGatherThresholdInput, initGatherCallback
    )
    -- PC277-PC282：child2捕获[UP16,UP15,UP11,UP0]。
    local clearMonsterCallback = make_Nested_Helper(
        UPVALUE_16, UPVALUE_15, UPVALUE_11, UPVALUE_0
    )
    -- PC283-PC288：child20捕获[UP16,UP13,UP11,UP0]。
    local clearDistanceCallback = make_Nested_s(
        UPVALUE_16, UPVALUE_13, UPVALUE_11, UPVALUE_0
    )
    -- PC289-PC295：child1捕获[UP2,UP0,UP17,UP18,UP19]。
    local rewardCallback = make_Nested_SL_2(
        UPVALUE_2, UPVALUE_0, UPVALUE_17, UPVALUE_18, UPVALUE_19
    )
    -- PC296-PC298：child13捕获UP0。
    local clearBlacklistCallback = make_Nested_ClearBlacklistItems(UPVALUE_0)
    -- PC299-PC306：child18捕获[UP2,UP0,UP1,R19,R16]。
    local blacklistCallback = make_Nested_Helper_10(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_6,
        openBlacklistDistanceInput, blacklistTimerCallback
    )
    -- PC307-PC312：child8捕获[UP2,UP0,UP1,UP7]。
    local storageCallback = make_Nested_SL_3(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )
    -- PC313-PC318：child19捕获[UP2,UP0,UP1,UP7]。
    local takeCallback = make_Nested_TakeItems(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )
    -- PC319-PC323：child10捕获[UP2,UP0,UP7]。
    local pickupCallback = make_Nested_shiquTimer(
        UPVALUE_2, UPVALUE_0, UPVALUE_7
    )
    -- PC324-PC329：child21捕获[UP2,UP0,UP1,UP7]。
    local dropCallback = make_Nested_dropTimer(
        UPVALUE_2, UPVALUE_0, UPVALUE_1, UPVALUE_7
    )

    local buttonHandlers = {
        yinguaibut = stopGatherCallback,
        clearmonsterbut = clearMonsterCallback,
        cleardistancebut = clearDistanceCallback,
        rewardbut = rewardCallback,
        clearblacklistbut = clearBlacklistCallback,
        blacklistbut = blacklistCallback,
        storagebut = storageCallback,
        takebut = takeCallback,
        shiqubut = pickupCallback,
        diuqibut = dropCallback,
        moneybut = make_Nested_FFFF00(UPVALUE_3, UPVALUE_0, UPVALUE_2, UPVALUE_1), -- child3；父工厂及刷新/行构造依赖已并入本文件
        xiaotuibut = Nested_OnGameLeaveWorld,
    }
    -- PC338-PC345：创建child9工厂闭包，捕获顺序为：
    -- T[6]=Attach_UITop返回的uiParent，T[22]=xBase，T[23]=yBase，
    -- UP[4]=buttonMap，T[21]=buttonHandlers。其三个显式参数为config/列索引/行偏移。
    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1
    local buttonMap = UPVALUE_4

    local function createButton(config, columnIndex, rowOffset)
        local x = xBase - 85 * columnIndex
        local y = yBase + rowOffset

        -- child9 PC1-PC50：GUI:Button_Create(uiParent,key,x,y,texture)。
        local button = GUI:Button_Create(
            uiParent, config.key, x, y, "res/public/fuzhu_btn.png"
        )
        if not button then
            return
        end

        buttonMap[config.key] = button
        GUI:Button_setTitleText(button, config.name)
        GUI:Button_setTitleFontSize(button, 18.0)
        GUI:Button_setTitleFontName(button, "res/public/kaiti2.ttf")
        GUI:Button_setTitleColor(button, "#ffffff")

        -- toggle项由child9创建child0回调；child0按buttonHandlers[key]门控。
        if config.toggle then
            config.toggled = false
            GUI:addOnClickEvent(button, function()
                local gate = buttonHandlers[config.key]
                local allowed = true
                if gate then
                    allowed = gate()
                end
                if allowed == false then
                    return
                end
                config.toggled = not config.toggled
                GUI:Button_setTitleText(
                    button,
                    config.toggled and config.toggle or config.name
                )
                GUI:Button_setTitleColor(
                    button,
                    config.toggled and "#ff0000" or "#ffffff"
                )
            end)
        end
    end

    -- PC346-PC378：三组配置分别以40、0、80为行偏移，列索引从ipairs返回。
    for columnIndex, config in ipairs(buttonGroups[1]) do
        createButton(config, columnIndex, 40.0)
    end
    for columnIndex, config in ipairs(buttonGroups[2]) do
        createButton(config, columnIndex, 0.0)
    end
    for columnIndex, config in ipairs(buttonGroups[3]) do
        createButton(config, columnIndex, 80.0)
    end

    -- PC379-PC418：创建“隐 藏”按钮，设置标题、字号、字体并绑定点击闭包。
    local hideButton = GUI:Button_Create(
        uiParent, "hidebut", 0.0, 0.0, "res/public/fuzhu_btn.png"
    )
    if hideButton then
        GUI:Button_setTitleText(hideButton, "隐 藏")
        GUI:Button_setTitleFontSize(hideButton, 18.0)
        GUI:Button_setTitleFontName(hideButton, "res/public/kaiti2.ttf")
        -- child15捕获[UP3,UP0]：模块UI状态对象与通知回调。
        GUI:addOnClickEvent(hideButton, make_Nested_Helper_9(UPVALUE_3, UPVALUE_0))
    end
end
-- top-level return is represented by the source registry
-- ---------------------------------------------------------------------------
-- 检查点202：Attach_UITop调用实参复核（root.children[42] PC181-PC183）。
-- PC181-PC182先取GUI.Attach_UITop方法；PC183为OP_068 A=6 B=7，
-- 因而按VM调用约定传递当前帧T[7]..T[13]共七个显式实参。
-- 紧邻的PC178-PC180先取NPCStorageProxy.RequestStorageData，
-- PC180同样以OP_358 A=6 B=7调用，消费同一组T[7]..T[13]。
-- 这证明两个调用共享同一参数槽区间及顺序，但不能证明七槽业务名称、
-- 值类型或最初生产者；缺少明确写槽证据前不命名、不改写。
-- GUI.Attach_UITop的宿主实现/签名未随仓库迁移，七参数语义仍待外部证据。
-- ---------------------------------------------------------------------------


-- ---------------------------------------------------------------------------
-- 检查点203：调用参数展开规则纠正及Nested_Anonymous调用链。
-- U(T,A+1,B)按unpack(start,end)解释，B是结束下标，不是参数数量。
-- 因此PC180/PC183的A=6、B=7只展开T[7]一个实参；两次调用传递同一T[7]。
-- T[7]在本原型PC133的多返回值调用(OP_233 A=5 C=7)处被写入T[5]..T[7]；
-- 这是调用前最后一个静态可见的T[7]写入点。其具体运行时值仍未确认。
-- PC143的OP_339只写T[8]..T[9]，不改变T[7]。
--
-- Nested_Anonymous调用链：
-- doInit_UI PC250创建root/43/12，捕获R[18]（Nested_Anonymous）为UP[0]；
-- root/43/19 PC27以A=1、B=1调用该包装器，U(T,2,1)为空参数区间；
-- root/43/12 PC11随后以A=0、B=2调用UP[0]，转发其T[1]..T[2]。
-- 该链确认了调用端原型与转发位置，但不证明T[0]/T[1]/T[2]的值、
-- 类型或业务映射；保留占位，不升级完整静态恢复。
-- ---------------------------------------------------------------------------


-- Checkpoint 205: T[6] producer narrowed to doInit_UI PC90 OP_359.
-- PC90 calls the function in R4 with the single argument T[5] and stores returns in T[4..T[6]].
-- PC133 later reads T[6] as its sole argument to ipairs. No explicit T[6] write was found
-- between PC90 and PC133. Thus T[6] is PC90's third return value, not an arbitrary stale slot.
-- If ENV.ipairs has standard Lua semantics and the call completes, its third return is 0;
-- the concrete host/runtime value is not promoted to verified without confirming ENV.ipairs.

  local __exports = {}
  if Nested_find ~= nil then __exports["Nested_find"] = Nested_find end
  if make_Nested_Helper ~= nil then __exports["make_Nested_Helper"] = make_Nested_Helper end
  if make_Nested_s ~= nil then __exports["make_Nested_s"] = make_Nested_s end
  if make_Nested_Helper_5 ~= nil then __exports["make_Nested_Helper_5"] = make_Nested_Helper_5 end
  if make_Nested_Helper_8 ~= nil then __exports["make_Nested_Helper_8"] = make_Nested_Helper_8 end
  if make_Nested_Helper_4 ~= nil then __exports["make_Nested_Helper_4"] = make_Nested_Helper_4 end
  if make_Nested_Helper_7 ~= nil then __exports["make_Nested_Helper_7"] = make_Nested_Helper_7 end
  if make_Nested_Anonymous ~= nil then __exports["make_Nested_Anonymous"] = make_Nested_Anonymous end
  if Nested_Helper_2 ~= nil then __exports["Nested_Helper_2"] = Nested_Helper_2 end
  if Nested_string ~= nil then __exports["Nested_string"] = Nested_string end
  if make_Nested_UnSchedule ~= nil then __exports["make_Nested_UnSchedule"] = make_Nested_UnSchedule end
  if make_Nested_FFFFFF ~= nil then __exports["make_Nested_FFFFFF"] = make_Nested_FFFFFF end
  if make_Nested_Helper_3 ~= nil then __exports["make_Nested_Helper_3"] = make_Nested_Helper_3 end
  if make_Nested_FFFF00 ~= nil then __exports["make_Nested_FFFF00"] = make_Nested_FFFF00 end
  if make_Nested_StopGatherMonsters ~= nil then __exports["make_Nested_StopGatherMonsters"] = make_Nested_StopGatherMonsters end
  if make_Nested_LuaSendMsg ~= nil then __exports["make_Nested_LuaSendMsg"] = make_Nested_LuaSendMsg end
  if make_Nested_SL_2 ~= nil then __exports["make_Nested_SL_2"] = make_Nested_SL_2 end
  if make_Nested_ClearBlacklistItems ~= nil then __exports["make_Nested_ClearBlacklistItems"] = make_Nested_ClearBlacklistItems end
  if make_Nested_blacklistTimer ~= nil then __exports["make_Nested_blacklistTimer"] = make_Nested_blacklistTimer end
  if make_Nested_Helper_10 ~= nil then __exports["make_Nested_Helper_10"] = make_Nested_Helper_10 end
  if make_Nested_SL_3 ~= nil then __exports["make_Nested_SL_3"] = make_Nested_SL_3 end
  if make_Nested_TakeItems ~= nil then __exports["make_Nested_TakeItems"] = make_Nested_TakeItems end
  if make_Nested_shiquTimer ~= nil then __exports["make_Nested_shiquTimer"] = make_Nested_shiquTimer end
  if make_Nested_dropTimer ~= nil then __exports["make_Nested_dropTimer"] = make_Nested_dropTimer end
  if Nested_OnGameLeaveWorld ~= nil then __exports["Nested_OnGameLeaveWorld"] = Nested_OnGameLeaveWorld end
  if make_Nested_Helper_9 ~= nil then __exports["make_Nested_Helper_9"] = make_Nested_Helper_9 end
  if make_Nested_InitGatherMonsters ~= nil then __exports["make_Nested_InitGatherMonsters"] = make_Nested_InitGatherMonsters end
  if make_Nested_04d_02d_02d ~= nil then __exports["make_Nested_04d_02d_02d"] = make_Nested_04d_02d_02d end
  if make_Nested_ffffff ~= nil then __exports["make_Nested_ffffff"] = make_Nested_ffffff end
  if make_doInit_UI ~= nil then __exports["make_doInit_UI"] = make_doInit_UI end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第六十三批.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第六十批.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
--[[
第六十批修订 / 检查点 #189
函数：StorageItems
规范路径：root.children[50]；legacy root/51
物理指令：224；常量：57；子原型：2；vararg_flag=0

状态：普通Lua主体草稿已恢复；检查点206修正多特殊名称匹配时的失败短路语义；仍有父级捕获的作者级业务原名、LuaSendMsg服务端字段定义及宿主运行时行为待验证。

父函数三个捕获槽按实际读写角色表达：
  UP[0] -> storageState：共享状态表，含isStoring及Nested_isOutputted使用的isOutputted。
  UP[1] -> notify：前置检查失败/背包为空提示，同时作为Nested_isOutputted的输出回调。
  UP[2] -> output：物品使用、存仓过程、仓库满及完成提示回调。
这些是按调用用途命名，不声称恢复了作者原始变量名。

依赖的子闭包：
  child0 Nested_isOutputted：make_Nested_isOutputted(storageState, notify)
  child1 Nested_Anonymous_2：make_FindAvailableStoragePage(maxPage,pageCapacity,openSize,storedPageData)

本文件保留VM可见的循环、筛选、调用顺序和七项LuaSendMsg参数；不把999999999或服务端字段猜成未证实的协议含义。
]]

local function make_StorageItems(storageState, notify, output)
    return function StorageItems()
        -- PC1-PC7：互斥检查。正在存仓则直接返回，否则先置位。
        if storageState.isStoring then
            return
        end
        storageState.isStoring = true

        -- PC14-PC23：先调用全局页检查；失败使用UP[1]提示并复位状态。
        if not GetAvailableStoragePage() then
            notify("仓库已满,无法存仓")
            storageState.isStoring = false
            return
        end

        -- PC24-PC36：直接访问NPCStorageProxy，不存在性保护不在当前指令流中。
        local storageProxy = NPCStorageProxy
        local maxPage = storageProxy:GetMaxPage()

        local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
        if not pageCapacity then
            pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE
        end

        local openSize = storageProxy:GetOpenSize()

        -- PC37-PC53：逐页读取物品数组长度，缺页数据记0。
        local storedPageData = {}
        for page = 1, maxPage do
            local pageData = storageProxy:GetStorageDataByPage(page)
            if pageData then
                storedPageData[page] = #pageData
            else
                storedPageData[page] = 0
            end
        end

        -- PC54-PC58：child1捕获[maxPage,pageCapacity,openSize,storedPageData]。
        local findAvailablePage = make_FindAvailableStoragePage(
            maxPage, pageCapacity, openSize, storedPageData
        )

        -- PC61-PC80：18项特殊物品名称表。
        local specialNames = {
            "金刚石",
            "玄铁",
            "真金矿石",
            "BOSS头骨",
            "转生证明",
            "魔神石",
            "神装碎片",
            "涅槃石",
            "宝石精魄",
            "天神令",
            "神彩",
            "金罡",
            "至尊",
            "圣皇",
            "凤凰",
            "麻痹戒指",
            "复活戒指",
            "切割神戒",
        }

        -- PC81-PC83：单项过滤表。
        local filterNames = {"待定"}

        -- PC84-PC95：读取背包数据；缺失时notify并复位。
        local bagData = SL:GetMetaValue("BAG_DATA")
        if not bagData then
            notify("背包物品为空")
            storageState.isStoring = false
            return
        end

        -- PC100-PC104：本轮已处理MakeIndex集合；成功发出请求的数量。
        local processedMakeIndexes = {}
        local queuedCount = 0

        -- PC102-PC104：child0捕获[storageState,notify]。
        local isOutputted = make_Nested_isOutputted(storageState, notify)

        -- PC105-PC224：唯一一轮pairs遍历；不拆成两次遍历。
        for _, item in pairs(bagData) do
            local makeIndex = item.MakeIndex

            -- PC109-PC112：MakeIndex缺失或本轮已处理则跳过。
            if makeIndex and not processedMakeIndexes[makeIndex] then
                -- PC113-PC119：ITEM_IS_BIND以完整item对象查询；truthy绑定物品跳过。
                local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)
                if not isBound then
                    -- PC122-PC150：单项filterNames表；纯文本匹配后使用对应物品。
                    for _, filterName in ipairs(filterNames) do
                        if string.find(item.Name, filterName, 1, true) then
                            local itemIndex =
                                SL:GetMetaValue("ITEM_INDEX_BY_NAME", item.Name)
                            SL:UseItemByIndex(itemIndex)
                            output("使用: " .. item.Name)
                        end
                    end

                    -- PC151-PC176：遍历18项特殊名称。匹配时调用child0(item,specialName)。
                    -- 只有最终返回值truthy才继续存仓；false/nil路径跳过当前物品。
                    -- PC151-PC176：对18项特殊名称逐一做纯文本匹配。
                    -- VM在每次匹配后立即检查Nested_isOutputted的返回值：
                    -- 任一次返回false/nil都会直接跳到外层pairs循环的下一件物品，
                    -- 因而不能让后续另一个名称匹配覆盖失败结果。
                    local matchedSpecialName = false
                    local shouldStore = true
                    for _, specialName in ipairs(specialNames) do
                        if string.find(item.Name, specialName, 1, true) then
                            matchedSpecialName = true
                            if not isOutputted(item, specialName) then
                                shouldStore = false
                                break
                            end
                        end
                    end

                    -- 没有匹配任何特殊名称时不存仓；有匹配时必须每次门控均truthy。
                    if matchedSpecialName and shouldStore then
                        -- PC177-PC186：每件候选物品重新查找目标页；nil时输出并退出整个函数。
                        local targetPage = findAvailablePage()
                        if not targetPage then
                            output("仓库已满,无法存仓")
                            storageState.isStoring = false
                            return
                        end

                        -- PC187-PC205：先输出存仓提示，再发出七参数存仓请求。
                        output("存: " .. item.Name)
                        LuaSendMsg(
                            global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
                            999999999,
                            item.MakeIndex,
                            targetPage,
                            0,
                            item.Name,
                            string.len(item.Name)
                        )

                        -- PC206-PC211：发送调用返回后更新本轮去重集合、页占用数和请求计数。
                        processedMakeIndexes[makeIndex] = true
                        storedPageData[targetPage] = storedPageData[targetPage] + 1
                        queuedCount = queuedCount + 1
                    end
                end
            end
        end

        -- PC214-PC224：遍历结束复位状态；仅请求计数大于0时输出完成提示。
        storageState.isStoring = false
        if queuedCount > 0 then
            output(
                "存仓完成, 共存入 " .. tostring(queuedCount) .. " 件物品"
            )
        end
    end
end

-- top-level return is represented by the source registry
  local __exports = {}
  if make_StorageItems ~= nil then __exports["make_StorageItems"] = make_StorageItems end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第六十批.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/verified_helpers_batches_1_3.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- MainLeftBottom.lua 静态去虚拟化：已核验辅助函数批次 1
-- 依据：MainLeftBottom_stage3.bin / 正确字段反汇编 / 原始 dispatcher。
-- 本文件仅包含本批次已能逐条确认语义的函数；不是完整 MainLeftBottom.lua。

local function __root30(arg)
    -- OP_247 在 arg 为假时把 arg 原样写入返回寄存器；为真时进入 IsDie 调用。
    if not arg then
        return arg
    end
    return not arg:IsDie()
end

local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

local function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")
    for _, allowedMapName in ipairs({ "土城" }) do
        if mapName == allowedMapName then
            return true
        end
    end
    return false
end

-- root/33：编译器生成的闭包转发器；两个上值分别为被调用函数与首个实参。
local function __root33(upvalueFunction, upvalueFirstArg, ...)
    return upvalueFunction(upvalueFirstArg, ...)
end

-- root/34：编译器生成的单次闭包转发器。
local function __root34(upvalueFunction, upvalueArg)
    return upvalueFunction(upvalueArg)
end

-- root/35：向 SL.Schedule 转发两个参数；调用时显式传入 SL 作为 self。
local function __root35(callback, interval)
    return SL:Schedule(callback, interval)
end

-- root/40：原型名未知；读取游戏主控制器并返回主玩家 ID。
local function __root40()
    return global.gamePlayerController:GetMainPlayerID()
end
-- MainLeftBottom.lua 静态去虚拟化：已核验辅助函数批次 2
-- 仅记录可从阶段三字节码与 dispatcher 逐条确定的语义。

-- root/1/1：捕获 removeFile 函数与路径，执行一次删除。
local function __root1_1(removeFile, path)
    return removeFile(path)
end

-- root/3：构造可写目录路径前缀。
local function GetWritablePath(prefix)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return prefix .. writablePath
end

-- root/5：取得当前视野中的全部地面掉落物；返回管理器接口给出的两个返回值。
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root/9：记录状态切换，并更新闭包保存的当前状态。
local function __makeRoot9(logger, initialState)
    local currentState = initialState
    return function(newState)
        logger(string.format("状态切换: %s -> %s", currentState, newState))
        currentState = newState
    end
end

-- root/14：获取地图 ID；元数据缺失时返回 0。
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- root/20/1：调度回调，转入全局 MainLoop。
local function __root20_1()
    return MainLoop()
end

-- root/22/2：按 dist 升序排列。
local function __root22_2(left, right)
    return left.dist < right.dist
end

-- root/26/1：对捕获对象的 name 发起加入黑名单请求。
local function __root26_1(capturedObject)
    return SL:RequestAddBlacklistByName(capturedObject.name)
end

-- root/29/1：按 _distance 升序排列。
local function __root29_1(left, right)
    return left._distance < right._distance
end

-- root/43/5：注册/调用游戏离开世界事件接口。
local function __root43_5()
    return global.gameWorldController:OnGameLeaveWorld()
end

-- root/43/14：提示后清空黑名单。
local function __root43_14(showMessage)
    showMessage("清空黑名单")
    return ClearBlacklistItems()
end

-- root/43/23/1/1/1：参数格式错误时调用捕获的提示函数。
local function __root43_23_1_1_1(showMessage)
    return showMessage("参数格式不对，请输入数字")
end

-- root/50、root/55：编译器生成的闭包转发器。
local function __root50(upvalueFunction, upvalueArgument)
    return upvalueFunction(upvalueArgument)
end

local function __root55(upvalueFunction, upvalueFirstArg, ...)
    return upvalueFunction(upvalueFirstArg, ...)
end

-- root/53/1：调用 SL.JsonDecode 解码捕获的 JSON 字符串。
local function __root53_1(jsonText)
    return SL:JsonDecode(jsonText)
end

-- root/54：一次性调度封装。
local function __root54(callback, delay)
    return SL:ScheduleOnce(callback, delay)
end

-- root/58：返回游戏元数据中的玩家 X、Y 坐标。
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end
-- MainLeftBottom.lua — verified helper batch 3
-- Reconstructed from the corrected VM dump and dispatcher semantics.
-- These functions are standalone recoveries; they are not yet merged into the
-- final MainLeftBottom.lua because the surrounding source names/call sites
-- still need whole-file integration.

-- root/40 (6 VM records)
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root/30 (7 VM records)
-- Preserve nil/false input as-is; otherwise return the inverse of IsDie().
local function IsActorAlive(actor)
    if not actor then
        return actor
    end
    return not actor:IsDie()
end

-- root.children[43] / legacy root/44 (20 VM records).
-- The VM dump serializes nil as ["unknown", 2]; it is not the string "unknown".
-- MainLoop call site confirms arguments (actor, mainPlayerID) and return order
-- (raw ownerID, description).
local function GetOwnerDescription(actor, mainPlayerID)
    local ownerID = actor:GetOwnerID()
    local description

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        description = "无归属"
    elseif ownerID == mainPlayerID then
        description = "自己"
    else
        description = "其他玩家"
    end

    return ownerID, description
end

-- root/29/1 (8 VM records), used by table.sort in root/29.
local function CompareMonsterDistance(a, b)
    return a._distance < b._distance
end
  local __exports = {}
  if __root30 ~= nil then __exports["__root30"] = __root30 end
  if GetMapName ~= nil then __exports["GetMapName"] = GetMapName end
  if IsInWhitelistMap ~= nil then __exports["IsInWhitelistMap"] = IsInWhitelistMap end
  if __root33 ~= nil then __exports["__root33"] = __root33 end
  if __root34 ~= nil then __exports["__root34"] = __root34 end
  if __root35 ~= nil then __exports["__root35"] = __root35 end
  if __root40 ~= nil then __exports["__root40"] = __root40 end
  if __root1_1 ~= nil then __exports["__root1_1"] = __root1_1 end
  if GetWritablePath ~= nil then __exports["GetWritablePath"] = GetWritablePath end
  if GetDroppedItems ~= nil then __exports["GetDroppedItems"] = GetDroppedItems end
  if __makeRoot9 ~= nil then __exports["__makeRoot9"] = __makeRoot9 end
  if GetMapId ~= nil then __exports["GetMapId"] = GetMapId end
  if __root20_1 ~= nil then __exports["__root20_1"] = __root20_1 end
  if __root22_2 ~= nil then __exports["__root22_2"] = __root22_2 end
  if __root26_1 ~= nil then __exports["__root26_1"] = __root26_1 end
  if __root29_1 ~= nil then __exports["__root29_1"] = __root29_1 end
  if __root43_5 ~= nil then __exports["__root43_5"] = __root43_5 end
  if __root43_14 ~= nil then __exports["__root43_14"] = __root43_14 end
  if __root43_23_1_1_1 ~= nil then __exports["__root43_23_1_1_1"] = __root43_23_1_1_1 end
  if __root50 ~= nil then __exports["__root50"] = __root50 end
  if __root55 ~= nil then __exports["__root55"] = __root55 end
  if __root53_1 ~= nil then __exports["__root53_1"] = __root53_1 end
  if __root54 ~= nil then __exports["__root54"] = __root54 end
  if PlayerPos ~= nil then __exports["PlayerPos"] = PlayerPos end
  if GetMainPlayerID ~= nil then __exports["GetMainPlayerID"] = GetMainPlayerID end
  if IsActorAlive ~= nil then __exports["IsActorAlive"] = IsActorAlive end
  if GetOwnerDescription ~= nil then __exports["GetOwnerDescription"] = GetOwnerDescription end
  if CompareMonsterDistance ~= nil then __exports["CompareMonsterDistance"] = CompareMonsterDistance end
  MainLeftBottomRecovered.sources["04_源码候选/verified_helpers_batches_1_3.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root38_GetOwnerID.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[38] / legacy root/39
-- Reconstruction label: GetOwnerID
-- 31 physical VM instructions; no captures; no child prototypes.
-- Status: complete static reconstruction; not runtime-validated.
--
-- Static truth table from docs/audit/owner_id_helpers_阶段核验.md:
--   nil / "" / -1       -> false
--   string ownerID     -> ownerID ~= tostring(ownerID)
--   non-string ownerID -> ownerID ~= expectedOwnerID
--
-- Parameter names are descriptive reconstruction labels.

local function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID ~= tostring(ownerID)
    end

    return ownerID ~= expectedOwnerID
end

-- The inequality against tostring(string) is intentionally retained; for
-- ordinary Lua strings this branch evaluates false, matching the static
-- truth table. No runtime samples have been used to alter this behavior.

  local __exports = {}
  if GetOwnerID ~= nil then __exports["GetOwnerID"] = GetOwnerID end
  MainLeftBottomRecovered.sources["04_源码候选/root38_GetOwnerID.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root7_GetOwnerIDText.lua
-- 独立词法块；保留原候选函数和内部闭包，不在此处伪造跨原型捕获绑定。
-- ============================================================================
do
-- root.children[7] / legacy root/8
-- Reconstruction label: GetOwnerIDText
-- 31 physical VM instructions; no captures; no child prototypes.
-- Status: complete static reconstruction; not runtime-validated.
--
-- Static truth table from docs/audit/owner_id_helpers_阶段核验.md:
--   nil / "" / -1       -> false
--   string ownerID     -> ownerID == tostring(ownerID)
--   non-string ownerID -> ownerID == expectedOwnerID
--
-- Parameter names are descriptive reconstruction labels.

local function GetOwnerIDText(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()

    if ownerID == nil or ownerID == "" or ownerID == -1 then
        return false
    end

    if type(ownerID) == "string" then
        return ownerID == tostring(ownerID)
    end

    return ownerID == expectedOwnerID
end

-- The string comparison is retained even though tostring(string) normally
-- returns the same string. Do not collapse this branch without runtime proof.

  local __exports = {}
  if GetOwnerIDText ~= nil then __exports["GetOwnerIDText"] = GetOwnerIDText end
  MainLeftBottomRecovered.sources["04_源码候选/root7_GetOwnerIDText.lua"] = __exports
end

-- ============================================================================
-- 根模块原型索引与后续整合规则
-- ============================================================================
-- 110个原型已登记在 MainLeftBottomRecovered.prototype_index。
-- 直接恢复代码优先级：
--   1) 不含upvalue且函数体已静态闭合：可直接并入根模块；
--   2) 有upvalue：保留 make_XXX(...) 工厂，按closure map顺序注入；
--   3) 主体可读但槽位/宿主语义未闭合：保留TODO，不编造参数/字段；
--   4) 仅有结构树/PC摘要：按 prototype_index 对应路径补充函数体。
--
-- 本汇总稿内已集中：根模块分段主体、MainLoop工厂、DiuItems工厂、
-- BlacklistPlayerDetection工厂、DeathAutoBlacklist工厂、onDamageMsg工厂、
-- FindMonsterCandidates工厂、doInit_UI及UI子闭包、StorageItems及子闭包、
-- 已核验短辅助函数批次。
--
-- 尚未做：全部候选函数的最终去重/根级闭包实例化/全局导出调用链集成、
-- Lua解释器语法检查、引擎环境运行验证。不要把本文件误当作最终可执行脚本。
return MainLeftBottomRecovered
