--[[
函数：Nested_FFFF00
所属函数：doInit_UI
原型索引：57
规范路径：root.children[42].children[3]
legacy路径：root/43/4
物理指令：320
状态：首版普通 Lua 草稿；未运行时验证。

本函数是资源统计窗口的创建/关闭入口。恢复依据包括：
- GUI.Win_IsNotNull(resWin) 的窗口存在性分支；
- 关闭提示、resTimer取消、GUI.Win_Close；
- Win_Create、Layout_Create、ListView_Create；
- 标题、初始时间、当前时间、历时和备注等UI节点；
- 四类货币/资源配置表；
- MoneyProxy、Nested_FFFFFF、Nested_Helper_3 及 Schedule。

四个父闭包捕获暂以 UPVALUE_0..3 表示，不擅自映射业务名称。
GUI构造函数的位置参数因融合指令尚未完全展开，保留TODO。
]]

local function Nested_FFFF00()
    local gui = GUI
    local sl = SL

    -- 捕获对象：创建窗口/状态对象/计时器等，真实业务身份待闭包数据流复核。
    local UPVALUE_0 = UP[0]
    local UPVALUE_1 = UP[1]
    local UPVALUE_2 = UP[2]
    local UPVALUE_3 = UP[3]

    -- 已存在窗口：执行关闭路径。
    if gui.Win_IsNotNull(UPVALUE_0.resWin) then
        UPVALUE_1("关闭资源信息窗口")

        if UPVALUE_2.resTimer then
            sl:UnSchedule(UPVALUE_2.resTimer)
            UPVALUE_2.resTimer = nil
        end

        gui:Win_Close(UPVALUE_0.resWin)
        return
    end

    -- 创建资源统计窗口。
    local resWin = gui:Win_Create(
        "resWin",
        0, 0,
        global.screenW,
        global.screenH,
        999
    )
    UPVALUE_0.resWin = resWin

    local rootLayout = gui:Layout_Create(
        resWin,
        "closeResWin",
        0, 0,
        global.screenW,
        global.screenH
    )

    gui:setTouchEnabled(rootLayout, true)
    gui:addOnClickEvent(rootLayout, Nested_UnSchedule)

    -- 列表容器。
    local resList = gui:ListView_Create(
        resWin,
        "resList",
        -- TODO: 精确位置、宽高和方向参数待融合载荷复核
        0, 0,
        global.screenW,
        global.screenH,
        1
    )
    gui:setAnchorPoint(resList, 0, 0.5)
    gui:ListView_setBackGroundColorType(resList, 1)
    gui:ListView_setBackGroundColor(resList, "#CEB5F7")
    gui:ListView_setBackGroundColorOpacity(resList, 255)

    -- 标题区域。
    local titleCell = gui:Layout_Create(
        resList, "titleCell", 0, 0, 1, 30
    )
    local titleText = gui:Text_Create(
        titleCell, "titleText", 1, 15, 20, "#FF0000", "资源统计"
    )

    -- 初始时间区域。
    local initTimeCell = gui:Layout_Create(
        resList, "initTimeCell", 0, 0, 1, 30
    )
    local initTimeText = gui:Text_Create(
        initTimeCell, "initTimeText", 1, 15, 20, "#00FF00",
        "初始时间:" .. tostring(UPVALUE_3.initTimeStr or "--")
    )

    -- 当前时间区域。
    local curTimeCell = gui:Layout_Create(
        resList, "curTimeCell", 0, 0, 1, 30
    )
    local curTimeText = gui:Text_Create(
        curTimeCell, "curTimeText", 1, 15, 20, "#00FF00",
        "当前时间:--"
    )

    -- 历时区域。
    local durTimeCell = gui:Layout_Create(
        resList, "durTimeCell", 0, 0, 1, 30
    )
    local durTimeText = gui:Text_Create(
        durTimeCell, "durTimeText", 1, 15, 20, "#00FF00", "历时:--"
    )

    -- 说明区域。
    local noteCell = gui:Layout_Create(
        resList, "noteCell", 0, 0, 1, 30
    )
    local noteText = gui:Text_Create(
        noteCell, "noteText", 1, 15, 20, "#FFFF00",
        "（括号内数量为非绑定资源的收益）"
    )

    -- 数值格式化子闭包：child0，父级PC118创建，零捕获。
    local formatNumber = Nested_Helper_2

    -- 资源统计更新子闭包：child2，父级PC265创建，捕获2个值。
    local updateResourceRows = Nested_FFFFFF

    -- 时间与资源刷新子闭包：child3，父级PC300创建，捕获10个值。
    local refreshResourceStatistics = Nested_Helper_3

    -- 四类货币配置；原型常量依次出现元宝/绑定元宝/灵符/绑定灵符。
    local moneyGroups = {
        { "元宝", "绑定元宝", 2, "money" },
        { "灵符", "绑定灵符", 2, "item" },
    }

    -- 其他资源配置；原型常量依次出现声望卷、悟道茶、洗髓丹、
    -- 转生水晶、恶魔令牌、血龙宝珠。
    local itemGroups = {
        { "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠" },
    }

    local moneyProxy = global.Facade:retrieveProxy(
        global.ProxyTable.MoneyProxy
    )

    -- 最后创建周期刷新闭包并保存调度句柄。
    -- 1.0秒间隔由PC317常量确认；Schedule实参及返回句柄槽位仍待核验。
    local timer = sl:Schedule(
        1.0,
        refreshResourceStatistics
    )
    UPVALUE_2.resTimer = timer

    return resWin, resList, moneyProxy, formatNumber,
        updateResourceRows, moneyGroups, itemGroups
end

return Nested_FFFF00
