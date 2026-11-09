--[[
第六十五批：Nested_FFFFFF（资源统计行节点构造）普通 Lua 草稿
原型：root.children[42].children[3].children[2]
legacy：root/43/4/3
65条物理指令、17常量、无子原型、vararg_flag=3。
父函数：Nested_FFFF00（root.children[42].children[3]）。

当前级别：完整静态恢复（未运行时验证）。65条物理指令的参数、循环、捕获、GUI实参、节点命名、返回映射均已闭合；Layout_Create尾参1保留原值，宿主端语义未知。

已确认：
- 参数：resourceNames、layoutOption、rowType；父级两次调用分别传入(moneyNames,2,"money")与(resourceNames,2,"item")。
- UPVALUE_0=父T[5]=resList（ListView节点）；UPVALUE_1=父T[1]=screenW*0.6（列表宽度）。
- PC7-PC9计算ceil(15/layoutOption)，该值用于cell名称后缀。
- 外层循环1..#resourceNames，步长layoutOption；内层循环1..layoutOption，步长1。
- resourceIndex=outerIndex+innerIndex-1；资源名称为空/假值时跳过Text创建。
- 每组创建Layout，名称=rowType.."_cell_"..ceil(15/layoutOption)，父节点resList，位置0,0，宽度UPVALUE_1，高度35，尾随参数1。
- Text节点名称由常量2、"_text_"、0.5、"_"及列索引拼接，即可读表达式"2_text_0.5_"..columnIndex；它不是按资源索引命名。
- Text横向位置=UPVALUE_1*(columnIndex-0.5)/1；字号/尺寸相关数值15、30，颜色#FFFFFF；初始文本resourceName..":--"。
- setAnchorPoint(textNode,0.5,0.5)；返回resourceName -> Text节点映射表。

限制：
- GUI API的尾随参数在反汇编寄存器中可确认数值1，但该参数的宿主端语义未知；保留位置，不擅自命名。
- 尚未进行宿主GUI运行时验证。
]]

local function Nested_FFFFFF(resourceNames, layoutOption, rowType, ...)
    local rowTextByName = {}

    -- 父级PC265-PC267捕获：UPVALUE_0=resList，UPVALUE_1=screenW*0.6。
    local listView = UPVALUE_0
    local cellWidth = UPVALUE_1
    local gui = GUI

    -- PC7-PC9：ceil(15/layoutOption)参与每个分组Layout的名称。
    local cellNameSuffix = math.ceil(15 / layoutOption)

    -- PC2-PC5及PC63：外层数值for，起点1、终点#resourceNames、步长layoutOption。
    for groupStart = 1, #resourceNames, layoutOption do
        -- PC12-PC16：rowType .. "_cell_" .. cellNameSuffix。
        local cellName = rowType .. "_cell_" .. cellNameSuffix

        -- PC17-PC22：父resList，x/y=0，宽度为捕获宽度，高度35，尾随实参1。
        -- 最后一个实参的GUI宿主语义尚未确认，故不命名。
        local cellLayout = gui:Layout_Create(
            listView,
            cellName,
            0, 0,
            cellWidth,
            35,
            1
        )

        -- PC23-PC26及PC62：内层数值for，1..layoutOption，步长1。
        for columnIndex = 1, layoutOption do
            -- PC27-PC30：resourceIndex=groupStart+columnIndex-1。
            local resourceIndex = groupStart + columnIndex - 1
            local resourceName = resourceNames[resourceIndex]

            if resourceName then
                -- PC39-PC44：固定前缀2_text_0.5_再拼接列索引。
                -- 该节点名按列编号，不使用resourceIndex或rowType。
                local textName = "2_text_0.5_" .. columnIndex

                -- PC32-PC35：cellWidth*(columnIndex-0.5)/1。
                -- PC46-PC51：15、30、#FFFFFF、resourceName..":--"。
                local textX = cellWidth * (columnIndex - 0.5) / 1
                local textNode = gui:Text_Create(
                    cellLayout,
                    textName,
                    textX,
                    15,
                    30,
                    "#FFFFFF",
                    resourceName .. ":--"
                )

                -- PC55-PC60：锚点(0.5,0.5)。
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


-- 检查点113：逐PC复核完成。
-- PC1创建返回映射表；PC2-PC5设置外层数值循环(1..#resourceNames，步长layoutOption)。
-- PC6-PC9计算ceil(15/layoutOption)；PC10-PC22创建rowType.."_cell_"..ceil结果
-- 的Layout，实参依次为GUI self、resList、cellName、0、0、cellWidth、35、1。
-- PC23-PC26设置内层循环(1..layoutOption，步长1)；PC27-PC31计算
-- resourceIndex=groupStart+columnIndex-1，并在资源名假值时跳过本格。
-- PC32-PC35计算x=cellWidth*(columnIndex-0.5)/1。
-- PC36-PC52创建Text：GUI self、cellLayout、"2_text_0.5_"..columnIndex、
-- x、15、30、"#FFFFFF"、resourceName..":--"。
-- PC53-PC60检查Text创建结果并设置锚点(0.5,0.5)；PC61按resourceName为键
-- 写入映射表；PC62/63为内外层数值循环回跳；PC64返回映射表；PC65返回。
-- Layout_Create最后的数值1明确保留，宿主GUI语义未知；未运行时验证。
