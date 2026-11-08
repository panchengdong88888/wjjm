-- MainLeftBottom(2).lua - short function drafts, batch 14
-- Status: readable first-pass reconstruction. Static review pending; not runtime-validated.
-- Canonical zero-based paths are shown alongside legacy one-based labels.
-- Generic upvalue parameter names are deliberate where closure slots are not fully named.

-- root.children[36] / legacy root/37 / GetAvailableStoragePage
-- The VM body queries NPCStorageProxy:GetMaxPage(), scans page data, and uses
-- GUIDefine.STORAGE_PER_PAGE_MAX / MMO.NPC_STORAGE_MAX_PAGE as fallback bounds.
local function make_GetAvailableStoragePage(notify)
    return function()
        local storageProxy = NPCStorageProxy
        if not storageProxy then
            notify("仓库代理未初始化")
            return
        end

        local maxPage = storageProxy:GetMaxPage()
        local page = 1
        local emptyPages = 0

        -- Draft interpretation of the VM numeric loop:
        -- query pages in order and count empty page payloads.
        while page <= maxPage do
            local pageData = storageProxy:GetStorageDataByPage(page)
            if not pageData or #pageData == 0 then
                emptyPages = emptyPages + 1
            end

            -- The bytecode also checks configured per-page capacity and the
            -- MMO maximum-page setting before deciding the returned page bound.
            page = page + 1
        end

        local perPageMax = GUIDefine and GUIDefine.STORAGE_PER_PAGE_MAX
        local npcMaxPage = global and global.MMO and global.MMO.NPC_STORAGE_MAX_PAGE
        local openSize = storageProxy:GetOpenSize()

        -- Approximate capacity-derived bound. The exact branch/return selection
        -- around PC22-PC50 remains flagged for static review.
        if perPageMax and npcMaxPage and openSize then
            local capacityPages = math.floor((openSize - 1) / perPageMax) + 1
            if capacityPages < maxPage then
                maxPage = capacityPages
            end
            if maxPage > npcMaxPage then
                maxPage = npcMaxPage
            end
        end

        return maxPage
    end
end

-- root.children[37] / legacy root/38 / DestroyUI
-- UP[0] and UP[1] are captured state objects; retain neutral names until parent
-- initializer mapping is reviewed.
local function make_DestroyUI(uiState, buttonMap)
    return function()
        uiState.isHidden = false

        local timer = uiState.resTimer
        if timer then
            SL:UnSchedule(timer)
            uiState.resTimer = nil
        end

        uiState.resWin = nil
        GUI:Win_CloseAll()

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end

-- root.children[40] / legacy root/41 / ShowHideAllButtons
-- UP[0] is the shared state object; UP[1]/UP[2] are captured tables used for
-- the two visibility passes. Exact source identifiers remain unresolved.
local function make_ShowHideAllButtons(uiState, buttonMap, secondaryButtonMap)
    return function()
        if uiState.rewardTimer then
            SL:UnSchedule(uiState.rewardTimer)
            uiState.rewardTimer = nil
        end

        if uiState.cruiseTimer then
            SL:UnSchedule(uiState.cruiseTimer)
            uiState.cruiseTimer = nil
        end

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end

        if uiState.hidebut then
            for key in pairs(secondaryButtonMap) do
                GUI:setVisible(secondaryButtonMap[key], false)
            end
            uiState.hidebut = nil
        end
    end
end

-- Review notes:
-- * GetAvailableStoragePage's branch structure is not fully resolved here. The
--   loop/capacity expression is a readable provisional model, not a proven
--   source-equivalent algorithm. Do not count it as statically complete.
-- * DestroyUI's instruction order is clear: clear isHidden; cancel resTimer if
--   present; nil resTimer/resWin; GUI:Win_CloseAll(); iterate UP[1] and set
--   each mapped control visible.
-- * ShowHideAllButtons cancels rewardTimer and cruiseTimer independently,
--   restores the UP[1] control map, then conditionally hides controls in UP[2]
--   when hidebut is truthy and clears hidebut.
-- * These three functions are draft-only and have not been runtime-tested.
