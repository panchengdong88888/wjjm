-- root.children[46] / legacy root/47
-- Reconstruction name: DiuItems
-- 169 physical VM instructions; one nested keyword-matcher prototype.
-- Status: first-pass readable Lua draft from the statically closed control/data flow.
-- Not original source text; not runtime-validated. Names such as state/candidates are
-- readable reconstruction names, not recovered original local-variable identifiers.

local function DiuItems()
    local MAX_GROUND_ITEMS = 35
    local state = UPVALUE_MODULE_STATE -- UP[0]; contains isDiuing
    local ShowLocalNoticeByType = UPVALUE_SHOW_NOTICE -- UP[1]

    -- PC 2-8: re-entry guard. A caller that did not acquire the flag must not clear it.
    if state.isDiuing then
        return
    end
    state.isDiuing = true

    -- PC 9-13: GetDroppedItems returns (items, count); only the second result is used.
    local _, groundItemCount = GetDroppedItems()
    groundItemCount = groundItemCount or 0

    -- PC 14-26: reject an already-overfull ground-item field.
    if MAX_GROUND_ITEMS < groundItemCount then
        ShowLocalNoticeByType(
            "地面物品(" .. groundItemCount .. ")超过上限(" .. MAX_GROUND_ITEMS .. ")"
        )
        state.isDiuing = false
        return
    end

    -- PC 27-35: obtain the current bag data.
    local bagData = SL:GetMetaValue("BAG_DATA")
    if not bagData then
        state.isDiuing = false
        return
    end

    -- PC 36-68: the VM also constructs a keyword table and its nested matcher closure.
    -- However, the only matcher call is in PC 91-95, which the constant-true
    -- branch at PC 89-90 skips on the observed path. The unused construction is
    -- therefore omitted from this readable draft rather than inventing an effect.

    -- PC 69-114: collect unbound, named, indexed bag items.
    local candidates = {}
    for _, item in pairs(bagData) do
        if item and item.Name and item.MakeIndex then
            if not SL:GetMetaValue("ITEM_IS_BIND", item) then
                -- PC 99-112:
                candidates[#candidates + 1] = {
                    makeIndex = item.MakeIndex,
                    count = item.OverLap or 1,
                    name = item.Name,
                }
            end
        end
    end

    -- PC 115-123: empty candidate list has its own notice/cleanup path.
    if #candidates == 0 then
        ShowLocalNoticeByType("背包无可丢弃物品")
        state.isDiuing = false
        return
    end

    -- PC 124-160: send one discard message per candidate until the ground cap.
    local sentCount = 0
    for _, candidate in ipairs(candidates) do
        if MAX_GROUND_ITEMS <= groundItemCount then
            -- PC 131-137: this text uses the fixed limit (35), not the live count.
            ShowLocalNoticeByType("地面物品已满" .. MAX_GROUND_ITEMS .. "件，停止丢弃")
            break
        end

        -- PC 138-142: per-item notice.
        ShowLocalNoticeByType("丢: " .. candidate.name)

        -- PC 143-156: LuaSendMsg packet arguments, in exact recovered order.
        LuaSendMsg(
            global.MsgType.MSG_CS_MAP_ITEM_DISCARD,
            candidate.makeIndex,
            candidate.count,
            0,
            0,
            candidate.name,
            string.len(candidate.name)
        )

        -- PC 157-158: count sends and advance the local ground-item count.
        sentCount = sentCount + 1
        groundItemCount = groundItemCount + 1
    end

    -- PC 161-169: report message-send count, clear the re-entry flag, return.
    ShowLocalNoticeByType("共丢弃 " .. sentCount .. " 件物品")
    state.isDiuing = false
end

-- Static reconstruction notes:
-- * UP[0] is the module state table; UP[1] is ShowLocalNoticeByType.
-- * No pcall/xpcall/finally cleanup exists in this prototype. If an external
--   helper/API raises, isDiuing may remain true, matching the visible bytecode.
-- * The VM's pairs iterator checks the first return (key) for termination and
--   takes the second return as item. The ipairs iterator checks index for nil.
-- * Runtime behavior and exact external API side effects remain unverified.
