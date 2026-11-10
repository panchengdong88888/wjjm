-- MainLeftBottom(2).lua 根模块首段普通 Lua 草稿
-- 原型：root / MainLeftBottom_Module
-- 规范路径：root
-- 规模：412条物理指令、109常量、58个直接子原型
-- 检查点192：仅恢复并整理PC1-PC41；不是完整根模块源码。
-- 状态：分段普通Lua草稿；已整理PC1-PC200中的已闭合片段，PC201-PC412仍待恢复；未运行时验证。

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

-- 后续PC201-PC412仍需逐段恢复：其余闭包注册、全局初始化及main/doInit注册。
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
local resetCounterA = 0
local resetCounterB = 0
local isGatherRunning = false
local resetCounterC = false
local resetCounterD = 0
local resetOptionalValue = nil
local resetTextValue = ""

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
