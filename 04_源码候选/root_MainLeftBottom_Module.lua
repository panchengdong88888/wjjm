-- MainLeftBottom(2).lua 根模块首段普通 Lua 草稿
-- 原型：root / MainLeftBottom_Module
-- 规范路径：root
-- 规模：412条物理指令、109常量、58个直接子原型
-- 检查点192-198、262-267：根模块分段普通Lua草稿，PC1-PC412均已建立分段记录；非作者原文逐字恢复，未运行时验证。
-- 状态：不是完整根模块源码，尚未运行时验证。
-- 检查点236：58个直接子原型闭包创建点与135个OP_387 live-cell捕获已建表，见docs/handoff/12_根模块闭包装配表.json。

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

-- PC1-PC42已按检查点262恢复初始化语句；PC43-PC85已按T寄存器顺序装配；PC86-PC211采集闭包及共享cell已在主恢复稿装配；PC212-PC296 UI闭包与模块字段已补充来源校验；PC297-PC315配置包装链已按T[44..51]顺序装配；PC316-PC349八组数值表已按原值核对；PC350-PC388黑名单闭包捕获与T[57]身份已在主恢复稿装配；PC390-PC412最终UI入口/返回路径待最后核验。
-- 本文件不是完整、可直接运行的原始Lua文件。


-- 检查点193：PC43-PC85，根模块辅助闭包创建与导出。
-- PC42的T[3] timerState已在前段创建；本段从PC43开始记录子闭包创建。
-- PC43-PC45：创建 root.children[16] PrintLog 闭包，并赋值给 _G.log。
-- PC46：创建 root.children[20] ShowLocalNoticeByType 闭包，捕获父 T[0]；
-- 本段没有观察到其全局导出，暂不臆测其最终持有位置。
-- PC48-PC51：创建 root.children[12] LuaSendMsg 闭包，捕获父 T[0]、T[4]，
-- 并将该闭包写入 PC3-PC5 创建的 MainLeftBottom.a.LuaSendMsg。
-- PC52-PC53：创建 ScheduleOnce、Schedule；PC54创建GetMapId；
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
-- 检查点263：主恢复稿装配段以rootRegisters影子表显式模拟T[4..8]的复用：
-- T[4]=PrintLog；T[5]先为_G（PC44/45写_G.log），PC46后为ShowLocalNoticeByType；
-- T[6]先为LuaSendMsg并于PC51写入a.LuaSendMsg，PC52再覆写为ScheduleOnce；
-- T[7]=Schedule；T[8]按PC54/56/58/60/62/64/68/71/74/79/83依次复用为
-- GetMapId/GetMapName/PlayerPos/GetDroppedItems/MoveTo/DiuItems/
-- GetAvailableStoragePage/GetStorageItemData/StorageItems/TakeItems/PickUpItems，
-- 每次全局导出均在下一次T[8]覆写前完成。
-- rootRegisters是恢复适配影子表，不是原作者源码中的真实table。
--
-- 注意：OP_387后续记录是闭包捕获描述，不是独立业务语句。
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
-- [3]=T[25] ClearTargetID_2闭包（清除当前目标）；
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
-- PC359：MainLeftBottom.onDamageMsg = onDamageMsg，实际消息处理器保存在模块字段。
-- PC360-PC362：创建root.children[6] / InstallDamageHook，捕获父T[0]=MainLeftBottom.a、T[4]=PrintLog，并覆盖同一父寄存器T[57]。
-- PC368创建BlacklistPlayerDetection时捕获T[57]的live cell；因此其UP[1]是PC360写入的InstallDamageHook，不是PC357创建的onDamageMsg处理器。
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


-- ============================================================================
-- 检查点237：高复用root寄存器值生命周期表（按OP_387 live cell语义）
--
-- 本节以corrected phase3 root反汇编的直接写入PC为边界。OP_387捕获父T表
-- 与寄存器编号组成的live cell，因此捕获时必须读取该PC之前最后一次写入的值。
-- 详细机器表：docs/handoff/12_根模块闭包装配表.json / register_value_timeline。
--
-- T[0]：PC1创建MainLeftBottom模块表并于PC2导出；PC3将寄存器T[0]改写为
--       a配置表，PC5写入MainLeftBottom.a。后续捕获的都是a表，不是模块根表。
-- T[1]：PC17临时构造Blocklist数组并于PC23写入a.Blocklist；PC24/26分别
--       重置为SendHookList/RecvHookList并于PC25/27赋值；PC30最终重置为b表，
--       PC32写入MainLeftBottom.b。所有闭包捕获都发生在PC30之后。
-- T[2]：PC18的1.0先用于PC22构造Blocklist；PC31短暂读入模块表，PC33立即
--       覆盖为z状态表，PC35写入MainLeftBottom.z，PC36-PC41初始化六个状态位。
--       后续五个捕获点取得的均是z表。
-- T[3]：PC19的9.0先用于Blocklist；PC42覆盖为新的timer-state表。后续五个
--       捕获点都在PC42之后；业务角色沿用已复核的ShowHideAllButtons映射。
-- T[4]：PC20的10.0先用于Blocklist；PC43创建PrintLog并写入T[4]，PC45导出
--       _G.log。PC72 GetStorageItemData捕获的就是PrintLog，通知回调身份现已确定。
-- T[5]：PC21的60000.0先用于Blocklist；PC44临时写入_G，PC46覆盖为
--       ShowLocalNoticeByType闭包。后续十个捕获点均取得该通知回调。
-- T[37]：PC212-PC270依次复用为IsInWhitelistMap、MainLoop、InitGatherMonsters、StopGatherMonsters、Builtsetting、MoveItemToQuickUse、DestroyUI、SetButtonVisibilityState、ShowHideAllButtons等闭包；PC275写入MainLeftBottom，
--       PC280重置为空表，PC281-PC282构造{"随机传送石"}。PC356 UseItemByIndex
--       和PC381 BlacklistPlayerDetection捕获的都是该一元素数组。
-- T[41]：PC286创建黑名单状态表，PC287-PC293初始化lastAttacker=nil、
--       lastHp=nil、deathHandled=false、alertAt=0、nextTryAt=0、
--       noStoneWarned=false、distance=nil；PC294赋给MainLeftBottom.blacklist。
--       五个捕获点共享此同一状态表。
-- T[57]：PC327-PC349先作为八向数值表中的一个二元素子表{1,1}；
--       PC357改写为onDamageMsg并于PC359存入MainLeftBottom.onDamageMsg；
--       PC360再改写为InstallDamageHook。PC370的唯一捕获因此是
--       BlacklistPlayerDetection.UP[1]=InstallDamageHook。
--
-- 本批已闭合9个高复用/关键寄存器的值生命周期与捕获时值；其余寄存器继续
-- 按fanout与写入复用顺序复核。此表是根模块装配证据，不代表根模块整体完成。


-- 检查点238：T[8]/T[42]/T[43]/T[44]共享cell值生命周期已按PC核对。
-- T[8]在PC86覆盖为gatherConfig并由PC87-PC89填充；PC199/236/244/399捕获该配置表。
-- T[42]=blacklist_distance.txt（PC295；捕获PC306/309/404）；T[43]=gather_monster_count.txt（PC296；捕获PC312/315/406）。
-- T[44]在PC297承载GetWritablePath闭包，PC299/301/303/403捕获同一闭包cell。
-- 详细逐PC时间线见docs/handoff/12_根模块闭包装配表.json；本批未改变静态完成数及运行时验证数。


-- 检查点239：根模块寄存器生命周期补充（均按捕获PC处的共享live cell值记录）。
-- T38=2.0（BlacklistPlayerDetection告警间隔）；T39=0.01（成功重试延迟）；T40=30.0（无道具重试延迟）。
-- T50=AnonymousHelper_33(ReadNumericConfig, 'gather_monster_count.txt')；由doInit_UI UP9捕获。
-- T52=PC349构造的8元素表，PC351被GetMapData2DPtr捕获；其可达源码路径不读取该UPVALUE。
-- T53=GetMapData2DPtr；T55=FindBlacklistPlayer；T56=UseItemByIndex(itemNameList)；T58=DeathAutoBlacklist。
-- BlacklistPlayerDetection的UP3/4/5/6/8/9/11与上述捕获身份/常量逐项对齐。详见docs/handoff/12_根模块闭包装配表.json及检查点239审计。


-- 检查点240：root PC298-PC315配置文件读写包装链与doInit_UI捕获槽闭合。
-- T[45]=root.children[9] ReadNumericConfig(GetWritablePath)，PC298创建，PC299捕获T[44]；
-- PC305由AnonymousHelper_49捕获为UP[0]，PC311由AnonymousHelper_33捕获为UP[0]。
-- T[46]=root.children[17] PCallHelper(GetWritablePath)，PC300创建，PC301捕获T[44]；
-- PC308由AnonymousHelper_32捕获为UP[0]，PC314由AnonymousHelper_54捕获为UP[0]。
-- T[47]=root.children[0] FileExistCheck_pcall_wrapper，PC302创建、PC303捕获T[44]；
-- T[48]=AnonymousHelper_49(ReadNumericConfig,"blacklist_distance.txt")；
-- T[49]=AnonymousHelper_32(PCallHelper,"blacklist_distance.txt")；
-- T[50]=AnonymousHelper_33(ReadNumericConfig,"gather_monster_count.txt")；
-- T[51]=AnonymousHelper_54(PCallHelper,"gather_monster_count.txt")。
-- PC390 doInit_UI捕获：UP[6]=T48、UP[9]=T50、UP[10]=T49、UP[12]=T44、
-- UP[14]=T51、UP[16]=T47。注意root.children[33]的恢复名是AnonymousHelper_33；
-- legacy root/34是路径标签，不是函数名。完整寄存器时间线见12_根模块闭包装配表。


-- 检查点241：root PC1-PC85模块字段与全局导出逐PC对账。
-- 模块根表：PC1创建，PC2写入_G.MainLeftBottom；PC3复用T0创建a表，
-- PC5挂入MainLeftBottom.a。a.version="10000"；screenW/screenH分别来自
-- SL:GetMetaValue("SCREEN_WIDTH"/"SCREEN_HEIGHT")；Blocklist={1.0,9.0,10.0,60000.0}；
-- SendHookList/RecvHookList为空表；isHidden=true、hidebut=nil；
-- PC51将LuaSendMsg闭包写入MainLeftBottom.a.LuaSendMsg。
-- PC30-PC32创建并挂入MainLeftBottom.b空表；PC33-PC35创建MainLeftBottom.z；
-- z的isPaused/isRunning/isStoring/isTaking/isDiuing/isOutputted均初始化false。
--
-- PC43-PC85闭包导出：PrintLog->_G.log(PC45)；GetMapId->_G.GetMapId(PC55)；
-- GetMapName->_G.GetMapName(PC57)；PlayerPos->_G.PlayerPos(PC59)；
-- GetDroppedItems->_G.GetDroppedItems(PC61)；MoveTo->_G.MoveTo(PC63)；
-- DiuItems->_G.DiuItems(PC67)；GetAvailableStoragePage->_G.GetAvailableStoragePage(PC70)；
-- GetStorageItemData->_G.GetStorageItemData(PC73)；StorageItems->_G.StorageItems(PC78)；
-- TakeItems->_G.TakeItems(PC82)；PickUpItems->_G.PickUpItems(PC85)。
-- LuaSendMsg在PC51进入MainLeftBottom.a字段；ShowLocalNoticeByType、ScheduleOnce、
-- Schedule在本区间创建但没有全局导出。逐PC账本见检查点241审计和12_根模块闭包装配表。


-- 检查点242：root PC86-PC211寄存器生命周期闭合与PC210名称纠错。
-- T7=Schedule（PC53创建，PC398由doInit_UI UP[7]捕获）。
-- T9=0.2（PC90；PC410由doInit_UI UP[19]捕获，具体UI用途未命名）。
-- T11=math.floor(3600/0.2)=18000（PC95；PC408由doInit_UI UP[17]捕获）。
-- T12=14项奖励记录表（PC96-PC167构造；PC409由doInit_UI UP[18]捕获）。
-- T13=gatherStatusText；T14=currentState共享cell，初值IDLE。
-- T15=目标ID集合；T16=自己归属计数；T17=扫描游标；T18=isGatherRunning；
-- T19=等待标记；T20=等待截止时间；T21=等待目标ID；T22=等待目标名称。
-- T23=FormatStateChange；T24=SetTargetID；T25=ClearTargetID_2；
-- T26=GetMainPlayerID；T27=GetPlayerPosition；T28=GetPlayerMapPosition；
-- T29=DistanceCalculation；T30=IsDie；T31=GetOwnerIDText；T32=GetOwnerID；
-- T33=GetOwnerDescription；T34=FindMonsterCandidates；
-- T35=ResetGatherMonsterData；T36=FindMonsterInCurrViewField。
-- PC210实际创建FindMonsterInCurrViewField并于PC211捕获T30=IsDie；
-- ClearBlacklistItems是root.children[15]，实际创建PC383。此前PC210注释中的名称错误已纠正。
-- 上述28个新增寄存器时间线及每个捕获槽见12_根模块闭包装配表.json。


-- 检查点243：PC212-PC340根模块字段与全局导出复核。
-- PC212-PC213：root.children[31] IsInWhitelistMap无捕获，导出全局IsInWhitelistMap。
-- PC214-PC237：root.children[45] MainLoop按既有22项捕获序列创建，PC237导出全局MainLoop。
-- PC238-PC246：InitGatherMonsters捕获[T3,T18,T23,T13,T35,T8,T4]，PC246全局导出。
-- PC247-PC255：StopGatherMonsters捕获[T18,T3,T25,T23,T13,T35,T4]，PC255全局导出。
-- PC256-PC258：Builtsetting捕获T5，PC258全局导出。
-- PC259-PC260：MoveItemToQuickUse无捕获，PC260全局导出。
-- PC261-PC265：DestroyUI捕获[T0,T3,T1]，写入MainLeftBottom.hide。
-- PC266-PC269：SetButtonVisibilityState捕获[T0,T1]，写入MainLeftBottom.show。
-- PC270-PC274：ShowHideAllButtons捕获[T3,T1,T0]，写入MainLeftBottom.destroy。
-- PC276-PC279：AccountIDValidation捕获[T4,T5]（PrintLog、ShowLocalNoticeByType），写入MainLeftBottom.main。
-- PC286-PC294：创建blacklistState并初始化lastAttacker=nil、lastHp=nil、deathHandled=false、alertAt=0、nextTryAt=0、noStoneWarned=false、distance=nil；同一表写入MainLeftBottom.blacklist。
-- T54：PC318临时数值/表构造用途在PC349前结束；PC352最终写入PCallHelper_2；PC354与PC384分别被FindBlacklistPlayer UP0和ClearBlacklistItems UP0捕获。两次捕获均取到PCallHelper_2，之后T54无再写入。
-- 该段为父模块创建/捕获/赋值账本，不替代子原型主体；PC341-PC412仍待对账。


-- 检查点244：root PC341-PC412最终闭包、模块字段与全局导出账本。
-- PC341-PC349按原始构造顺序建立T[52]八元素数值表：{ {1,0}, {-1,0}, {0,1}, {0,-1}, {1,1}, {1,-1}, {-1,1}, {-1,-1} }。其业务用途仍未知，不命名为方向表或寻路表。
-- PC350-PC351：root.children[22] GetMapData2DPtr捕获T[52]；已恢复的可达路径不读取该UPVALUE。
-- PC352：创建无捕获PCallHelper_2。
-- PC353-PC354：FindBlacklistPlayer UP[0]=T[54]=PCallHelper_2。
-- PC355-PC356：UseItemByIndex UP[0]=T[37]=randomTeleportItemNames。
-- PC357-PC359：onDamageMsg UP[0]=T[41]=blacklistState；PC359写入MainLeftBottom.onDamageMsg。
-- PC360-PC362：InstallDamageHook UP[0]=T[0]=MainLeftBottom.a UI/配置状态表、UP[1]=T[4] PrintLog；PC360覆写T[57]，后续BlacklistPlayerDetection捕获该live cell。
-- PC363-PC367：DeathAutoBlacklist捕获[T41 blacklistState,T4 PrintLog,T55 FindBlacklistPlayer,T5 ShowLocalNoticeByType]。
-- PC368-PC381：BlacklistPlayerDetection捕获13项[T2=MainLeftBottom.z状态表,T57 InstallDamageHook live cell,T41 blacklistState,T58 DeathAutoBlacklist,T55 FindBlacklistPlayer,T53 GetMapData2DPtr,T38=2.0,T4 PrintLog,T56 UseItemByIndex,T39=0.01,T5 ShowLocalNoticeByType,T40=30.0,T37随机传送道具名表]。
-- PC382：全局导出BlacklistItems=BlacklistPlayerDetection。
-- PC383-PC387：ClearBlacklistItems捕获[T54 PCallHelper_2,T4 PrintLog,T5 ShowLocalNoticeByType,T41 blacklistState]。
-- PC388：全局导出ClearBlacklistItems。
-- PC389-PC410：doInit_UI捕获20项，顺序为[T4,T2,T3,T0,T1,T41,T48,T7,T8,T50,T49,T5,T44,T42,T51,T43,T47,T11,T12,T9]；具体身份见12_根模块闭包装配表.json。
-- PC411：MainLeftBottom.doInit=doInit_UI；PC412：return根模块表。
-- 至此PC341-PC412的根级创建/捕获/模块字段/全局导出时序已对账；这不代表所有子函数均已达到完整静态恢复，也不代表根模块整体源码已装配完成。


-- 检查点245：根模块PC1-PC412全局导出与模块字段总账（跨区间合并复核）。
-- PC1-PC85：_G.MainLeftBottom；_G.log；_G.GetMapId；_G.GetMapName；_G.PlayerPos；_G.GetDroppedItems；_G.MoveTo；_G.DiuItems；_G.GetAvailableStoragePage；_G.GetStorageItemData；_G.StorageItems；_G.TakeItems；_G.PickUpItems。MainLeftBottom.a字段包括version/screenW/screenH/Blocklist/SendHookList/RecvHookList/isHidden/hidebut/LuaSendMsg；另建立b空表、z状态表。
-- PC86-PC211：复核未发现新的根级全局导出或MainLeftBottom根表字段写入；此区间是局部配置、共享状态和闭包创建。
-- PC212-PC340：_G.IsInWhitelistMap、_G.MainLoop、_G.InitGatherMonsters、_G.StopGatherMonsters、_G.Builtsetting、_G.MoveItemToQuickUse；模块字段hide/show/destroy/main/blacklist。
-- PC341-PC412：MainLeftBottom.onDamageMsg；_G.BlacklistItems；_G.ClearBlacklistItems；MainLeftBottom.doInit。
-- 总账将全局导出与模块字段分开统计；局部函数创建不等于导出。ShowLocalNoticeByType、ScheduleOnce、Schedule在已审PC段未发现根级导出。
-- 完整机器可读明细见docs/handoff/12_根模块闭包装配表.json的root_complete_module_ledger。


-- ============================================================================
-- 检查点246：无捕获子原型实际接入记录
--
-- 主装配代码位于 MainLeftBottom_恢复源码.lua 末尾的
-- root_assembly_checkpoint=246 区段。该文件作为独立候选保留根表构造与
-- PC级证据；22个无捕获闭包按原型身份接入root_prototypes。
-- 有捕获闭包暂不在此处伪造实例，必须使用OP_387共享cell语义。
-- ============================================================================


-- 检查点267：PC350-PC388黑名单闭包身份复核。
-- PC357 onDamageMsg捕获T41并写MainLeftBottom.onDamageMsg；PC360 InstallDamageHook捕获T0/T4并写T57。
-- PC368 BlacklistPlayerDetection.UP1捕获T57 live cell，捕获时cell.value为InstallDamageHook，不能接成onDamageMsg。
-- PC382/388分别导出_G.BlacklistItems与_G.ClearBlacklistItems；主恢复稿已增加对象身份断言。
-- 详细逐PC来源与函数主体边界见docs/audit/检查点267_PC350-PC388黑名单闭包链与导出身份核对.md。
