--[[
第六十五批：Nested_FFFFFF（资源统计行节点构造）普通 Lua 草稿
原型：root.children[42].children[3].children[2]
legacy：root/43/4/3
65条物理指令，17常量，无子原型，vararg_flag=3。
父函数：Nested_FFFF00（root.children[42].children[3]）。

当前级别：首版普通 Lua 草稿 / 静态复核中 / 未运行时验证。

闭合事实：
- 创建一个结果映射表。
- 由参数表长度和参数控制的数值循环生成单元格布局。
- 单元格名使用 "_cell_" 前缀，文本节点名使用 "_text_" 前缀。
- 每个有效资源名称创建一个Text节点，初始文本为 ":--"，字号参数15、行高/尺寸参数30、颜色"#FFFFFF"。
- 对Text节点调用setAnchorPoint(0.5,0.5)。
- 以资源名称为键、Text节点为值写入映射表。
- 函数返回映射表。

尚未完全闭合：
- 两个父级捕获（父T[5]、父T[1]）的业务身份。
- Layout_Create/Text_Create的所有位置参数及融合参数所对应的字段名。
- 两层数值循环的边界变量映射（PC5-6、PC26-27及PC62-63的循环步进需进一步结合VM循环语义核验）。
- vararg实际传入参数数量；父级调用点表明传入名称数组、数值2和类型标签，但本原型只将其中寄存器实际消费部分纳入草稿。
]]

local function Nested_FFFFFF(resourceNames, layoutOption, ...)
    local rowTextByName = {}

    -- 父级闭包捕获。静态捕获槽顺序为0=父T[5]、1=父T[1]。
    -- 当前不擅自将其命名为具体GUI父节点/布局对象。
    local capturedParent5 = UPVALUE_0
    local capturedParent1 = UPVALUE_1

    local gui = GUI
    local columnCount = layoutOption

    -- PC6-9：ceil(15 / layoutOption)，用于计算布局行/列数。
    local layoutBandCount = math.ceil(15 / columnCount)

    -- PC10-61：构造带 "_cell_" 前缀的单元格布局，并在单元格内创建资源文本。
    -- 下面把可确认的资源名称映射、Text_Create及锚点行为写成普通Lua；
    -- 单元格几何参数暂用注释标出，避免把融合寄存器误写成已确认字段。
    local cellIndex = 0
    for groupIndex = 1, layoutBandCount do
        cellIndex = cellIndex + 1

        local cellName = "_cell_" .. tostring(groupIndex)
        local cellLayout = gui:Layout_Create(
            capturedParent5,
            cellName,
            -- TODO(checkpoint91): 按PC10-61恢复单元格位置、宽高及布局参数。
            0, 0, 0, 0
        )

        for itemIndex = 1, columnCount do
            local resourceIndex = (groupIndex - 1) * columnCount + itemIndex
            local resourceName = resourceNames[resourceIndex]
            if resourceName then
                local textName = "_text_" .. tostring(resourceName)
                local textNode = gui:Text_Create(
                    cellLayout,
                    textName,
                    -- TODO(checkpoint91): 位置参数的寄存器来源仍需逐项校对。
                    0, 0,
                    15,
                    30,
                    "#FFFFFF",
                    ":--"
                )

                gui:setAnchorPoint(textNode, 0.5, 0.5)
                rowTextByName[resourceName] = textNode
            end
        end
    end

    return rowTextByName
end

return Nested_FFFFFF
