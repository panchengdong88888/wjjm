--[[
第六十五批：Nested_FFFFFF（资源统计行节点构造）普通 Lua 草稿
原型：root.children[42].children[3].children[2]
legacy：root/43/4/3
65条物理指令，17常量，无子原型，vararg_flag=3。
父函数：Nested_FFFF00（root.children[42].children[3]）。

当前级别：普通 Lua 草稿 / PC循环与捕获来源已复核 / GUI完整调用协议仍未闭合 / 未运行时验证。

静态确认：
- 父级PC265依次捕获父T[5]与父T[1]；回看父函数寄存器生命周期，分别是resList（ListView节点）和screenW*0.6。
- 参数0为资源名称数组，参数1为布局列数；父级两次调用分别传入(moneyNames,2,"money")和(resourceNames,2,"item")。第三个及后续vararg在本函数可见路径中未被消费。
- 外层数值循环：从1开始，到#resourceNames为止，步长layoutOption。
- 内层数值循环：从1到layoutOption，步长1。
- 每个资源索引为outerIndex + innerIndex - 1；超出数组长度或资源名称为假值时跳过节点创建。
- 每组创建一个_layout cell；宽度来自捕获的screenW*0.6，高度常量35，起点x/y为0。
- Text节点横向位置由捕获宽度*(innerIndex-0.5)计算；文本内容由resourceName与":--"拼接。
- Text_Create参数寄存器中可确认字号/尺寸相关数值15、30及颜色"#FFFFFF"；创建后setAnchorPoint(0.5,0.5)。
- 返回resourceName -> Text节点映射表。

仍未闭合：
- GUI.Layout_Create与GUI.Text_Create调用栈中的融合参数/隐式空槽，不能据当前反汇编打印形式完整命名所有参数。
- 节点名称的完整拼接表达式仍需结合融合载荷和宿主GUI签名核验；下方以可读占位名表达，不宣称逐字复原。
- PC9的ceil(15/layoutOption)结果在本段寄存器追踪中未找到可靠的高层用途，不擅自将其编入布局行数逻辑。
]]

local function Nested_FFFFFF(resourceNames, layoutOption, ...)
    local rowTextByName = {}

    -- 父级PC265的捕获槽位：UPVALUE_0=父T[5]，UPVALUE_1=父T[1]。
    -- 父函数PC73-75、PC86-96及PC265-267的寄存器生命周期确认：
    -- UPVALUE_0为resList；UPVALUE_1为screenW*0.6。
    local listView = UPVALUE_0
    local cellWidth = UPVALUE_1

    local gui = GUI

    -- PC9计算ceil(15/layoutOption)；该值在现有静态寄存器追踪中
    -- 尚未确认参与后续API实参，故保留为待解释值，不作为循环边界。
    local unresolvedCeilValue = math.ceil(15 / layoutOption)

    -- PC5/PC63：外层数值for，起点1、终点#resourceNames、步长layoutOption。
    for groupStart = 1, #resourceNames, layoutOption do
        local cellName = "_cell_" .. tostring(groupStart)

        -- PC10-22：父节点为resList，x/y为0，宽度取screenW*0.6，
        -- 高度常量35。额外融合参数的完整宿主签名仍待核验。
        local cellLayout = gui:Layout_Create(
            listView,
            cellName,
            0, 0,
            cellWidth,
            35
        )

        -- PC23-26/PC62：内层数值for，1..layoutOption，步长1。
        for columnIndex = 1, layoutOption do
            -- PC27-30：resourceIndex = groupStart + columnIndex - 1。
            local resourceIndex = groupStart + columnIndex - 1
            local resourceName = resourceNames[resourceIndex]

            if resourceName then
                -- 节点名的寄存器拼接中含_text_前缀；精确后缀组合仍待融合载荷核验。
                local textName = "_text_" .. tostring(resourceIndex)

                -- PC32-35：x = cellWidth * (columnIndex - 0.5) / 1。
                -- PC46-52：15、30、#FFFFFF，以及 resourceName .. ":--"。
                local textX = cellWidth * (columnIndex - 0.5) / 1
                local textNode = gui:Text_Create(
                    cellLayout,
                    textName,
                    textX,
                    15,
                    30,
                    "#FFFFFF",
                    tostring(resourceName) .. ":--"
                )

                -- PC55-60：锚点(0.5,0.5)。
                gui:setAnchorPoint(textNode, 0.5, 0.5)

                -- PC61：以资源名称为键保存Text节点。
                rowTextByName[resourceName] = textNode
            end
        end
    end

    -- PC64：返回映射表。
    return rowTextByName
end

return Nested_FFFFFF
