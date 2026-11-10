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

local function make_StorageItems(storageState, notify, output)
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
        local findAvailablePage = make_FindAvailableStoragePage(
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
        local isOutputted = make_Nested_isOutputted(storageState, notify)

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

return make_StorageItems
