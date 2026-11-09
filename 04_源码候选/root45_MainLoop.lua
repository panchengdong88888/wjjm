-- MainLeftBottom(2).lua VM recovery candidate
-- Prototype: root.children[45] (legacy root/46)
-- 417 physical VM instructions; 41 constants; no child prototypes.
--
-- STATUS: first-pass ordinary Lua draft. This is NOT original author source,
-- NOT a complete CFG proof, and NOT runtime validated.
-- Confirmed parent-capture mapping (zero-based UPVALUE slots):
--   UPVALUE_0  = running flag (root T[18], InitGatherMonsters sets true,
--                StopGatherMonsters sets false)
--   UPVALUE_1  = current state cell (root T[14], initially stateConstants.IDLE)
--   UPVALUE_2  = state constants table (root T[13]: IDLE/GATHERING/ATTACKING)
--   UPVALUE_3  = PrintLog (root.children[16], root T[4])
--   UPVALUE_4  = FormatStateChange (root.children[8], root T[23])
--   UPVALUE_5  = ResetGatherMonsterData (root.children[26], root T[35])
--   UPVALUE_6  = GetMainPlayerID (root.children[39], root T[26])
--   UPVALUE_7  = FindMonsterCandidates (root.children[28], root T[34])
--   UPVALUE_8  = mutable target-ID array (root T[15], initially {})
--   UPVALUE_9  = GetOwnerID (root.children[38], root T[32])
--   UPVALUE_10 = current target-list cursor (root T[17], initially 0)
--   UPVALUE_11 = self-owned target counter (root T[16], initially 0)
--   UPVALUE_12 = pending owner-change flag (root T[19], initially false)
--   UPVALUE_13 = owner-change deadline (root T[20], initially 0)
--   UPVALUE_14 = pending monster name (root T[22], initially "")
--   UPVALUE_15 = FindMonsterInCurrViewField (root.children[14], root T[36])
--   UPVALUE_16 = pending target ID (root T[21], initially nil)
--   UPVALUE_17 = GetOwnerIDText (root.children[7], root T[31])
--   UPVALUE_18 = IsDie/alive wrapper (root.children[29], root T[30])
--   UPVALUE_19 = GetOwnerDescription (root.children[43], root T[33])
--   UPVALUE_20 = SetTargetID (root.children[35], root T[24])
--   UPVALUE_21 = configuration table (root T[8]: GATHER_THRESHOLD,
--                CHECK_INTERVAL, ATTACK_WAIT_TIME)
--
-- The 22 captured parent T-registers are ordered:
--   18,14,13,4,23,35,26,34,15,32,17,16,19,20,22,36,21,31,30,33,24,8.
-- The identities above are grounded in root closure descriptors, helper creation
-- sites, function-state records, and the root/19 + root/27 state-helper captures.

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
        if #candidates == 0 then
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

            -- Confirmed helper: FindMonsterInCurrViewField has no formal
            -- parameters and returns an ID-keyed actor map. This call site passes
            -- UPVALUE_12 as an extra argument; the helper does not read it.
            -- The VM call site supplies two register slots here; their values are not
            -- semantically consumed by the zero-parameter helper. Keep the
            -- recovered helper invocation itself argument-free in this draft.
            local actorMap = UPVALUE_15()
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

        -- PC159-PC160 passes UPVALUE_12 as one extra argument. The helper has
        -- no formal parameters and ignores it, but retain the call-site value.
        local actorMap = UPVALUE_15(UPVALUE_12)
        local mainPlayerID = UPVALUE_6()
        local allOwnersResolved = true -- PC161; PC263 clears this on an unowned target.

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
                    allOwnersResolved = false

                    -- PC264 stores the current index before attempting to lock;
                    -- PC310-PC311 advance it after either the success or failure path.
                    UPVALUE_10 = index
                    UPVALUE_3(string.format(
                        "锁定怪物 %d: %s (ID: %s, 归属: %s)",
                        index,
                        monsterName,
                        tostring(targetID),
                        tostring(ownerDescription)
                    ))

                    -- Confirmed helper: SetTargetID(targetID). It returns false
                    -- when Facade/PlayerInputProxy is unavailable; on success it
                    -- calls proxy:SetTargetID(targetID, global.MMO.SELETE_TARGET_TYPE_FIND).
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
                    else
                        UPVALUE_3(string.format(
                            "锁定怪物 %s 失败",
                            monsterName
                        ))
                    end

                    -- Both SetTargetID outcomes advance the cursor and let the
                    -- numeric for-loop continue; neither branch returns here.
                    UPVALUE_10 = index + 1
                end
            end
        end

        -- PC166 prepares the numeric loop counter (UPVALUE_10 - 1); PC313
        -- increments/tests it and repeats at PC167. The loop therefore visits
        -- UPVALUE_10..#UPVALUE_8. The R2 flag starts true at PC161 and is cleared
        -- at PC263 when an unowned target is encountered.
        if allOwnersResolved then
            if UPVALUE_10 > #UPVALUE_8 then
                UPVALUE_3("所有怪物归属已获取，切换到攻击状态")
                UPVALUE_10 = 1
                UPVALUE_4(UPVALUE_2.ATTACKING)
                return
            end
        elseif UPVALUE_10 > #UPVALUE_8 then
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
        -- PC354 initializes the no-living-target flag; PC359/405 form the
        -- numeric for-loop over UPVALUE_10..#UPVALUE_8.

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

                -- Confirmed SetTargetID(targetID); this branch ignores its
                -- boolean result and returns immediately after the call.
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
