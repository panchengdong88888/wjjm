-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第五十六批 / 检查点 #80；首版候选，非作者原始源码。
-- TODO表示参数、捕获身份、循环边界或宿主API契约尚待静态复核。

-- 1) Nested_FFFFFF
-- root.children[42].children[3].children[2] / legacy root/43/4/3
-- 65条指令；17常量；父PC265捕获父T[5]=resList、父T[1]=screenW*0.6。
-- 普通Lua工厂用于显式表达这两个闭包捕获；实际原型参数为(resourceNames,layoutOption,rowType,...).
local function make_Nested_FFFFFF(resList, cellWidth)
    return function Nested_FFFFFF(resourceNames, layoutOption, rowType, ...)
        local textNodes = {}
        local columnCount = math.ceil(15 / layoutOption)

        for groupStart = 1, #resourceNames, layoutOption do
            local cellName = tostring(rowType) .. "_cell_" .. tostring(columnCount)
            local cell = GUI:Layout_Create(
                resList, cellName, 0, 0, cellWidth, 35, 1
            )

            for columnIndex = 1, layoutOption do
                local resourceIndex = groupStart + columnIndex - 1
                local resourceName = resourceNames[resourceIndex]
                if resourceName then
                    local textName = "2_text_0.5_" .. tostring(columnIndex)
                    local x = cellWidth * (columnIndex - 0.5) / 1
                    local text = GUI:Text_Create(
                        cell, textName, x, 15, 30, "#FFFFFF",
                        resourceName .. ":--"
                    )
                    if text then
                        GUI:setAnchorPoint(text, 0.5, 0.5)
                        textNodes[resourceName] = text
                    end
                end
            end
        end

        return textNodes
    end
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
-- root PC70创建，捕获root T[4]；捕获业务名未知，但其调用契约为接收一条提示文本的回调。
local function make_GetStorageItemData(notify)
    return function()
        local storageItems = {}
        local storageProxy = NPCStorageProxy
        if not storageProxy then
            return storageItems
        end

        local maxPage = storageProxy:GetMaxPage()
        local availableSlots = 0

        -- PC13-PC17初始化从第1页到maxPage的数值循环。
        for page = 1, maxPage do
            -- PC18-PC23：逐页读取；假值页数据跳过后续类型/遍历分支。
            local pageData = storageProxy:GetStorageDataByPage(page)

            -- PC24-PC41：只有table页数据才经ipairs逐项插入总列表。
            if type(pageData) == "table" then
                for _, item in ipairs(pageData) do
                    table.insert(storageItems, item)
                end
            end

            -- PC42-PC47：truthy页数据取长度；假值按0计。
            local pageItemCount = 0
            if pageData then
                pageItemCount = #pageData
            end

            -- PC48-PC57：每轮读取单页容量配置及仓库已开放总格数。
            local perPageMax = GUIDefine.STORAGE_PER_PAGE_MAX
            if not perPageMax then
                perPageMax = global.MMO.NPC_STORAGE_MAX_PAGE
            end
            local openSize = storageProxy:GetOpenSize()

            -- PC58-PC67：当前页可用上限 = min(单页上限, 总开放格数 - 前面页容量)。
            local pageLimit = openSize - (page - 1) * perPageMax
            if pageLimit > perPageMax then
                pageLimit = perPageMax
            end
            if pageLimit > 0 then
                -- 保留字节码的原始算术：不额外把负数钳制为0。
                availableSlots = availableSlots + (pageLimit - pageItemCount)
            end
        end

        -- PC71-PC75：捕获回调收到格式化后的仓库总可用格子提示。
        notify("仓库总可用格子: " .. tostring(availableSlots))

        -- PC76-PC77：返回累计的仓库物品数组。
        return storageItems
    end
end
