--[[
    11.16 邮件维护逻辑单元测试（7.50）
    用途：独立验证 7.49 已闭合的 root/52/23 槽1-54邮件分支优先级。
    重要：这是纯 Lua 模拟测试，不是游戏模块，不会调用真实服务器接口。
    不得替换/覆盖 11.16/测试管理/当前测试/唯一正式版.lua。
    执行方式：使用 Lua 5.1+ 运行本文件；全部断言通过后输出 PASS。
]]

local function makeMockSL(mailList, haveDelete)
    local calls = {}
    local mock = {}

    function mock:GetMetaValue(key)
        if key == "MAIL_LIST" then
            return mailList
        elseif key == "MAIL_HAVE_DEL_ITEM" then
            return haveDelete
        end
        error("unexpected GetMetaValue key: " .. tostring(key))
    end

    function mock:RequestMailList()
        calls[#calls + 1] = "RequestMailList"
    end

    function mock:RequestGetAllMailItems()
        calls[#calls + 1] = "RequestGetAllMailItems"
    end

    function mock:RequestDelReadMail()
        calls[#calls + 1] = "RequestDelReadMail"
    end

    return mock, calls
end

-- 按 7.49 已还原的原版顺序独立实现：
-- 列表不存在/为空 -> 请求列表；
-- 非空 -> 找第一封 sItem 非空且 btRecvFlag==0 的邮件；
-- 找到 -> 自动领取并结束本轮；
-- 未找到 -> 仅在 MAIL_HAVE_DEL_ITEM 为真时删除已读邮件并刷新列表。
local function RunMailMaintenance_11_16_UnitTest(SL)
    local mailList = SL:GetMetaValue("MAIL_LIST")

    if not mailList then
        SL:RequestMailList()
        return
    end

    local firstKey = next(mailList)
    if firstKey == nil then
        SL:RequestMailList()
        return
    end

    local foundClaimable = false
    for _, mail in pairs(mailList) do
        if mail and mail.sItem and #mail.sItem > 0
            and mail.btRecvFlag == 0 then
            foundClaimable = true
            break
        end
    end

    if foundClaimable then
        SL:RequestGetAllMailItems()
        return
    end

    if SL:GetMetaValue("MAIL_HAVE_DEL_ITEM") then
        SL:RequestDelReadMail()
        SL:RequestMailList()
    end
end

local function runCase(name, mailList, haveDelete, expected)
    local mock, calls = makeMockSL(mailList, haveDelete)
    RunMailMaintenance_11_16_UnitTest(mock)

    assert(#calls == #expected,
        name .. ": call count mismatch; got " .. #calls .. ", expected " .. #expected)

    for i = 1, #expected do
        assert(calls[i] == expected[i],
            name .. ": call[" .. i .. "] got " .. tostring(calls[i])
            .. ", expected " .. tostring(expected[i]))
    end

    print("[PASS] " .. name)
end

runCase("MAIL_LIST=nil：只请求列表", nil, true, {
    "RequestMailList"
})

runCase("MAIL_LIST为空表：只请求列表", {}, true, {
    "RequestMailList"
})

runCase("存在可领取邮件：领取优先并跳过删除", {
    { sItem = "附件", btRecvFlag = 0 }
}, true, {
    "RequestGetAllMailItems"
})

runCase("sItem缺失：不领取，按删除标志处理", {
    { btRecvFlag = 0 }
}, true, {
    "RequestDelReadMail", "RequestMailList"
})

runCase("sItem为空：不领取，按删除标志处理", {
    { sItem = "", btRecvFlag = 0 }
}, true, {
    "RequestDelReadMail", "RequestMailList"
})

runCase("附件已领取：不领取，按删除标志处理", {
    { sItem = "附件", btRecvFlag = 1 }
}, true, {
    "RequestDelReadMail", "RequestMailList"
})

runCase("无可领取邮件且无删除标志：不发送请求", {
    { sItem = "附件", btRecvFlag = 1 }
}, false, {})

runCase("多封邮件中后续项可领取：仍只触发自动领取", {
    { sItem = "", btRecvFlag = 0 },
    { sItem = "后续附件", btRecvFlag = 0 }
}, true, {
    "RequestGetAllMailItems"
})

print("邮件维护逻辑单元测试：8/8 PASS")
