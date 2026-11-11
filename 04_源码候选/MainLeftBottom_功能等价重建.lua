-- MainLeftBottom(2).lua 唯一持续更新主源码文件
-- 原型：root / MainLeftBottom_Module
-- 规范路径：root
-- 规模：412条物理指令、109常量、58个直接子原型
-- 检查点192-198、262-269：根模块分段普通Lua草稿，PC1-PC412均已建立分段记录；非作者原文逐字恢复；检查点273核对PC1-PC42根表/a/b/z/timerState创建顺序及来源导出身份；检查点276新增docs/handoff/13_MainLeftBottom_原型结构树.md，汇总110个原型节点及根级58个闭包创建点；未运行时验证。
-- 状态：持续开发中。此文件是唯一主源码；每批新增/修正直接写入本文件。当前尚未完成整体闭包装配，未运行时验证。
-- 检查点236：58个直接子原型闭包创建点与135个OP_387 live-cell捕获已建表，见docs/handoff/12_根模块闭包装配表.json。
-- 检查点278：第一批11个地图/坐标/玩家辅助函数已在本文件中整理为可读函数主体；静态证据完整，未运行时验证。
-- 检查点282：按原始VM固定参数计数纠正GetWritablePath/ReadNumericConfig入口；两者均为一个固定参数，额外参数不读取，未运行时验证。
-- 检查点281：按用户要求，当前优先级调整为MainLeftBottom_Module入口PC1-PC412与doInit_UI界面初始化；物品/背包/仓库功能暂缓。
-- 检查点283：PC2/4/31/34等ENV名称读写统一通过rootEnvironment；PC44/45中ENV["_G"]单独解析为rootRegisters[5]，log写入该表；全局闭包导出写入ENV而非假定写入_G。

-- VM的ENV是当前chunk环境，不应无条件等同于_G。
-- Lua 5.1优先通过getfenv取得；Lua 5.2+使用词法_ENV；
-- 只有运行环境不提供上述机制时才回退_G。
local rootEnvironment
if type(getfenv) == "function" then
    rootEnvironment = getfenv(1)
else
    rootEnvironment = _ENV or _G
end
assert(type(rootEnvironment) == "table",
    "MainLeftBottom root chunk environment is not a table")

local MainLeftBottom = {}
rootEnvironment.MainLeftBottom = MainLeftBottom

-- PC3-PC5：T[0]先创建a状态表，再于PC5挂入模块根表。
local a = {}
-- PC4-PC5：按字节码从当前chunk ENV重新读取模块表，再挂入a状态表。
local moduleForA = rootEnvironment.MainLeftBottom
moduleForA.a = a

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
local moduleForB = rootEnvironment.MainLeftBottom
moduleForB.b = b

-- PC33-PC35：T[2]创建z状态表，再挂入模块根表。
local z = {}
-- PC34-PC35：再次从当前chunk ENV读取模块表，再挂入z状态表。
local moduleForZ = rootEnvironment.MainLeftBottom
moduleForZ.z = z

-- PC36-PC41：按PC顺序初始化六个状态字段。
z.isPaused = false
z.isRunning = false
z.isStoring = false
z.isTaking = false
z.isDiuing = false
z.isOutputted = false

-- PC42：创建供各定时器闭包共享的空状态表（T[3]）。
local timerState = {}

-- PC1-PC42已按检查点262恢复初始化语句；PC43-PC85已按T寄存器顺序装配；PC86-PC211采集闭包及共享cell已在主恢复稿装配；PC212-PC296 UI闭包与模块字段已补充来源校验；PC297-PC315配置包装链已按T[44..51]顺序装配；PC316-PC349八组数值表已按原值核对；PC350-PC388黑名单闭包捕获与T[57]身份已在主恢复稿装配；PC390-PC412的doInit_UI 20项捕获、PC411 doInit字段和PC412根表返回已在检查点268核验。
-- 本文件是功能等价重建的唯一持续更新目标，不是原作者逐字源码。当前阶段尚不完整；后续代码直接追加/整合到本文件，不另建平行主源码。


-- 检查点193：PC43-PC85，根模块辅助闭包创建与导出。
-- PC42的T[3] timerState已在前段创建；本段从PC43开始记录子闭包创建。
-- PC43-PC45：创建 root.children[16] PrintLog闭包；PC44读取ENV['_G']，PC45向该表写入log。
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
-- T[4]=PrintLog；T[5]先为ENV["_G"]（PC44/45写其log），PC46后为ShowLocalNoticeByType；
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

-- PC275：从当前chunk ENV重新读取MainLeftBottom，并向该次读取结果写入main字段。
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

----------------------------------------------------------------
-- 检查点279：配置文件读写闭包链（功能等价复刻）
--
-- 对应根原型：
--   root.children[2]  GetWritablePath
--   root.children[9]  ReadNumericConfig
--   root.children[17] PCallHelper
--   root.children[0]  FileExistCheck_pcall_wrapper
--   root.children[49] AnonymousHelper_49
--   root.children[32] AnonymousHelper_32
--   root.children[33] AnonymousHelper_33
--   root.children[54] AnonymousHelper_54
--
-- 直接使用词法闭包表达原捕获关系，不再通过 make_xxx 工厂二次包装。
-- 保留原始 FileUtils 接收者、参数次序、pcall 分支及返回值传递。
----------------------------------------------------------------

-- root.children[2]：取得可写目录并拼接首个可变参数。
-- 原型fixed_param_count=1：path是唯一固定参数；额外参数进入VM的X表但不读取。
local function GetWritablePath(path)
    local fileUtils = cc.FileUtils:getInstance()
    local writablePath = fileUtils:getWritablePath()
    return writablePath .. path
end

-- root.children[9]：读取仅包含无符号十进制数字的配置文件。
-- fixed_param_count=1：fileName是唯一固定参数；额外参数不读取。
-- 不存在、读取结果非字符串、内容不匹配时均返回 nil。
local function ReadNumericConfig(fileName)
    local fileUtils = cc.FileUtils:getInstance()
    local fullPath = GetWritablePath(fileName)

    if not fileUtils:isFileExist(fullPath) then
        return nil
    end

    local content = fileUtils:getStringFromFile(fullPath)
    if type(content) ~= "string" then
        return nil
    end

    local normalized = string.gsub(content, "%s", "")
    local digits = string.match(normalized, "^%d+$")
    if digits then
        return tonumber(normalized)
    end

    return nil
end

-- root.children[17]：将文本写入由GetWritablePath解析出的文件路径。
-- 第一个参数是写入内容；第二个参数是路径参数。
-- 子闭包把GetWritablePath(arg0)的全部返回值转发给writeStringToFile。
-- pcall失败或写入结果严格等于false时返回false；其他成功结果（含nil）返回true。
local function PCallHelper(arg1, arg0, ...)
    local function Nested_tostring()
        local fileUtils = cc.FileUtils:getInstance()
        local payload = tostring(arg1)
        return fileUtils:writeStringToFile(
            payload,
            GetWritablePath(arg0)
        )
    end

    local ok, result = pcall(Nested_tostring, ...)
    if not ok or result == false then
        return false
    end

    return true
end

-- root.children[0]：检查文件；不存在时尝试删除，再次检查是否已不存在。
-- 返回值始终为（成功状态, 解析后的完整路径）。
local function FileExistCheck_pcall_wrapper(path, ...)
    local fileUtils = cc.FileUtils:getInstance()
    local resolvedPath = GetWritablePath(path)

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

-- root.children[49]：固定读取 blacklist_distance.txt，原样返回读取函数的结果。
local function AnonymousHelper_49()
    return ReadNumericConfig(blacklistDistanceConfigFile)
end

-- root.children[32]：固定写入 blacklist_distance.txt，转发首个显式参数。
local function AnonymousHelper_32(firstArg)
    return PCallHelper(blacklistDistanceConfigFile, firstArg)
end

-- root.children[33]：固定读取 gather_monster_count.txt。
local function AnonymousHelper_33()
    return ReadNumericConfig(gatherMonsterCountConfigFile)
end

-- root.children[54]：固定写入 gather_monster_count.txt，转发首个显式参数。
local function AnonymousHelper_54(firstArg)
    return PCallHelper(gatherMonsterCountConfigFile, firstArg)
end

----------------------------------------------------------------
-- 检查点279配置链结束；后续PC316-PC412继续使用同一词法作用域。
----------------------------------------------------------------


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
-- 检查点266：历史恢复记录曾以影子表描述T[44..51]的配置包装闭包；
-- 本文件最终实现不创建该适配表，doInit_UI直接捕获词法变量：
-- UP[6]/[9]/[10]/[12]/[14]/[16]分别绑定配置读取、配置写入、路径、文件检查闭包。

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

-- PC389：原始指令[82,137,59,"MainLeftBottom",null]将_ENV.MainLeftBottom读取到独立临时寄存器T[59]。
-- PC392/PC393/PC394仍分别捕获T[2]=MainLeftBottom.z、T[3]=timerState、T[0]=MainLeftBottom.a；
-- PC389不覆盖这三个寄存器。
-- PC390-PC410：创建root.children[42] / doInit_UI，捕获20项父root寄存器：
-- 其中UP[8]=T[8]=gatherConfig（PC86-PC89构造后未再覆写），传入Nested_InitGatherMonsters的config形参；不是FindMonsterInCurrViewField。
-- [T[4], T[2], T[3], T[0], T[1], T[41], T[48], T[7], T[8], T[50],
--  T[49], T[5], T[44], T[42], T[51], T[43], T[47], T[11], T[12], T[9]]。
-- 20项槽位身份已由检查点256逐项闭合；完整顺序与装配值见docs/audit/检查点256_doInit_UI二十项捕获与根闭包全量装配.md。
-- doInit_UI本体419条，已有首版普通Lua草稿（检查点187）；
-- 静态参数映射已由检查点208/235闭合：RequestStorageData与Attach_UITop各传T[7]一个显式实参；Nested_Anonymous fixed_param_count=2，T[0]=promptText、T[1]=successCallback、T[2]=nil。GUI宿主行为仍未运行时验证。
-- PC411：原始指令[144,268,59,"doInit",60]写入T[59].doInit=doInit_UI；
-- 主恢复稿在PC389读取的doInitModule上执行该赋值，不以rootModule局部变量替代。
-- PC412：根模块return。

-- 根模块PC1-PC412至此均有分段源码记录。
-- “PC范围已覆盖”不等于根模块已完成作者级源码恢复，也不等于运行时验证。



----------------------------------------------------------------
-- 功能等价复刻 · 第一批：地图、坐标、玩家与基础查询辅助函数
--
-- 这些函数均对应已有原型，不是新框架引擎 API：
--   GetMapId                 root.children[13]
--   GetMapName               root.children[30]
--   PlayerPos                root.children[57]
--   GetDroppedItems          root.children[4]
--   GetMainPlayerID          root.children[39]
--   IsDie                    root.children[29]
--   GetPlayerPosition        root.children[18]
--   GetPlayerMapPosition     root.children[44]
--   DistanceCalculation      root.children[11]
--   IsInWhitelistMap         root.children[31]
--   GetOwnerDescription      root.children[43]
--
-- 以下保留已核对的调用接收者、返回值数量、假值处理和比较方式。
-- 这些函数尚未在目标游戏环境运行验证。
----------------------------------------------------------------

-- 获取地图 ID；元变量为 nil/false 时回退为 0。
local function GetMapId()
    return SL:GetMetaValue("MAP_ID") or 0
end

-- 获取地图名称；元变量为 nil/false 时回退为空字符串。
local function GetMapName()
    return SL:GetMetaValue("MAP_NAME") or ""
end

-- 返回主角当前 X、Y 两个坐标值（两个独立返回值，不组装成表）。
local function PlayerPos()
    local x = SL:GetMetaValue("X")
    local y = SL:GetMetaValue("Y")
    return x, y
end

-- 返回当前视野内掉落物列表；保留宿主方法的全部返回值。
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root PC55/57/59/61：按原始ENV落点导出四个基础查询闭包。
rootEnvironment.GetMapId = GetMapId
rootEnvironment.GetMapName = GetMapName
rootEnvironment.PlayerPos = PlayerPos
rootEnvironment.GetDroppedItems = GetDroppedItems

-- 读取主玩家 ID；这是观察到的宿主对象方法，不是新框架文档 API。
local function GetMainPlayerID()
    return global.gamePlayerController:GetMainPlayerID()
end

-- 返回 actor 存活判断结果。
-- actor 为 nil/false 时，按 Lua and 短路规则原样返回该假值。
local function IsDie(actor)
    return actor and not actor:IsDie()
end

-- 以元变量 X/Y 构造坐标表；单个坐标为 nil/false 时回退为 0。
local function GetPlayerPosition()
    local x = SL:GetMetaValue("X")
    if not x then
        x = 0
    end

    local y = SL:GetMetaValue("Y")
    if not y then
        y = 0
    end

    return { x = x, y = y }
end

-- 从 actor 的地图坐标字段构造坐标表；actor 假值时返回 nil。
local function GetPlayerMapPosition(actor)
    if not actor then
        return nil
    end

    local x = actor.mCurrMapX
    if not x then
        x = 0
    end

    local y = actor.mCurrMapY
    if not y then
        y = 0
    end

    return { x = x, y = y }
end

-- 计算 Chebyshev 距离；任一坐标表假值时返回哨兵值 99999。
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

-- 安全区直接允许；否则只允许地图名严格等于“土城”。
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

-- 返回原始归属 ID 和对应说明文本，保持双返回值顺序。
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
rootEnvironment.MoveItemToQuickUse = MoveItemToQuickUse



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
local function AttachRecoveredPrototypes(prototypes, environment)
    assert(type(prototypes) == "table",
        "AttachRecoveredPrototypes expects a table of recovered closures")

    environment = environment or rootEnvironment
    assert(type(environment) == "table",
        "AttachRecoveredPrototypes expects a chunk environment table")
    local module = environment.MainLeftBottom
    assert(type(module) == "table",
        "AttachRecoveredPrototypes cannot find environment.MainLeftBottom")

    local function exportGlobal(globalName, prototypeName)
        local fn = prototypes[prototypeName]
        if fn ~= nil then
            environment[globalName] = fn
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
        module.a.LuaSendMsg = prototypes.LuaSendMsg
    end

    -- root PC212-PC258：采集控制相关全局入口。
    exportGlobal("IsInWhitelistMap", "IsInWhitelistMap")
    exportGlobal("MainLoop", "MainLoop")
    exportGlobal("InitGatherMonsters", "InitGatherMonsters")
    exportGlobal("StopGatherMonsters", "StopGatherMonsters")
    exportGlobal("Builtsetting", "Builtsetting")

    -- root PC259-PC274：模块表上的界面控制闭包。
    if prototypes.DestroyUI ~= nil then
        module.hide = prototypes.DestroyUI
    end
    if prototypes.SetButtonVisibilityState ~= nil then
        module.show = prototypes.SetButtonVisibilityState
    end
    if prototypes.ShowHideAllButtons ~= nil then
        module.destroy = prototypes.ShowHideAllButtons
    end
    exportGlobal("MoveItemToQuickUse", "MoveItemToQuickUse")

    -- root PC275-PC279：账号验证入口。
    if prototypes.AccountIDValidation ~= nil then
        module.main = prototypes.AccountIDValidation
    end

    -- root PC350-PC388：伤害回调与黑名单功能入口。
    if prototypes.onDamageMsg ~= nil then
        module.onDamageMsg = prototypes.onDamageMsg
    end
    exportGlobal("BlacklistItems", "BlacklistPlayerDetection")
    exportGlobal("ClearBlacklistItems", "ClearBlacklistItems")

    -- root PC389-PC411：主界面初始化入口。
    if prototypes.doInit_UI ~= nil then
        module.doInit = prototypes.doInit_UI
    end

    return module
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
--       ENV['_G'].log。PC72 GetStorageItemData捕获的就是PrintLog，通知回调身份现已确定。
-- T[5]：PC21的60000.0先用于Blocklist；PC44临时读取ENV['_G']，PC46覆盖为
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
-- 模块根表：PC1创建，PC2写入ENV.MainLeftBottom；PC3复用T0创建a表，
-- PC5挂入MainLeftBottom.a。a.version="10000"；screenW/screenH分别来自
-- SL:GetMetaValue("SCREEN_WIDTH"/"SCREEN_HEIGHT")；Blocklist={1.0,9.0,10.0,60000.0}；
-- SendHookList/RecvHookList为空表；isHidden=true、hidebut=nil；
-- PC51将LuaSendMsg闭包写入MainLeftBottom.a.LuaSendMsg。
-- PC30-PC32创建并挂入MainLeftBottom.b空表；PC33-PC35创建MainLeftBottom.z；
-- z的isPaused/isRunning/isStoring/isTaking/isDiuing/isOutputted均初始化false。
--
-- PC43-PC85闭包导出：PrintLog->ENV["_G"].log(PC45)；GetMapId->ENV.GetMapId(PC55)；
-- GetMapName->ENV.GetMapName(PC57)；PlayerPos->ENV.PlayerPos(PC59)；
-- GetDroppedItems->ENV.GetDroppedItems(PC61)；MoveTo->ENV.MoveTo(PC63)；
-- DiuItems->ENV.DiuItems(PC67)；GetAvailableStoragePage->ENV.GetAvailableStoragePage(PC70)；
-- GetStorageItemData->ENV.GetStorageItemData(PC73)；StorageItems->ENV.StorageItems(PC78)；
-- TakeItems->ENV.TakeItems(PC82)；PickUpItems->ENV.PickUpItems(PC85)。
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
-- PC390-PC410：doInit_UI在PC390创建，PC391-PC410依序捕获20项，顺序为[T4,T2,T3,T0,T1,T41,T48,T7,T8,T50,T49,T5,T44,T42,T51,T43,T47,T11,T12,T9]；具体身份见12_根模块闭包装配表.json。
-- PC411：MainLeftBottom.doInit=doInit_UI；PC412：return根模块表。
-- 至此PC341-PC412的根级创建/捕获/模块字段/全局导出时序已对账；这不代表所有子函数均已达到完整静态恢复，也不代表根模块整体源码已装配完成。


-- 检查点245：根模块PC1-PC412全局导出与模块字段总账（跨区间合并复核）。
-- PC1-PC85：ENV.MainLeftBottom；ENV["_G"].log（PC45）；ENV.GetMapId；ENV.GetMapName；ENV.PlayerPos；ENV.GetDroppedItems；ENV.MoveTo；ENV.DiuItems；ENV.GetAvailableStoragePage；ENV.GetStorageItemData；ENV.StorageItems；ENV.TakeItems；ENV.PickUpItems。MainLeftBottom.a字段包括version/screenW/screenH/Blocklist/SendHookList/RecvHookList/isHidden/hidebut/LuaSendMsg；另建立b空表、z状态表。
-- PC86-PC211：复核未发现新的根级全局导出或MainLeftBottom根表字段写入；此区间是局部配置、共享状态和闭包创建。
-- PC212-PC340：ENV.IsInWhitelistMap、ENV.MainLoop、ENV.InitGatherMonsters、ENV.StopGatherMonsters、ENV.Builtsetting、ENV.MoveItemToQuickUse；模块字段hide/show/destroy/main/blacklist。
-- PC341-PC412：MainLeftBottom.onDamageMsg；ENV.BlacklistItems；ENV.ClearBlacklistItems；MainLeftBottom.doInit。
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
-- PC382/388分别导出ENV.BlacklistItems与ENV.ClearBlacklistItems；主恢复稿已增加对象身份断言。
-- 详细逐PC来源与函数主体边界见docs/audit/检查点267_PC350-PC388黑名单闭包链与导出身份核对.md。


-- 检查点268：PC389/PC411原始指令核对。
-- PC389把_ENV.MainLeftBottom读入T[59]；PC392/393/394捕获的T[2]/T[3]/T[0]
-- 仍分别是z/timerState/a。PC411向T[59].doInit写入doInit_UI；详见检查点268审计。


-- 检查点269：PC390-PC410 doInit_UI二十项捕获逐槽对账。
-- UP[8]捕获T[8]=gatherConfig；Nested_InitGatherMonsters(config,getThreshold)会写config.GATHER_THRESHOLD。
-- 主恢复稿已将UP[8]注入rootSource.gatherConfig，并断言三个配置字段10/0.5/1。
-- 完整20槽映射见docs/audit/检查点269_doInit_UI二十项捕获逐槽对账与T8配置表修正.md。



-- ============================================================================
-- 功能等价重建：doInit_UI及其直接子闭包（第一版接入）
-- 根PC390-PC411的20项捕获现改为同一词法作用域直接绑定。
-- ============================================================================

local rootGlobal = rootEnvironment["_G"] or _G
local function PrintLog(message, ...)
    local logger = rootGlobal and rootGlobal.log
    if type(logger) == "function" and logger ~= PrintLog then return logger(message, ...) end
    if type(print) == "function" then
        if select("#", ...) > 0 then return print(string.format(tostring(message), ...)) end
        return print(tostring(message))
    end
end
rootGlobal.log = PrintLog


-- root.children[12] / LuaSendMsg：PC48-PC51捕获MainLeftBottom.a与PrintLog，
-- 并挂入a.LuaSendMsg。hook返回值严格为true时拦截网络发送。
local function LuaSendMsg(
    hookKey,
    param1,
    param2,
    param3,
    param4,
    messageId
)
    local message = {
        recog = 0,
        msgId = messageId,
        param1 = param1,
        param2 = param2,
        param3 = param3,
        param4 = param4,
    }

    local numericHookKey = tonumber(hookKey)
    local blockedIndex = table.find(a.Blocklist, numericHookKey)
    if not blockedIndex then
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
        PrintLog(logText)
    end

    local hookExists = a.SendHookList[hookKey]
    if hookExists then
        local hook = a.SendHookList[hookKey]
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

    global.networkCtl:SendMsg(
        hookKey,
        param1,
        param2,
        param3,
        param4,
        messageId
    )
end
a.LuaSendMsg = LuaSendMsg

local function ShowLocalNoticeByType(message, ...)
    local notice = rootEnvironment.ShowLocalNoticeByType
    if type(notice) == "function" and notice ~= ShowLocalNoticeByType then return notice(message, ...) end
    return PrintLog(message, ...)
end
local function Schedule(callback, interval) return SL:Schedule(callback, interval) end
local function ScheduleOnce(callback, delay) return SL:ScheduleOnce(callback, delay) end
-- ============================================================================
-- 根级入口闭包：PC212-PC279
-- 以唯一词法作用域装配共享状态；未确认的宿主依赖通过ENV读取并显式检查。
-- ============================================================================
local gatherRunningCell = { value = isGatherRunning }
local gatherStateCell = { value = currentState }
local gatherTargetsCell = { value = resettableTable }
local gatherCursorCell = { value = 0 }
local gatherOwnedCountCell = { value = 0 }
local gatherWaitingCell = { value = resetSlot19 }
local gatherDeadlineCell = { value = resetSlot20 }
local gatherPendingIDCell = { value = resetSlot21 }
local gatherPendingNameCell = { value = resetSlot22 }

local function SetGatherState(newState)
    local oldState = gatherStateCell.value
    PrintLog(string.format("状态切换: %s -> %s", tostring(oldState), tostring(newState)))
    gatherStateCell.value = newState
    currentState = newState
end

local function ResetGatherMonsterData()
    gatherTargetsCell.value = {}
    gatherCursorCell.value = 0
    gatherOwnedCountCell.value = 0
    gatherWaitingCell.value = false
    gatherDeadlineCell.value = 0
    gatherPendingIDCell.value = nil
    gatherPendingNameCell.value = ""
    resettableTable = gatherTargetsCell.value
    resetSlot16, resetSlot17 = 0, 0
    resetSlot19, resetSlot20, resetSlot21, resetSlot22 = false, 0, nil, ""
    local clearTarget = rootEnvironment.ClearTargetID_2
    if type(clearTarget) == "function" then clearTarget() end
    PrintLog("数据已重置")
end

-- PC184-PC194辅助闭包：按已核实的比较与排序规则直接落为词法函数。
local function GetOwnerID(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()
    if ownerID == nil or ownerID == "" or ownerID == -1 then return false end
    if type(ownerID) == "string" then return ownerID ~= tostring(ownerID) end
    return ownerID ~= expectedOwnerID
end

local function GetOwnerIDText(actor, expectedOwnerID)
    local ownerID = actor:GetOwnerID()
    if ownerID == nil or ownerID == "" or ownerID == -1 then return false end
    if type(ownerID) == "string" then return ownerID == tostring(ownerID) end
    return ownerID == expectedOwnerID
end

local function SetTargetID(targetID)
    if not global.Facade then return false end
    local proxy = global.Facade:retrieveProxy(global.ProxyTable.PlayerInputProxy)
    if not proxy then return false end
    proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND)
    return true
end

local function FindMonsterInCurrViewField()
    local monsters = SL:FindMonsterInCurrViewField(true, true) or {}
    local result = {}
    for _, actor in ipairs(monsters) do
        if IsDie(actor) then
            local actorID = actor:GetID()
            if actorID then result[actorID] = actor end
        end
    end
    return result
end

local function FindMonsterCandidates()
    local monsters = SL.FindMonsterInCurrViewField()
    if not monsters or #monsters == 0 then return {} end
    local ignoredNames = {}
    local ignoreSetting = GET_SETTING(global.MMO.SETTING_IDX_IGNORE_MONSTER)
    if ignoreSetting and type(ignoreSetting[1]) == "table" then
        for name, enabled in pairs(ignoreSetting[1]) do
            if enabled == true then ignoredNames[name] = true end
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
    table.sort(candidates, function(left, right)
        return left._distance < right._distance
    end)
    local result = {}
    for index, actor in ipairs(candidates) do
        if index > gatherConfig.GATHER_THRESHOLD then break end
        table.insert(result, actor)
    end
    return result
end

local function MainLoop()
    if not gatherRunningCell.value then return end

    if IsInWhitelistMap() then
        if gatherStateCell.value ~= gatherStatusText.IDLE then
            PrintLog("在白名单地图, 停止引怪")
            SetGatherState(gatherStatusText.IDLE)
            ResetGatherMonsterData()
        end
        return
    end

    local getCandidates = FindMonsterCandidates
    local getPlayerID = GetMainPlayerID
    local getOwnerID = GetOwnerID
    local getOwnerText = GetOwnerIDText
    local getOwnerDescription = GetOwnerDescription
    local isAlive = IsDie
    local findActors = FindMonsterInCurrViewField
    local setTarget = SetTargetID

    if type(getPlayerID) ~= "function" or type(getOwnerID) ~= "function"
        or type(isAlive) ~= "function" or type(findActors) ~= "function"
        or type(setTarget) ~= "function" then
        PrintLog("MainLoop依赖尚未全部接入，跳过本轮")
        return
    end

    if gatherStateCell.value == gatherStatusText.IDLE then
        PrintLog("扫描怪物中")
        if type(getCandidates) ~= "function" then
            PrintLog("FindMonsterCandidates尚未接入")
            return
        end
        local candidates = getCandidates() or {}
        if #candidates == 0 then
            PrintLog("视野内没有可攻击怪物")
            return
        end

        gatherTargetsCell.value = {}
        local mainPlayerID = getPlayerID()
        for _, actor in ipairs(candidates) do
            if not getOwnerID(actor, mainPlayerID) then
                table.insert(gatherTargetsCell.value, actor:GetID())
            end
        end
        if #gatherTargetsCell.value == 0 then
            PrintLog("没有可攻击的怪物")
            return
        end
        gatherCursorCell.value = 1
        gatherOwnedCountCell.value = 0
        PrintLog(string.format("开始引怪，目标数量: %d", #gatherTargetsCell.value))
        SetGatherState(gatherStatusText.GATHERING)
        return
    end

    if gatherStateCell.value == gatherStatusText.GATHERING then
        PrintLog("引怪中")
        if gatherWaitingCell.value then
            local now = os.time()
            if now < gatherDeadlineCell.value then
                PrintLog(string.format("等待归属变更中: %s (还剩 %d 秒)",
                    tostring(gatherPendingNameCell.value), gatherDeadlineCell.value - now))
                return
            end
            local actorMap = findActors()
            local actor = actorMap and actorMap[gatherPendingIDCell.value]
            local mainPlayerID = getPlayerID()
            if actor and type(getOwnerText) == "function" and getOwnerText(actor, mainPlayerID) then
                PrintLog(string.format("怪物 %s 归属已变更为自己", tostring(gatherPendingNameCell.value)))
            else
                PrintLog(string.format("怪物 %s 归属未变更或已离开视野", tostring(gatherPendingNameCell.value)))
            end
            gatherWaitingCell.value = false
            gatherDeadlineCell.value = 0
            gatherPendingIDCell.value = 0
            gatherPendingNameCell.value = ""
            gatherCursorCell.value = gatherCursorCell.value + 1
        end

        local actorMap = findActors(gatherWaitingCell.value) or {}
        local mainPlayerID = getPlayerID()
        local allOwnersResolved = true
        for index = gatherCursorCell.value, #gatherTargetsCell.value do
            local targetID = gatherTargetsCell.value[index]
            local actor = actorMap[targetID]
            if not actor then
                PrintLog(string.format("怪物 %d (ID: %s) 不在视野内，跳过", index, tostring(targetID)))
                gatherCursorCell.value = index + 1
            elseif not isAlive(actor) then
                PrintLog(string.format("怪物 %d (ID: %s) 已死亡，跳过", index, tostring(targetID)))
                gatherCursorCell.value = index + 1
            else
                local monsterName = actor:GetName() or "未知怪物"
                local ownerID, ownerDescription
                if type(getOwnerDescription) == "function" then
                    ownerID, ownerDescription = getOwnerDescription(actor, mainPlayerID)
                else
                    ownerID = getOwnerID(actor)
                    ownerDescription = ownerID == mainPlayerID and "自己" or "其他玩家"
                end
                if getOwnerID(actor, mainPlayerID) then
                    PrintLog(string.format("怪物 %d (%s, ID: %s) 归属属于其他玩家(归属ID: %s, %s)，跳过",
                        index, monsterName, tostring(targetID), tostring(ownerID), tostring(ownerDescription)))
                    gatherCursorCell.value = index + 1
                elseif type(getOwnerText) == "function" and getOwnerText(actor, mainPlayerID) then
                    PrintLog(string.format("怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index, monsterName, tostring(targetID), tostring(ownerID), tostring(ownerDescription)))
                    gatherOwnedCountCell.value = gatherOwnedCountCell.value + 1
                    gatherCursorCell.value = index + 1
                else
                    allOwnersResolved = false
                    gatherCursorCell.value = index
                    PrintLog(string.format("锁定怪物 %d: %s (ID: %s, 归属: %s)",
                        index, monsterName, tostring(targetID), tostring(ownerDescription)))
                    if setTarget(targetID) then
                        gatherWaitingCell.value = true
                        gatherDeadlineCell.value = os.time() + gatherConfig.ATTACK_WAIT_TIME
                        gatherPendingIDCell.value = targetID
                        gatherPendingNameCell.value = monsterName
                        PrintLog(string.format("开始等待 %s 归属变更 (等待 %d 秒)",
                            monsterName, gatherConfig.ATTACK_WAIT_TIME))
                    else
                        PrintLog(string.format("锁定怪物 %s 失败", monsterName))
                    end
                    gatherCursorCell.value = index + 1
                end
            end
        end

        if allOwnersResolved and gatherCursorCell.value > #gatherTargetsCell.value then
            PrintLog("所有怪物归属已获取，切换到攻击状态")
            gatherCursorCell.value = 1
            SetGatherState(gatherStatusText.ATTACKING)
        elseif not allOwnersResolved and gatherCursorCell.value > #gatherTargetsCell.value then
            PrintLog("怪物列表处理完毕但未全部获取归属，重新扫描")
            SetGatherState(gatherStatusText.IDLE)
            ResetGatherMonsterData()
        end
        return
    end

    if gatherStateCell.value == gatherStatusText.ATTACKING then
        PrintLog("攻击中")
        local actorMap = findActors() or {}
        for index = gatherCursorCell.value, #gatherTargetsCell.value do
            local targetID = gatherTargetsCell.value[index]
            local actor = actorMap[targetID]
            if actor and isAlive(actor) then
                local monsterName = actor:GetName() or "未知怪物"
                PrintLog(string.format("攻击怪物 %d: %s (ID: %s)", index, monsterName, tostring(targetID)))
                setTarget(targetID)
                return
            end
            PrintLog(string.format("怪物 %d (ID: %s) 已死亡或离开视野", index, tostring(targetID)))
            gatherCursorCell.value = index + 1
        end
        PrintLog("所有目标怪物已死亡或离开视野，切换到空闲状态")
        SetGatherState(gatherStatusText.IDLE)
        ResetGatherMonsterData()
    end
end

local function InitGatherMonsters()
    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end
    gatherRunningCell.value = true
    isGatherRunning = true
    SetGatherState(gatherStatusText.IDLE)
    ResetGatherMonsterData()
    timerState.gatherTimer = SL:Schedule(MainLoop, gatherConfig.CHECK_INTERVAL)
    ShowLocalNoticeByType(string.format("引怪功能已启动 (阈值: %d)", gatherConfig.GATHER_THRESHOLD))
end

local function StopGatherMonsters()
    gatherRunningCell.value = false
    isGatherRunning = false
    if timerState.gatherTimer then
        SL:UnSchedule(timerState.gatherTimer)
        timerState.gatherTimer = nil
    end
    local clearTarget = rootEnvironment.ClearTargetID_2
    if type(clearTarget) == "function" then clearTarget() end
    SetGatherState(gatherStatusText.IDLE)
    ResetGatherMonsterData()
    PrintLog("引怪功能已停止")
end

local function Builtsetting()
    CHANGE_SETTING(27, {0})
    ShowLocalNoticeByType("关闭背景音乐")
    CHANGE_SETTING(52, {0})
    ShowLocalNoticeByType("关闭游戏音乐")
    CHANGE_SETTING(1002, {0})
    ShowLocalNoticeByType("关闭高帧率")
    CHANGE_SETTING(57, {1})
    ShowLocalNoticeByType("开启人物简装")
    CHANGE_SETTING(58, {1})
    ShowLocalNoticeByType("开启怪物简装")
    CHANGE_SETTING(2005, {0})
    ShowLocalNoticeByType("关闭屏蔽怪物")
end

local function DestroyUI()
    uiState.isHidden = false
    if timerState.resTimer then
        SL:UnSchedule(timerState.resTimer)
        timerState.resTimer = nil
    end
    uiState.resWin = nil
    GUI:Win_CloseAll()
    for key in pairs(buttonMap) do GUI:setVisible(buttonMap[key], true) end
end

local function SetButtonVisibilityState()
    uiState.isHidden = true
    for key in pairs(buttonMap) do GUI:setVisible(buttonMap[key], true) end
end

local function ShowHideAllButtons()
    if timerState.rewardTimer then
        SL:UnSchedule(timerState.rewardTimer)
        timerState.rewardTimer = nil
    end
    if timerState.cruiseTimer then
        SL:UnSchedule(timerState.cruiseTimer)
        timerState.cruiseTimer = nil
    end
    for key in pairs(buttonMap) do GUI:setVisible(buttonMap[key], true) end
    if uiState.hidebut then
        GUI:setVisible(uiState.hidebut, false)
        uiState.hidebut = nil
    end
end

local function AccountIDValidation()
    local gameID = SL:GetMetaValue("GAME_ID")
    PrintLog("游戏id：" .. tostring(gameID))
    if gameID ~= 204208 then
        PrintLog("游戏不一致，id：" .. tostring(gameID))
        return
    end
    local accountID = SL:GetMetaValue("UID")
    PrintLog("账号ID：" .. tostring(accountID))
    local allowedAccountIDs = {
        "6324648", "39770358", "3548598", "1957840929", "1488903257",
        "1585201915", "1627987432", "1580027021", "1304755149"
    }
    local validationResult = false
    for _, allowedID in ipairs(allowedAccountIDs) do
        if tostring(accountID) == tostring(allowedID) then
            validationResult = true
            PrintLog("[提示] 账号ID在允许列表中，功能已开启")
            break
        end
    end
    if not validationResult then
        PrintLog("账号不存在，功能已限制，账号ID：" .. tostring(accountID))
        ShowLocalNoticeByType("[验证失败] 账号ID未在允许列表中")
    end
    local scheduledCallback = function()
        local mainProperty = MainProperty
        if mainProperty and mainProperty._ui and mainProperty._ui.Panel_mini_chat then
            SL:UnSchedule(validationResult)
            MainLeftBottom.doInit()
        end
        PrintLog("等待主界面属性栏(MainProperty)初始化完成...")
    end
    SL:Schedule(scheduledCallback,0.5)
end


-- root.children[3] / MoveTo：地图移动通知与目标距离判断（51条物理指令）。
-- 保留Facade冒号调用、PlayerPos双返回值、range的nil/false回退规则。
local function MoveTo(x, y, range)
    local moveInfo = {
        mapID = SL:GetMetaValue("MAP_ID"),
    }
    moveInfo.x = tonumber(x)
    moveInfo.y = tonumber(y)
    moveInfo.type = global.MMO.INPUT_MOVE_TYPE_AUTOMOVE
    if not range then
        range = 0
    end
    moveInfo.range = range

    global.Facade:sendNotification(global.NoticeTable.InputMove, moveInfo)

    local playerX, playerY = PlayerPos()
    local deltaX = math.abs(moveInfo.x - playerX)
    if not (deltaX <= moveInfo.range) then
        return false
    end

    local deltaY = math.abs(moveInfo.y - playerY)
    if not (deltaY <= moveInfo.range) then
        return false
    end
    return true
end
rootEnvironment.MoveTo = MoveTo

-- ============================================================================
-- 物品功能入口：root PC64-PC85
-- ============================================================================
local function DiuItems()
    local MAX_GROUND_ITEMS = 35
    if z.isDiuing then return end
    z.isDiuing = true
    local _, groundItemCount = GetDroppedItems()
    groundItemCount = groundItemCount or 0
    if MAX_GROUND_ITEMS < groundItemCount then
        ShowLocalNoticeByType("地面物品(" .. groundItemCount .. ")超过上限(" .. MAX_GROUND_ITEMS .. ")")
        z.isDiuing = false
        return
    end
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then z.isDiuing = false; return end
    local candidates = {}
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex and not SL:GetMetaValue("ITEM_IS_BIND", item) then
            candidates[#candidates + 1] = {makeIndex=item.MakeIndex,count=item.OverLap or 1,name=item.Name}
        end
    end
    if #candidates == 0 then
        ShowLocalNoticeByType("背包无可丢弃物品")
        z.isDiuing = false
        return
    end
    local sentCount = 0
    for _, candidate in ipairs(candidates) do
        if MAX_GROUND_ITEMS <= groundItemCount then
            ShowLocalNoticeByType("地面物品已满" .. MAX_GROUND_ITEMS .. "件，停止丢弃")
            break
        end
        ShowLocalNoticeByType("丢: " .. candidate.name)
        LuaSendMsg(global.MsgType.MSG_CS_MAP_ITEM_DISCARD,candidate.makeIndex,candidate.count,0,0,candidate.name,string.len(candidate.name))
        sentCount = sentCount + 1
        groundItemCount = groundItemCount + 1
    end
    ShowLocalNoticeByType("共丢弃 " .. sentCount .. " 件物品")
    z.isDiuing = false
end

local function TakeItems()
    if z.isTaking then return end
    z.isTaking = true
    local storageItems = GetStorageItemData()
    if not storageItems or #storageItems == 0 then
        ShowLocalNoticeByType("仓库无可取物品")
        z.isTaking = false
        return
    end
    local takenCount = 0
    for _, item in ipairs(storageItems) do
        if item and item.Name and item.MakeIndex then
            local itemName = string.trim(item.Name)
            ShowLocalNoticeByType("取: " .. itemName)
            LuaSendMsg(global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST,999999999,item.MakeIndex,0,0,itemName,string.len(itemName))
            takenCount = takenCount + 1
        end
    end
    z.isTaking = false
    if takenCount > 0 then ShowLocalNoticeByType("取出物品完成, 共取出 " .. tostring(takenCount) .. " 件") end
end

local function PickUpItems()
    local function Nested_dist_2(left,right) return left.dist < right.dist end
    local function Nested_dist(left,right)
        if left.kIdx ~= right.kIdx then return left.kIdx < right.kIdx end
        return left.dist < right.dist
    end
    local nameRules = {}
    local droppedItems,droppedCount = GetDroppedItems()
    if droppedCount == 0 then ShowLocalNoticeByType("地面无可拾取物品"); return end
    local playerX,playerY = PlayerPos()
    local preferredItems,ordinaryItems = {},{}
    for _,item in ipairs(droppedItems) do
        local name = item.mName or item.mONameStr or item.Name or item.name or ""
        local x = item.mCurrMapX or item.MapX or item.mapX or item.x
        local y = item.mCurrMapY or item.MapY or item.mapY or item.y
        if x and y then
            local distance = math.abs(playerX-x)+math.abs(playerY-y)
            local matchedRuleIndex = 0
            for ruleIndex,rule in ipairs(nameRules) do
                if string.find(name,rule) then matchedRuleIndex=ruleIndex; break end
            end
            if matchedRuleIndex > 0 then
                table.insert(preferredItems,{item=item,dist=distance,kIdx=matchedRuleIndex,x=x,y=y})
            else
                table.insert(ordinaryItems,{item=item,dist=distance,x=x,y=y})
            end
        end
    end
    table.sort(preferredItems,Nested_dist)
    table.sort(ordinaryItems,Nested_dist_2)
    local candidates = {}
    for _,entry in ipairs(preferredItems) do table.insert(candidates,entry) end
    for _,entry in ipairs(ordinaryItems) do table.insert(candidates,entry) end
    if #candidates == 0 then return end
    local target = candidates[1]
    MoveTo(target.x,target.y,0)
    if math.abs(playerX-target.x)<=1 and math.abs(playerY-target.y)<=1 then
        global.dropItemController:PickMainPlayerPosItem()
        ShowLocalNoticeByType("拾取: " .. target.item.mName)
    end
end

rootEnvironment.DiuItems = DiuItems
rootEnvironment.TakeItems = TakeItems
rootEnvironment.PickUpItems = PickUpItems

-- ============================================================================
-- 仓库入口：GetAvailableStoragePage / StorageItems
-- ============================================================================
local function GetAvailableStoragePage()
    local storageProxy = NPCStorageProxy
    if not storageProxy then
        PrintLog("仓库代理未初始化")
        return
    end
    local maxPage = storageProxy:GetMaxPage()
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        local currentCount = pageData and #pageData or 0
        local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
        if not pageCapacity then pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE end
        local openSize = storageProxy:GetOpenSize()
        local remainingOpenSize = openSize - (page - 1) * pageCapacity
        local pageLimit = remainingOpenSize
        if pageCapacity < remainingOpenSize then pageLimit = pageCapacity end
        if pageLimit > 0 and pageLimit > currentCount then return page end
    end
    return
end

local function StorageItems()
    if z.isStoring then return end
    z.isStoring = true
    if not GetAvailableStoragePage() then
        PrintLog("仓库已满,无法存仓")
        z.isStoring = false
        return
    end
    local storageProxy = NPCStorageProxy
    local maxPage = storageProxy:GetMaxPage()
    local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
    if not pageCapacity then pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE end
    local openSize = storageProxy:GetOpenSize()
    local storedPageData = {}
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        storedPageData[page] = pageData and #pageData or 0
    end
    local function findAvailablePage()
        for page = 1, maxPage do
            local remainingOpenSize = openSize - (page - 1) * pageCapacity
            local pageLimit = remainingOpenSize
            if pageCapacity < remainingOpenSize then pageLimit = pageCapacity end
            if pageLimit > 0 and pageLimit > storedPageData[page] then return page end
        end
        return
    end

    local specialNames = {
        "金刚石","玄铁","真金矿石","BOSS头骨","转生证明","魔神石",
        "神装碎片","涅槃石","宝石精魄","天神令","神彩","金罡",
        "至尊","圣皇","凤凰","麻痹戒指","复活戒指","切割神戒"
    }
    local filterNames = {"待定"}
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        PrintLog("背包物品为空")
        z.isStoring = false
        return
    end
    local processedMakeIndexes = {}
    local queuedCount = 0
    local function isOutputted(item, itemText)
        if not string.find(itemText, "聚灵珠", 1, true) then return true end
        if not z.isOutputted then
            z.isOutputted = true
            ShowLocalNoticeByType(item)
            local info = "聚灵珠信息: " .. tostring(item.Name)
                .. " StdMode=" .. tostring(item.StdMode)
                .. " Dura=" .. tostring(item.Dura)
                .. " DuraMax=" .. tostring(item.DuraMax)
            ShowLocalNoticeByType(info)
        end
        if not item.Dura then return false end
        if not item.DuraMax then return false end
        return item.Dura <= item.DuraMax
    end

    for _, item in pairs(bagData) do
        local makeIndex = item.MakeIndex
        if makeIndex and not processedMakeIndexes[makeIndex] then
            local isBound = SL:GetMetaValue("ITEM_IS_BIND", item)
            if not isBound then
                for _, filterName in ipairs(filterNames) do
                    if string.find(item.Name, filterName, 1, true) then
                        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", item.Name)
                        SL:UseItemByIndex(itemIndex)
                        ShowLocalNoticeByType("使用: " .. item.Name)
                    end
                end
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
                if matchedSpecialName and shouldStore then
                    local targetPage = findAvailablePage()
                    if not targetPage then
                        ShowLocalNoticeByType("仓库已满,无法存仓")
                        z.isStoring = false
                        return
                    end
                    ShowLocalNoticeByType("存: " .. item.Name)
                    LuaSendMsg(global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
                        999999999,item.MakeIndex,targetPage,0,item.Name,string.len(item.Name))
                    processedMakeIndexes[makeIndex] = true
                    storedPageData[targetPage] = storedPageData[targetPage] + 1
                    queuedCount = queuedCount + 1
                end
            end
        end
    end
    z.isStoring = false
    if queuedCount > 0 then
        ShowLocalNoticeByType("存仓完成, 共存入 " .. tostring(queuedCount) .. " 件物品")
    end
end

rootEnvironment.GetAvailableStoragePage = GetAvailableStoragePage
rootEnvironment.StorageItems = StorageItems

-- root.children[1] / GetStorageItemData：读取全部仓库页并统计可用格数。
local function GetStorageItemData()
    local storageItems = {}
    local storageProxy = NPCStorageProxy
    if not storageProxy then return storageItems end
    local maxPage = storageProxy:GetMaxPage()
    local availableSlots = 0
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        if type(pageData) == "table" then
            for _, item in ipairs(pageData) do table.insert(storageItems, item) end
        end
        local pageItemCount = pageData and #pageData or 0
        local perPageMax = GUIDefine.STORAGE_PER_PAGE_MAX
        if not perPageMax then perPageMax = global.MMO.NPC_STORAGE_MAX_PAGE end
        local openSize = storageProxy:GetOpenSize()
        local pageLimit = openSize - (page - 1) * perPageMax
        if pageLimit > perPageMax then pageLimit = perPageMax end
        if pageLimit > 0 then availableSlots = availableSlots + (pageLimit - pageItemCount) end
    end
    PrintLog("仓库总可用格子: " .. tostring(availableSlots))
    return storageItems
end
rootEnvironment.GetStorageItemData = GetStorageItemData

-- ============================================================================
-- 黑名单消息与清理入口：root.children[15]/[25]/[51]/[52]/[6]
-- ============================================================================
local function Nested_FriendProxy()
    return global.Facade.retrieveProxy(global.ProxyTable.FriendProxy)
end

local function PCallHelper_2()
    local ok, result = pcall(Nested_FriendProxy)
    if not ok then return nil end
    return result or nil
end

local function FindBlacklistPlayer(targetID)
    local friendProxy = PCallHelper_2()
    if not friendProxy then return false end
    local blacklistData = friendProxy._blacklistData
    if not blacklistData or not targetID then return false end
    local entry = blacklistData[targetID]
    if entry then return true, entry.Name end
    local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", targetID)
    if masterActorID and masterActorID ~= targetID then
        local masterEntry = blacklistData[masterActorID]
        if masterEntry then return true, masterEntry.Name end
    end
    return false
end

local function onDamageMsg(arg1, messageJson)
    if not messageJson or messageJson == "" then return end
    local decodeOK, message = pcall(function()
        return SL.JsonDecode(messageJson)
    end)
    if not decodeOK or type(message) ~= "table" then return end
    local mainActorID = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not mainActorID or message.UserID == mainActorID then return end
    local attackerID = message.AttackUserID
    if not attackerID or attackerID == mainActorID then return end
    if SL:GetMetaValue("ACTOR_IS_HERO", attackerID) then
        local masterActorID = SL:GetMetaValue("ACTOR_MASTER_ID", attackerID)
        if masterActorID then attackerID = masterActorID end
    end
    local attackerName = SL:GetMetaValue("ACTOR_NAME", attackerID)
    if not attackerName or attackerName == "" then return end
    if string.find(attackerName, "分身", 1, true) then return end
    blacklistState.lastAttacker = {id=attackerID,name=attackerName}
end
MainLeftBottom.onDamageMsg = onDamageMsg

local function InstallDamageHook()
    local gameMapController = global.gameMapController
    if not gameMapController then return end
    local messageHandlers = gameMapController.mNetMsgHandle
    if type(messageHandlers) ~= "table" then return end
    local messageTypes = global.MsgType
    if not messageTypes then return end
    local damageMessageType = messageTypes.MSG_SC_DAMAGE_HP
    if not damageMessageType then return end
    local originalHandler = messageHandlers[damageMessageType]
    if not originalHandler then return end
    if gameMapController.__ylwHookedOrigin == originalHandler then return end
    local wrappedHandler = function(arg1,arg2)
        local optionalCallback = gameMapController.onDamageMsg
        if type(optionalCallback) == "function" then pcall(optionalCallback,arg1,arg2) end
        return originalHandler(arg1,arg2)
    end
    messageHandlers[damageMessageType] = wrappedHandler
    originalHandler.__ylwHookedOrigin = originalHandler.mNetMsgHandle[damageMessageType]
    PrintLog("已挂接伤害消息钩子（击杀拉黑用）")
end

local function DeathAutoBlacklist()
    local lastAttacker = blacklistState.lastAttacker
    blacklistState.lastAttacker = nil
    if not lastAttacker or not lastAttacker.name or lastAttacker.name == "" then
        PrintLog("本次死亡没记录到凶手，跳过自动拉黑")
        return
    end
    if FindBlacklistPlayer(lastAttacker.id) then
        PrintLog("凶手已在黑名单中：%s",lastAttacker.name)
        return
    end
    PrintLog("被 %s 击杀，自动加入黑名单",lastAttacker.name)
    ShowLocalNoticeByType("自动拉黑：" .. lastAttacker.name)
    for retryIndex=0,5 do
        SL:ScheduleOnce(function()
            SL:RequestAddBlacklistByName(lastAttacker.name)
        end,0.5*retryIndex)
    end
end


-- root.children[22] / GetMapData2DPtr：五个独立参数的切比雪夫距离门控。
-- 原型的可达路径在PC37提前返回；后续不可达指令不纳入功能等价实现。
local function GetMapData2DPtr(x1, y1, x2, y2, maxDistance)
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

-- root.children[24] / UseItemByIndex：按捕获名称顺序寻找有库存的随机传送道具。
local function UseItemByIndex()
    for _, itemName in ipairs(randomTeleportItemNames) do
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

-- root.children[47] / BlacklistPlayerDetection：13项父级捕获已按PC368槽序直接绑定。
-- UP[0]=a；UP[1]=InstallDamageHook；UP[2]=blacklistState；
-- UP[3]=DeathAutoBlacklist；UP[4]=FindBlacklistPlayer；UP[5]=GetMapData2DPtr；
-- UP[6]=2.0；UP[7]=PrintLog；UP[8]=UseItemByIndex；UP[9]=0.01；
-- UP[10]=ShowLocalNoticeByType；UP[11]=30.0；UP[12]=randomTeleportItemNames。
local function BlacklistPlayerDetection()
    a.isBlacklisting = true
    InstallDamageHook()

    local mainActorID = SL.GetMetaValue("MAIN_ACTOR_ID")
    if not mainActorID then
        return
    end

    local hp = tonumber(SL.GetMetaValue("HP"))
    if not hp then
        return
    end

    local state = blacklistState
    local previousHp = state.lastHp
    if previousHp == nil then
        state.lastHp = hp
        state.deathHandled = (hp <= 0)
    elseif hp > 0 then
        state.lastHp = hp
        state.deathHandled = false
    elseif previousHp > 0 and not state.deathHandled then
        state.deathHandled = true
        state.lastHp = 0
        DeathAutoBlacklist()
    end

    if hp <= 0 then return end
    if IsInWhitelistMap() then return end

    local players = SL.GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
    if not players or #players <= 0 then return end

    for index = 1, #players do
        local player = players[index]
        if player then
            local playerInfo, playerObject = FindBlacklistPlayer(player)
            if playerInfo then
                local actorName = SL.GetMetaValue("ACTOR_NAME", player)
                if not actorName then
                    actorName = "黑名单玩家"
                end

                local distance = state.distance
                if distance then
                    local mainActorX = SL.GetMetaValue("ACTOR_MAP_X", mainActorID)
                    local mainActorY = SL.GetMetaValue("ACTOR_MAP_Y", mainActorID)
                    local playerX = SL.GetMetaValue("ACTOR_MAP_X", player)
                    local playerY = SL.GetMetaValue("ACTOR_MAP_Y", player)
                    local distanceResult = GetMapData2DPtr(
                        mainActorX, mainActorY, playerX, playerY, distance
                    )

                    if distanceResult ~= nil then
                        local now = os.time()
                        if now - state.alertAt >= (blacklistAlertThreshold or 0) then
                            state.alertAt = now
                            PrintLog(string.format(
                                "野外观测到黑名单玩家：%s（%d格）",
                                actorName,
                                distanceResult
                            ))
                        end

                        if state.nextTryAt <= now then
                            local usedTeleportItem = UseItemByIndex()
                            if usedTeleportItem then
                                state.nextTryAt = now + blacklistShortRetryDelay
                                state.noStoneWarned = false
                                ShowLocalNoticeByType(string.format(
                                    "黑名单玩家：%s（%d格），飞随机",
                                    blacklistNoItemRetryDelay,
                                    distanceResult or 0
                                ))
                                PrintLog(
                                    "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                                    actorName,
                                    distanceResult or 0,
                                    usedTeleportItem
                                )
                            else
                                state.nextTryAt = now + blacklistNoItemRetryDelay
                                if not state.noStoneWarned then
                                    state.noStoneWarned = true
                                    ShowLocalNoticeByType("没有随机传送石，黑名单玩家传送暂停")
                                end
                                PrintLog(
                                    "没有可用的随机传送道具（%s）",
                                    table.concat(randomTeleportItemNames, "/")
                                )
                            end
                        end
                    end
                end
            end
        end
    end
end
rootEnvironment.BlacklistItems = BlacklistPlayerDetection

local function ClearBlacklistItems()
    local friendProxy = PCallHelper_2()
    if not friendProxy or not friendProxy._blacklistData then
        PrintLog("取不到好友代理，清空失败")
        ShowLocalNoticeByType("清空黑名单失败")
        return
    end
    local blacklistData = friendProxy._blacklistData
    local entries = {}
    for key,_ in pairs(blacklistData) do entries[#entries+1] = key end
    if #entries == 0 then
        PrintLog("黑名单本来就是空的")
        ShowLocalNoticeByType("黑名单为空")
        return
    end
    PrintLog(string.format("开始清空黑名单，共 %d 人",#entries))
    ShowLocalNoticeByType("清空黑名单 " .. #entries .. " 人")
    for index,entryKey in ipairs(entries) do
        local delay = (index-1)*0.01
        SL:ScheduleOnce(function()
            SL:RequestOutBlacklist(entryKey)
            if friendProxy and friendProxy._blacklistData then
                friendProxy._blacklistData[entryKey] = nil
            end
        end,delay)
    end
    blacklistState.lastAttacker = nil
end

rootEnvironment.FindBlacklistPlayer = FindBlacklistPlayer
rootEnvironment.InstallDamageHook = InstallDamageHook
rootEnvironment.DeathAutoBlacklist = DeathAutoBlacklist
rootEnvironment.ClearBlacklistItems = ClearBlacklistItems

local function CallRootFunction(name, ...)
    local fn = rootEnvironment[name]
    if type(fn) ~= "function" then
        PrintLog("功能入口尚未接入：%s", name)
        return nil
    end
    return fn(...)
end

local function StorageItems(...) return CallRootFunction("StorageItems", ...) end
local function TakeItems(...) return CallRootFunction("TakeItems", ...) end
local function PickUpItems(...) return CallRootFunction("PickUpItems", ...) end
local function DiuItems(...) return CallRootFunction("DiuItems", ...) end
local function BlacklistItems(...) return CallRootFunction("BlacklistItems", ...) end
local function ClearBlacklistItems(...) return CallRootFunction("ClearBlacklistItems", ...) end

local printLog = PrintLog
local featureState = z
local uiState = a
local buttonMap = b
local readBlacklistDistanceConfig = AnonymousHelper_49
local schedule = Schedule
local readGatherMonsterCountConfig = AnonymousHelper_33
local writeBlacklistDistanceConfig = AnonymousHelper_32
local showLocalNotice = ShowLocalNoticeByType
local getWritablePath = GetWritablePath
local writeGatherMonsterCountConfig = AnonymousHelper_54
local checkConfigFileState = FileExistCheck_pcall_wrapper
local capturedValue17 = rootRegister11
local rewardEntries = loginAndOnlineRewardEntries
local capturedValue19 = 0.2

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

local function make_Nested_Helper(checkConfigFileState, configFileName, notify, printLog)
    local function Nested_Helper()
        local success, detail = checkConfigFileState(configFileName)
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

local function make_Nested_s(checkConfigFileState, configFileName, notify, printLog)
    local function Nested_s()
        local success, detail = checkConfigFileState(configFileName)
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
    writeConfigValue, notify, formatCallback, resolveWritablePath,
    configFileName, startBlacklistTimer, setButtonState
)
    local function Nested_Helper_5(value)
        if not writeConfigValue(value) then
            notify("黑名单距离保存失败")
            formatCallback(
                "黑名单距离保存失败，路径：%s",
                resolveWritablePath(configFileName)
            )
            return
        end

        notify("黑名单距离已保存：" .. value .. " 格")
        formatCallback("黑名单距离已保存：%d 格", value)
        if not startBlacklistTimer(value) then return end
        setButtonState("blacklistbut", true)
    end
    return Nested_Helper_5
end

local function make_Nested_Helper_8(
    writeConfigValue, notify, formatCallback, resolveWritablePath,
    configFileName, startGathering, setButtonState
)
    local function Nested_Helper_8(value)
        if not writeConfigValue(value) then
            notify("怪物阈值保存失败")
            formatCallback(
                "怪物阈值保存失败，路径：%s",
                resolveWritablePath(configFileName)
            )
            return
        end

        notify("怪物阈值已保存：" .. value)
        formatCallback("怪物阈值已保存：%d", value)
        if not startGathering(value) then return end
        setButtonState("yinguaibut", true)
    end
    return Nested_Helper_8
end

local function make_Nested_Helper_4(
    openDialog, writeConfigValue, notify, formatCallback,
    resolveWritablePath, configFileName, startBlacklistTimer, setButtonState
)
    local function Nested_Helper_4()
        local callback = make_Nested_Helper_5(
            writeConfigValue, notify, formatCallback, resolveWritablePath,
            configFileName, startBlacklistTimer, setButtonState
        )
        openDialog("请输入黑名单的距离格子（数字，按线路计算）", callback)
    end
    return Nested_Helper_4
end

local function make_Nested_Helper_7(
    openDialog, writeConfigValue, notify, formatCallback,
    resolveWritablePath, configFileName, startGathering, setButtonState
)
    local function Nested_Helper_7()
        local callback = make_Nested_Helper_8(
            writeConfigValue, notify, formatCallback, resolveWritablePath,
            configFileName, startGathering, setButtonState
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
            -- 检查点225已确认该dump标记是nil的序列化占位；清理定时器句柄。
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
    timerState, notify, moduleState, readBlacklistDistanceConfig,
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

        local distance = readBlacklistDistanceConfig()
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

    -- PC1-PC3：初始化完成通知。
    printLog("插件初始化完成")

    -- PC4-PC17：货币与资源名称常量。
    local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
    local resourceNames = {
        "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
    }

    -- PC19-PC58：时间状态初始化；os.time/os.date 均在 pcall 路径中调用。
    featureState.initTime = 0
    featureState.initTimeStr = "--"
    if os and os.time and os.date and pcall then
        local okTime, now = pcall(os.time)
        if okTime and now then
            featureState.initTime = now
            local okDate, dateText = pcall(os.date, "%Y-%m-%d %H:%M:%S", now)
            if okDate and dateText then
                featureState.initTimeStr = dateText
            end
        end
    end
    featureState.initSnapshot = {}

    -- PC59-PC99：MoneyProxy及两组名称循环，建立资源数量初始快照。
    local moneyProxy = global.Facade:retrieveProxy(global.ProxyTable.MoneyProxy)
    if moneyProxy then
        for _, name in ipairs(moneyNames) do
            local id = moneyProxy:GetMoneyIdByName(name)
            if id then
                local count = moneyProxy:GetMoneyCountById(id)
                -- PC82-PC85：false和nil均进入0回退分支。
                if not count then count = 0 end
                featureState.initSnapshot[name] = count
            end
        end
    end

    -- PC88-PC99是独立的第二个ipairs循环，不受MoneyProxy是否存在的门控。
    -- 第二组是背包资源，不走MoneyProxy：调用无捕获child0 Nested_find(name)，
    -- 并以资源名称作为initSnapshot键；BAG_DATA缺失时返回0。
    for _, name in ipairs(resourceNames) do
        featureState.initSnapshot[name] = Nested_find(name)
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
                    printLog(message)
                    if succeeded then
                        return
                    end
                end
            end
        end
        SL:ScheduleOnce(callback, slotIndex * 0.1)
    end

    -- PC146-PC166：替换cruiseTimer并建立周期任务。
    if timerState.cruiseTimer then
        SL:UnSchedule(timerState.cruiseTimer)
        timerState.cruiseTimer = nil
    end
    -- PC145清空父帧T[5]；PC160-PC163随后以该cell创建child12。
    -- 检查点111已闭合：R5是同日发送标记，另捕获UP[3]发送对象、UP[0]通知回调。
    local lastSentDate = nil
    local dailyCallback = make_Nested_04d_02d_02d(
        lastSentDate, uiState, printLog
    )
    timerState.cruiseTimer = SL:Schedule(dailyCallback, 1.0)

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
    local syncButtonState = make_Nested_ffffff(buttonGroups, buttonMap)

    -- PC239-PC244：child17 Nested_blacklistTimer捕获[UP5,UP6,UP2,UP7,UP0]。
    local blacklistTimerCallback = make_Nested_blacklistTimer(
        blacklistState, readBlacklistDistanceConfig, timerState, schedule, printLog
    )
    -- PC245-PC247：child7 Nested_InitGatherMonsters捕获[UP8,UP9]。
    local initGatherCallback = make_Nested_InitGatherMonsters(
        gatherConfig, readGatherMonsterCountConfig
    )

    -- PC248：child22 Nested_Anonymous仅捕获UP0(PrintLog)；检查点235确认固定参数为promptText/successCallback，分别映射T[0]/T[1]，T[2]=nil。
    -- PC250-PC258：child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]。
    local nestedAnonymous = make_Nested_Anonymous(printLog) -- child22固定参数映射已由检查点235闭合；Helper_4/Helper_7分别传入(promptText, callback)，T[2]=nil。
    local openBlacklistDistanceInput = make_Nested_Helper_4(
        nestedAnonymous, writeBlacklistDistanceConfig, showLocalNotice, printLog,
        getWritablePath, blacklistDistanceConfigFile, blacklistTimerCallback, syncButtonState
    ) -- child11 Nested_Helper_4主体已在本文件上方恢复
    -- PC259-PC267：child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]。
    local openGatherThresholdInput = make_Nested_Helper_7(
        nestedAnonymous, writeGatherMonsterCountConfig, showLocalNotice, printLog,
        getWritablePath, gatherMonsterCountConfigFile, initGatherCallback, syncButtonState
    ) -- child14 Nested_Helper_7主体已在本文件上方恢复

    -- PC269-PC276：child6捕获[UP2,UP11,UP9,UP0,R20,R17]。
    local stopGatherCallback = make_Nested_StopGatherMonsters(
        timerState, showLocalNotice, readGatherMonsterCountConfig, printLog,
        openGatherThresholdInput, initGatherCallback
    )
    -- PC277-PC282：child2捕获[UP16,UP15,UP11,UP0]。
    local clearMonsterCallback = make_Nested_Helper(
        checkConfigFileState, gatherMonsterCountConfigFile, showLocalNotice, printLog
    )
    -- PC283-PC288：child20捕获[UP16,UP13,UP11,UP0]。
    local clearDistanceCallback = make_Nested_s(
        checkConfigFileState, blacklistDistanceConfigFile, showLocalNotice, printLog
    )
    -- PC289-PC295：child1捕获[UP2,UP0,UP17,UP18,UP19]。
    local rewardCallback = make_Nested_SL_2(
        timerState, printLog, capturedValue17, rewardEntries, capturedValue19
    )
    -- PC296-PC298：child13捕获UP0。
    local clearBlacklistCallback = make_Nested_ClearBlacklistItems(printLog)
    -- PC299-PC306：child18捕获[UP2,UP0,UP1,R19,R16]。
    local blacklistCallback = make_Nested_Helper_10(
        timerState, printLog, featureState, readBlacklistDistanceConfig,
        openBlacklistDistanceInput, blacklistTimerCallback
    )
    -- PC307-PC312：child8捕获[UP2,UP0,UP1,UP7]。
    local storageCallback = make_Nested_SL_3(
        timerState, printLog, featureState, schedule
    )
    -- PC313-PC318：child19捕获[UP2,UP0,UP1,UP7]。
    local takeCallback = make_Nested_TakeItems(
        timerState, printLog, featureState, schedule
    )
    -- PC319-PC323：child10捕获[UP2,UP0,UP7]。
    local pickupCallback = make_Nested_shiquTimer(
        timerState, printLog, schedule
    )
    -- PC324-PC329：child21捕获[UP2,UP0,UP1,UP7]。
    local dropCallback = make_Nested_dropTimer(
        timerState, printLog, featureState, schedule
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
        moneybut = make_Nested_FFFF00(uiState, printLog, timerState, featureState), -- child3；父工厂及刷新/行构造依赖已并入本文件
        xiaotuibut = Nested_OnGameLeaveWorld,
    }
    -- PC338-PC345：创建child9工厂闭包，捕获顺序为：
    -- T[6]=Attach_UITop返回的uiParent，T[22]=xBase，T[23]=yBase，
    -- UP[4]=buttonMap，T[21]=buttonHandlers。其三个显式参数为config/列索引/行偏移。
    local xBase = miniChatRight - 10
    local yBase = miniChatY + 1

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
        GUI:addOnClickEvent(hideButton, make_Nested_Helper_9(uiState, printLog))
    end
end

-- PC411：doInit_UI直接挂入模块根表。
MainLeftBottom.doInit = doInit_UI

-- PC412：返回模块根表。
return MainLeftBottom

-- ============================================================================
-- 唯一主源码工作约定
-- 本文件 MainLeftBottom_功能等价重建.lua 是唯一持续更新的源码目标。
-- 后续完成的函数、UI初始化、捕获装配和模块导出均直接写入本文件。
-- root_MainLeftBottom_Module.lua 与 MainLeftBottom_恢复源码.lua 仅作证据参考，
-- 不再作为平行开发主线；不得以“全部完成后再生成”作为延后创建本文件的理由。
-- 当前状态：INCOMPLETE；PC212-PC279入口首批已写入（采集主循环、启动/停止、设置、UI控制、账号验证），仍有其他根级闭包及黑名单/物品功能待接入；Lua语法检查和游戏运行验证均未执行。
-- ============================================================================

-- ============================================================================
-- 检查点285：root.children[42] / doInit_UI 第一阶段收敛复核
--
-- 419条物理指令的主函数体已按PC顺序落为普通Lua；这里补记本轮逐项对账结果，
-- 避免把“UI代码已写入”误判为“23个子原型或捕获关系已全部验证”。
--
-- 23个直接子原型与当前实现的对应关系（按VM child索引，不按创建先后排序）：
-- child[0]  Nested_find：背包资源数量查询；
-- child[1]  make_Nested_SL_2：奖励定时器回调；
-- child[2]  make_Nested_Helper：清除拉怪数量配置；
-- child[3]  make_Nested_FFFF00：资源统计窗口及其刷新/行构造闭包；
-- child[4]  Nested_OnGameLeaveWorld：快速小退/离开世界回调；
-- child[5]  make_Nested_ffffff：按钮标题与toggle状态同步；
-- child[6]  make_Nested_StopGatherMonsters：停止/启动拉怪按钮门控；
-- child[7]  make_Nested_InitGatherMonsters：拉怪阈值初始化；
-- child[8]  make_Nested_SL_3：仓库存储定时器回调；
-- child[9]  createButton：按钮创建及其child[0]点击回调；
-- child[10] make_Nested_shiquTimer：拾取定时器回调；
-- child[11] make_Nested_Helper_4：黑名单距离输入及其输入回调；
-- child[12] make_Nested_04d_02d_02d：每日定时协议回调；
-- child[13] make_Nested_ClearBlacklistItems：清理黑名单按钮回调；
-- child[14] make_Nested_Helper_7：拉怪数量输入及其输入回调；
-- child[15] make_Nested_Helper_9：隐藏按钮回调；
-- child[16] item-slot callback：四组传送道具索引查询与快捷栏设置；
-- child[17] make_Nested_blacklistTimer：黑名单检测定时器；
-- child[18] make_Nested_Helper_10：黑名单按钮回调；
-- child[19] make_Nested_TakeItems：仓库取物定时器回调；
-- child[20] make_Nested_s：清除黑名单距离配置；
-- child[21] make_Nested_dropTimer：丢弃物品定时器回调；
-- child[22] make_Nested_Anonymous：输入对话框回调包装。
--
-- 上述23项均能在本文件中定位到对应的局部函数/闭包创建点；本轮静态核对没有
-- 发现缺失的 make_Nested_* 函数引用。子原型内部仍有宿主API契约及运行时行为
-- 未验证项，不把“引用已接通”扩大表述为“游戏内功能已验证”。
--
-- PC390-PC410的20项捕获按原始父T寄存器顺序绑定到当前词法变量：
-- UP[0] PrintLog                         <- T[4]
-- UP[1] featureState(z)                  <- T[2]
-- UP[2] timerState                       <- T[3]
-- UP[3] uiState(a)                       <- T[0]
-- UP[4] buttonMap(b)                     <- T[1]
-- UP[5] blacklistState                   <- T[41]
-- UP[6] readBlacklistDistanceConfig      <- T[48] AnonymousHelper_49
-- UP[7] schedule                         <- T[7] Schedule
-- UP[8] gatherConfig                     <- T[8]
-- UP[9] readGatherMonsterCountConfig     <- T[50] AnonymousHelper_33
-- UP[10] writeBlacklistDistanceConfig   <- T[49] AnonymousHelper_32
-- UP[11] showLocalNotice                 <- T[5] ShowLocalNoticeByType
-- UP[12] getWritablePath                 <- T[44] GetWritablePath
-- UP[13] blacklistDistanceConfigFile    <- T[42]
-- UP[14] writeGatherMonsterCountConfig  <- T[51] AnonymousHelper_54
-- UP[15] gatherMonsterCountConfigFile   <- T[43]
-- UP[16] checkConfigFileState           <- T[47] FileExistCheck_pcall_wrapper
-- UP[17] capturedValue17                <- T[11] 18000
-- UP[18] rewardEntries                  <- T[12] loginAndOnlineRewardEntries
-- UP[19] capturedValue19                <- T[9] 0.2
--
-- 绑定顺序与PC390-PC410捕获序列逐槽一致；本文件使用词法变量身份，不再通过
-- make_doInit_UI工厂或rootRegisters/rootConfigRegisters影子表二次装配。
--
-- 初始化顺序复核：完成通知 -> 计时/资源快照 -> Builtsetting -> 四组传送道具
-- ScheduleOnce -> 替换并建立每日Schedule -> 请求仓库数据 -> Attach_UITop ->
-- 读取mini-chat几何信息 -> 创建按钮配置与回调 -> 按40/0/80三组偏移创建按钮 ->
-- 创建隐藏按钮。未将异步ScheduleOnce回调提前执行，也未重排按钮回调构造。
--
-- 参数T[7]：保留为0。其静态生产者是PC90调用返回值中的第三返回值，PC133
-- 作为ipairs第三参数使用；标准Lua ipairs返回0。目标宿主是否覆盖ipairs仍未运行验证。
-- PC411 MainLeftBottom.doInit = doInit_UI、PC412 return MainLeftBottom 保持不变。
-- 本检查点只完成静态结构与捕获对账，不代表Lua语法检查或游戏运行验证通过。
-- ============================================================================

-- ============================================================================
-- 功能等价复刻 · 第二批：MoveTo与黑名单检测闭包（检查点286）
--
-- 本批直接把已有静态完整草稿接入唯一主源码：
-- 1) root.children[3] MoveTo：补齐PC62全局导出；拾取逻辑不再依赖未定义全局名。
-- 2) root.children[22] GetMapData2DPtr：五个独立参数、Chebyshev距离及nil哨兵。
-- 3) root.children[24] UseItemByIndex：按randomTeleportItemNames查询索引/数量，
--    有库存才调用SL:UseItemByIndex并返回名称。
-- 4) root.children[47] BlacklistPlayerDetection：补齐13项捕获的实际词法绑定，
--    包含HP变化/死亡自动拉黑、白名单地图过滤、黑名单玩家距离告警、
--    随机传送道具使用节流与无道具重试。
-- 5) rootEnvironment.BlacklistItems现指向BlacklistPlayerDetection，
--    使doInit_UI按钮包装器CallRootFunction("BlacklistItems")能够实际找到入口。
--
-- 捕获槽特别保留：UP[0]是MainLeftBottom.a（isBlacklisting状态），
-- 不是z功能状态表；UP[1]是PC360 InstallDamageHook live-cell当前值，
-- 不是PC357 onDamageMsg。InstallDamageHook内部originalHandler字段访问
-- 按已恢复物理指令原样保留，不以“看起来不合理”为由擅自改写。
--
-- 本批函数主体的静态控制流来自对应已恢复草稿；未执行Lua语法检查、
-- 未进行目标游戏运行验证。playerInfo/playerObject等局部值保留原型读写位置。
-- ============================================================================

-- ============================================================================
-- 功能等价复刻 · 第三批：PC43-PC63基础导出与LuaSendMsg（检查点287）
--
-- 已补齐根模块PC55/57/59/61四项chunk ENV全局导出：
-- GetMapId、GetMapName、PlayerPos、GetDroppedItems。
-- root.children[12] LuaSendMsg已按92条物理指令恢复并挂入MainLeftBottom.a.LuaSendMsg：
-- 六个固定参数、Blocklist日志豁免、SendHookList钩子调用与严格true拦截、
-- 未拦截时global.networkCtl:SendMsg六参数原样转发。
--
-- PrintLog、ShowLocalNoticeByType、ScheduleOnce、Schedule未被错误导出为ENV全局；
-- PrintLog仍按PC45写入ENV["_G"].log，LuaSendMsg仍只挂在a.LuaSendMsg。
-- 现有物品函数调用LuaSendMsg时使用同一词法函数，不再依赖未定义全局名。
--
-- 本批为静态源码整合；table.find、networkCtl与代理行为属于宿主依赖，
-- 未执行Lua语法检查或目标游戏运行验证。
-- ============================================================================


