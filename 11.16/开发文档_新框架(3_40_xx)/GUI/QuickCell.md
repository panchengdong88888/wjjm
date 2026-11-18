[TOC]
# 创建滚动容器子节点
## QuickCell_Create(parent, ID, x, y, w, h, createCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|w          |是|int|宽度|
|h          |是|int|高度|
|createCB   |是|function|创建子节点内容回调 [函数返回 widget]|
|activeCB	|否|function|判断是否需要激活/创建 [函数返回 boolean值]
|ext_param  |否|table| 附加参数 <br>event_x: boolean 是否横向, 默认false<br> tick_interval: 检测间隔,默认0.02 [3.40.9版本新增]|
- 示例代码

```
    local listviewCells = GUI:ListView_Create(_parent, "listviewCells", 200, 80, 587, 200, 1)
        for i = 1, 10 do
            GUI:QuickCell_Create(listviewCells, "QuickCell_Create"..i, 0, 0, 587, 200,  function(quickParent)
                local item = GUI:Layout_Create(quickParent, "cell_", 0, 0, 571, 70)
                -- 图标
                local itemIcon = GUI:Image_Create(item, "item_icon", 80, 35, "res/01/010001.png")
                GUI:setAnchorPoint(itemIcon, 0.5, 0.5)
                -- name
                local itemDesc = GUI:Text_Create(item, "item_name", 120, 40, 20, "#D6C6AD", "name.."..i)

                -- tips
                local itemDesc = GUI:Text_Create(item, "item_desc", 120, 15, 16, "#D6C6AD", "tips")

                -- 分割线
                local Image_line = GUI:Image_Create(item, "item_line", 0, 0, "res/buff/bg_buffzy_02.png")
                GUI:setAnchorPoint(Image_line, 0.5, 0)
                GUI:setPosition(Image_line, 571/2, 0)

                return item
            end)
        end
```

# 刷新展示
## QuickCell_Refresh(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|QuickCell对象|

# 强制退出/ 清理内容
## QuickCell_Exit(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|QuickCell对象|

```
	-- 顺序使用 通常用于刷新单个cell内容 [可参照 GUILayout/AuctionPutList 等..]
	GUI:QuickCell_Exit(quickCell)
	GUI:QuickCell_Refresh(quickCell)
```

