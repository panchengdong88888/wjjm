-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第五十六批 / 检查点 #80；首版候选，非作者原始源码。
-- TODO表示参数、捕获身份、循环边界或宿主API契约尚待静态复核。

-- 1) Nested_FFFFFF
-- root.children[42].children[3].children[2] / legacy root/43/4/3
-- 65条指令；17常量；vararg_flag=3；父PC265捕获父T[5]、T[1]。
local function Nested_FFFFFF(arg1, arg2, arg3)
    local layout = {}
    local columnCount = math.ceil(15 / arg1)
    local GUI = _G.GUI
    local captured0, captured1 = UPVALUE_0, UPVALUE_1 -- TODO：捕获对象业务身份

    local layoutName = "_cell_" .. tostring(arg2) .. "_"
    local container = GUI.Layout_Create(captured0, 0, 0, 35, true)

    -- PC23-PC62为两层数值循环；精确边界、步长及索引公式待复核。
    local outerCount = #arg1
    local innerCount = columnCount
    for outerIndex = 1, outerCount do
        for innerIndex = 1, innerCount do
            local itemIndex = 14 + innerIndex -- TODO：核实索引公式
            local item = arg1[itemIndex]
            if item then
                local textName = "_text_" .. tostring(itemIndex) .. "_"
                local text = GUI.Text_Create(
                    container, textName, 0, 0, 15, 30,
                    "#FFFFFF", tostring(item) .. ":--"
                )
                if text then
                    GUI.setAnchorPoint(text, 0.5, 0.5)
                    layout[itemIndex] = text
                end
            end
        end
    end
    return layout
end

-- 2) onDamageMsg
-- root.children[52] / legacy root/53；72条指令；19常量；1子原型；vararg_flag=2。
-- root PC356创建，捕获root T[57]；子原型Nested_JsonDecode捕获父T[3]。
local function Nested_JsonDecode()
    return SL.JsonDecode(UPVALUE_0) -- UPVALUE_0捕获父函数T[3]
end

local function onDamageMsg(arg1, arg2, ...)
    if not arg1 or arg1 == "" then
        return
    end

    -- TODO：vararg_flag=2及PC9栈窗口的参数对应关系仍待复核。
    local decodeOK, decoded = pcall(Nested_JsonDecode, arg1, arg2, ...)
    if not decodeOK then
        return
    end
    if type(decoded) ~= "table" then
        return
    end

    local mainActorID = SL.GetMetaValue("MAIN_ACTOR_ID")
    if decoded.UserID == mainActorID then
        return
    end
    if decoded.AttackUserID and decoded.AttackUserID == decoded.UserID then
        return
    end

    local actorIsHero = SL.GetMetaValue("ACTOR_IS_HERO", decoded.UserID)
    if not actorIsHero then
        return
    end

    local actorMasterID = SL.GetMetaValue("ACTOR_MASTER_ID", decoded.UserID)
    if not actorMasterID then
        return
    end

    local actorName = SL.GetMetaValue("ACTOR_NAME", decoded.UserID)
    if not actorName or actorName == "" then
        return
    end
    if string.find(actorName, "分身", 1, true) then
        return
    end

    -- TODO：捕获root T[57]的业务身份待追踪；字段来源按当前寄存器映射暂定。
    UPVALUE_0.lastAttacker = {
        id = decoded.UserID,
        name = actorName
    }
end

-- 3) GetStorageItemData
-- root.children[1] / legacy root/2；77条指令；16常量；无子原型；vararg_flag=0。
-- root PC70创建，捕获root T[4]；捕获值业务身份未证实。
local function GetStorageItemData()
    local storageItems = {}
    if not NPCStorageProxy then
        return storageItems
    end

    local maxPage = NPCStorageProxy.GetMaxPage()
    for page = 1, maxPage do
        local pageData = NPCStorageProxy.GetStorageDataByPage(page)
        if type(pageData) == "table" then
            for _, item in ipairs(pageData) do
                table.insert(storageItems, item)
            end
        end
    end

    -- PC47-PC70容量计算的精确分支/循环仍待复核，以下仅为可读骨架。
    local perPageMax = GUIDefine and GUIDefine.STORAGE_PER_PAGE_MAX
    local maxStoragePage = global and global.MMO and global.MMO.NPC_STORAGE_MAX_PAGE
    local openSize = NPCStorageProxy.GetOpenSize()
    local availableSlots = 0
    if perPageMax and maxStoragePage and openSize then
        local usedPageCapacity = math.max(0, (maxPage - 1) * perPageMax)
        local remaining = openSize - usedPageCapacity
        if remaining > 0 then
            availableSlots = availableSlots + remaining
        end
    end

    -- TODO：UPVALUE_0通知回调身份及容量循环累计公式待复核。
    UPVALUE_0("仓库总可用格子: " .. tostring(availableSlots))
    return storageItems
end
