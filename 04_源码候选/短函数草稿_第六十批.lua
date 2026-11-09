-- 第六十批 / 检查点 #141
-- StorageItems：root.children[50] / legacy root/51
-- 224条物理指令、57常量、2个子原型、vararg_flag=0。
-- 子原型0 Nested_isOutputted已有独立草稿（第三十四批）；子原型1容量页码算法已在检查点144闭合。
-- 主函数首版保留未闭合的数据结构、捕获对象与消息协议，不把占位参数当成作者原始调用。

local function StorageItems()
    local storageState = UPVALUE_0
    if storageState.isStoring then
        return
    end
    storageState.isStoring = true

    local storageProxy = NPCStorageProxy
    if not storageProxy then
        storageState.isStoring = false
        return
    end

    local availablePage = GetAvailableStoragePage()
    if not availablePage then
        UPVALUE_1("仓库已满,无法存仓")
        storageState.isStoring = false
        return
    end

    local maxPage = storageProxy:GetMaxPage()
    local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
    if not pageCapacity then
        pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE
    end
    local openSize = storageProxy:GetOpenSize()

    -- PC37-PC53：逐页读取仓库物品数组，只记录每页当前物品数量。
    -- pageData存在时取#pageData；不存在时记0。storedPageData[page]不是合并后的物品表。
    local storedPageData = {}
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        storedPageData[page] = pageData and #pageData or 0
    end

    -- PC61-PC80构造R8：18项特殊物品名称表；PC81-PC83构造R9：单项表{"待定"}。

    local bagData = SL.GetMetaValue("BAG_DATA")
    if not bagData then
        UPVALUE_1("背包物品为空")
        storageState.isStoring = false
        return
    end

    -- PC54创建子原型1（root.children[50].children[1]），捕获父函数R1/R2/R3/R4：
    -- maxPage、pageCapacity、openSize、storedPageData。它是零参数闭包，PC177-PC178调用，
    -- 返回第一个仍有空位的目标页码；nil表示所有页均满。精确容量算法见下方复原说明。
    -- PC102创建子原型0（root.children[50].children[0]），捕获2个父级值；

    local storedCount = 0

    -- R8/R9表身份已由PC61-PC83闭合：
    -- R8是PC61-PC80构造的18项特殊名称表：
    -- 金刚石、玄铁、真金矿石、BOSS头骨、转生证明、魔神石、神装碎片、
    -- 涅槃石、宝石精魄、天神令、神彩、金罡、至尊、圣皇、凤凰、
    -- 麻痹戒指、复活戒指、切割神戒。
    -- R9是PC81-PC83构造的单项表 {"待定"}。
    -- 因而PC122-PC150对R9逐项string.find，匹配后通过ITEM_INDEX_BY_NAME
    -- 查询索引并调用SL.UseItemByIndex；PC151-PC176对R8逐项匹配特殊名称。
    --
    -- 子原型0（root.children[50].children[0] / root/51/1）已逐PC复核：
    -- vararg=2，UPVALUE_0为含isOutputted字段的状态表，UPVALUE_1为输出回调。
    -- 第二个参数用于string.find(..., "聚灵珠", 1)；命中后仅在isOutputted未置位时
    -- 将其设为true，先把第一个参数交给输出回调，再构造“聚灵珠信息: ”
    -- + Name/StdMode/Dura/DuraMax的tostring拼接文本并再次交给同一回调。
    -- 随后根据Dura、DuraMax是否存在及二者大小关系返回状态值；
    -- 返回值用于PC175门控。不要把该子原型误写成通用isOutputted(item)过滤器。
    --
    -- PC105-PC215仍在恢复中：这里必须保持为单一pairs遍历体，不能拆成
    -- ipairs(bagData)和第二次pairs(bagData)两个循环。
    --
    -- 已确认的局部契约：
    -- * PC122-PC150：遍历R9，进行string.find；命中后查询ITEM_INDEX_BY_NAME，
    --   调用SL.UseItemByIndex，并通过UPVALUE_2输出“使用: ”提示。
    -- * PC151-PC176：另一个ipairs迭代遍历R8；PC167-PC170调用子原型0，
    --   调用时传入两个实参；PC175根据返回值决定是否进入容量门控。
    -- * PC177-PC178：零参数调用子原型1。返回假值则UPVALUE_2输出
    --   “仓库已满,无法存仓”，UPVALUE_0.isStoring=false并return。
    -- * 子原型1精确算法：for page=1,maxPage；普通页容量上限为pageCapacity；
    --   最后一页上限为min(pageCapacity, openSize-(maxPage-1)*pageCapacity)。
    --   读取storedPageData[page]，若当前数量小于该页上限则返回page；否则继续；
    --   全部页满则无显式返回值。PC24是数值for循环步进，PC25清理循环槽。
    -- * PC187-PC191：UPVALUE_2("存: " .. item.Name)。
    -- * PC192-PC205：LuaSendMsg七个实参依次为
    --   global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
    --   999999999, item.MakeIndex, 子原型1返回的目标页码, 0, item.Name,
    --   string.len(item.Name)。第4实参的调用点业务含义为目标仓库页码；
    --   服务端协议字段的正式名称/编码仍未从接收端证实。
    -- * PC206-PC211融合链：R22=item.MakeIndex；R12[R22]=true；
    --   R22=storedPageData[targetPage]；R22=R22+1；
    --   storedPageData[targetPage]=R22；R13=R13+1。
    --   R12在PC100初始化为空表，PC109-PC112按MakeIndex查重，
    --   因此它是本轮已处理/已发送物品索引集合；R4(storedPageData)按页记账。
    --   PC214-PC215复位isStoring；
    --   PC216-PC224仅在计数大于0时通过UPVALUE_2输出完成提示。
    --
    -- 检查点143：PC167-PC170子原型0实参为当前BAG_DATA物品记录R19、
    -- R8特殊名称迭代项R25；PC211为发送后的成功计数递增。
    -- 检查点144：子原型1容量算法及PC206-PC211记账链已逐条闭合，见审计报告。
    -- 尚未确认的只有LuaSendMsg第4字段在服务端协议中的正式字段名称/编码；
    -- 从调用点数据流可确认它承载子原型1返回的目标仓库页码。

end
