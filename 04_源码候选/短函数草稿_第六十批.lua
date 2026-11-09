-- 第六十批 / 检查点 #84
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

    -- PC61-PC79建立需要特殊处理/排除的物品名称集合。
    local specialNames = {
        "金刚石", "玄铁", "真金矿石", "BOSS头骨", "转生证明", "魔神石",
        "神装碎片", "涅槃石", "宝石精魄", "天神令", "神彩", "金罡",
        "至尊", "圣皇", "凤凰", "麻痹戒指", "复活戒指", "切割神戒"
    }

    local bagData = SL.GetMetaValue("BAG_DATA")
    if not bagData then
        UPVALUE_1("背包物品为空")
        storageState.isStoring = false
        return
    end

    -- 子原型1在PC54创建，捕获父函数4个寄存器；它负责一段页/容量相关数值计算，
    -- 具体公式、调用点实参与返回值含义尚未闭合，暂以占位变量记录。
    local pageCalculation = Nested_Anonymous_2 -- TODO: 应由PC54创建的闭包实例替代

    local storedCount = 0
    local outputState = { isOutputted = false }
    local function outputCallback(value)
        -- TODO: 此回调来自父函数捕获对象，具体输出目标待确认。
        UPVALUE_2(value)
    end

    -- PC105-PC150：pairs遍历背包物品，读取MakeIndex、绑定状态及名称，
    -- 对符合特殊条件的物品调用UseItemByIndex并输出“使用: ”提示。
    for itemKey, item in pairs(bagData) do
        if item then
            local makeIndex = item.MakeIndex
            local bindState = SL.GetMetaValue("ITEM_IS_BIND", makeIndex)
            if bindState then
                for _, specialName in ipairs(specialNames) do
                    if item.Name and string.find(item.Name, specialName, 1, true) then
                        local itemIndex = SL.GetMetaValue("ITEM_INDEX_BY_NAME", item.Name)
                        if itemIndex then
                            SL.UseItemByIndex(itemIndex)
                            UPVALUE_3("使用: " .. tostring(item.Name))
                        end
                    end
                end
            end
        end
    end

    -- 子原型0 Nested_isOutputted负责识别/记录“聚灵珠”并校验Dura/DuraMax；
    -- 其真实闭包捕获及主函数调用实参仍需从PC102-PC124进一步核对。
    -- PC151-PC176还有第二段ipairs/string.find筛选，过滤表与背包条目的对应关系未闭合。
    for _, item in ipairs(bagData) do
        if item and item.Name then
            -- TODO: 调用已恢复的Nested_isOutputted闭包；当前不伪造参数顺序。
            local eligible = true
            for _, specialName in ipairs(specialNames) do
                if string.find(item.Name, specialName, 1, true) then
                    eligible = false
                    break
                end
            end
            if eligible then
                -- TODO: 原字节码还有一段捕获函数/过滤逻辑，需恢复后才能确认此处条件。
            end
        end
    end

    -- PC177-PC186：检查页/容量计算结果；失败时提示仓库已满并复位isStoring。
    -- 目前尚不能把Nested_Anonymous_2的数值结果解释为确定的剩余格数。
    local pageLimit = pageCalculation and pageCalculation(maxPage, pageCapacity, openSize)
    if pageLimit == false then
        UPVALUE_1("仓库已满,无法存仓")
        storageState.isStoring = false
        return
    end

    -- PC187-PC215：遍历候选物品并发送存仓请求。LuaSendMsg实参位置/协议字段待复核。
    for _, item in pairs(bagData) do
        if item and item.MakeIndex then
            UPVALUE_3("存: " .. tostring(item.Name))
            -- 以下仅标出协议构成元素；999999999、MakeIndex、绑定/名称/长度等
            -- 在反汇编中确有寄存器构造，但参数次序和字段语义不能凭常量顺序推断。
            LuaSendMsg(
                global.MsgType.MSG_CS_STORAGE_STORE_REQUEST,
                999999999,
                item.MakeIndex
                -- TODO: 其余数值、名称长度、绑定状态及尾随字段待精确恢复
            )
            storedCount = storedCount + 1
        end
    end

    storageState.isStoring = false
    -- 原字节码末尾按计数条件输出“存仓完成, 共存入 N 件物品”；
    -- 是否只在正数时显示、计数口径与成功请求的关系待复核。
    if storedCount > 0 then
        UPVALUE_3("存仓完成, 共存入 " .. tostring(storedCount) .. " 件物品")
    end
end
