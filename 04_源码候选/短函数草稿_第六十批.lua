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

    -- PC54创建子原型1（root.children[50].children[1]），捕获父函数R1/R2/R3/R4：
    -- maxPage、pageCapacity、openSize、storedPageData。该闭包在PC177-PC178被零参数调用，
    -- 返回值用于PC179-PC180容量门控；不能伪造成接收(maxPage,pageCapacity,openSize)的函数。
    -- PC102创建子原型0（root.children[50].children[0]），捕获2个父级值；
    -- PC167-PC170通过该闭包执行二参数调用，两个实参的业务身份仍待精确映射。

    local storedCount = 0

    -- PC105-PC215实际上是一条pairs遍历的连续处理路径，不是先后两个独立的
    -- ipairs(bagData)/pairs(bagData)循环。PC122-PC150先遍历R9并执行字符串匹配、
    -- ITEM_INDEX_BY_NAME查询、UseItemByIndex及UPVALUE_2提示。
    -- PC151-PC176再遍历R8；PC167-PC170调用子原型0，传入两个寄存器实参，
    -- PC175据返回结果决定是否进入存仓容量检查。R8/R9表的精确业务名称和
    -- 子原型0两个参数的业务身份仍待映射，故这里不伪造普通Lua过滤表达式。

    -- PC177-PC180：零参数调用子原型1。返回假值时调用UPVALUE_2提示仓库已满，
    -- 将UPVALUE_0.isStoring复位为false并立即return；返回真值才继续存仓。
    -- 该返回值随后作为LuaSendMsg的第4个实参传入，具体协议字段含义仍待确认。
    local canStore = Nested_Anonymous_2() -- TODO: 替换为PC54实际创建的闭包变量
    if not canStore then
        UPVALUE_2("仓库已满,无法存仓")
        storageState.isStoring = false
        return
    end

    -- PC187-PC205：先调用UPVALUE_2("存: " .. item.Name)，再调用LuaSendMsg。
    -- 七个实参的顺序已按寄存器构造闭合：
    -- 消息类型、999999999、item.MakeIndex、子原型1返回值、0、item.Name、string.len(item.Name)。
    -- 注意：以下仍是协议参数结构草稿，子原型1返回值的字段语义未确认。
    -- TODO: 把此段放回PC105-PC215的pairs循环体，并恢复R8/R9双层迭代及子原型0调用点。
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
