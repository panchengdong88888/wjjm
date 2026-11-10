--[[
MainLeftBottom(2).lua 明文恢复整合稿（静态候选）
生成：2026-11-10 | GitHub checkpoint 267
用途：按110原型索引和PC级证据整合普通Lua候选、根模块状态及58个直接子闭包。
当前状态：109/110原型完整静态恢复；根直接闭包58/58已接入源码层装配；PC43-PC85、PC181-PC258及PC297-PC388闭包已按VM创建顺序整合；检查点261修正采集状态表跨词法块引用；检查点262按寄存器生命周期重建PC1-PC42初始化；检查点263显式恢复PC43-PC85的T[4..8]创建、覆写、捕获及导出顺序；检查点264恢复PC86-PC211采集闭包及T[14..22]共享cell注入；检查点265补齐PC212-PC296 UI闭包校验、模块字段身份及PC275全局模块表重读；检查点266按T[44..51]恢复PC297-PC315配置包装链并用于doInit_UI捕获注入；检查点267复核PC350-PC388黑名单闭包对象身份、T[57] live cell及全局导出落点。
重要：
- 根模块初始化与闭包创建仍采用明确标注的恢复适配结构，不冒充原作者逐字源码。
- 所有函数体仍按原型路径保留；根装配按OP_387捕获顺序绑定共享cell和状态表。
- 唯一未完整静态恢复的是root模块主体本身；未恢复逻辑不伪造空函数。
- 本文件PC412返回MainLeftBottom模块表；MainLeftBottomRecovered仅是本文件局部恢复注册容器，不作为额外全局导出。
- runtime_verified 全部为 false；未执行Lua编译器，也未进行目标游戏运行时验证。
- 新框架API以《新框架(3_40_xx).zip》为接口参考；只将文档明确的API标为DOCUMENTED。
- 诸如 actor:GetOwnerID()/actor:IsDie()/global.gamePlayerController:GetMainPlayerID()
  是脚本中观察到的宿主对象方法；开发包未检索到这些精确方法名，不擅自宣称文档已定义。
]]
local MainLeftBottomRecovered = { sources = {}, prototype_index = {} }

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
  ["root.children[6]"] = { name="InstallDamageHook", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第三十九批.lua", audit_file="docs/audit/检查点231_短函数复核_GetWritablePath与InstallDamageHook.md", instructions=40, runtime_verified=false },
  ["root.children[52].children[0]"] = { name="Nested_JsonDecode", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第四十批.lua", audit_file="docs/audit/检查点214_Nested_JsonDecode完整静态复审.md", instructions=6, runtime_verified=false },
  ["root.children[2]"] = { name="GetWritablePath", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root2_GetWritablePath.lua", audit_file="docs/audit/检查点231_短函数复核_GetWritablePath与InstallDamageHook.md", instructions=10, runtime_verified=false },
  ["root.children[42].children[22]"] = { name="Nested_Anonymous", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/Nested_Anonymous_第七十八批.lua", audit_file="docs/audit/检查点235_VM调用帧初始化与固定参数计数纠错.md", instructions=8, runtime_verified=false },
  ["root.children[8]"] = { name="FormatStateChange", status="complete_static_reconstruction", source_file="04_源码候选/root8_FormatStateChange.lua", audit_file="docs/audit/检查点177_FormatStateChange父级捕获身份与状态共享链闭合.md", instructions=10, runtime_verified=false },
  ["root.children[9]"] = { name="ReadNumericConfig", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root9_ReadNumericConfig.lua", audit_file="docs/audit/检查点232_ReadNumericConfig首参数与vararg入口复核.md", instructions=45, runtime_verified=false },
  ["root.children[23]"] = { name="Builtsetting", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第四十五批.lua", audit_file="docs/audit/检查点215_Builtsetting完整静态复审.md", instructions=55, runtime_verified=false },
  ["root.children[25]"] = { name="DeathAutoBlacklist", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root25_DeathAutoBlacklist.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=47, runtime_verified=false },
  ["root.children[12]"] = { name="LuaSendMsg", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第五十批.lua", audit_file="docs/audit/检查点221_LuaSendMsg完整静态复审.md", instructions=92, runtime_verified=false },
  ["root.children[22]"] = { name="GetMapData2DPtr", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root22_GetMapData2DPtr.lua", audit_file="docs/audit/检查点234_剩余未闭合原型盘点.md", instructions=144, runtime_verified=false },
  ["root.children[3]"] = { name="MoveTo", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十三批.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=51, runtime_verified=false },
  ["root.children[15]"] = { name="ClearBlacklistItems", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十四批.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=63, runtime_verified=false },
  ["root.children[52]"] = { name="onDamageMsg", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root52_onDamageMsg.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=72, runtime_verified=false },
  ["root.children[1]"] = { name="GetStorageItemData", status="complete_static_reconstruction_not_runtime_verified_integrated_checkpoint230", source_file="04_源码候选/短函数草稿_第五十六批.lua", instructions=77, runtime_verified=false },
  ["root.children[5]"] = { name="TakeItems", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十七批.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=99, runtime_verified=false },
  ["root.children[47]"] = { name="BlacklistPlayerDetection", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第五十九批.lua", audit_file="docs/audit/检查点233_已完成函数索引状态对账.md", instructions=216, runtime_verified=false },
  ["root.children[50]"] = { name="StorageItems", status="complete_static_reconstruction", source_file="04_源码候选/短函数草稿_第六十批.lua", audit_file="docs/audit/检查点223_StorageItems完整静态复审.md", instructions=224, runtime_verified=false },
  ["root.children[42]"] = { name="doInit_UI", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十三批.lua", audit_file="docs/audit/检查点235_VM调用帧初始化与固定参数计数纠错.md", instructions=419, runtime_verified=false },
  ["root.children[41]"] = { name="MoveItemToQuickUse", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十一批.lua", audit_file="docs/audit/检查点234_剩余未闭合原型盘点.md", instructions=133, runtime_verified=false },
  ["root"] = { name="MainLeftBottom_Module", status="partial_ordinary_lua_draft", source_file="04_源码候选/root_MainLeftBottom_Module.lua", instructions=412, runtime_verified=false },
  ["root.children[6].children[0]"] = { name="Nested_onDamageMsg", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第三十九批.lua", instructions=18, runtime_verified=false },
  ["root.children[14]"] = { name="FindMonsterInCurrViewField", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第十三批.lua", instructions=27, runtime_verified=false },
  ["root.children[34]"] = { name="AnonymousHelper_33", status="complete_static_reconstruction", source_file="04_源码候选/root35_AnonymousHelper_33_ScheduleWrapper.lua", audit_file="docs/audit/检查点227_AnonymousHelper_33_Schedule包装函数.md", instructions=7, runtime_verified=false },
  ["root.children[42].children[3]"] = { name="Nested_FFFF00", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十三批.lua", instructions=320, runtime_verified=false },
  ["root.children[42].children[18]"] = { name="Nested_Helper_10", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/短函数草稿_第六十三批.lua", instructions=39, runtime_verified=false },
  ["root.children[49]"] = { name="AnonymousHelper_49", status="complete_static_reconstruction_not_runtime_verified", source_file="04_源码候选/root49_AnonymousHelper_49.lua", instructions=5, runtime_verified=false },
  ["root.children[51]"] = { name="FindBlacklistPlayer", status="complete_static_reconstruction_not_runtime_verified_integrated_checkpoint230", source_file="04_源码候选/root49_PCallHelper_2_and_root51_FindBlacklistPlayer.lua", instructions=35, runtime_verified=false },
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
-- 检查点192-198、262-266：根模块分段普通Lua草稿，PC1-PC412均已建立分段记录；非作者原文逐字恢复，未运行时验证。
-- 状态：不是完整根模块源码，尚未运行时验证。

local MainLeftBottom = {}
_G.MainLeftBottom = MainLeftBottom

-- PC3-PC5：T[0]先创建a状态表，再于PC5挂入模块根表。
local a = {}
MainLeftBottom.a = a

-- PC6：版本字段。
a.version = "10000"

-- PC7-PC11：读取屏幕宽度并写入a.screenW。
a.screenW = SL:GetMetaValue("SCREEN_WIDTH")

-- PC12-PC16：读取屏幕高度并写入a.screenH。
a.screenH = SL:GetMetaValue("SCREEN_HEIGHT")

-- PC17-PC23：T[1]临时构造Blocklist数组，完成后挂入a表。
local blocklist = {1.0, 9.0, 10.0, 60000.0}
a.Blocklist = blocklist

-- PC24-PC25：创建并挂入发送钩子列表。
local sendHookList = {}
a.SendHookList = sendHookList

-- PC26-PC27：创建并挂入接收钩子列表。
local recvHookList = {}
a.RecvHookList = recvHookList

-- PC28-PC29：界面初始显示状态字段。
a.isHidden = true
a.hidebut = nil

-- PC30-PC32：T[1]创建b映射表；PC31重新读取模块根表，PC32挂入b。
local b = {}
local moduleForB = _G.MainLeftBottom
moduleForB.b = b

-- PC33-PC35：T[2]创建z状态表，再挂入模块根表。
local z = {}
MainLeftBottom.z = z

-- PC36-PC41：按PC顺序初始化六个状态字段。
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

-- PC42：创建供各定时器闭包共享的空状态表（T[3]）。
local timerState = {}

-- PC1-PC42已按检查点262恢复初始化语句；PC43-PC85已按T寄存器顺序装配；PC86-PC211采集闭包及共享cell已在主恢复稿装配；PC212-PC296 UI闭包与模块字段已补充来源校验；PC297-PC315配置包装链已按T[44..51]顺序装配；PC316-PC412仍按既有检查点分段整理。
-- 本文件不是完整、可直接运行的原始Lua文件。


-- 检查点193：PC43-PC85，根模块辅助闭包创建与导出。
-- PC42的T[3] timerState已在前段创建；本段从PC43开始记录子闭包创建。
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
-- 所有子原型实现均保留在各自源码文件；本根模块记录闭包创建、捕获顺序和导出位置；检查点250起，采集状态闭包
-- 已通过显式共享cell适配器完成静态装配。


-- 检查点194：PC86-PC167 配置表与奖励记录表构造。
-- PC86-PC89：创建供采集逻辑读取的配置表；root.children[28] FindMonsterCandidates
-- 在父root PC194创建时捕获该表为UPVALUE[4]，因此这里按已核实用途命名。
local gatherConfig = {
    GATHER_THRESHOLD = 10,
    CHECK_INTERVAL = 0.5,
    ATTACK_WAIT_TIME = 1
}

-- PC90-PC95：计算 math.floor(3600 / 0.2)，结果为18000。
local rootRegister11 = math.floor(3600 / 0.2)
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

-- PC210：创建root.children[14] / FindMonsterInCurrViewField，捕获数1；
-- PC211：捕获父帧T[30]（IsDie闭包）。ClearBlacklistItems实际是root.children[15]，在PC383创建。
-- 检查点264：主恢复装配段为T[14..22]各建立唯一共享cell，并按PC181、
-- PC184-PC193、PC194、PC200、PC210的顺序实例化对应闭包；工厂来源缺失时
-- requireRecoveredClosure会中止装配，避免nil/错位捕获被静默传入。

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

-- PC275：重新读取_ENV.MainLeftBottom；检查点265的主装配适配器显式读取_G.MainLeftBottom后再写入main字段。
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

-- PC294：同一blacklistState表挂入模块字段；后续onDamageMsg/黑名单闭包共享该对象。
MainLeftBottom.blacklist = blacklistState

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
-- 检查点266：主恢复稿用rootConfigRegisters影子表记录T[44..51]：
-- GetWritablePath、ReadNumericConfig、PCallHelper、FileExistCheck_pcall_wrapper、
-- AnonymousHelper_49、AnonymousHelper_32、AnonymousHelper_33、AnonymousHelper_54；
-- doInit_UI的UP[6]/[9]/[10]/[12]/[14]/[16]从对应T[48]/[50]/[49]/[44]/[51]/[47]注入。
-- rootConfigRegisters仅是恢复适配器，不是原作者源码中的真实table。

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
-- 检查点267：主恢复稿分别保留PC357 onDamageMsg模块字段与PC360 InstallDamageHook/T[57]共享cell，
-- 并对二者函数身份作静态断言；T[52]八组二元数值按PC316-PC349原值逐项核对。
-- 这两个父级捕获槽位按顺序保留；子闭包Nested_onDamageMsg的捕获另见检查点179。
-- PC363-PC367：创建root.children[25] / DeathAutoBlacklist，捕获：
-- [T[41], T[4], T[55], T[5]]。
-- PC368-PC381：创建root.children[47] / BlacklistPlayerDetection，按序捕获：
-- [T[2]=MainLeftBottom.z, T[57]=InstallDamageHook live cell, T[41], T[58], T[55], T[53], T[38],
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
-- 20项槽位身份已由检查点256逐项闭合；完整顺序与装配值见docs/audit/检查点256_doInit_UI二十项捕获与根闭包全量装配.md。
-- doInit_UI本体419条，已有首版普通Lua草稿（检查点187）；
-- 静态参数映射已由检查点208/235闭合：RequestStorageData与Attach_UITop各传T[7]一个显式实参；Nested_Anonymous fixed_param_count=2，T[0]=promptText、T[1]=successCallback、T[2]=nil。GUI宿主行为仍未运行时验证。
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
-- 检查点210：早期根模块装配兼容接口（保留，不作为当前主装配入口）
--
-- 用途：供外部测试/旧接续脚本把已绑定的子原型接回根模块字段。
-- 当前正式恢复稿在文件末尾的root_assembly_checkpoint=256区段按PC顺序
-- 完成全部58个根直接闭包绑定；本函数不被当前主装配流程调用。
-- prototypes中的函数必须是已完成父级捕获绑定的闭包实例；本接口不
-- 伪造VM upvalue，也不代替各子原型的函数体。
-- 未提供的项目保持原样，不以空函数冒充恢复结果。
--
-- 此函数是恢复适配器，不是原作者源码中的独立函数。
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
  if gatherConfig ~= nil then __exports["gatherConfig"] = gatherConfig end
  -- Checkpoint250: initial values for shared OP_387 parent-register cells.
  __exports["currentState"] = currentState
  __exports["resettableTable"] = resettableTable
  __exports["resetSlot16"] = resetSlot16
  __exports["resetSlot17"] = resetSlot17
  __exports["isGatherRunning"] = isGatherRunning
  __exports["resetSlot19"] = resetSlot19
  __exports["resetSlot20"] = resetSlot20
  __exports["resetSlot21"] = resetSlot21
  __exports["resetSlot22"] = resetSlot22
  __exports["timerState"] = timerState
  __exports["gatherStatusText"] = gatherStatusText
  -- Checkpoint251: shared UI/module state tables captured by the three UI closures.
  __exports["uiState"] = MainLeftBottom.a
  __exports["buttonMap"] = MainLeftBottom.b
  -- Checkpoint252: stable root captures for map-distance and blacklist helpers.
  __exports["opaquePairTable"] = opaquePairTable
  __exports["randomTeleportItemNames"] = randomTeleportItemNames
  __exports["blacklistState"] = blacklistState
  __exports["blacklistDistanceConfigFile"] = blacklistDistanceConfigFile
  __exports["gatherMonsterCountConfigFile"] = gatherMonsterCountConfigFile
  __exports["loginAndOnlineRewardEntries"] = loginAndOnlineRewardEntries
  __exports["rootRegister11"] = rootRegister11
  __exports["blacklistAlertThreshold"] = blacklistAlertThreshold
  __exports["blacklistShortRetryDelay"] = blacklistShortRetryDelay
  __exports["blacklistNoItemRetryDelay"] = blacklistNoItemRetryDelay
  MainLeftBottomRecovered.sources["04_源码候选/root_MainLeftBottom_Module.lua"] = __exports
end

-- ============================================================================
-- 来源文件：04_源码候选/root45_MainLoop.lua
-- MainLoop工厂按捕获顺序注入；可变父寄存器统一访问共享cell.value。
-- ============================================================================
do
-- MainLeftBottom(2).lua VM recovery candidate
-- Prototype: root.children[45] (legacy root/46)
-- 417 physical VM instructions; 41 constants; no child prototypes.
--
-- STATUS: complete static reconstruction candidate; checkpoint250 adds shared-cell factory adaptation. This is NOT original author source and NOT runtime validated. The 417-PC CFG was statically closed at checkpoints152-158.
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

-- Checkpoint250: shared-cell factory; mutable captured parent registers are passed by identity.
local function make_MainLoop(UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4, UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9, UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14, UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19, UPVALUE_20, UPVALUE_21)
    return function()
    if not UPVALUE_0.value then
        return
    end

    -- White-list map: leave the gather state machine and reset its data.
    if IsInWhitelistMap() then
        if UPVALUE_1.value ~= UPVALUE_2.IDLE then
            UPVALUE_3("在白名单地图, 停止引怪")
            UPVALUE_4(UPVALUE_2.IDLE)
            UPVALUE_5()
        end
        return
    end

    --------------------------------------------------------------------------
    -- IDLE: collect candidate monster IDs.
    --------------------------------------------------------------------------
    if UPVALUE_1.value == UPVALUE_2.IDLE then
        UPVALUE_3("扫描怪物中")

        local candidates = UPVALUE_7()
        if #candidates == 0 then
            UPVALUE_3("视野内没有可攻击怪物")
            return
        end

        UPVALUE_8.value = {}
        local mainPlayerID = UPVALUE_6()

        for _, actor in ipairs(candidates) do
            -- Preserve the captured GetOwnerID predicate and its truth value.
            if not UPVALUE_9(actor, mainPlayerID) then
                table.insert(UPVALUE_8.value, actor:GetID())
            end
        end

        if #UPVALUE_8.value == 0 then
            UPVALUE_3("没有可攻击的怪物")
            return
        end

        UPVALUE_10.value = 1
        UPVALUE_11.value = 0
        UPVALUE_3(string.format("开始引怪，目标数量: %d", #UPVALUE_8.value))
        UPVALUE_4(UPVALUE_2.GATHERING)
        return
    end

    --------------------------------------------------------------------------
    -- GATHERING: resume a pending owner wait, then scan the target list.
    --------------------------------------------------------------------------
    if UPVALUE_1.value == UPVALUE_2.GATHERING then
        UPVALUE_3("引怪中")

        if UPVALUE_12.value then
            local now = os.time()

            if now < UPVALUE_13.value then
                UPVALUE_3(string.format(
                    "等待归属变更中: %s (还剩 %d 秒)",
                    UPVALUE_14.value,
                    UPVALUE_13.value - now
                ))
                return
            end

            -- Confirmed helper: FindMonsterInCurrViewField has no formal
            -- parameters and returns an ID-keyed actor map. This call site passes
            -- UPVALUE_12.value as an extra argument; the helper does not read it.
            -- The VM call site supplies two register slots here; their values are not
            -- semantically consumed by the zero-parameter helper. Keep the
            -- recovered helper invocation itself argument-free in this draft.
            local actorMap = UPVALUE_15()
            local actor = actorMap and actorMap[UPVALUE_16.value]
            local mainPlayerID = UPVALUE_6()

            if actor and UPVALUE_17(actor, mainPlayerID) then
                UPVALUE_3(string.format(
                    "怪物 %s 归属已变更为自己",
                    UPVALUE_14.value
                ))
            else
                UPVALUE_3(string.format(
                    "怪物 %s 归属未变更或已离开视野",
                    UPVALUE_14.value
                ))
            end

            UPVALUE_12.value = false
            UPVALUE_13.value = 0
            UPVALUE_16.value = 0
            UPVALUE_14.value = ""
            UPVALUE_10.value = UPVALUE_10.value + 1
        end

        -- PC159-PC160 passes UPVALUE_12.value as one extra argument. The helper has
        -- no formal parameters and ignores it, but retain the call-site value.
        local actorMap = UPVALUE_15(UPVALUE_12.value)
        local mainPlayerID = UPVALUE_6()
        local allOwnersResolved = true -- PC161; PC263 clears this on an unowned target.

        for index = UPVALUE_10.value, #UPVALUE_8.value do
            local targetID = UPVALUE_8.value[index]
            local actor = actorMap and actorMap[targetID]

            if not actor then
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 不在视野内，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10.value = index + 1

            elseif not UPVALUE_18(actor) then
                -- This wrapper is truthy for a living actor in this call path.
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 已死亡，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10.value = index + 1

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
                    UPVALUE_10.value = index + 1

                elseif UPVALUE_17(actor, mainPlayerID) then
                    UPVALUE_3(string.format(
                        "怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    UPVALUE_11.value = UPVALUE_11.value + 1
                    UPVALUE_10.value = index + 1

                else
                    allOwnersResolved = false

                    -- PC264 stores the current index before attempting to lock;
                    -- PC310-PC311 advance it after either the success or failure path.
                    UPVALUE_10.value = index
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
                        UPVALUE_12.value = true
                        UPVALUE_13.value = os.time()
                            + UPVALUE_21.ATTACK_WAIT_TIME
                        UPVALUE_16.value = targetID
                        UPVALUE_14.value = monsterName

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
                    UPVALUE_10.value = index + 1
                end
            end
        end

        -- PC166 prepares the numeric loop counter (UPVALUE_10.value - 1); PC313
        -- increments/tests it and repeats at PC167. The loop therefore visits
        -- UPVALUE_10.value..#UPVALUE_8.value. The R2 flag starts true at PC161 and is cleared
        -- at PC263 when an unowned target is encountered.
        if allOwnersResolved then
            if UPVALUE_10.value > #UPVALUE_8.value then
                UPVALUE_3("所有怪物归属已获取，切换到攻击状态")
                UPVALUE_10.value = 1
                UPVALUE_4(UPVALUE_2.ATTACKING)
                return
            end
        elseif UPVALUE_10.value > #UPVALUE_8.value then
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
    if UPVALUE_1.value == UPVALUE_2.ATTACKING then
        UPVALUE_3("攻击中")

        local actorMap = UPVALUE_15()
        -- PC354 initializes the no-living-target flag; PC359/405 form the
        -- numeric for-loop over UPVALUE_10.value..#UPVALUE_8.value.

        for index = UPVALUE_10.value, #UPVALUE_8.value do
            local targetID = UPVALUE_8.value[index]
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
            UPVALUE_10.value = index + 1
        end

        UPVALUE_3("所有目标怪物已死亡或离开视野，切换到空闲状态")
        UPVALUE_4(UPVALUE_2.IDLE)
        UPVALUE_5()
        return
    end
end

    end
end

return make_MainLoop

  local __exports = {}
  if make_MainLoop ~= nil then __exports["make_MainLoop"] = make_MainLoop end
  MainLeftBottomRecovered.sources["04_源码候选/root45_MainLoop.lua"] = __exports
end
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

-- Checkpoint250 adapter: captured mutable parent registers are shared cell objects.
local function make_MainLoop(UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4, UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9, UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14, UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19, UPVALUE_20, UPVALUE_21)
    return function()
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

    end
end

return make_MainLoop

  local __exports = {}
  if make_MainLoop ~= nil then __exports["make_MainLoop"] = make_MainLoop end
  MainLeftBottomRecovered.sources["04_源码候选/root45_MainLoop.lua"] = __exports
end
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
    local function DiuItems()
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
    return DiuItems
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
-- 来源文件：04_源码候选/短函数草稿_第六十三批.lua
-- root.children[42] doInit_UI；20项父级捕获由根装配区按PC390-PC410顺序注入。
-- 本工厂内部包含已恢复的23个子原型/回调构造逻辑；未确认T槽继续保留候选中的中性占位。
-- ============================================================================
do
--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
完整静态恢复（检查点187/199/200/201/203/204/208/226；PC1-PC419全部映射；根工厂显式接收20项捕获。T7按标准Lua ipairs第三返回值取0；Nested_Anonymous的T2来源作为独立子原型继续待核验；未运行时验证。
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
    local function Nested_Helper()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空怪物阈值")
            printLog("已清空怪物阈值存档：%s", detail)
        else
            notify("清空怪物阈值失败")
            printLog("清空怪物阈值失败：%s", detail)
        end
    end
    return Nested_Helper
end

local function make_Nested_s(checkCallback, checkArgument, notify, printLog)
    local function Nested_s()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空黑名单距离")
            printLog("已清空黑名单距离存档：%s", detail)
        else
            notify("清空黑名单距离失败")
            printLog("清空黑名单距离失败：%s", detail)
        end
    end
    return Nested_s
end

local function make_Nested_Helper_5(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveDistance, setButtonState
)
    local function Nested_Helper_5(value)
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
    return Nested_Helper_5
end

local function make_Nested_Helper_8(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveThreshold, setButtonState
)
    local function Nested_Helper_8(value)
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
    return Nested_Helper_8
end

local function make_Nested_Helper_4(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveDistance, setButtonState
)
    local function Nested_Helper_4()
        local callback = make_Nested_Helper_5(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveDistance, setButtonState
        )
        openDialog("请输入黑名单的距离格子（数字，按线路计算）", callback)
    end
    return Nested_Helper_4
end

local function make_Nested_Helper_7(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveThreshold, setButtonState
)
    local function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveThreshold, setButtonState
        )
        openDialog("请输入拉怪的怪物数量阈值（数字）", callback)
    end
    return Nested_Helper_7
end

-- ---------------------------------------------------------------------------
-- root.children[42].children[22] / Nested_Anonymous (第七十八批主体并入)
-- 8条父原型指令；child0 Nested_str 27条；其内含4条 Nested_Helper_11。
-- 检查点235已闭合固定参数帧：fixed_param_count=2，调用实参(promptText, successCallback)分别写入T[0]/T[1]；T[2]无写入，确定为nil。错误分支直接调用T[2]的attempt-to-call-nil行为按字节码保留。
-- ---------------------------------------------------------------------------
local function make_Nested_Anonymous(PrintLog)
    return function(promptText, successCallback)
        -- 原始VM调用帧M已确认：本原型fixed_param_count=2。
        -- 两个固定参数分别进入新建帧表T[0]、T[1]；额外实参进入独立X表。
        -- T[2]没有任何写入指令，因此该槽确定为nil。
        local T0_SLOT = promptText
        local T1_SLOT = successCallback
        local T2_SLOT = nil

        local function Nested_str(optionalSuffix)
            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = { inputMode = 2, maxLength = 6 },
            }
            local initialText = T0_SLOT
            if optionalSuffix then
                initialText = initialText .. "\n" .. optionalSuffix
            end
            dialogParams.str = initialText

            local function Nested_match(status, result)
                if status ~= 1 then return end
                local editStr = result and result.editStr or ""
                local normalized = tostring(editStr):gsub("%s", "")
                local isDigits = string.match(normalized, "^%d+$")
                local numericValue
                if isDigits then numericValue = tonumber(normalized) end
                if numericValue then
                    T1_SLOT(numericValue)
                    return
                end
                PrintLog("%s：参数格式不对（%s）", initialText, tostring(editStr))
                local function Nested_Helper_11()
                    -- 原字节码直接调用T[2]；该槽确定为nil，保留attempt-to-call-nil行为。
                    T2_SLOT("参数格式不对，请输入数字")
                end
                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- Nested_str固定参数数为1，但PC6-PC7以空实参区间调用，optionalSuffix=nil。
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
    local function Nested_UnSchedule()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            -- VM dump中的['unknown',2]尚未确认等价nil；保留占位。
            timerState.resTimer = nil
        end

        GUI:Win_Close(moduleState.resWin)
    end
    return Nested_UnSchedule
end

-- child2 Nested_FFFFFF：65条，捕获[resList,screenW*0.6]。
local function make_Nested_FFFFFF(listView, cellWidth)
    local function Nested_FFFFFF(resourceNames, layoutOption, rowType)
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
    return Nested_FFFFFF
end

-- child3 Nested_Helper_3：168条，捕获10项。
local function make_Nested_Helper_3(
    moduleState, timerState, curTimeText, durTimeText, initState,
    moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
)
    local function Nested_Helper_3()
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
    return Nested_Helper_3
end

-- 父原型Nested_FFFF00：320条，捕获[moduleState,printLog,timerState,initState]。检查点207逐PC复审PC1-PC320，修正五处Text_Create返回值门控。
local function make_Nested_FFFF00(moduleState, printLog, timerState, initState)
    local function Nested_FFFF00()
        local gui = GUI
        local sl = SL

        -- PC1-PC27：窗口已存在则关闭；resTimer取消后清为nil；检查点225确认K[28]=["unknown",2]是nil的VM dump序列化占位。
        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
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
    return Nested_FFFF00
end


local function make_Nested_StopGatherMonsters(
    timerState, notify, canStartGather, logNotice,
    openThresholdInput, applyGatherState
)
    local function Nested_StopGatherMonsters()
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
    return Nested_StopGatherMonsters
end

local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    local function Nested_LuaSendMsg()
        counter = counter + 1
        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]
        if not entry then return end

        LuaSendMsg(9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3])
    end
    return Nested_LuaSendMsg
end

local function make_Nested_SL_2(timerState, notify, modulus, messageEntries, scheduleContext)
    local function Nested_SL_2()
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
    return Nested_SL_2
end

local function make_Nested_ClearBlacklistItems(notify)
    local function Nested_ClearBlacklistItems()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
    return Nested_ClearBlacklistItems
end

local function make_Nested_blacklistTimer(
    config, getDistance, timerState, schedule, formatNotice
)
    local function Nested_blacklistTimer(distance)
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
    return Nested_blacklistTimer
end

local function make_Nested_Helper_10(
    timerState, notify, moduleState, readBlacklistDistance,
    openBlacklistDistanceInput, startBlacklistTimer
)
    local function Nested_Helper_10()
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
    return Nested_Helper_10
end

local function make_Nested_SL_3(timerState, notify, featureState, schedule)
    local function Nested_SL_3()
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
    return Nested_SL_3
end

local function make_Nested_TakeItems(timerState, notify, featureState, schedule)
    local function Nested_TakeItems()
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
    return Nested_TakeItems
end

local function make_Nested_shiquTimer(timerState, notify, schedule)
    local function Nested_shiquTimer()
        if timerState.shiquTimer then
            notify("关闭拾取物品")
            SL:UnSchedule(timerState.shiquTimer)
            timerState.shiquTimer = nil
            return
        end
        notify("开启拾取物品")
        timerState.shiquTimer = schedule(PickUpItems, 0.01)
    end
    return Nested_shiquTimer
end

local function make_Nested_dropTimer(timerState, notify, featureState, schedule)
    local function Nested_dropTimer()
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
    return Nested_dropTimer
end

local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

local function make_Nested_Helper_9(uiState, notify)
    local function Nested_Helper_9()
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
    return Nested_Helper_9
end

local function make_Nested_InitGatherMonsters(config, getThreshold)
    local function Nested_InitGatherMonsters(threshold)
        if not threshold then threshold = getThreshold() end
        config.GATHER_THRESHOLD = threshold
        if not config.GATHER_THRESHOLD then return false end
        InitGatherMonsters()
        return true
    end
    return Nested_InitGatherMonsters
end

local function make_Nested_04d_02d_02d(lastSentDate, messageSender, notify)
    local function Nested_04d_02d_02d()
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
    return Nested_04d_02d_02d
end

local function make_Nested_ffffff(buttonConfigs, buttonByKey)
    local function Nested_ffffff(key, toggled)
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
    return Nested_ffffff
end

local function make_doInit_UI(upvalue0, upvalue1, upvalue2, upvalue3, upvalue4, upvalue5, upvalue6, upvalue7, upvalue8, upvalue9, upvalue10, upvalue11, upvalue12, upvalue13, upvalue14, upvalue15, upvalue16, upvalue17, upvalue18, upvalue19)
    local function doInit_UI()
    -- PC390在root创建本闭包时明确捕获20个父级T寄存器。
    -- UP[0..19]依次对应父root的T[4,2,3,0,1,41,48,7,8,50,49,5,44,42,51,43,47,11,12,9]。
    -- 可直接确认的身份：UP[0]=PrintLog；UP[1]=MainLeftBottom.z功能状态表；
    -- UP[2]=root PC42创建的timerState；UP[3]=MainLeftBottom.a UI状态表；
    -- UP[5]是root创建并挂到MainLeftBottom.blacklist的黑名单状态表；
    -- UP[8]是含GATHER_THRESHOLD/CHECK_INTERVAL/ATTACK_WAIT_TIME的配置表；
    -- UP[11]是root PC46创建的ShowLocalNoticeByType闭包；
    -- UP[13]/UP[15]分别是黑名单距离/拉怪数量配置文件路径；
    -- UP[17]=root PC90计算所得18000；UP[19]=0.2。其余槽位保持编号，不猜业务名称。
    local UPVALUE_0, UPVALUE_1, UPVALUE_2, UPVALUE_3, UPVALUE_4 =
        upvalue0, upvalue1, upvalue2, upvalue3, upvalue4
    local UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9 =
        upvalue5, upvalue6, upvalue7, upvalue8, upvalue9
    local UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14 =
        upvalue10, upvalue11, upvalue12, upvalue13, upvalue14
    local UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19 =
        upvalue15, upvalue16, upvalue17, upvalue18, upvalue19

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
        UPVALUE_2.cruiseTimer = nil
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
    local T7 = 0 -- PC133: standard Lua ipairs第三返回值；本模块未见覆盖ipairs的赋值
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData(T7)
    end

    local uiParent = GUI:Attach_UITop(T7)

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

    -- PC248：child22 Nested_Anonymous仅捕获UP0(PrintLog)；检查点235确认固定参数为promptText/successCallback，分别映射T[0]/T[1]，T[2]=nil。
    -- PC250-PC258：child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]。
    local nestedAnonymous = make_Nested_Anonymous(UPVALUE_0) -- child22主体已并入；固定参数槽已由检查点235闭合：T[0]=promptText、T[1]=successCallback、T[2]=nil；错误分支的nil调用按原字节码保留。
    local openBlacklistDistanceInput = make_Nested_Helper_4(
        nestedAnonymous, UPVALUE_10, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_13, blacklistTimerCallback, syncButtonState
    ) -- child11 Nested_Helper_4主体已在本文件上方恢复
    -- PC259-PC267：child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]。
    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous, UPVALUE_14, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_15, initGatherCallback, syncButtonState
    ) -- child14 Nested_Helper_7主体已在本文件上方恢复

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
return doInit_UI
end -- make_doInit_UI


-- ---------------------------------------------------------------------------
-- 检查点202：Attach_UITop调用实参复核（root.children[42] PC181-PC183）。
-- PC181-PC182先取GUI.Attach_UITop方法；PC183为OP_068 A=6 B=7，
-- 因而按VM调用约定传递当前帧T[7]..T[13]共七个显式实参。
-- 紧邻的PC178-PC180先取NPCStorageProxy.RequestStorageData，
-- PC180同样以OP_358 A=6 B=7调用，消费同一组T[7]..T[13]。
-- 这证明两个调用共享同一参数槽区间及顺序，但不能证明七槽业务名称、
-- 值类型或最初生产者；缺少明确写槽证据前不命名、不改写。
-- 开发文档GUI/常用方法.md定义Attach_UITop()无必需参数；字节码仍传T7=0，保留这个额外实参。RequestStorageData未见于开发文档，按引擎内部对象方法原样保留。
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
-- Standard Lua ipairs returns iterator, table, 0. No module assignment overriding ipairs was found; T7 is therefore represented as 0, while target-host runtime remains unverified.

  local __exports = {}
  if make_doInit_UI ~= nil then __exports["make_doInit_UI"] = make_doInit_UI end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第六十三批.lua"] = __exports
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
    installDamageHookCell,
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
    local function BlacklistPlayerDetection()
        featureState.isBlacklisting = true
        -- OP_387 live-cell适配：按T[57]共享cell当前值调用安装器。
        installDamageHookCell.value()

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
    return BlacklistPlayerDetection
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
-- 来源文件：04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua
-- 检查点254：仅整合root.children[32]/[33]两个短闭包工厂，按根寄存器映射注入。
-- ============================================================================
do
-- root.children[57] / legacy root/58 / PlayerPos
-- Complete static reconstruction; not runtime-validated.
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end

-- root.children[32] / legacy root/33 / anonymous forwarding wrapper.
-- UP[0] captures root T[46]; UP[1] captures root T[42].
-- The bytecode forwards exactly the first vararg after the captured argument.
local function make_AnonymousHelper_32(upvalue0, upvalue1)
    return function(arg1)
        return upvalue0(upvalue1, arg1)
    end
end

-- root.children[33] / legacy root/34 / anonymous forwarding wrapper.
-- UP[0] captures root T[45]; UP[1] captures root T[43].
local function make_AnonymousHelper_33(upvalue0, upvalue1)
    return function()
        return upvalue0(upvalue1)
    end
end

  local __exports = {}
  if make_AnonymousHelper_32 ~= nil then __exports["make_AnonymousHelper_32"] = make_AnonymousHelper_32 end
  if make_AnonymousHelper_33 ~= nil then __exports["make_AnonymousHelper_33"] = make_AnonymousHelper_33 end
  MainLeftBottomRecovered.sources["04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root47_BlacklistPlayerDetection.lua
-- 检查点255：UP1接入root T[57]共享live-cell；PC360写入InstallDamageHook后PC368捕获。
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
--   UP[1]  root T[57] live cell; PC360 writes InstallDamageHook before PC368 captures it
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
    installDamageHookCell,
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
    local function BlacklistPlayerDetection()
        featureState.isBlacklisting = true
        -- Dereference the same parent T[57] cell captured at PC368.
        installDamageHookCell.value()

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
    return BlacklistPlayerDetection
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
  if make_BlacklistPlayerDetection ~= nil then
    __exports["make_BlacklistPlayerDetection"] = make_BlacklistPlayerDetection
  end
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

local make_Nested_JsonDecode

local function make_onDamageMsg(blacklistState)
    return function(arg1, messageJson)
        -- fixed_param_count=2; PC1/PC3 gate on the second fixed parameter.
        if not messageJson or messageJson == "" then
            return
        end

        -- PC 6-16: decode the JSON under pcall; require a table result.
        -- root.children[52].children[0]：捕获父帧T[0] cell；父PC8随后将T[0]改写为第二固定参数messageJson。
        local decodeInput = arg1
        local function decodeMessage()
            local jsonDecode = SL.JsonDecode
            return jsonDecode(decodeInput)
        end
        -- OP_387 captured the parent T[0] cell; PC8 then overwrites T[0] with T[1].
        decodeInput = messageJson
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
--[[
函数：doInit_UI | 原型索引52 | root.children[42] | legacy root/43
物理指令419 | 常量105 | 子原型23 | vararg_flag=0
完整静态恢复（检查点187/199/200/201/203/204/208/226；PC1-PC419全部映射；根工厂显式接收20项捕获。T7按标准Lua ipairs第三返回值取0；Nested_Anonymous的T2来源作为独立子原型继续待核验；未运行时验证。
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
    local function Nested_Helper()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空怪物阈值")
            printLog("已清空怪物阈值存档：%s", detail)
        else
            notify("清空怪物阈值失败")
            printLog("清空怪物阈值失败：%s", detail)
        end
    end
    return Nested_Helper
end

local function make_Nested_s(checkCallback, checkArgument, notify, printLog)
    local function Nested_s()
        local success, detail = checkCallback(checkArgument)
        if success then
            notify("已清空黑名单距离")
            printLog("已清空黑名单距离存档：%s", detail)
        else
            notify("清空黑名单距离失败")
            printLog("清空黑名单距离失败：%s", detail)
        end
    end
    return Nested_s
end

local function make_Nested_Helper_5(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveDistance, setButtonState
)
    local function Nested_Helper_5(value)
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
    return Nested_Helper_5
end

local function make_Nested_Helper_8(
    validateValue, notify, formatCallback, resolveFailureContext,
    failureContext, saveThreshold, setButtonState
)
    local function Nested_Helper_8(value)
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
    return Nested_Helper_8
end

local function make_Nested_Helper_4(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveDistance, setButtonState
)
    local function Nested_Helper_4()
        local callback = make_Nested_Helper_5(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveDistance, setButtonState
        )
        openDialog("请输入黑名单的距离格子（数字，按线路计算）", callback)
    end
    return Nested_Helper_4
end

local function make_Nested_Helper_7(
    openDialog, validateValue, notify, formatCallback,
    resolveFailureContext, failureContext, saveThreshold, setButtonState
)
    local function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            validateValue, notify, formatCallback, resolveFailureContext,
            failureContext, saveThreshold, setButtonState
        )
        openDialog("请输入拉怪的怪物数量阈值（数字）", callback)
    end
    return Nested_Helper_7
end

-- ---------------------------------------------------------------------------
-- root.children[42].children[22] / Nested_Anonymous
-- 8条父原型指令；fixed_param_count=2；child0 Nested_str 27条，内含Nested_match与Nested_Helper_11。
-- 原始VM调用帧已证明T[0]=promptText、T[1]=successCallback、T[2]=nil。
-- ---------------------------------------------------------------------------
local function make_Nested_Anonymous(PrintLog)
    return function(promptText, successCallback)
        -- 原始VM调用帧M已确认：本原型fixed_param_count=2。
        -- 两个固定参数分别进入新建帧表T[0]、T[1]；额外实参进入独立X表。
        -- T[2]没有任何写入指令，因此该槽确定为nil。
        local T0_SLOT = promptText
        local T1_SLOT = successCallback
        local T2_SLOT = nil

        -- child0 Nested_str捕获顺序：
        -- UP[0] <- T[0]；UP[1] <- 父UP[0](PrintLog)；
        -- UP[2] <- T[2](nil)；UP[3] <- T[1](successCallback)。
        local function Nested_str(optionalSuffix)
            local dialogParams = {
                btnType = 2,
                showEdit = true,
                editParams = {
                    inputMode = 2,
                    maxLength = 6,
                },
            }

            local initialText = T0_SLOT
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
                    T1_SLOT(numericValue)
                    return
                end

                PrintLog(
                    "%s：参数格式不对（%s）",
                    initialText,
                    tostring(editStr)
                )

                local function Nested_Helper_11()
                    -- 保留原字节码的直接调用。T[2]确定为nil，
                    -- 因而该错误提示分支会触发attempt-to-call-nil；
                    -- 不补造第三回调，也不增加原字节码没有的保护。
                    T2_SLOT("参数格式不对，请输入数字")
                end

                SL:ScheduleOnce(Nested_Helper_11, 0.1)
            end

            dialogParams.callback = Nested_match
            SL:OpenCommonTipsPop(dialogParams)
        end

        -- Nested_str固定参数数为1，但PC6-PC7以空实参区间调用它，optionalSuffix=nil。
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
    local function Nested_UnSchedule()
        printLog("点击空白,关闭资源信息窗口")

        if timerState.resTimer then
            SL:UnSchedule(timerState.resTimer)
            -- VM dump中的['unknown',2]尚未确认等价nil；保留占位。
            timerState.resTimer = nil
        end

        GUI:Win_Close(moduleState.resWin)
    end
    return Nested_UnSchedule
end

-- child2 Nested_FFFFFF：65条，捕获[resList,screenW*0.6]。
local function make_Nested_FFFFFF(listView, cellWidth)
    local function Nested_FFFFFF(resourceNames, layoutOption, rowType)
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
    return Nested_FFFFFF
end

-- child3 Nested_Helper_3：168条，捕获10项。
local function make_Nested_Helper_3(
    moduleState, timerState, curTimeText, durTimeText, initState,
    moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
)
    local function Nested_Helper_3()
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
    return Nested_Helper_3
end

-- 父原型Nested_FFFF00：320条，捕获[moduleState,printLog,timerState,initState]。检查点207逐PC复审PC1-PC320，修正五处Text_Create返回值门控。
local function make_Nested_FFFF00(moduleState, printLog, timerState, initState)
    local function Nested_FFFF00()
        local gui = GUI
        local sl = SL

        -- PC1-PC27：窗口已存在则关闭；resTimer取消后清为nil；检查点225确认K[28]=["unknown",2]是nil的VM dump序列化占位。
        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = nil
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
    return Nested_FFFF00
end


local function make_Nested_StopGatherMonsters(
    timerState, notify, canStartGather, logNotice,
    openThresholdInput, applyGatherState
)
    local function Nested_StopGatherMonsters()
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
    return Nested_StopGatherMonsters
end

local function make_Nested_LuaSendMsg(counter, modulus, messageEntries)
    local function Nested_LuaSendMsg()
        counter = counter + 1
        local index = (counter - 1) % modulus + 1
        local entry = messageEntries[index]
        if not entry then return end

        LuaSendMsg(9002, entry[1], 1.0, 2.0, 3.0, entry[2], entry[3])
    end
    return Nested_LuaSendMsg
end

local function make_Nested_SL_2(timerState, notify, modulus, messageEntries, scheduleContext)
    local function Nested_SL_2()
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
    return Nested_SL_2
end

local function make_Nested_ClearBlacklistItems(notify)
    local function Nested_ClearBlacklistItems()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
    return Nested_ClearBlacklistItems
end

local function make_Nested_blacklistTimer(
    config, getDistance, timerState, schedule, formatNotice
)
    local function Nested_blacklistTimer(distance)
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
    return Nested_blacklistTimer
end

local function make_Nested_Helper_10(
    timerState, notify, moduleState, readBlacklistDistance,
    openBlacklistDistanceInput, startBlacklistTimer
)
    local function Nested_Helper_10()
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
    return Nested_Helper_10
end

local function make_Nested_SL_3(timerState, notify, featureState, schedule)
    local function Nested_SL_3()
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
    return Nested_SL_3
end

local function make_Nested_TakeItems(timerState, notify, featureState, schedule)
    local function Nested_TakeItems()
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
    return Nested_TakeItems
end

local function make_Nested_shiquTimer(timerState, notify, schedule)
    local function Nested_shiquTimer()
        if timerState.shiquTimer then
            notify("关闭拾取物品")
            SL:UnSchedule(timerState.shiquTimer)
            timerState.shiquTimer = nil
            return
        end
        notify("开启拾取物品")
        timerState.shiquTimer = schedule(PickUpItems, 0.01)
    end
    return Nested_shiquTimer
end

local function make_Nested_dropTimer(timerState, notify, featureState, schedule)
    local function Nested_dropTimer()
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
    return Nested_dropTimer
end

local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

local function make_Nested_Helper_9(uiState, notify)
    local function Nested_Helper_9()
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
    return Nested_Helper_9
end

local function make_Nested_InitGatherMonsters(config, getThreshold)
    local function Nested_InitGatherMonsters(threshold)
        if not threshold then threshold = getThreshold() end
        config.GATHER_THRESHOLD = threshold
        if not config.GATHER_THRESHOLD then return false end
        InitGatherMonsters()
        return true
    end
    return Nested_InitGatherMonsters
end

local function make_Nested_04d_02d_02d(lastSentDate, messageSender, notify)
    local function Nested_04d_02d_02d()
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
    return Nested_04d_02d_02d
end

local function make_Nested_ffffff(buttonConfigs, buttonByKey)
    local function Nested_ffffff(key, toggled)
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
    return Nested_ffffff
end

local function make_doInit_UI(upvalue0, upvalue1, upvalue2, upvalue3, upvalue4, upvalue5, upvalue6, upvalue7, upvalue8, upvalue9, upvalue10, upvalue11, upvalue12, upvalue13, upvalue14, upvalue15, upvalue16, upvalue17, upvalue18, upvalue19)
    local function doInit_UI()
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
        upvalue0, upvalue1, upvalue2, upvalue3, upvalue4
    local UPVALUE_5, UPVALUE_6, UPVALUE_7, UPVALUE_8, UPVALUE_9 =
        upvalue5, upvalue6, upvalue7, upvalue8, upvalue9
    local UPVALUE_10, UPVALUE_11, UPVALUE_12, UPVALUE_13, UPVALUE_14 =
        upvalue10, upvalue11, upvalue12, upvalue13, upvalue14
    local UPVALUE_15, UPVALUE_16, UPVALUE_17, UPVALUE_18, UPVALUE_19 =
        upvalue15, upvalue16, upvalue17, upvalue18, upvalue19

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
        UPVALUE_2.cruiseTimer = nil
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
    local T7 = 0 -- PC133: standard Lua ipairs第三返回值；本模块未见覆盖ipairs的赋值
    local storageProxy = global.Facade:retrieveProxy(global.ProxyTable.NPCStorageProxy)
    if storageProxy then
        storageProxy:RequestStorageData(T7)
    end

    local uiParent = GUI:Attach_UITop(T7)

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

    -- PC248：child22 Nested_Anonymous仅捕获UP0(PrintLog)；主体已并入上方工厂。fixed_param_count=2，T[0]/T[1]分别对应两个调用实参，T[2]=nil。
    -- PC250-PC258：child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]。
    local nestedAnonymous = make_Nested_Anonymous(UPVALUE_0) -- child22主体已并入；固定参数槽已由检查点235闭合：T[0]=promptText、T[1]=successCallback、T[2]=nil；错误分支的nil调用按原字节码保留。
    local openBlacklistDistanceInput = make_Nested_Helper_4(
        nestedAnonymous, UPVALUE_10, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_13, blacklistTimerCallback, syncButtonState
    ) -- child11 Nested_Helper_4主体已在本文件上方恢复
    -- PC259-PC267：child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]。
    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous, UPVALUE_14, UPVALUE_11, UPVALUE_0,
        UPVALUE_12, UPVALUE_15, initGatherCallback, syncButtonState
    ) -- child14 Nested_Helper_7主体已在本文件上方恢复

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
return doInit_UI
end -- make_doInit_UI


-- ---------------------------------------------------------------------------
-- 检查点202：Attach_UITop调用实参复核（root.children[42] PC181-PC183）。
-- PC181-PC182先取GUI.Attach_UITop方法；PC183为OP_068 A=6 B=7，
-- 因而按VM调用约定传递当前帧T[7]..T[13]共七个显式实参。
-- 紧邻的PC178-PC180先取NPCStorageProxy.RequestStorageData，
-- PC180同样以OP_358 A=6 B=7调用，消费同一组T[7]..T[13]。
-- 这证明两个调用共享同一参数槽区间及顺序，但不能证明七槽业务名称、
-- 值类型或最初生产者；缺少明确写槽证据前不命名、不改写。
-- 开发文档GUI/常用方法.md定义Attach_UITop()无必需参数；字节码仍传T7=0，保留这个额外实参。RequestStorageData未见于开发文档，按引擎内部对象方法原样保留。
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
-- 原始VM调用帧M将前两个固定参数写入T[0]/T[1]，额外参数写入独立X表；
-- 因此T[0]=promptText、T[1]=successCallback，T[2]从新建T表中保持nil。
-- ---------------------------------------------------------------------------


-- Checkpoint 205: T[6] producer narrowed to doInit_UI PC90 OP_359.
-- PC90 calls the function in R4 with the single argument T[5] and stores returns in T[4..T[6]].
-- PC133 later reads T[6] as its sole argument to ipairs. No explicit T[6] write was found
-- between PC90 and PC133. Thus T[6] is PC90's third return value, not an arbitrary stale slot.
-- Standard Lua ipairs returns iterator, table, 0. No module assignment overriding ipairs was found; T7 is therefore represented as 0, while target-host runtime remains unverified.

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

local function make_StorageItems(storageState, notify, output, makeNestedIsOutputted, makeFindAvailableStoragePage)
    local function StorageItems()
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
        local findAvailablePage = makeFindAvailableStoragePage(
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
        local isOutputted = makeNestedIsOutputted(storageState, notify)

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
    return StorageItems
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

-- root.children[2] / legacy root/3：构造可写目录路径。
-- PC7读取首个可变参数；PC8拼接顺序为 writablePath .. path；PC9返回。
-- vararg_flag=1，额外参数未读取，保留原可变参数形式。
local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return writablePath .. path
end

do
    local __exports = { GetWritablePath = GetWritablePath }
    MainLeftBottomRecovered.sources["04_源码候选/root2_GetWritablePath.lua"] = __exports
end

-- root/5：取得当前视野中的全部地面掉落物；返回管理器接口给出的两个返回值。
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root.children[23] / legacy root/24：六组设置开关与提示回调。
-- UPVALUE[0]的原始业务名称未知；只按字节码确认的单文本参数契约命名。
local function make_Builtsetting(onSettingMessage)
    return function()
        CHANGE_SETTING(27, { 0 })
        onSettingMessage("关闭背景音乐")

        CHANGE_SETTING(52, { 0 })
        onSettingMessage("关闭游戏音乐")

        CHANGE_SETTING(1002, { 0 })
        onSettingMessage("关闭高帧率")

        CHANGE_SETTING(57, { 1 })
        onSettingMessage("开启人物简装")

        CHANGE_SETTING(58, { 1 })
        onSettingMessage("开启怪物简装")

        CHANGE_SETTING(2005, { 0 })
        onSettingMessage("关闭屏蔽怪物")
    end
end

do
    local __exports = { make_Builtsetting = make_Builtsetting }
    MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第四十五批.lua"] = __exports
end



-- root.children[8] / legacy root/9：FormatStateChange。
-- UPVALUE[0]=PrintLog；UPVALUE[1]=currentState共享单元。
-- 此工厂是单原型恢复表达；最终根模块装配时必须让它与MainLoop绑定同一状态cell。
local function make_FormatStateChange(logger, currentStateCell)
    return function(newState, ...)
        local message = string.format(
            "状态切换: %s -> %s",
            currentStateCell.value,
            newState
        )
        logger(message)
        currentStateCell.value = newState
    end
end
local __makeRoot9 = make_FormatStateChange

do
    local __exports = { make_FormatStateChange = make_FormatStateChange }
    MainLeftBottomRecovered.sources["04_源码候选/root8_FormatStateChange.lua"] = __exports
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

-- root.children[52].children[0] / legacy root/53/1：
-- 工厂参数代表子原型捕获的父级T[3]；字节码PC1-PC4明确为SL.JsonDecode(jsonText)点调用。
make_Nested_JsonDecode = function(jsonText)
    return function()
        local jsonDecode = SL.JsonDecode
        return jsonDecode(jsonText)
    end
end

-- 独立调用适配器；保留同一字节码确认的点调用形式。
local function __root53_1(jsonText)
    local jsonDecode = SL.JsonDecode
    return jsonDecode(jsonText)
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
  if make_Nested_JsonDecode ~= nil then __exports["make_Nested_JsonDecode"] = make_Nested_JsonDecode end
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



-- ============================================================================
-- 来源文件：04_源码候选/root9_ReadNumericConfig.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- root.children[9] / legacy root/10
-- Reconstruction name: ReadNumericConfig
-- 45 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = GetWritablePath closure (root.children[2]), captured at root PC298.

local function make_ReadNumericConfig(GetWritablePath)
    return function(fileName)
        -- fixed_param_count=1; fileName is the sole fixed parameter.

        -- PC 1-4: acquire the FileUtils singleton before resolving the path.
        local fileUtils = cc.FileUtils:getInstance()

        -- PC 5-7: resolve the supplied path through the captured helper.
        local fullPath = GetWritablePath(fileName)

        local fileExists = fileUtils:isFileExist(fullPath)
        if not fileExists then
            -- PC 11-14: clear the return slot and return nil.
            return nil
        end

        -- PC 15-20: read the file contents and inspect its Lua type.
        local content = fileUtils:getStringFromFile(fullPath)
        if type(content) ~= "string" then
            -- PC 21-24: clear the return slot and return nil.
            return nil
        end

        -- PC 25-36: remove all Lua whitespace, then test for ASCII digits only.
        local normalized = string.gsub(content, "%s", "")
        local isUnsignedInteger = string.match(normalized, "^%d+$")

        -- PC 41-43: a matching digit string is converted and returned as a number.
        if isUnsignedInteger then
            return tonumber(normalized)
        end

        -- PC 37-40: failed pattern match clears the return slot and returns nil.
        return nil
    end
end

-- Static reconstruction notes:
-- * Parent root PC297 creates GetWritablePath (root.children[2]) with no captures;
--   root PC298 creates this closure and PC299 captures that helper as UP[0].
-- * Root PC295 supplies the filename "blacklist_distance.txt" to a wrapper
--   closure created at root PC304. That wrapper captures this function and the
--   filename at PC305-PC306, then calls ReadNumericConfig(fileName) and forwards
--   its return values. The wrapper is root.children[49] / AnonymousHelper_49.
-- * The false isFileExist branch, non-string file-read branch, and failed
--   digit-pattern branch each clear the return slot before returning nil.
-- * Only a non-empty sequence of ASCII decimal digits reaches tonumber.
-- * fixed_param_count=1; fileName is the sole fixed parameter; additional arguments are unused.
-- * GetWritablePath is independently complete-static at checkpoint 127: it returns writablePath .. fileName.
-- * No target-runtime validation; FileUtils behavior remains host-dependent.

  local __exports = {}
  if make_ReadNumericConfig ~= nil then __exports["make_ReadNumericConfig"] = make_ReadNumericConfig end
  MainLeftBottomRecovered.sources["04_源码候选/root9_ReadNumericConfig.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第十二批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- MainLeftBottom(2).lua - short helper drafts, batch 12
-- Contains mixed-status helper reconstructions; see each function's status comment. None are runtime-validated.
-- Local names are reconstruction names, not claimed original identifiers.

-- root.children[11] / legacy root/12 / DistanceCalculation
-- Status: complete static reconstruction; not runtime-validated.
-- 25 physical instruction records; PC1-PC23 active path is fully mapped, PC24-PC25 are unreachable tail returns.
-- Returns a large sentinel when either point is absent.
local function DistanceCalculation(pointA, pointB)
    if not pointA then
        return 99999
    end
    if not pointB then
        return 99999
    end

    local dx = math.abs(pointA.x - pointB.x)
    local dy = math.abs(pointA.y - pointB.y)
    return math.max(dx, dy)
end

-- root.children[14] / legacy root/15 / FindMonsterInCurrViewField
-- Intentionally not drafted in this batch: its captured predicate's identity
-- and the precise SL method contract need a separate pass.

-- root.children[31] / legacy root/32 / IsInWhitelistMap
-- Status: complete static reconstruction; not runtime-validated.
-- 28 physical instruction records; PC1-PC27 active path, PC28 is a tail return after PC27.
-- The explicit whitelist contains only 土城.
local function IsInWhitelistMap()
    if SL:GetMetaValue("IN_SAFE_AREA") then
        return true
    end

    local mapName = SL:GetMetaValue("MAP_NAME")
    local whitelist = { "土城" }

    for _, allowedMapName in ipairs(whitelist) do
        if mapName == allowedMapName then
            return true
        end
    end

    return false
end

-- root.children[35] / legacy root/36 / SetTargetID
-- Status: complete static reconstruction; not runtime-validated.
-- Vararg flag is set, but only the first argument is read by the body.
local function SetTargetID(targetID)
    if not global.Facade then
        return false
    end

    local playerInputProxy =
        global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)

    if not playerInputProxy then
        return false
    end

    playerInputProxy:SetTargetID(
        targetID,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
    return true
end

  local __exports = {}
  if DistanceCalculation ~= nil then __exports["DistanceCalculation"] = DistanceCalculation end
  if IsInWhitelistMap ~= nil then __exports["IsInWhitelistMap"] = IsInWhitelistMap end
  if SetTargetID ~= nil then __exports["SetTargetID"] = SetTargetID end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第十二批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第十三批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- MainLeftBottom(2).lua - short function drafts, batch 13
-- Status: first-pass readable Lua drafts; static review pending; not runtime-validated.
-- Canonical paths use zero-based root.children[n].
-- Captured values are represented by factory parameters where their original local names
-- are not established. These are reconstruction names, not recovered source identifiers.

-- root.children[10] / legacy root/11 / SetButtonVisibilityState
-- Status: complete static reconstruction; not runtime-validated.
-- Captures: UP[0]=root T[0] (state object), UP[1]=root T[1] (button map).
local function make_SetButtonVisibilityState(moduleState, buttonMap)
    return function()
        -- PC 1-2: set the captured module/UI state flag.
        moduleState.isHidden = true

        -- PC 3-14: walk buttonMap keys and make each mapped GUI element visible.
        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end

-- root.children[26] / legacy root/27 / ResetGatherMonsterData
-- Status: complete static reconstruction; not runtime-validated.
-- Captures (in slot order): root T[15], T[16], T[17], T[25], T[19],
-- T[20], T[21], T[22], T[4]. T[4] is PrintLog; most state-cell names remain neutral.
local function make_ResetGatherMonsterData(
    resetTableCell,
    zeroCell1,
    zeroCell2,
    resetAction,
    zeroCell3,
    zeroCell4,
    zeroCell5,
    emptyStringCell,
    printLog
)
    return function()
        -- PC 1-2: replace the captured table with a fresh table.
        resetTableCell.value = {}

        -- PC 3-6 and PC 10-17: clear captured numeric/string cells.
        zeroCell1.value = 0
        zeroCell2.value = 0

        -- PC 7-8: invoke the captured no-argument reset action.
        resetAction()

        zeroCell3.value = 0
        zeroCell4.value = 0
        zeroCell5.value = 0
        emptyStringCell.value = ""

        -- PC 18-20: report completion.
        printLog("数据已重置")
    end
end

-- root.children[27] / legacy root/28 / StopGatherMonsters
-- Status: complete static reconstruction; not runtime-validated.
-- Captures (in slot order): root T[18], T[3], T[25], T[23], T[13], T[35], T[4].
local function make_StopGatherMonsters(
    runningFlag,
    timerState,
    preStopAction,
    setGatherState,
    gatherStates,
    resetGatherMonsterData,
    printLog
)
    return function()
        -- PC 1-2: clear the captured running flag.
        runningFlag.value = false

        -- PC 3-13: cancel and clear the gather timer if one exists.
        local timer = timerState.gatherTimer
        if timer then
            SL:UnSchedule(timer)
            timerState.gatherTimer = nil
        end

        -- PC 14-24: reset related state, transition to IDLE, and notify.
        preStopAction()
        setGatherState(gatherStates.IDLE)
        resetGatherMonsterData()
        printLog("引怪功能已停止")
    end
end

-- root.children[14] / legacy root/15 / FindMonsterInCurrViewField
-- Captures UP[0]=root T[30], which is the previously reconstructed IsDie helper.
local function make_FindMonsterInCurrViewField(isAlive)
    return function()
        -- PC 1-8: request the current view-field list; false/nil becomes an empty list.
        local monsters = SL:FindMonsterInCurrViewField(true, true)
        if not monsters then
            monsters = {}
        end

        -- PC 9-26: retain actors accepted by the captured predicate and with a truthy ID.
        local result = {}
        for _, actor in ipairs(monsters) do
            if isAlive(actor) then
                local actorID = actor:GetID()
                if actorID then
                    result[actorID] = actor
                end
            end
        end

        return result
    end
end

-- Review notes:
-- * SetButtonVisibilityState's captured table is traversed with pairs; GUI:setVisible
--   receives the mapped value and true. The captured names are intentionally generic.
-- * ResetGatherMonsterData performs captured-cell assignments in VM slot order.
--   resetAction and notify are retained as generic callbacks because their business
--   identities are not proven by this prototype alone.
-- * StopGatherMonsters clears the running flag, conditionally cancels gatherTimer,
--   invokes the captured pre-stop action, sets IDLE, calls the reset helper, then notifies.
-- * FindMonsterInCurrViewField calls SL:FindMonsterInCurrViewField(true, true), applies
--   captured IsDie (whose established truthy result denotes an alive actor), then indexes
--   the result by actor:GetID().
-- * SetButtonVisibilityState, ResetGatherMonsterData, and StopGatherMonsters remain
--   first-pass drafts. FindMonsterInCurrViewField was independently checked against
--   all 27 physical PCs and its captured IsDie helper; it is complete static
--   reconstruction (not runtime-validated). Original local names are not claimed.

  local __exports = {}
  if make_SetButtonVisibilityState ~= nil then __exports["make_SetButtonVisibilityState"] = make_SetButtonVisibilityState end
  if make_ResetGatherMonsterData ~= nil then __exports["make_ResetGatherMonsterData"] = make_ResetGatherMonsterData end
  if make_StopGatherMonsters ~= nil then __exports["make_StopGatherMonsters"] = make_StopGatherMonsters end
  if make_FindMonsterInCurrViewField ~= nil then __exports["make_FindMonsterInCurrViewField"] = make_FindMonsterInCurrViewField end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第十三批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第十四批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- MainLeftBottom(2).lua - short function drafts, batch 14
-- Status: readable first-pass reconstruction. Static review pending; not runtime-validated.
-- Canonical zero-based paths are shown alongside legacy one-based labels.
-- Generic upvalue parameter names are deliberate where closure slots are not fully named.

-- root.children[36] / legacy root/37 / GetAvailableStoragePage
-- 51条指令；1项捕获：root PC68捕获父root T[4]，此处按用途命名为notify。
-- 检查点190：PC1-PC51完整静态复核；未运行时验证。
local function make_GetAvailableStoragePage(notify)
    return function()
        local storageProxy = NPCStorageProxy
        if not storageProxy then
            notify("仓库代理未初始化")
            return
        end

        local maxPage = storageProxy:GetMaxPage()

        -- PC15-PC48：升序扫描每一页，返回第一个仍有可用格子的页码。
        for page = 1, maxPage do
            local pageData = storageProxy:GetStorageDataByPage(page)
            local currentCount = 0
            if pageData then
                currentCount = #pageData
            end

            -- 每轮均读取配置容量；配置为假值时回退MMO的单页容量常量。
            local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
            if not pageCapacity then
                pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE
            end

            local openSize = storageProxy:GetOpenSize()
            local remainingOpenSize =
                openSize - (page - 1) * pageCapacity

            -- PC39-PC41：单页上限=min(单页配置容量, 尚余开放格数)。
            local pageLimit = remainingOpenSize
            if pageCapacity < remainingOpenSize then
                pageLimit = pageCapacity
            end

            -- PC42-PC47：页上限必须大于0，且必须大于当前占用数；
            -- 命中后立即返回当前页码。
            if pageLimit > 0 and pageLimit > currentCount then
                return page
            end
        end

        -- PC49-PC51：遍历耗尽时无显式返回值（nil）。
        return
    end
end

-- root.children[37] / legacy root/38 / DestroyUI
-- Status: complete static reconstruction; not runtime-validated.
-- Captures: UP[0]=root T[0] UI state; UP[1]=root T[3] timer state;
-- UP[2]=root T[1] button map.
local function make_DestroyUI(uiState, timerState, buttonMap)
    return function()
        uiState.isHidden = false

        local timer = timerState.resTimer
        if timer then
            SL:UnSchedule(timer)
            timerState.resTimer = nil
        end

        uiState.resWin = nil
        GUI:Win_CloseAll()

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end

-- root.children[40] / legacy root/41 / ShowHideAllButtons
-- Status: complete static reconstruction; not runtime-validated.
-- Captures: UP[0]=root T[3] timer state; UP[1]=root T[1] button map;
-- UP[2]=root T[0] UI state containing the single hidebut control.
local function make_ShowHideAllButtons(timerState, buttonMap, uiState)
    return function()
        if timerState.rewardTimer then
            SL:UnSchedule(timerState.rewardTimer)
            timerState.rewardTimer = nil
        end

        if timerState.cruiseTimer then
            SL:UnSchedule(timerState.cruiseTimer)
            timerState.cruiseTimer = nil
        end

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end

        if uiState.hidebut then
            GUI:setVisible(uiState.hidebut, false)
            uiState.hidebut = nil
        end
    end
end

-- Review notes:
-- * GetAvailableStoragePage在检查点190已逐PC闭合：逐页取#pageData或0，按min(pageCapacity,openSize-(page-1)*pageCapacity)计算页上限，首个pageLimit>currentCount且pageLimit>0的页码立即返回；无可用页返回nil。
-- * DestroyUI's instruction order is clear: clear isHidden; cancel resTimer if
--   present; nil resTimer/resWin; GUI:Win_CloseAll(); iterate UP[1] and set
--   each mapped control visible.
-- * ShowHideAllButtons cancels rewardTimer and cruiseTimer independently,
--   restores the UP[1] control map, then conditionally hides controls in UP[2]
--   when hidebut is truthy and clears hidebut.
-- * DestroyUI与ShowHideAllButtons保持各自原有静态状态；GetAvailableStoragePage在检查点190升级为完整静态恢复。三者均未运行时验证。

  local __exports = {}
  if make_GetAvailableStoragePage ~= nil then __exports["make_GetAvailableStoragePage"] = make_GetAvailableStoragePage end
  if make_DestroyUI ~= nil then __exports["make_DestroyUI"] = make_DestroyUI end
  if make_ShowHideAllButtons ~= nil then __exports["make_ShowHideAllButtons"] = make_ShowHideAllButtons end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第十四批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root25_DeathAutoBlacklist.lua
-- 检查点253：保留独立工厂词法作用域，由根装配区按捕获顺序实例化。
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
-- 检查点253：保留独立工厂词法作用域，由根装配区按捕获顺序实例化。
-- ============================================================================
do
-- root.children[52] / legacy root/53 / onDamageMsg
-- 72 physical instructions; complete static reconstruction, not runtime-validated.
-- UP[0] = blacklistState (root T[41]); the same table is exposed as MainLeftBottom.blacklist.

local function make_onDamageMsg(blacklistState)
    return function(arg1, messageJson)
        -- fixed_param_count=2; PC1/PC3 gate on the second fixed parameter.
        if not messageJson or messageJson == "" then
            return
        end

        -- PC 6-16: decode the JSON under pcall; require a table result.
        local decodeInput = arg1
        local function decodeMessage()
            local jsonDecode = SL.JsonDecode
            return jsonDecode(decodeInput)
        end
        -- OP_387 captured the parent T[0] cell; PC8 then overwrites T[0] with T[1].
        decodeInput = messageJson

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
-- * fixed_param_count=2; PC1/PC3 check the second parameter for truthy/non-empty.
-- * Nested_JsonDecode captures the parent T[0] cell; PC8 writes T[1] into that cell
--   before pcall, so the child decodes the second fixed parameter messageJson.
-- * The callback stores only blacklistState.lastAttacker; it does not itself
--   request blacklist insertion or schedule any action.
-- * No runtime validation; SL metadata and JSON decoder behavior are host-dependent.

  local __exports = {}
  if make_onDamageMsg ~= nil then __exports["make_onDamageMsg"] = make_onDamageMsg end
  MainLeftBottomRecovered.sources["04_源码候选/root52_onDamageMsg.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第五十四批.lua
-- 检查点253：保留独立工厂词法作用域，由根装配区按捕获顺序实例化。
-- ============================================================================
do
-- 检查点 #78 / #133：ClearBlacklistItems 完整静态恢复
-- root.children[15] / legacy root/16；63条父指令；17常量；1个子原型。
-- 捕获顺序：UP[0]=好友代理getter；UP[1]/UP[2]=两路提示回调；
-- UP[3]=含lastAttacker字段的状态对象。原始局部变量名未知，按调用契约命名。

local function make_ClearBlacklistItems(
    getFriendProxy,
    notifyPrimary,
    notifySecondary,
    attackerState
)
    return function()
        -- PC1-PC7：取得代理并确认_blacklistData存在。
        local friendProxy = getFriendProxy()
        if not friendProxy or not friendProxy._blacklistData then
            notifyPrimary("取不到好友代理，清空失败")
            notifySecondary("清空黑名单失败")
            return
        end

        local blacklistData = friendProxy._blacklistData

        -- PC15-PC24：pairs迭代的第一个返回值（key）被追加到entries。
        local entries = {}
        for key, _value in pairs(blacklistData) do
            entries[#entries + 1] = key
        end

        -- PC25-PC34：空列表时两路提示后返回。
        if #entries == 0 then
            notifyPrimary("黑名单本来就是空的")
            notifySecondary("黑名单为空")
            return
        end

        -- PC35-PC44：通知开始清理及条目数量。
        notifyPrimary(string.format("开始清空黑名单，共 %d 人", #entries))
        notifySecondary("清空黑名单 " .. #entries .. " 人")

        -- PC45-PC60：每个key按(index-1)*0.01秒调度异步移除。
        for index, entryKey in ipairs(entries) do
            local delay = (index - 1) * 0.01
            SL:ScheduleOnce(function()
                -- 子原型root.children[15].children[0]捕获entryKey与friendProxy。
                SL:RequestOutBlacklist(entryKey)
                if friendProxy and friendProxy._blacklistData then
                    friendProxy._blacklistData[entryKey] = nil
                end
            end, delay)
        end

        -- PC61-PC63：清空lastAttacker字段并返回。
        attackerState.lastAttacker = nil
    end
end

-- 静态复核：
-- * pairs循环收集的是第一个迭代返回值，即key，不是value。
-- * 子闭包UP[0]为当前entryKey，UP[1]为friendProxy。
-- * RequestOutBlacklist保留SL接收者；随后删除friendProxy._blacklistData[entryKey]。
-- * ScheduleOnce保留SL接收者，delay=(index-1)*0.01。
-- * UP[3].lastAttacker在调度循环之后写nil。
-- * 63条父指令与13条子指令均已映射；未运行时验证。

  local __exports = {}
  if make_ClearBlacklistItems ~= nil then __exports["make_ClearBlacklistItems"] = make_ClearBlacklistItems end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第五十四批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root22_GetMapData2DPtr.lua
-- root.children[22]捕获T[52]；活动路径不读取捕获值，仍按捕获顺序传入。
-- ============================================================================
do
-- root.children[22] / legacy root/23
-- VM index label: GetMapData2DPtr
-- 144 physical records; no child prototypes; captured UP[0] is not read
-- on the reachable entry path. PC38-PC144 are unreachable after PC37 return.
-- This source models the reachable behavior only; it is not runtime-validated.

local function make_GetMapData2DPtr(unusedCapturedValue)
    return function(x1, y1, x2, y2, maxDistance)
        -- PC1-PC10: all four coordinates and maxDistance must be truthy.
        if not x1 or not y1 or not x2 or not y2 or not maxDistance then
            return nil
        end

        -- PC13-PC18: identical coordinates return numeric zero.
        if x1 == x2 and y1 == y2 then
            return 0.0
        end

        -- PC19-PC22: non-positive range returns nil.
        if maxDistance <= 0 then
            return nil
        end

        -- PC23-PC33: Chebyshev distance.
        local dx = math.abs(x2 - x1)
        local dy = math.abs(y2 - y1)
        local distance = math.max(dx, dy)

        -- PC34-PC37: over-limit distance clears the return slot; PC37 returns.
        if maxDistance < distance then
            return nil
        end

        return distance
    end
end

  local __exports = {}
  if make_GetMapData2DPtr ~= nil then
    __exports["make_GetMapData2DPtr"] = make_GetMapData2DPtr
  end
  MainLeftBottomRecovered.sources["04_源码候选/root22_GetMapData2DPtr.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第三十一批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- 第三十一批：UseItemByIndex
-- 规范路径：root.children[24]
-- 旧标签：root/25
-- 原型索引：32；物理指令：33；常量：8；子原型：0
-- 状态：完整静态恢复；尚未运行时验证。
--
-- 闭包捕获：
--   UP[0] <- 父级 root 的 T[37]（闭包创建点 PC355 后的捕获描述 PC356）。
--   捕获表的业务来源/完整内容仍未追踪；这里使用中性名称 itemNameList。
--
-- 静态控制流：
--   ipairs 遍历捕获表；每项分别查询 ITEM_INDEX_BY_NAME 和 ITEM_COUNT；
--   数量经 tonumber 转换，nil/false 路径归零；
--   只有索引存在且数量大于 0 时才调用 UseItemByIndex；
--   调用后返回当前 itemName；循环耗尽则无值返回。

local function make_UseItemByIndex(itemNameList)
    return function()
        for _, itemName in ipairs(itemNameList) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
            local itemCount = tonumber(
                SL:GetMetaValue("ITEM_COUNT", itemName)
            ) or 0

            if itemIndex and itemCount > 0 then
                SL:UseItemByIndex(itemIndex)
                return itemName
            end
        end
    end
end

  local __exports = {}
  if make_UseItemByIndex ~= nil then __exports["make_UseItemByIndex"] = make_UseItemByIndex end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第三十一批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第三十四批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- 第三十四批：Nested_isOutputted
-- 规范路径：root.children[50].children[0]
-- 旧标签：root/51/1
-- 原型索引：98；物理指令：52；常量：15；子原型：0
-- 状态：完整静态恢复（检查点174）；52条指令、2项捕获和父级调用点已闭合。
-- 尚未运行时验证；父级 UP[0]/UP[1] 的更上层业务原名仍未知。
--
-- 捕获：
--   子 UP[0] = 父 StorageItems 的 UP[0]：具有 isOutputted 字段的共享状态对象。
--   子 UP[1] = 父 StorageItems 的 UP[1]：输出回调。
--   StorageItems PC102 创建闭包，PC103/PC104 按上述顺序捕获父 UP[0]/UP[1]。
--
-- 参数：
--   父 StorageItems PC167-PC170 调用闭包，显式传入当前物品记录 R19 和当前
--   ipairs(R8) 迭代值 R25；对应 item 与 itemText。子原型没有读取额外 vararg。

local function make_Nested_isOutputted(outputState, outputCallback)
    return function(item, itemText)
        if not string.find(itemText, "聚灵珠", 1, true) then
            return true
        end

        if not outputState.isOutputted then
            outputState.isOutputted = true
            outputCallback(item)

            local info = "聚灵珠信息: "
                .. tostring(item.Name)
                .. " StdMode=" .. tostring(item.StdMode)
                .. " Dura=" .. tostring(item.Dura)
                .. " DuraMax=" .. tostring(item.DuraMax)

            outputCallback(info)
        end

        if not item.Dura then
            return false
        end

        if not item.DuraMax then
            return false
        end

        return item.Dura <= item.DuraMax
    end
end

  local __exports = {}
  if make_Nested_isOutputted ~= nil then __exports["make_Nested_isOutputted"] = make_Nested_isOutputted end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第三十四批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第十五批.lua
-- 短函数/辅助闭包集中整合；各工厂参数按对应原型捕获顺序注入。
-- 本段只表示独立原型源码，不代表已完成根模块所有闭包实例化。
-- ============================================================================
do
-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第十五批：4 个短闭包
-- Nested_Helper_11已于检查点112完成静态恢复（未运行时验证）；本文件其他函数仍按各自状态管理。
-- 说明：UPVALUE_n 是闭包捕获槽位占位名，不代表已确认的业务变量名。

-- 原型：root.children[0].children[0]
-- legacy：root/1/1；物理指令：5
-- 检查点171：父root/1 PC17创建闭包，PC18捕获R1=FileUtils实例，
-- PC19捕获R2=路径参数；捕获顺序及两个生产者均已闭合。
-- 子函数仅调用 FileUtils:removeFile(path)，不保留方法返回值。
local function make_Nested_removeFile(fileUtils, path)
    return function()
        fileUtils:removeFile(path)
    end
end

-- 原型：root.children[15].children[0]
-- legacy：root/16/1；物理指令：13
-- 检查点170：父 ClearBlacklistItems PC52 创建闭包，PC53 捕获 R8=当前 entryKey，
-- PC54 捕获 R0=FriendProxy；两个捕获槽位顺序已闭合。
-- 子函数先调用 SL:RequestOutBlacklist(entryKey)，再在 FriendProxy._blacklistData
-- 存在时删除该 key；删除操作是本地数据清理，不改变 RequestOutBlacklist 的参数。
local function make_Nested_SL(entryKey, friendProxy)
    return function()
        SL:RequestOutBlacklist(entryKey)

        if friendProxy._blacklistData then
            friendProxy._blacklistData[entryKey] = nil
        end
    end
end


  local __exports = {}
  if make_Nested_removeFile ~= nil then __exports["make_Nested_removeFile"] = make_Nested_removeFile end
  if make_Nested_SL ~= nil then __exports["make_Nested_SL"] = make_Nested_SL end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第十五批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/小型辅助函数_首批草稿.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- Small helper batch 1: readable static Lua drafts.
-- These are reconstructed from corrected physical-PC disassembly, not original
-- source text. No target-runtime validation has been performed.

-- root.children[13] / legacy root/14 / GetMapId (9 instructions)
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- root.children[29] / legacy root/30 / IsDie (7 instructions)
-- Preserve Lua's short-circuit return behavior: false/nil actor is returned as-is.
local function IsDie(actor)
    return actor and not actor:IsDie()
end

-- root.children[30] / legacy root/31 / GetMapName (9 instructions)
local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

-- root.children[39] / legacy root/40 / GetMainPlayerID (6 instructions)
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- root.children[28].children[0] / legacy root/29/1 / distance comparator
local function CompareDistance(a, b)
    return a._distance < b._distance
end

-- root.children[46].children[0] / legacy root/47/1 / keyword matcher closure
-- The nested prototype captures the keyword array from DiuItems.
local function MakeContainsAnyKeyword(capturedKeywords)
    return function(text)
        for _, keyword in ipairs(capturedKeywords) do
            if string.find(text, keyword, 1, true) then
                return true
            end
        end
        return false
    end
end

  local __exports = {}
  if IsDie ~= nil then __exports["IsDie"] = IsDie end
  if CompareDistance ~= nil then __exports["CompareDistance"] = CompareDistance end
  if MakeContainsAnyKeyword ~= nil then __exports["MakeContainsAnyKeyword"] = MakeContainsAnyKeyword end
  MainLeftBottomRecovered.sources["04_源码候选/小型辅助函数_首批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/PrintLog_日志辅助函数_第七批.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- root.children[16] / legacy root/17 / PrintLog
-- 38 physical instructions; static reconstruction, not runtime-validated.
-- The function is vararg: first argument is the value/message, remaining
-- arguments are optional string.format substitutions.

local function PrintLog(value, ...)
    if type(value) == "table" then
        -- PC6-10: SL.dump(value, "【超本】")
        SL.dump(value, "【超本】")
        return
    end

    -- PC12-14: convert the first argument before optional formatting.
    local message = tostring(value)

    -- PC15-20: count extra arguments. If none, skip the protected format path.
    if select("#", ...) > 0 then
        -- PC21-30: pcall(string.format, message, ...).
        local ok, formatted = pcall(string.format, message, ...)
        if ok and formatted then
            -- PC29 copies the truthy result into a register, but the active
            -- bytecode does not subsequently consume that register.
            message = formatted
        end
    end

    -- PC31-37: test SL and SL.Print existence. There is no call instruction
    -- after the lookup in this prototype; preserve this as an observed no-op
    -- check rather than inventing a Print invocation.
    if SL and SL.Print then
        -- Intentionally empty: no corresponding call exists in the bytecode.
    end
end

  local __exports = {}
  if PrintLog ~= nil then __exports["PrintLog"] = PrintLog end
  MainLeftBottomRecovered.sources["04_源码候选/PrintLog_日志辅助函数_第七批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- PCallHelper and its nested file-write closure.
-- Source prototypes:
--   root.children[17] / legacy root/18 / PCallHelper (14 physical instructions)
--   root.children[17].children[0] / legacy root/18/1 / Nested_tostring (14)
-- Complete static reconstruction; not runtime-validated.

local function make_PCallHelper(capturedOuter)
    return function(arg1, arg0, ...)
        -- Child upvalues:
        --   UP[0] <- parent arg1
        --   UP[1] <- parent capturedOuter
        --   UP[2] <- parent arg0
        local function Nested_tostring()
            local fileUtils = cc.FileUtils:getInstance()
            local payload = tostring(arg1)

            -- OP_252 invokes capturedOuter(arg0), collects all returned values,
            -- and forwards that result window as the final argument list to
            -- writeStringToFile. The method receiver is fileUtils.
            return fileUtils:writeStringToFile(
                payload,
                capturedOuter(arg0)
            )
        end

        -- pcall receives Nested_tostring followed by the original varargs.
        -- Nested_tostring is non-vararg, so extra arguments are ignored.
        local ok, result = pcall(Nested_tostring, ...)

        -- Exact wrapper contract:
        --   pcall error             -> false
        --   successful result false -> false
        --   any other successful result (including nil) -> true
        if not ok or result == false then
            return false
        end
        return true
    end
end

  local __exports = {}
  if make_PCallHelper ~= nil then __exports["make_PCallHelper"] = make_PCallHelper end
  MainLeftBottomRecovered.sources["04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/位置读取函数_第五批草稿.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- Position-reading helper batch 5.
-- Static reconstruction only; no target-runtime validation.

-- root.children[57] / legacy root/58 / PlayerPos (10 physical instructions)
-- PC1-4: SL:GetMetaValue("X") -> first return value.
-- PC5-8: SL:GetMetaValue("Y") -> variable return window.
-- PC9 returns all accumulated values. The Y call is deliberately kept as a
-- multiple-return expression instead of forcing a single result.
local function PlayerPos()
    return SL:GetMetaValue("X"), SL:GetMetaValue("Y")
end

-- root.children[18] / legacy root/19 / GetPlayerPosition (19 physical instructions)
-- Complete static reconstruction from all 19 physical instructions.
-- X and Y are read independently; each false/nil result takes a zero fallback.
-- The fused PC14 sequence constructs the fallback value/table path; PC15-17
-- build the returned coordinate table and assign x/y fields.
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X") or 0
    local y = SL:GetMetaValue("Y") or 0

    return {
        x = x,
        y = y,
    }
end

  local __exports = {}
  if GetPlayerPosition ~= nil then __exports["GetPlayerPosition"] = GetPlayerPosition end
  MainLeftBottomRecovered.sources["04_源码候选/位置读取函数_第五批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/其他短辅助函数_第二批草稿.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- Small helper batch 2: readable static Lua reconstructions.
-- No target-runtime validation has been performed.

-- root.children[4] / legacy root/5 / GetDroppedItems (8 instructions)
-- The method returns both values unchanged; callers decide which result to use.
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root.children[20] / legacy root/21 / ShowLocalNoticeByType (15 instructions)
-- The single upvalue is represented as screenState; its exact original local
-- identifier is not recovered. The helper builds a notice record and forwards
-- that one record to SL.ShowLocalNoticeByType.
local function make_ShowLocalNoticeByType(capturedScreenObject)
    return function(message)
        local notice = {
            Type = 10,
            Msg = message,
            FColor = 249,
            BColor = 0,
            X = 5,
            Y = capturedScreenObject.screenH - 50,
        }

        SL.ShowLocalNoticeByType(notice)
    end
end

-- Capture proof: root initializer creates root.children[20] at root PC46;
-- the immediately following OP_387 capture descriptor selects parent T[0].
-- The object identity is therefore represented as capturedScreenObject; its
-- screenH field and use in Y=screenH-50 are directly observed in the child.

  local __exports = {}
  if make_ShowLocalNoticeByType ~= nil then __exports["make_ShowLocalNoticeByType"] = make_ShowLocalNoticeByType end
  MainLeftBottomRecovered.sources["04_源码候选/其他短辅助函数_第二批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短闭包辅助函数_第三批草稿.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- Small closure/helper batch 3: static readable reconstructions.
-- Captured values are represented as factory parameters; these names are explanatory.

-- root.children[19].children[0] / legacy root/20/1 / Nested_MainLoop
local function Nested_MainLoop()
    MainLoop()
end

-- root.children[25].children[0] / legacy root/26/1 / Nested_RequestAddBlacklistByName
-- UP[0] is an object whose .name field is forwarded to the SL API.
local function make_Nested_RequestAddBlacklistByName(blacklistEntry)
    return function()
        SL:RequestAddBlacklistByName(blacklistEntry.name)
    end
end

-- root.children[42].children[4] / legacy root/43/5 / Nested_OnGameLeaveWorld
local function Nested_OnGameLeaveWorld()
    global.gameWorldController:OnGameLeaveWorld()
end

-- root.children[42].children[13] / legacy root/43/14 / Nested_Helper_6
-- UP[0] is the notification callback captured by the UI initializer.
local function make_Nested_ClearBlacklistItems(notify)
    return function()
        notify("清空黑名单")
        ClearBlacklistItems()
    end
end

  local __exports = {}
  if Nested_MainLoop ~= nil then __exports["Nested_MainLoop"] = Nested_MainLoop end
  if make_Nested_RequestAddBlacklistByName ~= nil then __exports["make_Nested_RequestAddBlacklistByName"] = make_Nested_RequestAddBlacklistByName end
  if Nested_OnGameLeaveWorld ~= nil then __exports["Nested_OnGameLeaveWorld"] = Nested_OnGameLeaveWorld end
  if make_Nested_ClearBlacklistItems ~= nil then __exports["make_Nested_ClearBlacklistItems"] = make_Nested_ClearBlacklistItems end
  MainLeftBottomRecovered.sources["04_源码候选/短闭包辅助函数_第三批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/代理与回调短函数_第四批.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- Short proxy/callback helper batch 4.
-- Reconstructed from corrected physical-PC disassembly; no runtime validation.

-- root.children[49].children[0] / legacy root/50/1 / Nested_FriendProxy
-- No captured upvalues and no explicit parameters.
local function Nested_FriendProxy()
    return global.Facade.retrieveProxy(
        global.ProxyTable.FriendProxy
    )
end

-- root.children[32] / legacy root/33 / AnonymousHelper_33
-- Two captured upvalues are forwarded as a function and its first argument;
-- remaining varargs are forwarded unchanged. Capture identities need parent review.
local function make_AnonymousHelper_33(callback, wrappedFunction)
    return function(...)
        return callback(wrappedFunction, ...)
    end
end

-- root.children[33] / legacy root/34 / AnonymousHelper_34
-- One captured function is called with the second captured value as its sole argument.
local function make_AnonymousHelper_34(callback, argument)
    return function()
        return callback(argument)
    end
end

-- root.children[48] / legacy root/49 / PCallHelper_2 (10 instructions)
-- Executes the zero-argument FriendProxy lookup under pcall. On error it returns
-- nil; on success it returns the child result (false/nil also normalize to nil).
local function PCallHelper_2()
    local ok, result = pcall(Nested_FriendProxy)
    if not ok then
        return nil
    end
    return result or nil
end

  local __exports = {}
  if Nested_FriendProxy ~= nil then __exports["Nested_FriendProxy"] = Nested_FriendProxy end
  if make_AnonymousHelper_33 ~= nil then __exports["make_AnonymousHelper_33"] = make_AnonymousHelper_33 end
  if make_AnonymousHelper_34 ~= nil then __exports["make_AnonymousHelper_34"] = make_AnonymousHelper_34 end
  if PCallHelper_2 ~= nil then __exports["PCallHelper_2"] = PCallHelper_2 end
  MainLeftBottomRecovered.sources["04_源码候选/代理与回调短函数_第四批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第三十七批.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- 第三十七批：短函数普通 Lua 恢复草稿
-- 来源：MainLeftBottom(2).lua VM corrected phase3 disassembly
-- 说明：按真实原型路径与控制流恢复；业务对象类型/作者原始局部变量名不作猜测。
-- 本批包含一个短函数：GetPlayerMapPosition。

----------------------------------------------------------------------
-- 原型索引 89
-- 规范路径：root.children[44]
-- legacy 路径：root/45
-- 17条物理指令；5个常量；无子原型；vararg_flag=1
--
-- 控制流：
-- 1) actor 为 nil/false 时返回 nil；
-- 2) 分别读取 actor.mCurrMapX / actor.mCurrMapY；
-- 3) 对任一假值坐标使用 0 作为默认值；
-- 4) 返回 { x = ..., y = ... }。
--
-- 注意：VM 条件使用 Lua truthiness，而非仅判断 nil。
----------------------------------------------------------------------

local function GetPlayerMapPosition(actor)
    if not actor then
        return nil
    end

    local mapX = actor.mCurrMapX
    if not mapX then
        mapX = 0
    end

    local mapY = actor.mCurrMapY
    if not mapY then
        mapY = 0
    end

    return {
        x = mapX,
        y = mapY,
    }
end

  local __exports = {}
  if GetPlayerMapPosition ~= nil then __exports["GetPlayerMapPosition"] = GetPlayerMapPosition end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第三十七批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/PickUpItems_距离比较闭包_第九批.lua
-- 独立短辅助函数与比较闭包；保留来源及各原型的词法边界。
-- ============================================================================
do
-- PickUpItems short comparator closures.
-- Parent: root.children[21] / legacy root/22 / PickUpItems.
-- Static reconstruction only; no runtime validation.

-- root.children[21].children[0] / legacy root/22/1
-- 19 physical instructions, vararg; compares kIdx first and dist on ties.
local function Nested_dist(a, b)
    if a.kIdx ~= b.kIdx then
        return a.kIdx < b.kIdx
    end
    return a.dist < b.dist
end

-- root.children[21].children[1] / legacy root/22/2
-- 8 physical instructions, vararg; compares dist only.
local function Nested_dist_2(a, b)
    return a.dist < b.dist
end

  local __exports = {}
  if Nested_dist ~= nil then __exports["Nested_dist"] = Nested_dist end
  if Nested_dist_2 ~= nil then __exports["Nested_dist_2"] = Nested_dist_2 end
  MainLeftBottomRecovered.sources["04_源码候选/PickUpItems_距离比较闭包_第九批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第五十三批.lua
-- 独立函数/闭包工厂；保留原型边界与调用参数顺序。
-- ============================================================================
do
-- 检查点 #77 / #132：MoveTo 静态校正
-- root.children[3] / legacy root/4
-- 51 条物理指令；20 个常量；无子原型；vararg_flag=3；零捕获。

local function MoveTo(x, y, range)
    -- PC1-PC6：创建移动通知数据并读取当前地图ID。
    local moveInfo = {
        mapID = SL:GetMetaValue("MAP_ID"),
    }

    -- PC7-PC14：坐标参数先经 tonumber 转换。
    moveInfo.x = tonumber(x)
    moveInfo.y = tonumber(y)

    -- PC15-PC22：设置自动移动类型；range为nil/false时替换为0。
    moveInfo.type = global.MMO.INPUT_MOVE_TYPE_AUTOMOVE
    if not range then
        range = 0
    end
    moveInfo.range = range

    -- PC23-PC30：Facade作为self接收者，发送InputMove通知。
    global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)

    -- PC31-PC32：PlayerPos返回当前玩家X、Y坐标。
    local playerX, playerY = PlayerPos()

    -- PC33-PC38：若X轴差值大于range，直接返回false。
    local deltaX = math.abs(moveInfo.x - playerX)
    if not (deltaX <= moveInfo.range) then
        return false
    end

    -- PC40-PC45：只有X轴通过后才检查Y轴；Y轴差值大于range则false。
    local deltaY = math.abs(moveInfo.y - playerY)
    if not (deltaY <= moveInfo.range) then
        return false
    end

    -- PC47-PC50：两个轴向差值均不超过range时返回true。
    return true
end

-- 静态复核结论：
-- * R0/R1/R2分别对应首三个显式参数x/y/range；vararg标志3保留为原型元数据。
-- * OP362对range执行Lua真值判断：nil/false使用0；0本身为truthy，不会被替换。
-- * PC23-PC30的调用窗口包含Facade接收者、NoticeTable.InputMove和moveInfo。
-- * PC38、PC45均为 <= 比较；结合PC39/46跳转，任一轴超出range即返回false。
-- * PlayerPos的两个返回值顺序为X、Y（与root.children[57]静态候选契约一致）。
-- * 所有51条物理指令已映射；未运行时验证。

  local __exports = {}
  if MoveTo ~= nil then __exports["MoveTo"] = MoveTo end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第五十三批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第三十九批.lua
-- 独立函数/闭包工厂；保留原型边界与调用参数顺序。
-- ============================================================================
do
-- 检查点 #63 / #133：InstallDamageHook 完整静态恢复
-- root.children[6] / legacy root/7；40条指令；9常量；1个子原型。
-- 父闭包捕获2项：UP[0]为模块状态对象（PC31读取后立即被覆盖，未参与后续行为）；
-- UP[1]为挂接完成提示回调。

local function make_InstallDamageHook(_moduleState, notify)
    return function()
        local gameMapController = global.gameMapController
        if not gameMapController then
            return
        end

        local messageHandlers = gameMapController.mNetMsgHandle
        if type(messageHandlers) ~= "table" then
            return
        end

        local messageTypes = global.MsgType
        if not messageTypes then
            return
        end

        local damageMessageType = messageTypes.MSG_SC_DAMAGE_HP
        if not damageMessageType then
            return
        end

        local originalHandler = messageHandlers[damageMessageType]
        if not originalHandler then
            return
        end

        if gameMapController.__ylwHookedOrigin == originalHandler then
            return
        end

        -- 子原型 root.children[6].children[0] 捕获当前控制器与原处理器。
        local wrappedHandler = function(arg1, arg2)
            local optionalCallback = gameMapController.onDamageMsg
            if type(optionalCallback) == "function" then
                pcall(optionalCallback, arg1, arg2)
            end

            -- 无论可选回调是否存在/是否成功，均返回原处理器结果。
            return originalHandler(arg1, arg2)
        end

        -- PC29-PC30取得处理器表并创建包装闭包；PC31读取的UP[0]随后被覆盖。
        -- PC32-PC33：把包装闭包写入控制器的消息处理器表。
        messageHandlers[damageMessageType] = wrappedHandler

        -- PC34-PC36：按字节码原样从originalHandler读取其mNetMsgHandle字段，
        -- 再取damageMessageType对应值，写回originalHandler.__ylwHookedOrigin。
        originalHandler.__ylwHookedOrigin =
            originalHandler.mNetMsgHandle[damageMessageType]

        -- PC37-PC39：调用捕获的提示回调。
        notify("已挂接伤害消息钩子（击杀拉黑用）")
    end
end

-- 独立子原型表达（与上方内联闭包等价）：
local function make_Nested_onDamageMsg(gameMapController, originalHandler)
    return function(arg1, arg2)
        local optionalCallback = gameMapController.onDamageMsg
        if type(optionalCallback) == "function" then
            pcall(optionalCallback, arg1, arg2)
        end
        return originalHandler(arg1, arg2)
    end
end

-- 静态复核：
-- * 父函数PC1-PC28的所有保护返回和幂等判断均保留。
-- * PC31读取UP[0]后PC32立刻覆盖该寄存器；该捕获当前未发现业务效果。
-- * PC33写入目标是gameMapController.mNetMsgHandle[damageMessageType]。
-- * PC34-PC36写入目标不是gameMapController，而是originalHandler.__ylwHookedOrigin；
--   不增加原字节码没有的nil保护。
-- * 子函数18条指令：可选onDamageMsg用pcall调用，随后原处理器(arg1,arg2)的全部返回值直接返回。
-- * 40条父指令及18条子指令均已映射；未运行时验证。

  local __exports = {}
  if make_InstallDamageHook ~= nil then __exports["make_InstallDamageHook"] = make_InstallDamageHook end
  if make_Nested_onDamageMsg ~= nil then __exports["make_Nested_onDamageMsg"] = make_Nested_onDamageMsg end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第三十九批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root50_Nested_Anonymous_2.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- root.children[50].children[1] / legacy root/51/2
-- Reconstruction label: Nested_Anonymous_2
-- 27 physical VM instructions; 4 captured values; no child prototypes.
-- Status: complete static reconstruction after independent review (checkpoint 173);
-- all 27 child instructions, four capture producers, and the parent zero-argument
-- invocation/result-consumption path are reconciled. Runtime behavior is not validated.
--
-- Capture mapping (StorageItems parent, PC54-PC58):
--   UP[0] = maxPage
--   UP[1] = pageCapacity
--   UP[2] = openSize
--   UP[3] = storedPageData (per-page occupied item counts)
--
-- The local function name below is descriptive only; the original identifier
-- was not recovered.

local function make_FindAvailableStoragePage(
    maxPage,
    pageCapacity,
    openSize,
    storedPageData
)
    return function()
        -- Search pages in ascending order and return the first page that has
        -- room for another stored item.
        for page = 1, maxPage do
            local pageLimit = pageCapacity

            -- The final page may be smaller than the ordinary page capacity.
            if page == maxPage then
                pageLimit = math.min(
                    pageCapacity,
                    openSize - (maxPage - 1) * pageCapacity
                )
            end

            local currentCount = storedPageData[page]
            if currentCount < pageLimit then
                return page
            end
        end

        return nil
    end
end

-- Evidence / limits:
-- * Parent root/51 PC54 creates this closure with four captures; PC55-PC58
--   copy parent R1/R2/R3/R4 into capture slots 0..3.
-- * Existing StorageItems review maps those captures to
--   maxPage/pageCapacity/openSize/storedPageData and confirms the final-page
--   capacity expression above.
-- * Parent PC37-PC53 builds storedPageData: for each page it calls
--   NPCStorageProxy:GetStorageDataByPage(page), stores #pageData when present,
--   and stores 0 when the page data is absent. Thus the child compares a number,
--   not a possibly-nil raw page-data array.
-- * Parent PC177-PC179 calls this closure with zero explicit arguments and
--   branches on its first return: a page number continues the store path; nil
--   enters the '仓库已满,无法存仓' failure path.
-- * The child loop checks pages in ascending order, applies the reduced
--   final-page capacity only when page == maxPage, returns the first page with
--   currentCount < pageLimit, and returns nil after exhausting all pages.
-- * This is readable reconstruction, not recovered author formatting or
--   original local names. No host runtime test has been performed.

  local __exports = {}
  if make_FindAvailableStoragePage ~= nil then __exports["make_FindAvailableStoragePage"] = make_FindAvailableStoragePage end
  MainLeftBottomRecovered.sources["04_源码候选/root50_Nested_Anonymous_2.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第七十四批.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- root.children[42].children[16] / legacy root/43/17
-- Nested_ITEM_INDEX_BY_NAME：26条指令；7常量；无子原型；2项捕获。
-- UP[0]=快捷栏配置表；UP[1]=移动结果提示回调。

local function make_Nested_ITEM_INDEX_BY_NAME(config, notifyMoveResult)
    return function()
        for _, itemName in ipairs(config.names) do
            local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)

            if itemIndex then
                local success, callbackValue =
                    MoveItemToQuickUse(itemIndex, config.slot)

                notifyMoveResult(callbackValue)

                if success then
                    break
                end
            end
        end
    end
end

-- 调用顺序已闭合：先按config.names顺序查ITEM_INDEX_BY_NAME；
-- 找到索引后调用MoveItemToQuickUse(itemIndex, config.slot)，将第二返回值
-- 传给捕获回调；第一返回值truthy时停止遍历。无显式返回值。
-- MoveItemToQuickUse调用方参数顺序为(itemIndex, slot)，未运行时验证。

  local __exports = {}
  if make_Nested_ITEM_INDEX_BY_NAME ~= nil then __exports["make_Nested_ITEM_INDEX_BY_NAME"] = make_Nested_ITEM_INDEX_BY_NAME end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第七十四批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root56_root57_short_functions.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- MainLeftBottom(2).lua 静态恢复候选
-- 检查点 #169；以下两个原型均已完整静态复核，尚未运行时验证。

----------------------------------------------------------------
-- root.children[56] / legacy root/57
-- ClearTargetID_2；22 条物理指令
----------------------------------------------------------------
local function ClearTargetID_2()
    if not global.Facade then
        return
    end

    local playerInputProxy = global.Facade:retrieveProxy(
        global.ProxyTable.PlayerInputProxy
    )
    if not playerInputProxy then
        return
    end

    playerInputProxy:SetTargetID(
        0,
        global.MMO.SELETE_TARGET_TYPE_FIND
    )
end

----------------------------------------------------------------
-- root.children[57] / legacy root/58
-- PlayerPos；10 条物理指令
----------------------------------------------------------------
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end

-- 静态边界：
-- ClearTargetID_2：Facade 缺失或 retrieveProxy 返回假值时直接 return；
-- SetTargetID 保留 playerInputProxy 为 receiver，显式参数为 0 和
-- global.MMO.SELETE_TARGET_TYPE_FIND。
-- PlayerPos：先后读取 X、Y，并返回两个独立返回值；不是坐标表。
-- 两个函数均未进行宿主运行时验证。

  local __exports = {}
  if ClearTargetID_2 ~= nil then __exports["ClearTargetID_2"] = ClearTargetID_2 end
  MainLeftBottomRecovered.sources["04_源码候选/root56_root57_short_functions.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root55_children_drafts.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
----------------------------------------------------------------
-- root.children[55].children[0]
-- legacy root/56/1；Nested_Panel_mini_chat；24 条物理指令
----------------------------------------------------------------
local function make_Nested_Panel_mini_chat(validationResult, showWaitingNotice)
    -- UP[0] 精确捕获父 AccountIDValidation 的局部 validationResult（Nested_ID 返回值）。
    -- UP[1] 捕获父函数 UP[0] 的日志/提示回调。
    -- 注意：字节码确实将 validationResult 传给 SL:UnSchedule；其宿主语义未验证。
    return function()
        local mainProperty = MainProperty

        if mainProperty
            and mainProperty._ui
            and mainProperty._ui.Panel_mini_chat
        then
            SL:UnSchedule(validationResult)
            MainLeftBottom.doInit()
        end

        -- PC21-23：无论初始化条件是否满足，均调用等待提示回调。
        showWaitingNotice("等待主界面属性栏(MainProperty)初始化完成...")
    end
end

----------------------------------------------------------------
-- root.children[55].children[1]
-- legacy root/56/2；Nested_ID；27 条物理指令；vararg=1
----------------------------------------------------------------
local function make_Nested_ID(allowedAccountIDs, showAllowedNotice, showDeniedNotice)
    -- UP[0]：允许账号 ID 数组
    -- UP[1]：允许时的提示回调
    -- UP[2]：不允许时的提示回调
    return function(accountID, ...)
        local normalizedAccountID = tostring(accountID)

        for _, allowedID in ipairs(allowedAccountIDs) do
            if normalizedAccountID == tostring(allowedID) then
                showAllowedNotice("[提示] 账号ID在允许列表中，功能已开启")
                return true
            end
        end

        showDeniedNotice("账号不存在，功能已限制，账号ID：" .. tostring(accountID))
        return false
    end
end

-- 静态复原说明：
-- * Nested_ID 的比较是 tostring(accountID) 与 tostring(allowedID) 的相等比较，
--   不是原值直接比较；只读取第一个显式参数，额外变参未被读取。
-- * 两条返回路径分别返回 true/false，且各自只调用对应的一参提示回调。
-- * Nested_Panel_mini_chat 的三层存在性检查、UnSchedule receiver、doInit
--   零参调用及无条件等待提示均由 PC1-24 覆盖。
-- * Panel 子闭包的父级捕获生产者已闭合：UP[0]=validationResult，UP[1]=父 UP[0]。
-- * validationResult 被传入 SL:UnSchedule 是字节码事实；参数为何如此使用仍待宿主运行时验证。

----------------------------------------------------------------
-- root.children[55]
-- legacy root/56；AccountIDValidation；64 条物理指令；完整静态恢复（未运行时验证）
----------------------------------------------------------------
local function make_AccountIDValidation(logCallback, failureCallback)
    -- UP[0]：日志/普通提示回调（游戏ID、账号ID、成功提示、等待提示）。
    -- UP[1]：验证失败提示回调。
    return function()
        local gameID = SL:GetMetaValue("GAME_ID")
        logCallback("游戏id：" .. gameID)

        if gameID ~= 204208 then
            logCallback("游戏不一致，id：" .. gameID)
            return
        end

        local accountID = SL:GetMetaValue("UID")
        logCallback("账号ID：" .. accountID)

        local allowedAccountIDs = {
            "6324648",
            "39770358",
            "3548598",
            "1957840929",
            "1488903257",
            "1585201915",
            "1627987432",
            "1580027021",
            "1304755149",
        }

        local validateAccountID = make_Nested_ID(
            allowedAccountIDs,
            logCallback,
            failureCallback
        )
        local validationResult = validateAccountID(accountID)

        if validationResult then
            logCallback("[验证成功] 账号ID验证通过")
        else
            failureCallback("[验证失败] 账号ID未在允许列表中")
        end

        -- PC58 创建子闭包：第一个捕获为当前 validationResult，第二个捕获为父 UP[0]。
        local scheduledCallback = make_Nested_Panel_mini_chat(
            validationResult,
            logCallback
        )
        SL:Schedule(scheduledCallback, 0.5)
    end
end

-- MainLeftBottom(2).lua 普通 Lua 恢复候选
-- 检查点 #169：root.children[55] 父函数及两个子原型
-- 说明：这是基于 corrected phase3 反汇编的可读重建，不是原始源码逐字节恢复。
-- 未进行宿主运行时验证。


-- 检查点 #169：父 PC58 的两项捕获已逐指令闭合；validationResult 的宿主含义仍未运行时验证。

  local __exports = {}
  if make_Nested_Panel_mini_chat ~= nil then __exports["make_Nested_Panel_mini_chat"] = make_Nested_Panel_mini_chat end
  if make_Nested_ID ~= nil then __exports["make_Nested_ID"] = make_Nested_ID end
  if make_AccountIDValidation ~= nil then __exports["make_AccountIDValidation"] = make_AccountIDValidation end
  MainLeftBottomRecovered.sources["04_源码候选/root55_children_drafts.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- root.children[19] / legacy root/20 / InitGatherMonsters
-- 36 physical instructions, one zero-argument MainLoop child closure.
-- Complete static reconstruction; not target-runtime validated.

local function make_InitGatherMonsters(
    runtimeState,              -- UP[0] <- root T[3], contains gatherTimer
    isGathering,               -- UP[1] <- root T[18], assigned true
    FormatStateChange,         -- UP[2] <- root T[23]
    stateConstants,            -- UP[3] <- root T[13]: IDLE/GATHERING/ATTACKING
    ResetGatherMonsterData,    -- UP[4] <- root T[35]
    config,                    -- UP[5] <- root T[8]
    showNotice                 -- UP[6] <- root T[4]
)
    return function()
        -- PC1-11: cancel the previous timer and clear the stored handle.
        if runtimeState.gatherTimer then
            SL:UnSchedule(runtimeState.gatherTimer)
            runtimeState.gatherTimer = nil
        end

        -- PC12-13: update the captured running flag.
        isGathering.value = true

        -- PC14-19: transition to IDLE, then reset gather-monster data.
        FormatStateChange(stateConstants.IDLE)
        ResetGatherMonsterData()

        -- PC20-27: schedule MainLoop and save the returned timer.
        runtimeState.gatherTimer = SL:Schedule(
            MainLoop,
            config.CHECK_INTERVAL
        )

        -- PC28-35: report startup and the configured threshold.
        showNotice(string.format(
            "引怪功能已启动 (阈值: %d)",
            config.GATHER_THRESHOLD
        ))
    end
end

-- Exact parent capture sources at root PC238-245:
-- UP[0..6] <- T[3], T[18], T[23], T[13], T[35], T[8], T[4].
-- T[23] is the FormatStateChange closure created at root PC181.
-- T[13] is the state constants table created at root PC168-171.
-- T[35] is the ResetGatherMonsterData closure created at root PC200.

  local __exports = {}
  if make_InitGatherMonsters ~= nil then __exports["make_InitGatherMonsters"] = make_InitGatherMonsters end
  MainLeftBottomRecovered.sources["04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第三十八批.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- root.children[0] / legacy root/1
-- FileExistCheck_pcall_wrapper：32条父指令；1个子原型；vararg_flag=1。
-- UP[0]是root.children[2] GetWritablePath闭包；本工厂参数用于显式表达该捕获。
-- 子闭包捕获FileUtils实例与resolvedPath，执行removeFile，不保留返回值。

local function make_FileExistCheck_pcall_wrapper(resolveWritablePath)
    return function(path, ...)
        local fileUtils = cc.FileUtils:getInstance()
        local resolvedPath = resolveWritablePath(path)

        if fileUtils:isFileExist(resolvedPath) then
            return true, resolvedPath
        end

        local function Nested_removeFile()
            fileUtils:removeFile(resolvedPath)
        end
        local removeSucceeded = pcall(Nested_removeFile)

        if not removeSucceeded then
            return false, resolvedPath
        end

        return not fileUtils:isFileExist(resolvedPath), resolvedPath
    end
end

-- PC1-PC32按检查点62静态闭合：先解析路径；存在即true/path；
-- 不存在则pcall删除；pcall失败返回false/path；成功后再次检查并返回
-- not exists/path。额外vararg不读取。未运行时验证。

  local __exports = {}
  if make_FileExistCheck_pcall_wrapper ~= nil then __exports["make_FileExistCheck_pcall_wrapper"] = make_FileExistCheck_pcall_wrapper end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第三十八批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root49_AnonymousHelper_49.lua
-- 短原型集中整合；工厂参数用于显式表达捕获槽位。
-- ============================================================================
do
-- root.children[49] / legacy root/50 / AnonymousHelper_49
-- 5条指令；捕获ReadNumericConfig闭包与固定文件名；无显式参数。

local function make_AnonymousHelper_49(readNumericConfig, fileName)
    return function()
        return readNumericConfig(fileName)
    end
end

-- 返回ReadNumericConfig的全部返回值，不做转换或吞掉nil。
-- 根模块在root PC304创建，PC305/PC306依序捕获读取函数和文件名。

  local __exports = {}
  if make_AnonymousHelper_49 ~= nil then __exports["make_AnonymousHelper_49"] = make_AnonymousHelper_49 end
  MainLeftBottomRecovered.sources["04_源码候选/root49_AnonymousHelper_49.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第五十批.lua
-- LuaSendMsg 92条物理指令完整静态恢复；Upvalue保留中性语义名。
-- ============================================================================
do
-- 检查点 #74 首版草稿 / 检查点 #190 参数与拦截路径校正
-- 原型：root.children[12] / legacy root/13
-- 92条物理指令；34常量；无子原型；vararg_flag=0
-- root PC48创建闭包，捕获root T[0]与root T[4]。
-- UPVALUE_0按用途临时命名为hookState（含Blocklist/SendHookList）；
-- UPVALUE_1按用途临时命名为logCallback。原始业务变量名尚未确认。
-- 两个Upvalue的业务身份未知不影响其读写与调用契约恢复。
-- 完整静态恢复：PC1-PC92全部映射；未运行时验证。

local function make_LuaSendMsg(hookState, logCallback)
    return function(
        hookKey,
        param1,
        param2,
        param3,
        param4,
        messageId
    )
        -- PC1-PC17：固定六参数映射。
        -- arg1是Blocklist/SendHookList查找键；arg2..arg5进入param1..4；
        -- arg6进入message.msgId。recog固定为0。
        local message = {
            recog = 0,
            msgId = messageId,
            param1 = param1,
            param2 = param2,
            param3 = param3,
            param4 = param4,
        }

        -- PC18-PC27：table.find(Blocklist, tonumber(arg1))命中时只跳过日志构造；
        -- 不跳过后续hook处理或networkCtl.SendMsg。
        local numericHookKey = tonumber(hookKey)
        local blockedIndex = table.find(
            hookState.Blocklist,
            numericHookKey
        )

        if not blockedIndex then
            -- PC28-PC52：按param1..param4顺序构造日志参数列表。
            -- 字符串用单引号包裹；其他值统一tostring；空值行为保留ipairs语义。
            local formattedParams = {}
            local parameterSource = {
                message.param1,
                message.param2,
                message.param3,
                message.param4,
            }

            for _, value in ipairs(parameterSource) do
                if type(value) == "string" then
                    table.insert(formattedParams, "'" .. value .. "'")
                else
                    table.insert(formattedParams, tostring(value))
                end
            end

            local logText = "LuaSendMsg("
                .. table.concat(formattedParams, ", ")
                .. ")"
            logCallback(logText)
        end

        -- PC63-PC86：按arg1查SendHookList；只接受function类型。
        -- pcall(hook,arg1,arg6,message)成功且第二返回值严格为true时拦截发送。
        -- PC63-PC67：第一次读取只做truthy存在性门控。
        local hookExists = hookState.SendHookList[hookKey]
        if hookExists then
            -- PC68-PC70：字节码再次读取同一键，保留第二次table索引。
            local hook = hookState.SendHookList[hookKey]
            if type(hook) == "function" then
                local callOK, handled = pcall(
                    hook,
                    hookKey,
                    messageId,
                    message
                )
                if callOK and handled == true then
                    return
                end
            end
        end

        -- PC87-PC92：hook不存在、hook异常或未返回true时，原六参数原样转发。
        global.networkCtl:SendMsg(
            hookKey,
            param1,
            param2,
            param3,
            param4,
            messageId
        )
    end
end


  local __exports = {}
  if make_LuaSendMsg ~= nil then __exports["make_LuaSendMsg"] = make_LuaSendMsg end
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第五十批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第六十一批.lua
-- MoveItemToQuickUse 133条物理指令完整静态恢复；无Upvalue捕获。
-- SetQuickUsePosData的布尔实参按字节码原值保留，不推断宿主内部语义。
-- ============================================================================
do
--[[
函数：MoveItemToQuickUse
原型索引：51
规范路径：root.children[41]
legacy路径：root/42
物理指令：133
常量：26
子原型：0
vararg_flag：2
状态：完整静态恢复（检查点191参数契约复核、检查点222全PC复审）；未运行时验证。

参数：
  itemIndex：待移动物品的索引。调用点root.children[42] PC131-PC145通过
             SL:GetMetaValue("ITEM_INDEX_BY_NAME", name)取得，并作为第1实参。
  targetPos：目标快捷栏位置。调用点传slotConfig.slot，作为第2实参。
调用方接收(success, message)，把message传给PrintLog；success truthy时停止尝试同组后续名称。

恢复原则：
  - 按133条物理PC顺序表达所有可达路径。
  - 保留SetQuickUsePosData的原始实参顺序和布尔值，不为布尔值编造业务含义。
  - 不把代理方法调用结果当作成功确认；本函数的success来自字节码中的显式布尔常量。
  - 宿主代理API尚未运行时验证。
]]

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

  local __exports = { MoveItemToQuickUse = MoveItemToQuickUse }
  MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第六十一批.lua"] = __exports
end


-- ============================================================================
-- 来源文件：04_源码候选/root35_AnonymousHelper_33_ScheduleWrapper.lua
-- root.children[34]的7指令SL:Schedule转发包装函数。
-- ============================================================================
do
-- root.children[34] / legacy root/35 / AnonymousHelper_33
-- 7条物理指令；2个显式参数；无Upvalue捕获、无子原型。
-- PC1-PC2读取SL.Schedule并保留SL作为self；
-- PC3-PC4将两个实参放入调用区；PC5返回SL:Schedule的全部返回值。
-- SL:Schedule(callback,time)签名由新框架3_40_xx/SL.md确认。

local function AnonymousHelper_33_Schedule(callback, interval)
    return SL:Schedule(callback, interval)
end

  MainLeftBottomRecovered.sources["04_源码候选/root35_AnonymousHelper_33_ScheduleWrapper.lua"] = { AnonymousHelper_33_Schedule = AnonymousHelper_33_Schedule }
end


-- ============================================================================
-- 检查点229：优先补入已完整静态恢复的短函数/简单闭包
-- 本批仅按现有PC级审计与原型索引整合；未进行目标运行时验证。
-- ============================================================================

do
    -- root.children[32] / legacy root/33 / AnonymousHelper_32
    -- 6条指令；UP[0]捕获root T[46]，UP[1]捕获root T[42]。
    -- PC1-PC4：调用UP[0](UP[1], 第一个显式参数)并返回全部结果。
    -- PC5-PC6位于直接return之后，不可达。
    local function make_AnonymousHelper_32(upvalue0, upvalue1)
        return function(arg1)
            return upvalue0(upvalue1, arg1)
        end
    end

    MainLeftBottomRecovered.sources["root/33_AnonymousHelper_32.lua"] = {
        make_AnonymousHelper_32 = make_AnonymousHelper_32
    }
end

do
    -- root.children[53] / legacy root/54 / ScheduleOnce
    -- 7条指令；零Upvalue；两个显式参数callback与delay。
    -- PC1-PC2读取SL.ScheduleOnce并保留SL作为self；
    -- PC3-PC5转发两个参数并返回全部调用结果；PC6-PC7不可达。
    local function ScheduleOnce(callback, delay)
        return SL:ScheduleOnce(callback, delay)
    end

    MainLeftBottomRecovered.sources["root/54_ScheduleOnce.lua"] = {
        ScheduleOnce = ScheduleOnce
    }
end

do
    -- root.children[54] / legacy root/55 / AnonymousHelper_54
    -- 6条指令；UP[0]=PCallHelper闭包，UP[1]="gather_monster_count.txt"。
    -- PC1-PC4调用PCallHelper(fileName, firstArg)，原样转发全部返回值；
    -- PC5-PC6位于直接return之后，不可达。
    local function make_AnonymousHelper_54(pcallHelper, fileName)
        return function(firstArg)
            return pcallHelper(fileName, firstArg)
        end
    end

    MainLeftBottomRecovered.sources["root/55_AnonymousHelper_54.lua"] = {
        make_AnonymousHelper_54 = make_AnonymousHelper_54
    }
end

do
    -- root.children[22] / legacy root/23 / GetMapData2DPtr
    -- 144条物理指令，但PC38-PC144均位于PC37无条件return之后；
    -- 可达行为仅为坐标有效性检查、相同坐标返回0、Chebyshev距离限幅。
    -- UP[0]由root PC350捕获，但活动路径从未读取，工厂参数仅保留捕获位置。
    local function make_GetMapData2DPtr(unusedCapturedValue)
        return function(x1, y1, x2, y2, maxDistance)
            if not x1 or not y1 or not x2 or not y2 or not maxDistance then
                return nil
            end

            if x1 == x2 and y1 == y2 then
                return 0.0
            end

            if maxDistance <= 0 then
                return nil
            end

            local dx = math.abs(x2 - x1)
            local dy = math.abs(y2 - y1)
            local distance = math.max(dx, dy)

            if maxDistance < distance then
                return nil
            end

            return distance
        end
    end

    MainLeftBottomRecovered.sources["04_源码候选/root22_GetMapData2DPtr.lua"] = {
        make_GetMapData2DPtr = make_GetMapData2DPtr
    }
end


-- ============================================================================
-- 检查点230：继续优先整合简单、已有完整静态证据的明文函数
-- ============================================================================

do
    -- root.children[1] / legacy root/2 / GetStorageItemData
    -- 77条指令；root PC71创建并捕获父T[4]，其业务身份尚未命名，
    -- PC72捕获时父T[4]已由PC43写入PrintLog，因此该回调确定为printLog。
    local function make_GetStorageItemData(printLog)
        return function()
            local storageItems = {}
            local storageProxy = NPCStorageProxy
            if not storageProxy then
                return storageItems
            end

            local maxPage = storageProxy:GetMaxPage()
            local availableSlots = 0

            for page = 1, maxPage do
                local pageData = storageProxy:GetStorageDataByPage(page)

                if type(pageData) == "table" then
                    for _, item in ipairs(pageData) do
                        table.insert(storageItems, item)
                    end
                end

                local pageItemCount = 0
                if pageData then
                    pageItemCount = #pageData
                end

                local perPageMax = GUIDefine.STORAGE_PER_PAGE_MAX
                if not perPageMax then
                    perPageMax = global.MMO.NPC_STORAGE_MAX_PAGE
                end

                local openSize = storageProxy:GetOpenSize()
                local pageLimit = openSize - (page - 1) * perPageMax
                if pageLimit > perPageMax then
                    pageLimit = perPageMax
                end

                if pageLimit > 0 then
                    availableSlots = availableSlots + (pageLimit - pageItemCount)
                end
            end

            printLog("仓库总可用格子: " .. tostring(availableSlots))
            return storageItems
        end
    end

    MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第五十六批.lua#GetStorageItemData"] = {
        make_GetStorageItemData = make_GetStorageItemData
    }
end

do
    -- root.children[51] / legacy root/52 / FindBlacklistPlayer
    -- 35条指令，UP[0]为root.children[48] PCallHelper_2。
    -- PCallHelper_2及其Nested_FriendProxy子原型已在前文“代理与回调短函数”词法块中恢复。
    -- fixed_param_count=1：targetId是唯一固定参数。
    local function make_FindBlacklistPlayer(getFriendProxySafely)
        return function(targetId)
            local friendProxy = getFriendProxySafely()
            if not friendProxy then
                return false
            end

            local blacklistData = friendProxy._blacklistData
            if not blacklistData or not targetId then
                return false
            end

            local entry = blacklistData[targetId]
            if entry then
                return true, entry.Name
            end

            local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", targetId)
            if masterActorID and masterActorID ~= targetId then
                local masterEntry = blacklistData[masterActorID]
                if masterEntry then
                    return true, masterEntry.Name
                end
            end

            return false
        end
    end

    MainLeftBottomRecovered.sources["04_源码候选/root49_PCallHelper_2_and_root51_FindBlacklistPlayer.lua"] = {
        make_FindBlacklistPlayer = make_FindBlacklistPlayer
    }
end



-- ============================================================================
-- 来源文件：04_源码候选/root28_FindMonsterCandidates.lua
-- root.children[28]；5项父级捕获在root装配区按OP_387顺序注入。
-- ============================================================================
do
    local function make_FindMonsterCandidates(
        GetPlayerPosition,
        IsDie,
        GetPlayerMapPosition,
        DistanceCalculation,
        config
    )
        local function FindMonsterCandidates()
            local monsters = SL.FindMonsterInCurrViewField()
            if not monsters or #monsters == 0 then
                return {}
            end
            local ignoreSetting =
                GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)
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
                        actor._distance =
                            DistanceCalculation(playerPosition, actorPosition)
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
        return FindMonsterCandidates
    end
    MainLeftBottomRecovered.sources["04_源码候选/root28_FindMonsterCandidates.lua"] = {
        make_FindMonsterCandidates = make_FindMonsterCandidates
    }
end



-- ============================================================================
-- 来源文件：04_源码候选/短函数草稿_第五十七批.lua
-- root.children[5] / legacy root/6 / TakeItems；捕获T[2]状态表、T[5]提示回调。
-- ============================================================================
do
    local function make_TakeItems(takingState, notify)
        return function()
            if takingState.isTaking then
                return
            end
            takingState.isTaking = true
            local storageItems = GetStorageItemData()
            if not storageItems or #storageItems == 0 then
                notify("仓库无可取物品")
                takingState.isTaking = false
                return
            end
            -- 字节码PC42-PC64的"待定"过滤循环位于不可达分支。
            local _deadFilterTerms = { "待定" }
            local takenCount = 0
            for _, item in ipairs(storageItems) do
                if item and item.Name and item.MakeIndex then
                    local itemName = string.trim(item.Name)
                    notify("取: " .. itemName)
                    LuaSendMsg(
                        global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST,
                        999999999,
                        item.MakeIndex,
                        0,
                        0,
                        itemName,
                        string.len(itemName)
                    )
                    takenCount = takenCount + 1
                end
            end
            takingState.isTaking = false
            if takenCount > 0 then
                notify("取出物品完成, 共取出 " .. tostring(takenCount) .. " 件")
            end
        end
    end
    MainLeftBottomRecovered.sources["04_源码候选/短函数草稿_第五十七批.lua"] = {
        make_TakeItems = make_TakeItems
    }
end



-- ============================================================================
-- 来源文件：04_源码候选/PickUpItems_拾取流程_第十批.lua
-- root.children[21]；UP[0]=root T[5]=ShowLocalNoticeByType。
-- 两个比较器作为父原型的子闭包，在PickUpItems调用体内建立。
-- ============================================================================
do
    local function make_PickUpItems(notify)
        return function()
            local function Nested_dist_2(a, b)
                return a.dist < b.dist
            end
            local function Nested_dist(a, b)
                if a.kIdx ~= b.kIdx then
                    return a.kIdx < b.kIdx
                end
                return a.dist < b.dist
            end

            local nameRules = {}
            local droppedItems, droppedCount = GetDroppedItems()
            if droppedCount == 0 then
                notify("地面无可拾取物品")
                return
            end
            local playerX, playerY = PlayerPos()
            local preferredItems = {}
            local ordinaryItems = {}

            for itemIndex, item in ipairs(droppedItems) do
                local name = item.mName or item.mONameStr or item.Name or item.name or ""
                local x = item.mCurrMapX or item.MapX or item.mapX or item.x
                local y = item.mCurrMapY or item.MapY or item.mapY or item.y
                if x and y then
                    local distance = math.abs(playerX - x) + math.abs(playerY - y)
                    local matchedRuleIndex = 0
                    for ruleIndex, rule in ipairs(nameRules) do
                        if string.find(name, rule) then
                            matchedRuleIndex = ruleIndex
                            break
                        end
                    end
                    if matchedRuleIndex > 0 then
                        table.insert(preferredItems, {
                            item = item, dist = distance,
                            kIdx = matchedRuleIndex, x = x, y = y
                        })
                    else
                        table.insert(ordinaryItems, {
                            item = item, dist = distance, x = x, y = y
                        })
                    end
                end
            end
            table.sort(preferredItems, Nested_dist)
            table.sort(ordinaryItems, Nested_dist_2)
            local candidates = {}
            for _, entry in ipairs(preferredItems) do
                table.insert(candidates, entry)
            end
            for _, entry in ipairs(ordinaryItems) do
                table.insert(candidates, entry)
            end
            if #candidates == 0 then
                return
            end
            local target = candidates[1]
            MoveTo(target.x, target.y, 0)
            if math.abs(playerX - target.x) <= 1
                and math.abs(playerY - target.y) <= 1
            then
                global.dropItemController:PickMainPlayerPosItem()
                notify("拾取: " .. target.item.mName)
            end
        end
    end
    MainLeftBottomRecovered.sources["04_源码候选/PickUpItems_拾取流程_第十批.lua"] = {
        make_PickUpItems = make_PickUpItems
    }
end


-- 检查点238根模块寄存器生命周期补充：T[8]=gatherConfig（PC86-PC89构造，4个捕获）；
-- T[42]=blacklist_distance.txt；T[43]=gather_monster_count.txt；T[44]=GetWritablePath闭包。
-- 以上均为PC证据确认的父帧共享cell值，详细捕获点见docs/handoff/12_根模块闭包装配表.json。


-- 检查点239根模块闭包绑定补充：BlacklistPlayerDetection（root.children[47]）UP[3]=DeathAutoBlacklist(T58)、UP[4]=FindBlacklistPlayer(T55)、UP[5]=GetMapData2DPtr(T53)、UP[6]=2.0(T38)、UP[8]=UseItemByIndex(T56)、UP[9]=0.01(T39)、UP[11]=30.0(T40)。
-- doInit_UI UP[9]捕获T50，即ReadNumericConfig('gather_monster_count.txt')固定参数包装闭包。
-- GetMapData2DPtr UP[0]捕获PC349组装的T52八元素表；可达路径不读取该Upvalue。完整PC时间线见docs/handoff/12_根模块闭包装配表.json。


-- 检查点240：root PC298-PC315闭包创建与捕获值核对。
-- T45=ReadNumericConfig(GetWritablePath)；T46=PCallHelper(GetWritablePath)。
-- T47=FileExistCheck_pcall_wrapper(GetWritablePath)。
-- T48=AnonymousHelper_49(ReadNumericConfig,"blacklist_distance.txt")。
-- T49=AnonymousHelper_32(PCallHelper,"blacklist_distance.txt")。
-- T50=AnonymousHelper_33(ReadNumericConfig,"gather_monster_count.txt")。
-- T51=AnonymousHelper_54(PCallHelper,"gather_monster_count.txt")。
-- root PC390 doInit_UI捕获槽：UP[6]=T48、UP[9]=T50、UP[10]=T49、
-- UP[12]=T44(GetWritablePath)、UP[14]=T51、UP[16]=T47。
-- T49/T51均调用PCallHelper(固定文件名, firstArg)，不是读取配置文件的包装器；
-- T48/T50才是ReadNumericConfig固定文件名读取包装器。
-- root.children[33]的恢复名为AnonymousHelper_33（legacy路径root/34），
-- 不要将一基路径编号误作原型函数名。所有结论均为静态恢复，未运行时验证。


-- 检查点241：根模块PC1-PC85明文字段/导出对账摘要。
-- _G.MainLeftBottom在PC2导出；MainLeftBottom.a含version="10000"、
-- screenW/screenH、Blocklist={1,9,10,60000}、SendHookList、RecvHookList、
-- isHidden=true、hidebut=nil及PC51写入的LuaSendMsg。
-- MainLeftBottom.b为空表；MainLeftBottom.z含六个false状态字段。
-- PC45/55/57/59/61/63/67/70/73/78/82/85分别导出log、GetMapId、
-- GetMapName、PlayerPos、GetDroppedItems、MoveTo、DiuItems、
-- GetAvailableStoragePage、GetStorageItemData、StorageItems、TakeItems、
-- PickUpItems。详细PC映射见root_MainLeftBottom_Module.lua及检查点241审计。


-- 检查点242：root PC86-PC211寄存器生命周期摘要与捕获时值核验。
-- T7=Schedule；T9=0.2；T11=18000；T12=14项奖励记录表；
-- T13=gatherStatusText；T14=currentState共享cell；
-- T15目标ID集合、T16自己归属计数、T17扫描游标、T18运行标记、
-- T19等待标记、T20截止时间、T21等待目标ID、T22等待目标名称；
-- T23 FormatStateChange、T24 SetTargetID、T25 ClearTargetID_2、
-- T26 GetMainPlayerID、T27 GetPlayerPosition、T28 GetPlayerMapPosition、
-- T29 DistanceCalculation、T30 IsDie、T31 GetOwnerIDText、T32 GetOwnerID、
-- T33 GetOwnerDescription、T34 FindMonsterCandidates、
-- T35 ResetGatherMonsterData、T36 FindMonsterInCurrViewField。
-- 更正：PC210创建的是FindMonsterInCurrViewField，PC211捕获T30=IsDie；
-- ClearBlacklistItems实际在PC383创建（root.children[15]），不是PC210。
-- 所有捕获按OP_387共享live cell与PC顺序核对；无运行时验证。


-- 根模块装配账本补充（检查点243，静态证据：corrected phase3 root PC212-PC340）。
-- 全局导出：IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting、MoveItemToQuickUse。
-- MainLeftBottom字段：hide=DestroyUI、show=SetButtonVisibilityState、destroy=ShowHideAllButtons、main=AccountIDValidation、blacklist=blacklistState。
-- UI控制闭包捕获顺序：DestroyUI[T0,T3,T1]；SetButtonVisibilityState[T0,T1]；ShowHideAllButtons[T3,T1,T0]。
-- AccountIDValidation捕获PrintLog与ShowLocalNoticeByType；blacklistState在PC286-PC293初始化并于PC294挂入MainLeftBottom.blacklist。
-- 根寄存器时间线至检查点243为57/57闭合；T54最终为PCallHelper_2，分别于PC354/PC384捕获给FindBlacklistPlayer/ClearBlacklistItems。
-- 该账本不是根模块完整普通Lua装配，PC341-PC412仍待复核；本文件所有恢复仍未运行时验证。


-- 检查点244：根模块PC341-PC412最终装配关系（依据corrected phase3）。
-- MainLeftBottom.onDamageMsg = onDamageMsg（PC359）。
-- _G.BlacklistItems = BlacklistPlayerDetection（PC382）。
-- _G.ClearBlacklistItems = ClearBlacklistItems（PC388）。
-- MainLeftBottom.doInit = doInit_UI（PC411）；PC412返回MainLeftBottom。
-- doInit_UI在root创建时按20项顺序捕获[T4,T2,T3,T0,T1,T41,T48,T7,T8,T50,T49,T5,T44,T42,T51,T43,T47,T11,T12,T9]。
-- BlacklistPlayerDetection的13项捕获、DeathAutoBlacklist的4项捕获、ClearBlacklistItems的4项捕获及onDamageMsg的状态表捕获已写入根模块闭包装配表；均为父寄存器live cell，不是独立快照。
-- 本段补齐的是root级创建/挂载/导出账本，不将未完成的根模块伪装成完整作者源码。


-- 检查点245：根模块PC1-PC412导出/字段总账复核。
-- 全局导出共21项（包含模块根表_MainLeftBottom本身）：MainLeftBottom、log、GetMapId、GetMapName、PlayerPos、GetDroppedItems、MoveTo、DiuItems、GetAvailableStoragePage、GetStorageItemData、StorageItems、TakeItems、PickUpItems、IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting、MoveItemToQuickUse、BlacklistItems、ClearBlacklistItems。
-- MainLeftBottom根表字段：a、b、z、hide、show、destroy、main、blacklist、onDamageMsg、doInit；a/b/z内部字段另按层级记录。
-- PC86-PC211未发现新的根级导出/根表字段赋值；该区间的寄存器闭包创建和共享状态不视为导出。
-- 本总账只确认静态字节码赋值，不代表宿主执行时机已验证。


-- ============================================================================
-- 检查点246：root 22个无捕获直接子原型的实际绑定
--
-- 依据：docs/handoff/12_根模块闭包装配表.json closure_sites。
-- 本段只绑定capture_count=0的直接子原型；有捕获工厂暂不在此猜测参数，
-- 避免把OP_387 live-cell误作值快照。所有绑定均是静态候选，未运行时验证。
-- ============================================================================
do
    local sources = MainLeftBottomRecovered.sources
    local rootSource = sources["04_源码候选/root_MainLeftBottom_Module.lua"]
    local rootModule = rootSource and rootSource.MainLeftBottom
    assert(type(rootModule) == "table",
        "root module candidate is missing from source registry")

    local function sourceFunction(sourcePath, symbol)
        local source = sources[sourcePath]
        local value = source and source[symbol]
        if type(value) ~= "function" then
            return nil
        end
        return value
    end

    local rootPrototypes = {}
    local missing = {}

    -- 检查点263：PC43-PC85根模块首批闭包装配。
    -- rootRegisters是恢复适配层的父T寄存器影子表，不是原作者的数据结构。
    -- T[0..3]的值已由PC1-PC42初始化段建立；此处显式记录T[4..8]的创建和覆写。
    local rootRegisters = {
        [0] = rootModule.a,       -- T[0]在PC3覆写为a表
        [1] = rootModule.b,       -- T[1]在PC30最终成为b表
        [2] = rootModule.z,       -- T[2]在PC33最终成为z表
        [3] = rootSource.timerState
    }

    local function bindDirect(prototypeName, sourcePath, symbol)
        local fn = sourceFunction(sourcePath, symbol)
        if fn then
            rootPrototypes[prototypeName] = fn
        else
            missing[#missing + 1] = prototypeName .. " <- " ..
                sourcePath .. ":" .. symbol
        end
        return fn
    end

    -- 恢复适配保护：某个子原型源码缺失时立即报错，禁止把T[8]上一个闭包
    -- 错误导出为下一个函数，也禁止把_G回退成ShowLocalNoticeByType。
    local function requireRecoveredClosure(name, value)
        assert(type(value) == "function",
            "recovered root closure source unavailable: " .. name)
        return value
    end

    -- PC43：创建PrintLog并写入父寄存器T[4]。
    bindDirect("PrintLog", "04_源码候选/PrintLog_日志辅助函数_第七批.lua", "PrintLog")
    rootRegisters[4] = requireRecoveredClosure("PrintLog", rootPrototypes.PrintLog)

    -- PC44-PC45：T[5]暂存_G；PC45执行_G.log=T[4]。
    rootRegisters[5] = _G
    rootRegisters[5].log = rootRegisters[4]

    -- PC46-PC47：创建ShowLocalNoticeByType，捕获T[0]=a表，随后覆写T[5]。
    local makeShowNotice = sourceFunction(
        "04_源码候选/其他短辅助函数_第二批草稿.lua",
        "make_ShowLocalNoticeByType"
    )
    if makeShowNotice then
        rootPrototypes.ShowLocalNoticeByType = makeShowNotice(rootRegisters[0])
    end
    rootRegisters[5] = requireRecoveredClosure(
        "ShowLocalNoticeByType", rootPrototypes.ShowLocalNoticeByType
    )

    -- PC48-PC51：创建LuaSendMsg，按序捕获T[0]=a、T[4]=PrintLog；
    -- PC51先将T[6]闭包存入a.LuaSendMsg，之后T[6]才允许被ScheduleOnce覆盖。
    local makeLuaSendMsg = sourceFunction(
        "04_源码候选/短函数草稿_第五十批.lua", "make_LuaSendMsg"
    )
    if makeLuaSendMsg then
        rootPrototypes.LuaSendMsg = makeLuaSendMsg(rootRegisters[0], rootRegisters[4])
        rootRegisters[6] = requireRecoveredClosure("LuaSendMsg", rootPrototypes.LuaSendMsg)
        rootRegisters[0].LuaSendMsg = rootRegisters[6]
    end
    assert(rootRegisters[0].LuaSendMsg == rootPrototypes.LuaSendMsg,
        "PC51 LuaSendMsg module-field attachment failed")

    -- PC52-PC53：T[6]覆写为ScheduleOnce；T[7]创建Schedule。
    bindDirect("ScheduleOnce", "root/54_ScheduleOnce.lua", "ScheduleOnce")
    rootRegisters[6] = requireRecoveredClosure("ScheduleOnce", rootPrototypes.ScheduleOnce)
    bindDirect("Schedule", "04_源码候选/root35_AnonymousHelper_33_ScheduleWrapper.lua", "AnonymousHelper_33_Schedule")
    rootRegisters[7] = requireRecoveredClosure("Schedule", rootPrototypes.Schedule)

    -- PC54-PC63：T[8]连续复用五次；每个闭包都在下一次覆写前立即导出。
    bindDirect("GetMapId", "04_源码候选/verified_helpers_batches_1_3.lua", "GetMapId")
    rootRegisters[8] = requireRecoveredClosure("GetMapId", rootPrototypes.GetMapId)
    _G.GetMapId = rootRegisters[8]

    bindDirect("GetMapName", "04_源码候选/verified_helpers_batches_1_3.lua", "GetMapName")
    rootRegisters[8] = requireRecoveredClosure("GetMapName", rootPrototypes.GetMapName)
    _G.GetMapName = rootRegisters[8]

    bindDirect("PlayerPos", "04_源码候选/verified_helpers_batches_1_3.lua", "PlayerPos")
    rootRegisters[8] = requireRecoveredClosure("PlayerPos", rootPrototypes.PlayerPos)
    _G.PlayerPos = rootRegisters[8]

    bindDirect("GetDroppedItems", "04_源码候选/verified_helpers_batches_1_3.lua", "GetDroppedItems")
    rootRegisters[8] = requireRecoveredClosure("GetDroppedItems", rootPrototypes.GetDroppedItems)
    _G.GetDroppedItems = rootRegisters[8]

    bindDirect("MoveTo", "04_源码候选/短函数草稿_第五十三批.lua", "MoveTo")
    rootRegisters[8] = requireRecoveredClosure("MoveTo", rootPrototypes.MoveTo)
    _G.MoveTo = rootRegisters[8]

    -- PC64-PC67：T[8]=DiuItems；捕获T[2]=z表、T[5]=ShowLocalNoticeByType。
    local makeDiuItems = sourceFunction("04_源码候选/root46_DiuItems.lua", "make_DiuItems")
    if makeDiuItems and rootRegisters[5] then
        rootPrototypes.DiuItems = makeDiuItems(rootRegisters[2], rootRegisters[5])
    end
    rootRegisters[8] = requireRecoveredClosure("DiuItems", rootPrototypes.DiuItems)
    _G.DiuItems = rootRegisters[8]

    -- PC68-PC70：T[8]=GetAvailableStoragePage，捕获T[4]=PrintLog。
    local makeGetAvailableStoragePage = sourceFunction(
        "04_源码候选/短函数草稿_第十四批.lua", "make_GetAvailableStoragePage"
    )
    if makeGetAvailableStoragePage then
        rootPrototypes.GetAvailableStoragePage = makeGetAvailableStoragePage(rootRegisters[4])
    end
    rootRegisters[8] = requireRecoveredClosure(
        "GetAvailableStoragePage", rootPrototypes.GetAvailableStoragePage
    )
    _G.GetAvailableStoragePage = rootRegisters[8]

    -- PC71-PC73：T[8]=GetStorageItemData，捕获T[4]=PrintLog。
    local getStorageItemSource = sources["04_源码候选/短函数草稿_第五十六批.lua#GetStorageItemData"]
    local makeGetStorageItemData = getStorageItemSource and getStorageItemSource.make_GetStorageItemData
    if type(makeGetStorageItemData) == "function" then
        rootPrototypes.GetStorageItemData = makeGetStorageItemData(rootRegisters[4])
    end
    rootRegisters[8] = requireRecoveredClosure(
        "GetStorageItemData", rootPrototypes.GetStorageItemData
    )
    _G.GetStorageItemData = rootRegisters[8]

    -- PC74-PC78：T[8]=StorageItems，捕获[T[2],T[4],T[5]]；
    -- 两个嵌套工厂代表StorageItems内部创建的子闭包，不是root额外捕获槽。
    local makeStorageItems = sourceFunction("04_源码候选/短函数草稿_第六十批.lua", "make_StorageItems")
    local makeNestedIsOutputted = sourceFunction("04_源码候选/短函数草稿_第三十四批.lua", "make_Nested_isOutputted")
    local makeFindAvailablePage = sourceFunction(
        "04_源码候选/root50_Nested_Anonymous_2.lua", "make_FindAvailableStoragePage"
    )
    if makeStorageItems and makeNestedIsOutputted and makeFindAvailablePage then
        rootPrototypes.StorageItems = makeStorageItems(
            rootRegisters[2], rootRegisters[4], rootRegisters[5],
            makeNestedIsOutputted, makeFindAvailablePage
        )
    end
    rootRegisters[8] = requireRecoveredClosure("StorageItems", rootPrototypes.StorageItems)
    _G.StorageItems = rootRegisters[8]

    -- PC79-PC82：T[8]=TakeItems，捕获[T[2],T[5]]。
    local makeTakeItems = sourceFunction("04_源码候选/短函数草稿_第五十七批.lua", "make_TakeItems")
    if makeTakeItems and rootRegisters[5] then
        rootPrototypes.TakeItems = makeTakeItems(rootRegisters[2], rootRegisters[5])
    end
    rootRegisters[8] = requireRecoveredClosure("TakeItems", rootPrototypes.TakeItems)
    _G.TakeItems = rootRegisters[8]

    -- PC83-PC85：T[8]=PickUpItems，捕获T[5]；PC85完成本段最后一次全局导出。
    local makePickUpItems = sourceFunction("04_源码候选/PickUpItems_拾取流程_第十批.lua", "make_PickUpItems")
    if makePickUpItems and rootRegisters[5] then
        rootPrototypes.PickUpItems = makePickUpItems(rootRegisters[5])
    end
    rootRegisters[8] = requireRecoveredClosure("PickUpItems", rootPrototypes.PickUpItems)
    _G.PickUpItems = rootRegisters[8]

    -- 检查点261：gatherStatusText在root source候选的独立词法块内声明，
    -- 通过__exports导出为rootSource.gatherStatusText；不能在本装配词法块
    -- 直接引用同名局部变量，否则会读到全局nil。
    -- root PC86-PC180：配置、奖励记录和采集状态值已在root source候选中按PC顺序建立：
    -- PC86-PC89 gatherConfig；PC90-PC95 rootRegister11=18000；
    -- PC96-PC167 loginAndOnlineRewardEntries；PC168-PC172 gatherStatusText/currentState；
    -- PC173-PC180 resettableTable及T[16..22]状态槽。以下装配层从PC181开始接入闭包。
    -- 检查点250：OP_387共享live-cell适配层。
    -- 每个父root T寄存器仅创建一个cell；捕获同一寄存器的闭包复用同一对象。
    -- {value=...}是恢复适配表示，不声称原作者源码采用此数据结构。
    local function newLiveCell(value)
        return { value = value }
    end
    local rootCells = {
        [14] = newLiveCell(rootSource.currentState),
        [15] = newLiveCell(rootSource.resettableTable),
        [16] = newLiveCell(rootSource.resetSlot16),
        [17] = newLiveCell(rootSource.resetSlot17),
        [18] = newLiveCell(rootSource.isGatherRunning),
        [19] = newLiveCell(rootSource.resetSlot19),
        [20] = newLiveCell(rootSource.resetSlot20),
        [21] = newLiveCell(rootSource.resetSlot21),
        [22] = newLiveCell(rootSource.resetSlot22)
    }

    -- 每个父T寄存器只分配一个cell；不同寄存器不能误共用同一代理对象。
    local seenRootCells = {}
    for _, registerIndex in ipairs({14, 15, 16, 17, 18, 19, 20, 21, 22}) do
        local cell = rootCells[registerIndex]
        assert(type(cell) == "table" and not seenRootCells[cell],
            "invalid or reused OP_387 parent cell T[" .. registerIndex .. "]")
        seenRootCells[cell] = true
    end

    local makeFormatStateChange = sourceFunction(
        "04_源码候选/root8_FormatStateChange.lua", "make_FormatStateChange"
    )
    if makeFormatStateChange then
        rootPrototypes.FormatStateChange =
            makeFormatStateChange(rootPrototypes.PrintLog, rootCells[14])
    end
    rootPrototypes.FormatStateChange = requireRecoveredClosure(
        "FormatStateChange", rootPrototypes.FormatStateChange
    )

    -- PC184-PC193按root寄存器创建顺序绑定十个无捕获辅助闭包；均不产生根级导出。
    -- PC184 root.children[35] SetTargetID。
    bindDirect("SetTargetID", "04_源码候选/短函数草稿_第十二批.lua", "SetTargetID")
    rootPrototypes.SetTargetID = requireRecoveredClosure("SetTargetID", rootPrototypes.SetTargetID)
    -- PC185 root.children[56] ClearTargetID_2。
    bindDirect("ClearTargetID_2", "04_源码候选/root56_root57_short_functions.lua", "ClearTargetID_2")
    rootPrototypes.ClearTargetID_2 = requireRecoveredClosure("ClearTargetID_2", rootPrototypes.ClearTargetID_2)
    -- PC186 root.children[39] GetMainPlayerID包装器。
    bindDirect("GetMainPlayerID", "04_源码候选/verified_helpers_batches_1_3.lua", "GetMainPlayerID")
    rootPrototypes.GetMainPlayerID = requireRecoveredClosure("GetMainPlayerID", rootPrototypes.GetMainPlayerID)
    -- PC187 root.children[18] GetPlayerPosition。
    bindDirect("GetPlayerPosition", "04_源码候选/位置读取函数_第五批草稿.lua", "GetPlayerPosition")
    rootPrototypes.GetPlayerPosition = requireRecoveredClosure("GetPlayerPosition", rootPrototypes.GetPlayerPosition)
    -- PC188 root.children[44] GetPlayerMapPosition。
    bindDirect("GetPlayerMapPosition", "04_源码候选/短函数草稿_第三十七批.lua", "GetPlayerMapPosition")
    rootPrototypes.GetPlayerMapPosition = requireRecoveredClosure("GetPlayerMapPosition", rootPrototypes.GetPlayerMapPosition)
    -- PC189 root.children[11] DistanceCalculation。
    bindDirect("DistanceCalculation", "04_源码候选/短函数草稿_第十二批.lua", "DistanceCalculation")
    rootPrototypes.DistanceCalculation = requireRecoveredClosure("DistanceCalculation", rootPrototypes.DistanceCalculation)
    -- PC190 root.children[29] IsDie包装器。
    bindDirect("IsDie", "04_源码候选/小型辅助函数_首批草稿.lua", "IsDie")
    rootPrototypes.IsDie = requireRecoveredClosure("IsDie", rootPrototypes.IsDie)
    -- PC191 root.children[7] GetOwnerIDText。
    bindDirect("GetOwnerIDText", "04_源码候选/root7_GetOwnerIDText.lua", "GetOwnerIDText")
    rootPrototypes.GetOwnerIDText = requireRecoveredClosure("GetOwnerIDText", rootPrototypes.GetOwnerIDText)
    -- PC192 root.children[38] GetOwnerID。
    bindDirect("GetOwnerID", "04_源码候选/root38_GetOwnerID.lua", "GetOwnerID")
    rootPrototypes.GetOwnerID = requireRecoveredClosure("GetOwnerID", rootPrototypes.GetOwnerID)
    -- PC193 root.children[43] GetOwnerDescription。
    bindDirect("GetOwnerDescription", "04_源码候选/verified_helpers_batches_1_3.lua", "GetOwnerDescription")
    rootPrototypes.GetOwnerDescription = requireRecoveredClosure("GetOwnerDescription", rootPrototypes.GetOwnerDescription)

    -- FindMonsterCandidates：UP[0..4]依次为GetPlayerPosition、IsDie、
    -- GetPlayerMapPosition、DistanceCalculation、gatherConfig。五项均为
    -- 稳定函数/表引用，不涉及可变标量cell代理。
    local makeFindMonsterCandidates = sourceFunction(
        "04_源码候选/root28_FindMonsterCandidates.lua",
        "make_FindMonsterCandidates"
    )
    if makeFindMonsterCandidates and rootSource.gatherConfig then
        rootPrototypes.FindMonsterCandidates = makeFindMonsterCandidates(
            rootPrototypes.GetPlayerPosition,
            rootPrototypes.IsDie,
            rootPrototypes.GetPlayerMapPosition,
            rootPrototypes.DistanceCalculation,
            rootSource.gatherConfig
        )
    end
    rootPrototypes.FindMonsterCandidates = requireRecoveredClosure(
        "FindMonsterCandidates", rootPrototypes.FindMonsterCandidates
    )

    -- PC200-PC209创建ResetGatherMonsterData并捕获九个父寄存器值。
    local makeResetGather = sourceFunction(
        "04_源码候选/短函数草稿_第十三批.lua", "make_ResetGatherMonsterData"
    )
    if makeResetGather then
        rootPrototypes.ResetGatherMonsterData = makeResetGather(
            rootCells[15], rootCells[16], rootCells[17],
            rootPrototypes.ClearTargetID_2,
            rootCells[19], rootCells[20], rootCells[21], rootCells[22],
            rootPrototypes.PrintLog
        )
    end
    rootPrototypes.ResetGatherMonsterData = requireRecoveredClosure(
        "ResetGatherMonsterData", rootPrototypes.ResetGatherMonsterData
    )

    -- FindMonsterInCurrViewField UP[0]=T[30]=IsDie；作为MainLoop稳定函数捕获。
    local makeFindInView = sourceFunction(
        "04_源码候选/短函数草稿_第十三批.lua",
        "make_FindMonsterInCurrViewField"
    )
    if makeFindInView then
        rootPrototypes.FindMonsterInCurrViewField =
            makeFindInView(rootPrototypes.IsDie)
    end
    rootPrototypes.FindMonsterInCurrViewField = requireRecoveredClosure(
        "FindMonsterInCurrViewField", rootPrototypes.FindMonsterInCurrViewField
    )

    -- PC212-PC213：创建并导出IsInWhitelistMap；本段采集闭包的根级创建在PC210。
    bindDirect("IsInWhitelistMap",
        "04_源码候选/短函数草稿_第十二批.lua", "IsInWhitelistMap")
    rootPrototypes.IsInWhitelistMap = requireRecoveredClosure(
        "IsInWhitelistMap", rootPrototypes.IsInWhitelistMap
    )
    _G.IsInWhitelistMap = rootPrototypes.IsInWhitelistMap

    local makeMainLoop = sourceFunction(
        "04_源码候选/root45_MainLoop.lua", "make_MainLoop"
    )
    if makeMainLoop then
        rootPrototypes.MainLoop = makeMainLoop(
            rootCells[18], rootCells[14], rootSource.gatherStatusText,
            rootPrototypes.PrintLog, rootPrototypes.FormatStateChange,
            rootPrototypes.ResetGatherMonsterData,
            rootPrototypes.GetMainPlayerID, rootPrototypes.FindMonsterCandidates,
            rootCells[15], rootPrototypes.GetOwnerID, rootCells[17],
            rootCells[16], rootCells[19], rootCells[20], rootCells[22],
            rootPrototypes.FindMonsterInCurrViewField, rootCells[21],
            rootPrototypes.GetOwnerIDText, rootPrototypes.IsDie,
            rootPrototypes.GetOwnerDescription, rootPrototypes.SetTargetID,
            rootSource.gatherConfig
        )
    end
    rootPrototypes.MainLoop = requireRecoveredClosure("MainLoop", rootPrototypes.MainLoop)
    _G.MainLoop = rootPrototypes.MainLoop

    local makeInitGather = sourceFunction(
        "04_源码候选/InitGatherMonsters_初始化逻辑_第八批草稿.lua",
        "make_InitGatherMonsters"
    )
    if makeInitGather then
        rootPrototypes.InitGatherMonsters = makeInitGather(
            rootSource.timerState, rootCells[18],
            rootPrototypes.FormatStateChange, rootSource.gatherStatusText,
            rootPrototypes.ResetGatherMonsterData, rootSource.gatherConfig,
            rootPrototypes.PrintLog
        )
    end
    rootPrototypes.InitGatherMonsters = requireRecoveredClosure(
        "InitGatherMonsters", rootPrototypes.InitGatherMonsters
    )
    _G.InitGatherMonsters = rootPrototypes.InitGatherMonsters

    local makeStopGather = sourceFunction(
        "04_源码候选/短函数草稿_第十三批.lua", "make_StopGatherMonsters"
    )
    if makeStopGather then
        rootPrototypes.StopGatherMonsters = makeStopGather(
            rootCells[18], rootSource.timerState,
            rootPrototypes.ClearTargetID_2, rootPrototypes.FormatStateChange,
            rootSource.gatherStatusText, rootPrototypes.ResetGatherMonsterData,
            rootPrototypes.PrintLog
        )
    end
    rootPrototypes.StopGatherMonsters = requireRecoveredClosure(
        "StopGatherMonsters", rootPrototypes.StopGatherMonsters
    )
    _G.StopGatherMonsters = rootPrototypes.StopGatherMonsters

    -- Builtsetting：UP[0]=root T[5]=ShowLocalNoticeByType；PC258导出全局。
    local makeBuiltsetting = sourceFunction(
        "04_源码候选/短函数草稿_第四十五批.lua",
        "make_Builtsetting"
    )
    if makeBuiltsetting and rootPrototypes.ShowLocalNoticeByType then
        rootPrototypes.Builtsetting =
            makeBuiltsetting(rootPrototypes.ShowLocalNoticeByType)
    end
    rootPrototypes.Builtsetting = requireRecoveredClosure(
        "Builtsetting", rootPrototypes.Builtsetting
    )
    _G.Builtsetting = rootPrototypes.Builtsetting

    -- root PC259-PC260：创建无捕获MoveItemToQuickUse；PC260导出全局。
    bindDirect("MoveItemToQuickUse",
        "04_源码候选/root_MainLeftBottom_Module.lua", "MoveItemToQuickUse")
    rootPrototypes.MoveItemToQuickUse = requireRecoveredClosure(
        "MoveItemToQuickUse", rootPrototypes.MoveItemToQuickUse
    )
    _G.MoveItemToQuickUse = rootPrototypes.MoveItemToQuickUse

    -- 检查点251：UI闭包按父root寄存器T[0]/T[1]/T[3]捕获顺序注入。
    -- T[0]=MainLeftBottom.a（UI状态对象），T[1]=MainLeftBottom.b（按钮映射），
    -- T[3]=timerState；三者均为共享表引用，不作值复制。
    assert(rootSource.uiState == rootModule.a
        and rootSource.buttonMap == rootModule.b
        and type(rootSource.timerState) == "table",
        "PC261-PC274 UI capture object identity mismatch")
    local makeDestroyUI = sourceFunction(
        "04_源码候选/短函数草稿_第十四批.lua", "make_DestroyUI"
    )
    if makeDestroyUI then
        rootPrototypes.DestroyUI = makeDestroyUI(
            rootSource.uiState, rootSource.timerState, rootSource.buttonMap
        )
    end
    rootPrototypes.DestroyUI = requireRecoveredClosure("DestroyUI", rootPrototypes.DestroyUI)
    rootModule.hide = rootPrototypes.DestroyUI

    local makeSetButtonVisibility = sourceFunction(
        "04_源码候选/短函数草稿_第十三批.lua", "make_SetButtonVisibilityState"
    )
    if makeSetButtonVisibility then
        rootPrototypes.SetButtonVisibilityState = makeSetButtonVisibility(
            rootSource.uiState, rootSource.buttonMap
        )
    end
    rootPrototypes.SetButtonVisibilityState = requireRecoveredClosure(
        "SetButtonVisibilityState", rootPrototypes.SetButtonVisibilityState
    )
    rootModule.show = rootPrototypes.SetButtonVisibilityState

    local makeShowHideAll = sourceFunction(
        "04_源码候选/短函数草稿_第十四批.lua", "make_ShowHideAllButtons"
    )
    if makeShowHideAll then
        rootPrototypes.ShowHideAllButtons = makeShowHideAll(
            rootSource.timerState, rootSource.buttonMap, rootSource.uiState
        )
    end
    rootPrototypes.ShowHideAllButtons = requireRecoveredClosure(
        "ShowHideAllButtons", rootPrototypes.ShowHideAllButtons
    )
    rootModule.destroy = rootPrototypes.ShowHideAllButtons

    -- PC275：按字节码重新读取_ENV.MainLeftBottom；PC276-PC278创建AccountIDValidation。
    local accountValidationModule = _G.MainLeftBottom
    assert(type(accountValidationModule) == "table",
        "PC275 _ENV.MainLeftBottom is not a table")

    -- AccountIDValidation：UP[0]=root T[4]=PrintLog，UP[1]=root T[5]=ShowLocalNoticeByType。
    -- 内部Nested_ID与Nested_Panel_mini_chat工厂保留在同一来源词法块。
    local makeAccountIDValidation = sourceFunction(
        "04_源码候选/root55_children_drafts.lua",
        "make_AccountIDValidation"
    )
    if makeAccountIDValidation and rootPrototypes.ShowLocalNoticeByType then
        rootPrototypes.AccountIDValidation = makeAccountIDValidation(
            rootPrototypes.PrintLog,
            rootPrototypes.ShowLocalNoticeByType
        )
    end
    rootPrototypes.AccountIDValidation = requireRecoveredClosure(
        "AccountIDValidation", rootPrototypes.AccountIDValidation
    )
    -- PC279：字段写入目标是PC275重新读取的_ENV.MainLeftBottom。
    accountValidationModule.main = rootPrototypes.AccountIDValidation

    -- PC280-PC296的模块状态和配置常量来自root来源词法块。
    assert(type(rootSource.randomTeleportItemNames) == "table"
        and #rootSource.randomTeleportItemNames == 1
        and rootSource.randomTeleportItemNames[1] == "随机传送石",
        "PC280-PC282 randomTeleportItemNames reconstruction mismatch")
    assert(type(rootSource.blacklistState) == "table"
        and rootModule.blacklist == rootSource.blacklistState
        and rootSource.blacklistState.lastAttacker == nil
        and rootSource.blacklistState.lastHp == nil
        and rootSource.blacklistState.deathHandled == false
        and rootSource.blacklistState.alertAt == 0
        and rootSource.blacklistState.nextTryAt == 0
        and rootSource.blacklistState.noStoneWarned == false
        and rootSource.blacklistState.distance == nil,
        "PC286-PC294 blacklistState identity/initial values mismatch")
    assert(rootSource.blacklistAlertThreshold == 2.0
        and rootSource.blacklistShortRetryDelay == 0.01
        and rootSource.blacklistNoItemRetryDelay == 30.0,
        "PC283-PC285 blacklist timing constants mismatch")
    assert(rootSource.blacklistDistanceConfigFile == "blacklist_distance.txt"
        and rootSource.gatherMonsterCountConfigFile == "gather_monster_count.txt",
        "PC295-PC296 configuration file names mismatch")

    -- 检查点266：PC297-PC315配置文件包装链。
    -- rootConfigRegisters是恢复适配层影子表，显式记录T[42..51]捕获身份。
    local rootConfigRegisters = {
        [42] = rootSource.blacklistDistanceConfigFile,
        [43] = rootSource.gatherMonsterCountConfigFile
    }

    -- PC297：创建无捕获GetWritablePath，写入T[44]。
    bindDirect("GetWritablePath",
        "04_源码候选/verified_helpers_batches_1_3.lua", "GetWritablePath")
    rootConfigRegisters[44] = requireRecoveredClosure(
        "GetWritablePath", rootPrototypes.GetWritablePath
    )

    -- PC298-PC299：ReadNumericConfig捕获T[44]，创建后写入T[45]。
    local makeReadNumericConfig = sourceFunction(
        "04_源码候选/root9_ReadNumericConfig.lua", "make_ReadNumericConfig"
    )
    if makeReadNumericConfig then
        rootPrototypes.ReadNumericConfig =
            makeReadNumericConfig(rootConfigRegisters[44])
    end
    rootConfigRegisters[45] = requireRecoveredClosure(
        "ReadNumericConfig", rootPrototypes.ReadNumericConfig
    )

    -- PC300-PC301：PCallHelper捕获同一T[44]，创建后写入T[46]。
    local makePCallHelper = sourceFunction(
        "04_源码候选/PCallHelper_文件写入包装_第六批草稿.lua",
        "make_PCallHelper"
    )
    if makePCallHelper then
        rootPrototypes.PCallHelper =
            makePCallHelper(rootConfigRegisters[44])
    end
    rootConfigRegisters[46] = requireRecoveredClosure(
        "PCallHelper", rootPrototypes.PCallHelper
    )

    -- PC302-PC303：FileExistCheck_pcall_wrapper捕获T[44]，写入T[47]。
    local makeFileExistCheck = sourceFunction(
        "04_源码候选/短函数草稿_第三十八批.lua",
        "make_FileExistCheck_pcall_wrapper"
    )
    if makeFileExistCheck then
        rootPrototypes.FileExistCheck_pcall_wrapper =
            makeFileExistCheck(rootConfigRegisters[44])
    end
    rootConfigRegisters[47] = requireRecoveredClosure(
        "FileExistCheck_pcall_wrapper", rootPrototypes.FileExistCheck_pcall_wrapper
    )

    -- PC304-PC306：AnonymousHelper_49捕获[T[45],T[42]]，写入T[48]。
    local makeAnonymousHelper49 = sourceFunction(
        "04_源码候选/root49_AnonymousHelper_49.lua", "make_AnonymousHelper_49"
    )
    if makeAnonymousHelper49 then
        rootPrototypes.AnonymousHelper_49 = makeAnonymousHelper49(
            rootConfigRegisters[45], rootConfigRegisters[42]
        )
    end
    rootConfigRegisters[48] = requireRecoveredClosure(
        "AnonymousHelper_49", rootPrototypes.AnonymousHelper_49
    )

    -- PC307-PC309：AnonymousHelper_32捕获[T[46],T[42]]，写入T[49]。
    local makeAnonymousHelper32 = sourceFunction(
        "04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua",
        "make_AnonymousHelper_32"
    )
    if makeAnonymousHelper32 then
        rootPrototypes.AnonymousHelper_32 = makeAnonymousHelper32(
            rootConfigRegisters[46], rootConfigRegisters[42]
        )
    end
    rootConfigRegisters[49] = requireRecoveredClosure(
        "AnonymousHelper_32", rootPrototypes.AnonymousHelper_32
    )

    -- PC310-PC312：AnonymousHelper_33捕获[T[45],T[43]]，写入T[50]。
    local makeAnonymousHelper33 = sourceFunction(
        "04_源码候选/PlayerPos与匿名转发闭包_第十一批.lua",
        "make_AnonymousHelper_33"
    )
    if makeAnonymousHelper33 then
        rootPrototypes.AnonymousHelper_33 = makeAnonymousHelper33(
            rootConfigRegisters[45], rootConfigRegisters[43]
        )
    end
    rootConfigRegisters[50] = requireRecoveredClosure(
        "AnonymousHelper_33", rootPrototypes.AnonymousHelper_33
    )

    -- PC313-PC315：AnonymousHelper_54捕获[T[46],T[43]]，写入T[51]。
    local makeAnonymousHelper54 = sourceFunction(
        "root/55_AnonymousHelper_54.lua", "make_AnonymousHelper_54"
    )
    if makeAnonymousHelper54 then
        rootPrototypes.AnonymousHelper_54 = makeAnonymousHelper54(
            rootConfigRegisters[46], rootConfigRegisters[43]
        )
    end
    rootConfigRegisters[51] = requireRecoveredClosure(
        "AnonymousHelper_54", rootPrototypes.AnonymousHelper_54
    )

    -- PC316-PC349：T[52]是八个二元数值子表构成的外层数组；只核对原始值，
    -- 不为其命名业务用途，也不把它误认成脚本函数或引擎API。
    local expectedOpaquePairs = {
        {1, 0}, {-1, 0}, {0, 1}, {0, -1},
        {1, 1}, {1, -1}, {-1, 1}, {-1, -1}
    }
    assert(type(rootSource.opaquePairTable) == "table"
        and #rootSource.opaquePairTable == #expectedOpaquePairs,
        "PC316-PC349 T[52] outer table size mismatch")
    for i, expectedPair in ipairs(expectedOpaquePairs) do
        local actualPair = rootSource.opaquePairTable[i]
        assert(type(actualPair) == "table"
            and actualPair[1] == expectedPair[1]
            and actualPair[2] == expectedPair[2],
            "PC316-PC349 T[52] pair mismatch at index " .. i)
    end

    -- root.children[22]捕获T[52]；静态可达路径不读取此表，但保留真实捕获注入。
    local makeGetMapData2DPtr = sourceFunction(
        "04_源码候选/root22_GetMapData2DPtr.lua", "make_GetMapData2DPtr"
    )
    if makeGetMapData2DPtr then
        rootPrototypes.GetMapData2DPtr =
            makeGetMapData2DPtr(rootSource.opaquePairTable)
    end
    rootPrototypes.GetMapData2DPtr = requireRecoveredClosure(
        "GetMapData2DPtr", rootPrototypes.GetMapData2DPtr
    )

    -- root.children[51] UP[0]=root.children[48] PCallHelper_2。
    -- root PC352：创建无捕获PCallHelper_2，PC353由FindBlacklistPlayer捕获。
    bindDirect("PCallHelper_2",
        "04_源码候选/代理与回调短函数_第四批.lua", "PCallHelper_2")
    rootPrototypes.PCallHelper_2 = requireRecoveredClosure(
        "PCallHelper_2", rootPrototypes.PCallHelper_2
    )

    local makeFindBlacklistPlayer = sourceFunction(
        "04_源码候选/root49_PCallHelper_2_and_root51_FindBlacklistPlayer.lua",
        "make_FindBlacklistPlayer"
    )
    if makeFindBlacklistPlayer then
        rootPrototypes.FindBlacklistPlayer =
            makeFindBlacklistPlayer(rootPrototypes.PCallHelper_2)
    end
    rootPrototypes.FindBlacklistPlayer = requireRecoveredClosure(
        "FindBlacklistPlayer", rootPrototypes.FindBlacklistPlayer
    )

    -- root.children[24] UP[0]=root T[37]随机传送物品名称表。
    local makeUseItemByIndex = sourceFunction(
        "04_源码候选/短函数草稿_第三十一批.lua", "make_UseItemByIndex"
    )
    if makeUseItemByIndex then
        rootPrototypes.UseItemByIndex =
            makeUseItemByIndex(rootSource.randomTeleportItemNames)
    end
    rootPrototypes.UseItemByIndex = requireRecoveredClosure(
        "UseItemByIndex", rootPrototypes.UseItemByIndex
    )

    local makeOnDamageMsg = sourceFunction(
        "04_源码候选/root52_onDamageMsg.lua", "make_onDamageMsg"
    )
    if makeOnDamageMsg then
        rootPrototypes.onDamageMsg = makeOnDamageMsg(rootSource.blacklistState)
    end
    rootPrototypes.onDamageMsg = requireRecoveredClosure(
        "onDamageMsg", rootPrototypes.onDamageMsg
    )
    rootModule.onDamageMsg = rootPrototypes.onDamageMsg
    assert(rootModule.onDamageMsg == rootPrototypes.onDamageMsg,
        "PC359 MainLeftBottom.onDamageMsg attachment failed")

    -- root PC360-PC362：InstallDamageHook捕获T[0]=MainLeftBottom.a、T[4]=PrintLog。
    -- PC360写入T[57]；后续BlacklistPlayerDetection捕获同一个live cell。
    local makeInstallDamageHook = sourceFunction(
        "04_源码候选/短函数草稿_第三十九批.lua",
        "make_InstallDamageHook"
    )
    if makeInstallDamageHook then
        rootPrototypes.InstallDamageHook = makeInstallDamageHook(
            rootModule.a,
            rootPrototypes.PrintLog
        )
    end
    rootPrototypes.InstallDamageHook = requireRecoveredClosure(
        "InstallDamageHook", rootPrototypes.InstallDamageHook
    )
    local damageHookCell = newLiveCell(rootPrototypes.InstallDamageHook)
    assert(not seenRootCells[damageHookCell],
        "T[57] InstallDamageHook live cell aliases another root cell")
    seenRootCells[damageHookCell] = true
    rootCells[57] = damageHookCell
    assert(rootCells[57].value == rootPrototypes.InstallDamageHook
        and rootCells[57].value ~= rootPrototypes.onDamageMsg,
        "PC360 T[57] must contain InstallDamageHook, not onDamageMsg")

    local makeDeathAutoBlacklist = sourceFunction(
        "04_源码候选/root25_DeathAutoBlacklist.lua", "make_DeathAutoBlacklist"
    )
    if makeDeathAutoBlacklist then
        rootPrototypes.DeathAutoBlacklist = makeDeathAutoBlacklist(
            rootSource.blacklistState,
            rootPrototypes.PrintLog,
            rootPrototypes.FindBlacklistPlayer,
            rootPrototypes.ShowLocalNoticeByType
        )
    end
    rootPrototypes.DeathAutoBlacklist = requireRecoveredClosure(
        "DeathAutoBlacklist", rootPrototypes.DeathAutoBlacklist
    )

    -- 检查点255：BlacklistPlayerDetection的13项捕获按root PC368顺序注入。
    -- UP[0]=root T[2]=MainLeftBottom.z状态表；UP[1]=root T[57]共享live cell，
    -- PC360已将其值覆盖为InstallDamageHook；UP[2]=共享blacklistState。
    -- 用rootCells[57]保留OP_387 cell语义，工厂内部通过.value()读取并调用当前函数值。
    -- 特别注意：不能将UP[0]误接为整个MainLeftBottom模块表，也不能将UP[1]接成onDamageMsg。
    local makeBlacklistPlayerDetection = sourceFunction(
        "04_源码候选/root47_BlacklistPlayerDetection.lua",
        "make_BlacklistPlayerDetection"
    )
    if makeBlacklistPlayerDetection then
        rootPrototypes.BlacklistPlayerDetection = makeBlacklistPlayerDetection(
            rootModule.z,
            rootCells[57],
            rootSource.blacklistState,
            rootPrototypes.DeathAutoBlacklist,
            rootPrototypes.FindBlacklistPlayer,
            rootPrototypes.GetMapData2DPtr,
            rootSource.blacklistAlertThreshold,
            rootPrototypes.PrintLog,
            rootPrototypes.UseItemByIndex,
            rootSource.blacklistShortRetryDelay,
            rootPrototypes.ShowLocalNoticeByType,
            rootSource.blacklistNoItemRetryDelay,
            rootSource.randomTeleportItemNames
        )
    end
    rootPrototypes.BlacklistPlayerDetection = requireRecoveredClosure(
        "BlacklistPlayerDetection", rootPrototypes.BlacklistPlayerDetection
    )
    _G.BlacklistItems = rootPrototypes.BlacklistPlayerDetection

    local makeClearBlacklistItems = sourceFunction(
        "04_源码候选/短函数草稿_第五十四批.lua", "make_ClearBlacklistItems"
    )
    if makeClearBlacklistItems then
        rootPrototypes.ClearBlacklistItems = makeClearBlacklistItems(
            rootPrototypes.PCallHelper_2,
            rootPrototypes.PrintLog,
            rootPrototypes.ShowLocalNoticeByType,
            rootSource.blacklistState
        )
    end
    rootPrototypes.ClearBlacklistItems = requireRecoveredClosure(
        "ClearBlacklistItems", rootPrototypes.ClearBlacklistItems
    )
    _G.ClearBlacklistItems = rootPrototypes.ClearBlacklistItems

    -- 检查点267：PC350-PC388黑名单闭包链的对象身份与导出落点复核。
    assert(rootModule.blacklist == rootSource.blacklistState,
        "PC294/357/363/368/383 blacklistState identity mismatch")
    assert(rootModule.onDamageMsg == rootPrototypes.onDamageMsg,
        "PC359 onDamageMsg module field mismatch")
    assert(rootCells[57] and rootCells[57].value == rootPrototypes.InstallDamageHook,
        "PC360/368 T[57] live-cell value mismatch")
    assert(rootCells[57].value ~= rootPrototypes.onDamageMsg,
        "PC357 onDamageMsg must not replace PC360 InstallDamageHook in T[57]")
    assert(_G.BlacklistItems == rootPrototypes.BlacklistPlayerDetection,
        "PC382 BlacklistItems global export mismatch")
    assert(_G.ClearBlacklistItems == rootPrototypes.ClearBlacklistItems,
        "PC388 ClearBlacklistItems global export mismatch")

    -- 检查点256：最后一个root.children[42]工厂，20项捕获严格按PC390-PC410顺序注入。
    local makeDoInitUI = sourceFunction(
        "04_源码候选/短函数草稿_第六十三批.lua", "make_doInit_UI"
    )
    if makeDoInitUI then
        rootPrototypes.doInit_UI = makeDoInitUI(
            rootPrototypes.PrintLog,                         -- UP0 <- T[4]
            rootModule.z,                                    -- UP1 <- T[2]
            rootSource.timerState,                            -- UP2 <- T[3]
            rootModule.a,                                    -- UP3 <- T[0]
            rootModule.b,                                    -- UP4 <- T[1]
            rootSource.blacklistState,                        -- UP5 <- T[41]
            rootConfigRegisters[48],                       -- UP6 <- T[48]
            rootPrototypes.Schedule,                          -- UP7 <- T[7]
            rootPrototypes.FindMonsterInCurrViewField,        -- UP8 <- T[8]
            rootConfigRegisters[50],                       -- UP9 <- T[50]
            rootConfigRegisters[49],                       -- UP10 <- T[49]
            rootPrototypes.ShowLocalNoticeByType,             -- UP11 <- T[5]
            rootConfigRegisters[44],                       -- UP12 <- T[44]
            rootSource.blacklistDistanceConfigFile,           -- UP13 <- T[42]
            rootConfigRegisters[51],                       -- UP14 <- T[51]
            rootSource.gatherMonsterCountConfigFile,          -- UP15 <- T[43]
            rootConfigRegisters[47],                       -- UP16 <- T[47]
            rootSource.rootRegister11,                        -- UP17 <- T[11] = 18000
            rootSource.loginAndOnlineRewardEntries,           -- UP18 <- T[12]
            0.2                                               -- UP19 <- T[9]
        )
    end
    rootPrototypes.doInit_UI = requireRecoveredClosure("doInit_UI", rootPrototypes.doInit_UI)
    -- PC411：将doInit_UI闭包写入原模块字段MainLeftBottom.doInit。
    rootModule.doInit = rootPrototypes.doInit_UI
    assert(rootModule.doInit == rootPrototypes.doInit_UI,
        "PC411 MainLeftBottom.doInit attachment failed")

    -- 根级全局导出已在各自PC创建点写入；不在模块尾部重复赋值。
    MainLeftBottomRecovered.root_module = rootModule
    MainLeftBottomRecovered.root_prototypes = rootPrototypes
    MainLeftBottomRecovered.root_assembly_checkpoint = {
        checkpoint = 267,
        root_pc86_pc211_ordered = true,
        root_pc181_pc258_ordered = true,
        root_pc297_pc357_ordered = true,
        root_pc357_pc388_ordered = true,
        root_prefix_pc43_pc85_ordered = true,
        checkpoint261_gather_status_scope_fixed = true,
        checkpoint262_root_pc1_pc42_sequential_source_restored = true,
        checkpoint263_root_pc43_pc85_register_ordered = true,
        checkpoint264_root_pc86_pc211_cells_capture_ordered = true,
        checkpoint265_root_pc212_pc296_module_fields_guarded = true,
        checkpoint266_root_pc297_pc315_config_registers_ordered = true,
        checkpoint267_root_pc350_pc388_blacklist_chain_guarded = true,
        root_late_direct_bindings_at_pc = { IsInWhitelistMap = 212, MoveItemToQuickUse = 259, GetWritablePath = 297, PCallHelper_2 = 352 },
        direct_child_closures_expected = 22,
        direct_child_closures_bound = 22 - #missing,
        missing = missing,
        captured_factory_closures_expected = 36,
        captured_factory_closures_bound = 36,
        captured_factory_closures_pending = 0,
        captured_factory_names_bound = {
            "ShowLocalNoticeByType", "DiuItems", "FindMonsterCandidates",
            "LuaSendMsg", "GetAvailableStoragePage", "GetStorageItemData",
            "TakeItems", "PickUpItems", "StorageItems", "Builtsetting",
            "AccountIDValidation", "InstallDamageHook", "FormatStateChange",
            "ResetGatherMonsterData", "MainLoop", "InitGatherMonsters",
            "StopGatherMonsters", "FindMonsterInCurrViewField", "DestroyUI",
            "SetButtonVisibilityState", "ShowHideAllButtons", "ReadNumericConfig",
            "PCallHelper", "FileExistCheck_pcall_wrapper", "GetMapData2DPtr",
            "FindBlacklistPlayer", "UseItemByIndex", "AnonymousHelper_49",
            "AnonymousHelper_54", "DeathAutoBlacklist", "onDamageMsg",
            "ClearBlacklistItems", "AnonymousHelper_32", "AnonymousHelper_33",
            "BlacklistPlayerDetection", "doInit_UI"
        },
        runtime_verified = false,
        capture_semantics = "OP_387 shared cells T[14..22] represented by one shared {value=...} adapter per parent register; gather live cells and UI shared tables are passed by identity; T[44] GetWritablePath is shared by three helpers; T[52] and T[37] captures are injected; blacklistState and config filename captures are shared; root.children[32]/[33] anonymous wrappers are bound; T[57] live cell is represented by rootCells[57]; BlacklistPlayerDetection dereferences .value()"
    }
end

-- root PC412：原模块的最终返回值是MainLeftBottom表。
-- 本恢复稿内部使用MainLeftBottomRecovered.sources保存工厂注册信息，
-- 该注册容器属于恢复适配层，不是原模块导出对象。
local recoveredRootModule = MainLeftBottomRecovered.root_module
assert(type(recoveredRootModule) == "table",
    "recovered MainLeftBottom root module was not assembled")
return recoveredRootModule
