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

父闭包捕获已由doInit_UI PC330-PC334闭合：UP[0]=MainLeftBottom模块表，UP[1]=PrintLog，UP[2]=独立计时器状态表，UP[3]=MainLeftBottom模块表（initTime/initSnapshot所在表）。
GUI构造函数的位置参数因融合指令尚未完全展开，保留TODO。
]]

local function Nested_FFFF00()
    local gui = GUI
    local sl = SL

    -- doInit_UI PC330-PC334的捕获顺序已核实。
    local moduleState = UP[0]       -- MainLeftBottom：resWin、screenW、screenH
    local printLog = UP[1]          -- PrintLog函数
    local timerState = UP[2]        -- 独立状态表：resTimer
    local initState = UP[3]         -- MainLeftBottom：initTimeStr、initSnapshot

    -- 已存在窗口：执行关闭路径。
    if gui.Win_IsNotNull(moduleState.resWin) then
        printLog("关闭资源信息窗口")

        if timerState.resTimer then
            sl:UnSchedule(timerState.resTimer)
            timerState.resTimer = nil
        end

        gui:Win_Close(moduleState.resWin)
        return
    end

    -- 创建资源统计窗口。
    local resWin = gui:Win_Create(
        "resWin",
        0, 0,
        moduleState.screenW,
        moduleState.screenH,
        false, true, true, true, true,
        999
    )
    moduleState.resWin = resWin

    local rootLayout = gui:Layout_Create(
        resWin,
        "closeResWin",
        0, 0,
        moduleState.screenW,
        moduleState.screenH,
        true
    )

    gui:setTouchEnabled(rootLayout, true)
    -- child4（Nested_UnSchedule）捕获[printLog,timerState,moduleState]；
    -- 点击空白时输出“点击空白,关闭资源信息窗口”，取消resTimer、清句柄并关闭resWin。
    gui:addOnClickEvent(rootLayout, Nested_UnSchedule)

    -- 列表容器。
    local screenW = moduleState.screenW
    local screenH = moduleState.screenH
    local resList = gui:ListView_Create(
        resWin,
        "resList",
        (screenW - 1) / 2,
        screenH / 2,
        screenW * 0.6,
        screenH * 0.6,
        1.0
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
        titleCell, "titleText", 0.5, 15, 20, "#FF0000", "资源统计"
    )

    -- 初始时间区域。
    local initTimeCell = gui:Layout_Create(
        resList, "initTimeCell", 0, 0, 1, 30
    )
    local initTimeText = gui:Text_Create(
        initTimeCell, "initTimeText", 0.5, 15, 20, "#00FF00",
        "初始时间:" .. tostring(initState.initTimeStr or "--")
    )

    -- 当前时间区域。
    local curTimeCell = gui:Layout_Create(
        resList, "curTimeCell", 0, 0, 1, 30
    )
    local curTimeText = gui:Text_Create(
        curTimeCell, "curTimeText", 0.5, 15, 20, "#00FF00",
        "当前时间:--"
    )

    -- 历时区域。
    local durTimeCell = gui:Layout_Create(
        resList, "durTimeCell", 0, 0, 1, 30
    )
    local durTimeText = gui:Text_Create(
        durTimeCell, "durTimeText", 0.5, 15, 20, "#00FF00", "历时:--"
    )

    -- 说明区域。
    local noteCell = gui:Layout_Create(
        resList, "noteCell", 0, 0, 1, 30
    )
    local noteText = gui:Text_Create(
        noteCell, "noteText", 0.5, 15, 20, "#FFFF00",
        "（括号内数量为非绑定资源的收益）"
    )

    -- 数值格式化子闭包：child0，父级PC118创建，零捕获。
    local formatNumber = Nested_Helper_2

    -- 资源统计行创建子闭包：child2，PC265捕获[ListView, screenW*0.6]；
    -- 父函数用(names, 2, "money"/"item")两次调用。
    local updateResourceRows = Nested_FFFFFF

    -- 时间/资源刷新子闭包：child3，PC300捕获10项，顺序为：
    -- [moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,
    --  updateResourceRows,formatNumber,updateResourceRows,Nested_string]。
    -- Nested_string（child1）是BAG_DATA物品名称/索引查询辅助闭包。
    -- 父函数在PC311-PC312立即调用，随后PC313-PC319由父函数安排1.0秒周期调度。
    local refreshResourceStatistics = Nested_Helper_3

    -- PC268-PC281的两组准确名称数组。
    local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
    local resourceNames = {
        "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
    }

    local moneyProxy = global.Facade:retrieveProxy(
        global.ProxyTable.MoneyProxy
    )

    -- PC282-PC291：分别建立货币行与其他资源行，第二参数均为2。
    updateResourceRows(moneyNames, 2, "money")
    updateResourceRows(resourceNames, 2, "item")

    -- PC300创建Nested_Helper_3刷新闭包；PC311-PC312立即调用一次。
    -- 刷新闭包检查窗口有效性，更新当前时间/历时和资源文本。
    -- 随后父函数PC313-PC319调用SL:Schedule(callback,1.0)，并将返回句柄写入timerState.resTimer。
    refreshResourceStatistics()
    timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)

    return
end

return Nested_FFFF00
