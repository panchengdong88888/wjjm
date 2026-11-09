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

父闭包捕获已按root闭包创建PC390-PC410、doInit_UI PC330-PC334及本函数实际UPvalue使用复核：Nested_FFFF00的UP[0]=doInit_UI UP[3]（MainLeftBottom UI状态表，含resWin/screenW/screenH），UP[1]=doInit_UI UP[0]（PrintLog），UP[2]=doInit_UI UP[2]（计时器状态表，doInit_UI中读取cruiseTimer，本函数写入resTimer），UP[3]=doInit_UI UP[1]（initTime/initTimeStr/initSnapshot状态表）。
GUI构造函数的位置参数因融合指令尚未完全展开，保留TODO。
]]

local function Nested_FFFF00()
    local gui = GUI
    local sl = SL

    -- doInit_UI PC330-PC334的捕获描述依次为父UP[3],UP[0],UP[2],UP[1]。
    -- 父UP[0]在PC1-PC3作为PrintLog调用；父UP[1]在PC19-PC58保存initTime/initTimeStr/initSnapshot；
    -- 父UP[2]在PC152-PC166读取cruiseTimer；父UP[3]在PC379-PC414操作hidebut等UI状态。
    local moduleState = UP[0]       -- doInit_UI UP[3]：MainLeftBottom UI状态表
    local printLog = UP[1]          -- doInit_UI UP[0]：PrintLog函数
    local timerState = UP[2]        -- doInit_UI UP[2]：计时器状态表（cruiseTimer/resTimer）
    local initState = UP[3]         -- doInit_UI UP[1]：initTime/initTimeStr/initSnapshot状态表

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
        nil, 999
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
    -- child4（Nested_UnSchedule）在父PC68-PC71依次捕获UP[1],UP[2],UP[0]，
    -- 即[printLog,timerState,moduleState]；点击空白时通知、取消resTimer、清句柄并关闭resWin。
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
        resList, "titleCell", 0, 0, 1, 30, 1
    )
    local titleText = gui:Text_Create(
        titleCell, "titleText", 0.5, 15, 20, "#FF0000", "资源统计"
    )
    gui:setAnchorPoint(titleText, 0.5, 0.5)

    -- 初始时间区域。
    local initTimeCell = gui:Layout_Create(
        resList, "initTimeCell", 0, 0, 1, 30, 1
    )
    local initTimeText = gui:Text_Create(
        initTimeCell, "initTimeText", 0.5, 15, 20, "#00FF00",
        "初始时间:" .. tostring(initState.initTimeStr or "--")
    )
    gui:setAnchorPoint(initTimeText, 0.5, 0.5)

    -- 当前时间区域。
    local curTimeCell = gui:Layout_Create(
        resList, "curTimeCell", 0, 0, 1, 30, 1
    )
    local curTimeText = gui:Text_Create(
        curTimeCell, "curTimeText", 0.5, 15, 20, "#00FF00",
        "当前时间:--"
    )
    gui:setAnchorPoint(curTimeText, 0.5, 0.5)

    -- 历时区域。
    local durTimeCell = gui:Layout_Create(
        resList, "durTimeCell", 0, 0, 1, 30, 1
    )
    local durTimeText = gui:Text_Create(
        durTimeCell, "durTimeText", 0.5, 15, 20, "#00FF00", "历时:--"
    )
    gui:setAnchorPoint(durTimeText, 0.5, 0.5)

    -- 说明区域。
    local noteCell = gui:Layout_Create(
        resList, "noteCell", 0, 0, 1, 30, 1
    )
    local noteText = gui:Text_Create(
        noteCell, "noteText", 0.5, 15, 20, "#FFFF00",
        "（括号内数量为非绑定资源的收益）"
    )
    gui:setAnchorPoint(noteText, 0.5, 0.5)

    -- 数值格式化子闭包：child0，父级PC118创建，零捕获。
    local formatNumber = Nested_Helper_2

    -- 资源统计行创建子闭包：child2，PC265捕获[ListView, screenW*0.6]；
    -- 参数(rowNames,2,rowType)中的rowType分别为'money'/'item'，参与cell名称；
    -- cell名后缀为ceil(15/2)，Text名按列索引生成；返回资源名称->Text节点映射表。
    local updateResourceRows = Nested_FFFFFF

    -- 时间/资源刷新子闭包：child3，PC300捕获10项，顺序为：
    -- [moduleState,timerState,curTimeText,durTimeText,initState,MoneyProxy,
    --  moneyRows,formatNumber,itemRows,Nested_string]。
    -- Nested_string（child1）从BAG_DATA按名称查找背包物品并读取绑定/叠加信息。
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
    local moneyRows = updateResourceRows(moneyNames, 2, "money")
    local itemRows = updateResourceRows(resourceNames, 2, "item")

    -- PC300创建Nested_Helper_3刷新闭包；PC311-PC312立即调用一次。
    -- 刷新闭包检查窗口有效性，更新当前时间/历时和资源文本。
    -- 随后父函数PC313-PC319调用SL:Schedule(callback,1.0)，并将返回句柄写入timerState.resTimer。
    refreshResourceStatistics()
    timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)

    return
end



--[[
检查点94补充：PC139-146、PC173-180、PC201-208、PC229-236、PC257-264均执行对应Text节点的setAnchorPoint(node,0.5,0.5)；原草稿漏掉这些调用，现已补齐。
PC125/153/187/215/243等Layout_Create实参序列均包含末尾数值1，原草稿五处时间/标题/备注Layout调用漏掉该参数，现已补齐。该参数的GUI宿主语义仍未确认。
]]

return Nested_FFFF00


--[[
检查点96补充：Nested_FFFF00 PC38-PC44准备Win_Create实参时，五个布尔值依次为false,true,true,true,true；PC43的OP_125明确清空T[13]，即在最后的999参数前保留一个nil实参槽。故Win_Create调用显式补入nil，不把空槽丢弃。
]]
