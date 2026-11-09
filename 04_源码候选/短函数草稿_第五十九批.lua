-- MainLeftBottom(2).lua 普通 Lua 草稿
-- 第五十九批 / 检查点 #140
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
            -- UPVALUE_4(player)返回两个值；首返回值用于存在性门控。
            local playerInfo, playerObject = UPVALUE_4(player)
            if playerInfo then
                -- PC94-PC101：ACTOR_NAME查询的对象实参是视野列表中的player；
                -- 名称缺失时回退为固定文本“黑名单玩家”，而不是跳过该玩家。
                local actorName = SL.GetMetaValue("ACTOR_NAME", player)
                if not actorName then
                    actorName = "黑名单玩家"
                end

                local distance = state.distance
                if distance then
                    -- PC108-PC127：分别读取本机MAIN_ACTOR_ID与视野player的地图坐标。
                    local mainActorX = SL.GetMetaValue("ACTOR_MAP_X", mainActorID)
                    local mainActorY = SL.GetMetaValue("ACTOR_MAP_Y", mainActorID)
                    local playerX = SL.GetMetaValue("ACTOR_MAP_X", player)
                    local playerY = SL.GetMetaValue("ACTOR_MAP_Y", player)

                    -- PC128-PC134：捕获的距离函数接收五个独立实参，非坐标表。
                    local distanceResult = UPVALUE_5(
                        mainActorX, mainActorY, playerX, playerY, distance
                    )

                    -- PC136-PC141将nil作为无效距离哨兵；非nil结果才继续处理。
                    if distanceResult ~= nil then
                            -- PC142-PC159：读取os.time()；UPVALUE_6是直接阈值数值，
                            -- 与(now - state.alertAt)比较。达到阈值才更新alertAt并通知。
                            local now = os.time()
                            if now - state.alertAt >= (UPVALUE_6 or 0) then
                                state.alertAt = now
                                UPVALUE_7(string.format(
                                    "野外观测到黑名单玩家：%s（%d格）",
                                    actorName,
                                    distanceResult
                                ))
                            end

                            -- PC160-PC173：只有state.nextTryAt <= now才进入尝试窗口；
                            -- UPVALUE_8在PC164-PC165作为零参数函数调用，返回下一次尝试间隔。
                            -- 随后写入state.nextTryAt=now+间隔，并将noStoneWarned复位为false。
                            if state.nextTryAt <= now then
                                state.nextTryAt = now + UPVALUE_8()
                                state.noStoneWarned = false

                                -- PC174-PC192：确认构造“飞随机”提示并调用捕获回调；
                                -- 但寄存器复用和UPVALUE_10/UPVALUE_7的业务身份仍需继续映射。
                                -- 不再把未经证实的UPVALUE_9(actorName,distanceResult)当作道具选择API。
                                -- TODO：确认随机传送道具筛选、实际使用调用及其成功/失败分支。
                            end

                            -- PC193-PC213：另一路径使用UPVALUE_11作为时间间隔，
                            -- 更新nextTryAt；noStoneWarned为false时置true并发送一次“无随机传送石”提示。
                            -- 随后调用table.concat(UPVALUE_12(), "/")构造路径文本，
                            -- 再把该文本交给捕获的格式化/通知回调。具体业务身份待映射。
                        end
                    end
                end
            end
        end
    end
end
