-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第五十七批 / 检查点 #81
-- 原型：root.children[5] / legacy root/6；99条物理指令；23常量；无子原型；vararg_flag=0。
-- 根函数 PC79 创建闭包，两个捕获依次为 root T[2]、root T[5]。
-- 以下保留已恢复控制流；未闭合的请求实参、过滤表及捕获对象业务身份明确标注。

local function TakeItems()
    local takingState = UPVALUE_0
    if takingState.isTaking then
        return
    end

    takingState.isTaking = true

    local storageItems = GetStorageItemData()
    if not storageItems then
        storageItems = {}
    end

    if #storageItems == 0 then
        -- UPVALUE_1 在本函数中以函数方式调用；准确业务名称/来源待追踪。
        UPVALUE_1("仓库无可取物品")
        takingState.isTaking = false
        return
    end

    local takenCount = 0
    local filterTerms = {} -- TODO：PC8-PC11的表构造载荷及其内容尚未完整映射。

    for _, item in ipairs(storageItems) do
        if item and item.Name and item.MakeIndex then
            local itemName = string.trim(item.Name)
            local skipRequest = false

            -- PC42-PC66：按过滤条件表逐项 string.find。
            -- 命中后置位标记并跳过本条仓库取出请求；过滤表的准确来源/元素待复核。
            for _, filterText in ipairs(filterTerms) do
                if string.find(itemName, filterText, 1, true) then
                    skipRequest = true
                    break
                end
            end

            if not skipRequest then
                -- PC67-PC71：调用捕获函数输出“取: ”及物品名称。
                UPVALUE_1("取: " .. itemName)

                -- PC72-PC85：发送仓库取出请求。
                -- 消息类型与MakeIndex/999999999等常量可确认；完整位置参数映射待复核。
                LuaSendMsg(
                    global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST,
                    item.MakeIndex,
                    999999999,
                    0,
                    0
                ) -- TODO：后四项/实参顺序为首版占位，不能视为最终协议。

                takenCount = takenCount + 1
            end
        end
    end

    takingState.isTaking = false

    if takenCount > 0 then
        UPVALUE_1("取出物品完成, 共取出 " .. tostring(takenCount) .. " 件")
    end
end
