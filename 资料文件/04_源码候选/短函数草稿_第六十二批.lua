--[[
函数：Nested_FFFF00
所属函数：doInit_UI
原型：root.children[42].children[3] / legacy root/43/4
物理指令：320；常量：72；子原型：5；vararg_flag=0
状态：普通Lua草稿（检查点188修订捕获工厂与子闭包实参）；未运行时验证。

捕获顺序（父doInit_UI PC330-PC334）：
  UP[0] = moduleState（doInit_UI UP[3]，MainLeftBottom UI状态表）
  UP[1] = printLog（doInit_UI UP[0]，PrintLog）
  UP[2] = timerState（doInit_UI UP[2]，包含cruiseTimer/resTimer）
  UP[3] = initState（doInit_UI UP[1]，initTime/initTimeStr/initSnapshot状态表）

子闭包：
  child4 Nested_UnSchedule：捕获[printLog,timerState,moduleState]
  child0 Nested_Helper_2：无捕获
  child1 Nested_string：无捕获
  child2 Nested_FFFFFF：捕获[resList, screenW*0.6]
  child3 Nested_Helper_3：捕获[moduleState,timerState,curTimeText,durTimeText,
    initState,MoneyProxy,moneyRows,formatNumber,itemRows,Nested_string]

本文件用工厂函数把VM闭包捕获显式转换成普通Lua参数；make_Nested_UnSchedule、
make_Nested_FFFFFF、make_Nested_Helper_3及两个无捕获辅助函数定义在其他候选文件中。
GUI方法的可见接收者/参数顺序按反汇编保留；宿主标志/尾参语义不作猜测。
]]

local function make_Nested_FFFF00(moduleState, printLog, timerState, initState)
    return function Nested_FFFF00()
        local gui = GUI
        local sl = SL

        -- PC1-PC27：窗口已存在则关闭；resTimer取消后写入unknown哨兵而非nil。
        if gui:Win_IsNotNull(moduleState.resWin) then
            printLog("关闭资源信息窗口")
            if timerState.resTimer then
                sl:UnSchedule(timerState.resTimer)
                timerState.resTimer = UNKNOWN_VALUE_SENTINEL
            end
            gui:Win_Close(moduleState.resWin)
            return
        end

        -- PC28-PC46：Win_Create显式保留nil参数槽及最后的999。
        local resWin = gui:Win_Create(
            "resWin",
            0, 0,
            moduleState.screenW, moduleState.screenH,
            false, true, true, true, true,
            nil, 999
        )
        moduleState.resWin = resWin

        -- PC47-PC72：根Layout和空白点击关闭回调。
        local rootLayout = gui:Layout_Create(
            resWin, "closeResWin", 0, 0,
            moduleState.screenW, moduleState.screenH, true
        )
        gui:setTouchEnabled(rootLayout, true)

        -- child4在父PC68-PC71捕获[printLog,timerState,moduleState]。
        local closeCallback =
            make_Nested_UnSchedule(printLog, timerState, moduleState)
        gui:addOnClickEvent(rootLayout, closeCallback)

        -- PC73-PC117：ListView几何、锚点及背景参数。
        local screenW = moduleState.screenW
        local screenH = moduleState.screenH
        local listWidth = screenW * 0.6
        local resList = gui:ListView_Create(
            resWin, "resList",
            (screenW - 1) / 2, screenH / 2,
            listWidth, screenH * 0.6, 1.0
        )
        gui:setAnchorPoint(resList, 0, 0.5)
        gui:ListView_setBackGroundColorType(resList, 1)
        gui:ListView_setBackGroundColor(resList, "#CEB5F7")
        gui:ListView_setBackGroundColorOpacity(resList, 255)

        -- PC118-PC264：标题、初始时间、当前时间、历时、备注五组区域。
        local titleCell = gui:Layout_Create(resList, "titleCell", 0, 0, 1, 30, 1)
        local titleText = gui:Text_Create(
            titleCell, "titleText", 0.5, 15, 20, "#FF0000", "资源统计"
        )
        gui:setAnchorPoint(titleText, 0.5, 0.5)

        local initTimeCell = gui:Layout_Create(resList, "initTimeCell", 0, 0, 1, 30, 1)
        local initTimeText = gui:Text_Create(
            initTimeCell, "initTimeText", 0.5, 15, 20, "#00FF00",
            "初始时间:" .. tostring(initState.initTimeStr or "--")
        )
        gui:setAnchorPoint(initTimeText, 0.5, 0.5)

        local curTimeCell = gui:Layout_Create(resList, "curTimeCell", 0, 0, 1, 30, 1)
        local curTimeText = gui:Text_Create(
            curTimeCell, "curTimeText", 0.5, 15, 20, "#00FF00", "当前时间:--"
        )
        gui:setAnchorPoint(curTimeText, 0.5, 0.5)

        local durTimeCell = gui:Layout_Create(resList, "durTimeCell", 0, 0, 1, 30, 1)
        local durTimeText = gui:Text_Create(
            durTimeCell, "durTimeText", 0.5, 15, 20, "#00FF00", "历时:--"
        )
        gui:setAnchorPoint(durTimeText, 0.5, 0.5)

        local noteCell = gui:Layout_Create(resList, "noteCell", 0, 0, 1, 30, 1)
        local noteText = gui:Text_Create(
            noteCell, "noteText", 0.5, 15, 20, "#FFFF00",
            "（括号内数量为非绑定资源的收益）"
        )
        gui:setAnchorPoint(noteText, 0.5, 0.5)

        -- PC265-PC267创建child2：捕获resList与listWidth。
        local updateResourceRows = make_Nested_FFFFFF(resList, listWidth)

        -- PC268-PC281：两组资源名称。
        local moneyNames = {"元宝", "绑定元宝", "灵符", "绑定灵符"}
        local resourceNames = {
            "声望卷", "悟道茶", "洗髓丹", "转生水晶", "恶魔令牌", "血龙宝珠"
        }

        -- PC282-PC291：child2两次调用，实参为(names,2,"money"/"item")。
        local moneyRows = updateResourceRows(moneyNames, 2, "money")
        local itemRows = updateResourceRows(resourceNames, 2, "item")

        -- PC292：child1 Nested_string无捕获；PC293-PC299随后获取MoneyProxy。
        local getItemCount = Nested_string
        local moneyProxy = global.Facade:retrieveProxy(
            global.ProxyTable.MoneyProxy
        )

        -- PC300-PC310创建child3，10项捕获顺序按闭包描述显式传入。
        local formatNumber = Nested_Helper_2
        local refreshResourceStatistics = make_Nested_Helper_3(
            moduleState, timerState, curTimeText, durTimeText, initState,
            moneyProxy, moneyRows, formatNumber, itemRows, getItemCount
        )

        -- PC311-PC312先立即刷新一次；PC313-PC319再安排1秒周期并保存句柄。
        refreshResourceStatistics()
        timerState.resTimer = sl:Schedule(refreshResourceStatistics, 1.0)

        -- PC320：无显式返回值。
        return
    end
end

return make_Nested_FFFF00
