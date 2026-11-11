-- Small helper batch 2: readable static Lua reconstructions.
-- No target-runtime validation has been performed.

-- root.children[4] / legacy root/5 / GetDroppedItems (8 instructions)
-- The method returns both values unchanged; callers decide which result to use.
local function GetDroppedItems()
    return global.dropItemManager:FindDropItemInCurrViewFieldAll()
end

-- root.children[20] / legacy root/21 / ShowLocalNoticeByType (15 instructions)
-- The single upvalue is represented as screenState; its exact original local
-- identifier is not recovered. The helper builds a notice record and forwards
-- that one record to SL.ShowLocalNoticeByType.
local function make_ShowLocalNoticeByType(capturedScreenObject)
    return function ShowLocalNoticeByType(message)
        local notice = {
            Type = 10,
            Msg = message,
            FColor = 249,
            BColor = 0,
            X = 5,
            Y = capturedScreenObject.screenH - 50,
        }

        SL.ShowLocalNoticeByType(notice)
    end
end

-- Capture proof: root initializer creates root.children[20] at root PC46;
-- the immediately following OP_387 capture descriptor selects parent T[0].
-- The object identity is therefore represented as capturedScreenObject; its
-- screenH field and use in Y=screenH-50 are directly observed in the child.
