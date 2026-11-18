[TOC]
# 创建列表容器[优化加载]
## TableView_Create(parent, ID, x, y, width, height, direction, cellWid, cellHei, num)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|容器宽度|
|height     |是|int|容器高度|
|direction  |是|int|1：垂直; 2：水平|
|cellWid	|是|int|单个cell 宽|
|cellHei	|是|int|单个cell 高|
|num		|是|int|需创建cell个数|

# 设置子cell创建方法
## TableView_setCellCreateEvent(widget, func)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|func		|是|function|创建函数 传入参数(cell父节点, cell下标)|

# 设置滚动方向
## TableView_setDirection(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|value		|是|int|滚动方向 1：垂直; 2：水平|

# 获取滚动方向  [3.40.9版本]
## GUI:TableView_getDirection(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|

# 设置背景颜色
## TableView_setBackGroundColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|value		|是|string|十六进制颜色值 例: "#FFFFFF"|

# 设置内部区域偏移位置 [3.40.3版本]
## TableView_setContentOffset(widget, x, y)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|x			|是|int|偏移坐标X|
|y			|是|int|偏移坐标Y|

# 获取内部区域偏移位置 [3.40.3版本]
## TableView_getContentOffset(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|


# 添加点击cell事件
## TableView_addOnTouchedCellEvent(widget, func)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|func		|是|function|点击cell触发回调|


# 滚动到某cell位置
## TableView_scrollToCell(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|index		|是|int|对应cell下标|

# 添加容器滚动回调 [3.40.3版本]
## GUI:TableView_addOnScrollEvent(widget, func)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|func		|是|function|容器滚动回调函数 param1: TableView控件|

# 设置容器cell个数 [3.40.5版本]
## GUI:TableView_setTableViewCellsNumHandler(widget, func)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|func		|是|int/function|cell总个数(int)/返回cell总个数的函数(func)|

# 加载容器所有列表数据 [3.40.5版本]
## GUI:TableView_reloadData(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
* 结合GUI:TableView_setTableViewCellsNumHandler方法 改变数据使用

# 加载容器所有列表数据，且维持当前容器偏移位置 [3.40.6版本]
## GUI:TableView_reloadDataEx(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
* 结合GUI:TableView_setTableViewCellsNumHandler方法 改变数据使用

# 添加容器鼠标滚动事件 [3.40.5版本]
## GUI:TableView_addMouseScrollEvent(widget, func)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableView对象|
|func		|否|function|鼠标滚动回调函数传参{widget = widget, x = 滚动坐标X, y = 滚动坐标Y} [不填采用官方默认添加滚动] |

# TableViewCell
# 获取容器cell的下标/序列号
## GUI:TableViewCell_getIdx(cell)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|tableViewCell对象|


* 示例代码
```
		local winWidth = 900
		local winHeight = 600
		local wnd = GUI:Win_Create("Win_1", 0, 0, winWidth, winHeight)
		
		local tableView = GUI:TableView_Create(wnd, "TABLEVIEW", 200, 100, 600, 400, 1, 600, 40, 200)
		GUI:TableView_setBackGroundColor(tableView, "#FFFFFF")
		GUI:TableView_setDirection(tableView, 2)
		-- 设置cell创建方法
		GUI:TableView_setCellCreateEvent(tableView, function(parent, idx, ID)
			if ID == "TABLEVIEW" then
				local panel = GUI:Layout_Create(parent, string.format("layout_%s", idx), 0, 0, 600, 40)
				local text = GUI:Text_Create(panel, "TEXT", 0, 20, 18, "#00FF00", "IDX----------------"..idx)
				GUI:setAnchorPoint(text, 0, 0.5)
			end
		end)
   		
		local function touchCellFunc(tv, cell)
			local idx = GUI:TableViewCell_getIdx(cell)
			local panel = GUI:getChildByID(cell, string.format("layout_%s", idx))
			GUI:Layout_setBackGroundColorType(panel, 1)
			GUI:Layout_setBackGroundColor(panel, "#00EEAA")
			if idx == 15 then
				GUI:TableView_scrollToCell(tv, 18)
			end
		end
		-- 添加cell点击事件
		GUI:TableView_addOnTouchedCellEvent( tableView, touchCellFunc )
		SL:ScheduleOnce(function ()
			GUI:TableView_scrollToCell(tableView, 6)
		end, 1/60)

	```


