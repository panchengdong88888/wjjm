-- MainLeftBottom(2).lua VM recovery candidate
-- Prototype: root.children[45] (legacy root/46)
-- 417 physical VM instructions; 41 constants; no child prototypes.
--
-- STATUS: first-pass ordinary Lua draft. This is NOT original author source,
-- NOT a complete CFG proof, and NOT runtime validated.
-- UPVALUE_n names below are zero-based capture-slot placeholders. Their exact
-- parent-scope declarations and most business identities remain provisional.
--
-- Confirmed capture identities:
--   UPVALUE_9  = GetOwnerID
--   UPVALUE_17 = GetOwnerIDText
--   UPVALUE_18 = root.children[29] alive-like wrapper; truthy means actor alive
--   UPVALUE_19 = GetOwnerDescription(actor, mainPlayerID), returns two values
--   UPVALUE_21 = configuration table with ATTACK_WAIT_TIME

local function MainLoop()
    if not UPVALUE_0 then
        return
    end

    -- White-list map: leave the gather state machine and reset its data.
    if IsInWhitelistMap() then
        if UPVALUE_1 ~= UPVALUE_2.IDLE then
            UPVALUE_3("在白名单地图, 停止引怪")
            UPVALUE_4(UPVALUE_2.IDLE)
            UPVALUE_5()
        end
        return
    end

    --------------------------------------------------------------------------
    -- IDLE: collect candidate monster IDs.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.IDLE then
        UPVALUE_3("扫描怪物中")

        local candidates = UPVALUE_7()
        if not candidates or #candidates == 0 then
            UPVALUE_3("视野内没有可攻击怪物")
            return
        end

        UPVALUE_8 = {}
        local mainPlayerID = UPVALUE_6()

        for _, actor in ipairs(candidates) do
            -- Preserve the captured GetOwnerID predicate and its truth value.
            if not UPVALUE_9(actor, mainPlayerID) then
                table.insert(UPVALUE_8, actor:GetID())
            end
        end

        if #UPVALUE_8 == 0 then
            UPVALUE_3("没有可攻击的怪物")
            return
        end

        UPVALUE_10 = 1
        UPVALUE_11 = 0
        UPVALUE_3(string.format("开始引怪，目标数量: %d", #UPVALUE_8))
        UPVALUE_4(UPVALUE_2.GATHERING)
        return
    end

    --------------------------------------------------------------------------
    -- GATHERING: resume a pending owner wait, then scan the target list.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.GATHERING then
        UPVALUE_3("引怪中")

        if UPVALUE_12 then
            local now = os.time()

            if now < UPVALUE_13 then
                UPVALUE_3(string.format(
                    "等待归属变更中: %s (还剩 %d 秒)",
                    UPVALUE_14,
                    UPVALUE_13 - now
                ))
                return
            end

            -- UPVALUE_15 is an actor-map/provider helper. Its true identity and
            -- the exact meaning of this optional argument are still unknown.
            local actorMap = UPVALUE_15(UPVALUE_12)
            local actor = actorMap and actorMap[UPVALUE_16]
            local mainPlayerID = UPVALUE_6()

            if actor and UPVALUE_17(actor, mainPlayerID) then
                UPVALUE_3(string.format(
                    "怪物 %s 归属已变更为自己",
                    UPVALUE_14
                ))
            else
                UPVALUE_3(string.format(
                    "怪物 %s 归属未变更或已离开视野",
                    UPVALUE_14
                ))
            end

            UPVALUE_12 = false
            UPVALUE_13 = 0
            UPVALUE_16 = 0
            UPVALUE_14 = ""
            UPVALUE_10 = UPVALUE_10 + 1
        end

        local actorMap = UPVALUE_15()
        local mainPlayerID = UPVALUE_6()

        for index = UPVALUE_10, #UPVALUE_8 do
            local targetID = UPVALUE_8[index]
            local actor = actorMap and actorMap[targetID]

            if not actor then
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 不在视野内，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10 = index + 1

            elseif not UPVALUE_18(actor) then
                -- This wrapper is truthy for a living actor in this call path.
                UPVALUE_3(string.format(
                    "怪物 %d (ID: %s) 已死亡，跳过",
                    index,
                    tostring(targetID)
                ))
                UPVALUE_10 = index + 1

            else
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                local ownerID, ownerDescription =
                    UPVALUE_19(actor, mainPlayerID)

                if UPVALUE_9(actor, mainPlayerID) then
                    UPVALUE_3(string.format(
                        "怪物 %d (%s, ID: %s) 归属属于其他玩家(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    UPVALUE_10 = index + 1

                elseif UPVALUE_17(actor, mainPlayerID) then
                    UPVALUE_3(string.format(
                        "怪物 %d (%s, ID: %s) 归属已属于自己(归属ID: %s, %s)，跳过",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerID),
                        tostring(ownerDescription)
                    ))
                    UPVALUE_11 = UPVALUE_11 + 1
                    UPVALUE_10 = index + 1

                else
                    UPVALUE_3(string.format(
                        "怪物 %s 归属未变更或已离开视野",
                        monsterName
                    ))

                    -- UPVALUE_20 accepts a target ID. Do not rename this helper
                    -- as SetTargetID/PickUpItems before its producer is proven.
                    local accepted = UPVALUE_20(targetID)

                    if accepted then
                        UPVALUE_12 = true
                        UPVALUE_13 = os.time()
                            + UPVALUE_21.ATTACK_WAIT_TIME
                        UPVALUE_16 = targetID
                        UPVALUE_14 = monsterName

                        UPVALUE_3(string.format(
                            "开始等待 %s 归属变更 (等待 %d 秒)",
                            monsterName,
                            UPVALUE_21.ATTACK_WAIT_TIME
                        ))
                        return
                    end

                    UPVALUE_3(string.format(
                        "锁定怪物 %s 失败",
                        monsterName
                    ))
                    UPVALUE_10 = index + 1
                    return
                end
            end
        end

        -- PC 313-343 aggregate/loop-bound logic is represented conservatively.
        -- Its exact counter and termination dataflow remains to be reviewed.
        if UPVALUE_11 >= #UPVALUE_8 then
            UPVALUE_3("所有怪物归属已获取，切换到攻击状态")
            UPVALUE_10 = 1
            UPVALUE_4(UPVALUE_2.ATTACKING)
            return
        end

        if UPVALUE_10 > #UPVALUE_8 then
            UPVALUE_3("怪物列表处理完毕但未全部获取归属，重新扫描")
            UPVALUE_4(UPVALUE_2.IDLE)
            UPVALUE_5()
            return
        end

        return
    end

    --------------------------------------------------------------------------
    -- ATTACKING: locate the next surviving actor by its stored target ID.
    --------------------------------------------------------------------------
    if UPVALUE_1 == UPVALUE_2.ATTACKING then
        UPVALUE_3("攻击中")

        local actorMap = UPVALUE_15()

        for index = UPVALUE_10, #UPVALUE_8 do
            local targetID = UPVALUE_8[index]
            local actor = actorMap and actorMap[targetID]

            if actor and UPVALUE_18(actor) then
                local monsterName = actor:GetName()
                if not monsterName then
                    monsterName = "未知怪物"
                end

                UPVALUE_3(string.format(
                    "攻击怪物 %d: %s (ID: %s)",
                    index,
                    monsterName,
                    tostring(targetID)
                ))

                -- Same unresolved one-argument target-action helper.
                UPVALUE_20(targetID)
                return
            end

            UPVALUE_3(string.format(
                "怪物 %d (ID: %s) 已死亡或离开视野",
                index,
                tostring(targetID)
            ))
            UPVALUE_10 = index + 1
        end

        UPVALUE_3("所有目标怪物已死亡或离开视野，切换到空闲状态")
        UPVALUE_4(UPVALUE_2.IDLE)
        UPVALUE_5()
        return
    end
end

return MainLoop
