-- 检查点 #81 / #134：TakeItems 完整静态恢复
-- root.children[5] / legacy root/6；99条物理指令；23常量；无子原型；无vararg。
-- 父root PC79创建闭包：UP[0]=root T[2]状态对象；UP[1]=root T[5]文本回调。
-- 检查点248：汇总源码以MainLeftBottom.z和ShowLocalNoticeByType实例化此工厂。
local function make_TakeItems(takingState, notify)
    return function()
        -- PC1-PC7：isTaking互斥保护并置为true。
        if takingState.isTaking then
            return
        end
        takingState.isTaking = true

        -- PC12-PC18：取得仓库物品；假值或空数组进入空仓提示分支。
        local storageItems = GetStorageItemData()
        if not storageItems or #storageItems == 0 then
            notify("仓库无可取物品")
            takingState.isTaking = false
            return
        end

        -- PC8-PC11确实构造了含"待定"的临时过滤表，但PC42-PC47的常量分支
        -- 将控制流直接送至PC65，PC48-PC64的ipairs/string.find过滤循环不可达。
        -- 因此可达路径不按"待定"过滤，不能把死分支写成实际过滤规则。
        local _deadFilterTerms = { "待定" }

        local takenCount = 0

        -- PC25-PC41、PC65-PC71：遍历仓库条目，只处理item、Name、MakeIndex均truthy的项。
        for _, item in ipairs(storageItems) do
            if item and item.Name and item.MakeIndex then
                local itemName = string.trim(item.Name)

                notify("取: " .. itemName)

                -- PC72-PC85：7项参数，顺序由调用寄存器窗口恢复。
                LuaSendMsg(
                    global.MsgType.MSG_CS_STORAGE_PICK_OUT_REQUEST,
                    999999999,
                    item.MakeIndex,
                    0,
                    0,
                    itemName,
                    string.len(itemName)
                )

                -- PC86：仅在发送调用之后增加计数。
                takenCount = takenCount + 1
            end
        end

        -- PC89-PC90：循环结束后复位isTaking。
        takingState.isTaking = false

        -- PC91-PC98：只有计数大于0才发送完成提示。
        if takenCount > 0 then
            notify("取出物品完成, 共取出 " .. tostring(takenCount) .. " 件")
        end
    end
end

-- 静态复核：
-- * PC42-PC64的过滤循环位于常量条件分支的不可达路径；可达路径直接进入PC65。
-- * LuaSendMsg参数顺序为消息类型、999999999、MakeIndex、0、0、trim后的名称、名称长度。
-- * 计数在LuaSendMsg调用后递增；最后只在计数大于0时提示完成。
-- * 没有字节码级异常保护；若宿主调用抛错，isTaking可能保持true，不擅自添加finally。
-- * 99条物理指令均已映射；未运行时验证。
