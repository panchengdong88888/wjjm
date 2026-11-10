-- MainLeftBottom(2).lua - short function drafts, batch 14
-- Status: readable first-pass reconstruction. Static review pending; not runtime-validated.
-- Canonical zero-based paths are shown alongside legacy one-based labels.
-- Generic upvalue parameter names are deliberate where closure slots are not fully named.

-- root.children[36] / legacy root/37 / GetAvailableStoragePage
-- 51条指令；1项捕获：root PC68捕获父root T[4]，此处按用途命名为notify。
-- 检查点190：PC1-PC51完整静态复核；未运行时验证。
local function make_GetAvailableStoragePage(notify)
    return function GetAvailableStoragePage()
        local storageProxy = NPCStorageProxy
        if not storageProxy then
            notify("仓库代理未初始化")
            return
        end

        local maxPage = storageProxy:GetMaxPage()

        -- PC15-PC48：升序扫描每一页，返回第一个仍有可用格子的页码。
        for page = 1, maxPage do
            local pageData = storageProxy:GetStorageDataByPage(page)
            local currentCount = 0
            if pageData then
                currentCount = #pageData
            end

            -- 每轮均读取配置容量；配置为假值时回退MMO的单页容量常量。
            local pageCapacity = GUIDefine.STORAGE_PER_PAGE_MAX
            if not pageCapacity then
                pageCapacity = global.MMO.NPC_STORAGE_MAX_PAGE
            end

            local openSize = storageProxy:GetOpenSize()
            local remainingOpenSize =
                openSize - (page - 1) * pageCapacity

            -- PC39-PC41：单页上限=min(单页配置容量, 尚余开放格数)。
            local pageLimit = remainingOpenSize
            if pageCapacity < remainingOpenSize then
                pageLimit = pageCapacity
            end

            -- PC42-PC47：页上限必须大于0，且必须大于当前占用数；
            -- 命中后立即返回当前页码。
            if pageLimit > 0 and pageLimit > currentCount then
                return page
            end
        end

        -- PC49-PC51：遍历耗尽时无显式返回值（nil）。
        return
    end
end

-- root.children[37] / legacy root/38 / DestroyUI
-- Status: complete static reconstruction; not runtime-validated.
-- Captures: UP[0]=root T[0] UI state; UP[1]=root T[3] timer state;
-- UP[2]=root T[1] button map.
local function make_DestroyUI(uiState, timerState, buttonMap)
    return function()
        uiState.isHidden = false

        local timer = timerState.resTimer
        if timer then
            SL:UnSchedule(timer)
            timerState.resTimer = nil
        end

        uiState.resWin = nil
        GUI:Win_CloseAll()

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end
    end
end

-- root.children[40] / legacy root/41 / ShowHideAllButtons
-- Status: complete static reconstruction; not runtime-validated.
-- Captures: UP[0]=root T[3] timer state; UP[1]=root T[1] button map;
-- UP[2]=root T[0] UI state containing the single hidebut control.
local function make_ShowHideAllButtons(timerState, buttonMap, uiState)
    return function()
        if timerState.rewardTimer then
            SL:UnSchedule(timerState.rewardTimer)
            timerState.rewardTimer = nil
        end

        if timerState.cruiseTimer then
            SL:UnSchedule(timerState.cruiseTimer)
            timerState.cruiseTimer = nil
        end

        for key in pairs(buttonMap) do
            GUI:setVisible(buttonMap[key], true)
        end

        if uiState.hidebut then
            GUI:setVisible(uiState.hidebut, false)
            uiState.hidebut = nil
        end
    end
end

-- Review notes:
-- * GetAvailableStoragePage在检查点190已逐PC闭合：逐页取#pageData或0，按min(pageCapacity,openSize-(page-1)*pageCapacity)计算页上限，首个pageLimit>currentCount且pageLimit>0的页码立即返回；无可用页返回nil。
-- * DestroyUI's instruction order is clear: clear isHidden; cancel resTimer if
--   present; nil resTimer/resWin; GUI:Win_CloseAll(); iterate UP[1] and set
--   each mapped control visible.
-- * ShowHideAllButtons cancels rewardTimer and cruiseTimer independently,
--   restores the UP[1] control map, then conditionally hides controls in UP[2]
--   when hidebut is truthy and clears hidebut.
-- * DestroyUI与ShowHideAllButtons保持各自原有静态状态；GetAvailableStoragePage在检查点190升级为完整静态恢复。三者均未运行时验证。
