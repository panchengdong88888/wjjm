-- 第六十批 / 检查点 #141
-- StorageItems：root.children[50] / legacy root/51
-- 224条物理指令、57常量、2个子原型、vararg_flag=0。
-- 子原型0 Nested_isOutputted已有独立草稿（第三十四批）；子原型1 Nested_Anonymous_2仍处阶段分析。
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

    -- PC37-PC53：按页读取仓库数据并汇总。页数/容量边界及汇总字段仍需结合子原型1复核。
    local storedPageData = {}
    for page = 1, maxPage do
        local pageData = storageProxy:GetStorageDataByPage(page)
        if pageData then
            for key, value in pairs(pageData) do
                storedPageData[key] = value
            end
        end
    end

    -- PC61-PC83分别构造R8/R9两张表；当前仅能确认它们被后续两段ipairs使用，
    -- 尚未将常量和构造寄存器完整对应，故不把常量池内容猜成单一specialNames表。

    local bagData = SL.GetMetaValue("BAG_DATA")
    if not bagData then
        UPVALUE_1("背包物品为空")
        storageState.isStoring = false
        return
    end

    -- PC54创建子原型1（root.children[50].children[1]），捕获父函数R1/R2/R3/R4：
    -- maxPage、pageCapacity、openSize、storedPageData。该闭包在PC177-PC178被零参数调用，
    -- 返回值用于PC179-PC180容量门控；不能伪造成接收(maxPage,pageCapacity,openSize)的函数。
    -- PC102创建子原型0（root.children[50].children[0]），捕获2个父级值；
    -- PC167-PC170通过该闭包执行二参数调用，两个实参的业务身份仍待精确映射。

    local storedCount = 0

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
    -- * 子原型1由PC54创建，捕获父函数R1/R2/R3/R4，依次对应
    --   maxPage、pageCapacity、openSize、storedPageData。
    -- * PC187-PC191：UPVALUE_2("存: " .. item.Name)。
    -- * PC192-PC205：LuaSendMsg七个实参依次为
    --   global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
    --   999999999, item.MakeIndex, 子原型1返回值, 0, item.Name,
    --   string.len(item.Name)。
    -- * PC206-PC211包含存仓后的表/计数记账；PC214-PC215复位isStoring；
    --   PC216-PC224仅在计数大于0时通过UPVALUE_2输出完成提示。
    --
    -- TODO：恢复R8/R9两张表的构造和业务含义、两层迭代边界、子原型0的
    -- 两个实参身份、子原型1内部容量算术、第4个LuaSendMsg参数的协议含义，
    -- 以及PC206-PC211记账的准确表达式。未闭合前不伪造可执行循环体。

end
