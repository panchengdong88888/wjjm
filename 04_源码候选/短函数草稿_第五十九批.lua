-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第五十九批 / 检查点 #83
-- BlacklistPlayerDetection：root.children[47] / legacy root/48
-- 216条物理指令、35常量、无子原型、vararg_flag=0；root PC367创建闭包，捕获13个父寄存器。
-- 捕获映射尚未给出本函数13个upvalue对应的父寄存器；统一保留UPVALUE_0..12。

local function BlacklistPlayerDetection()
    -- 开启黑名单检测状态，并调用一个捕获的启动/通知函数（具体业务身份待映射）。
    UPVALUE_0.isBlacklisting = true
    UPVALUE_1()

    -- PC5-PC11：先读取本机 MAIN_ACTOR_ID；缺失/假值时立即返回。
    -- 这是HP读取之前的独立前置门槛，不能省略。
    local mainActorID = SL.GetMetaValue("MAIN_ACTOR_ID")
    if not mainActorID then
        return
    end

    -- PC12-PC20：读取本角色HP。先通过SL.GetMetaValue取值，再tonumber转换。
    local hp = tonumber(SL.GetMetaValue("HP"))
    if not hp then
        return
    end

    local state = UPVALUE_2
    local previousHp = state.lastHp

    -- PC21-PC54已逐条闭合：
    -- lastHp为nil时先记录当前HP，并按当前HP是否<=0初始化deathHandled；
    -- 已有lastHp时，当前HP>0则更新lastHp并清除deathHandled；
    -- 当前HP<=0且previousHp>0且尚未处理死亡时，只触发一次死亡回调。
    -- PC23的["unknown",2]是nil序列化哨兵，不是字符串"unknown"。
    if previousHp == nil then
        state.lastHp = hp
        state.deathHandled = (hp <= 0)
    elseif hp > 0 then
        state.lastHp = hp
        state.deathHandled = false
    elseif previousHp > 0 and not state.deathHandled then
        state.deathHandled = true
        state.lastHp = 0
        UPVALUE_3()
    end

    -- 仅在满足HP/死亡状态门槛且不处于白名单地图时继续。
    if hp <= 0 then return end
    if IsInWhitelistMap() then return end

    -- 获取视野玩家列表；空列表直接结束。
    local players = SL.GetMetaValue("FIND_IN_VIEW_PLAYER_LIST")
    if not players or #players <= 0 then return end

    -- PC74-PC215：按列表索引遍历视野玩家。
    for index = 1, #players do
        local player = players[index]
        if player then
            -- UPVALUE_4负责取得玩家/实体信息；返回值具体结构待确认。
            local actorInfo, actorObject = UPVALUE_4(player)
            if actorInfo then
                local actorName = SL.GetMetaValue("ACTOR_NAME", actorInfo)
                if actorName then
                    local distance = state.distance
                    if distance then
                        -- 获取玩家及本机坐标相关数据。坐标来源与UPVALUE_5..UPVALUE_9的对象身份待复核。
                        local playerX = SL.GetMetaValue("ACTOR_MAP_X", actorInfo)
                        local playerY = SL.GetMetaValue("ACTOR_MAP_Y", actorInfo)
                        local playerX2 = SL.GetMetaValue("ACTOR_MAP_X", actorObject)
                        local playerY2 = SL.GetMetaValue("ACTOR_MAP_Y", actorObject)
                        local coordinateData = {
                            playerX, playerY, playerX2, playerY2
                        }
                        local distanceResult = UPVALUE_5(coordinateData)

                        -- 原始比较使用unknown哨兵；该条件尚不能安全改写为确定的距离范围判断。
                        if distanceResult ~= "unknown" then
                            local now = os.time()
                            if now - state.alertAt >= (UPVALUE_6 or 0) then
                                state.alertAt = now
                                local alertText = string.format(
                                    "野外观测到黑名单玩家：%s（%d格）",
                                    actorName,
                                    distanceResult
                                )
                                UPVALUE_7(alertText)
                            end

                            -- nextTryAt控制随机传送尝试频率。
                            if now >= (state.nextTryAt or 0) then
                                state.nextTryAt = now + (UPVALUE_8 or 0)
                                state.noStoneWarned = false

                                -- 尝试通过捕获函数/对象选择随机传送道具。
                                -- 物品选择、使用API及返回值尚未从寄存器/捕获映射完全闭合。
                                local itemResult = UPVALUE_9(actorName, distanceResult)
                                if itemResult then
                                    UPVALUE_10(string.format(
                                        "黑名单玩家：%s（%d格），飞随机",
                                        actorName,
                                        distanceResult
                                    ))
                                    local detail = string.format(
                                        "黑名单玩家 %s，距离 %d 格，使用 %s 随机传送",
                                        actorName,
                                        distanceResult,
                                        tostring(itemResult)
                                    )
                                    UPVALUE_11(detail)
                                else
                                    if not state.noStoneWarned then
                                        state.noStoneWarned = true
                                        UPVALUE_10("没有随机传送石，黑名单玩家传送暂停")
                                    end
                                    -- 无可用道具时还会构造“没有可用的随机传送道具（%s）”提示；
                                    -- table.concat与GetMetaValue("os"/路径)相关调用参数仍待精确映射。
                                    local unavailable = string.format(
                                        "没有可用的随机传送道具（%s）",
                                        tostring(itemResult or "")
                                    )
                                    UPVALUE_12(unavailable)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
