[TOC]
# 创建物品框
## ItemShow_Create(parent, ID, x, y, setData)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|setData    |是|table|配置数据|
- 配置数据详细参数 示例

```
	local setData  = {}
	setData.index = 4                     -- 物品Index
	setData.look  = true                  -- 是否显示tips
	setData.bgVisible = true              -- 是否显示背景框
	setData.count = 1                     -- 物品数量
	setData.color = 225                   -- 颜色ID （0~255）
	--setData.starLv = false              -- 是否显示星级
	--setData.checkPower = true           -- 是否检查战力从而显示提升小箭头
	--setData.showModelEffect = true      -- 只显示内观特效不显示背包特效
	--setData.onlyShowSFX = true          -- 只显示道具特效其它都不显示
	--setData.noSwallow = true            -- 是否触摸吞噬
	--setData.noMouseTips = true          -- 鼠标移入不显示tips
	--setData.mouseCheckTimes = 6         -- 鼠标移入检测物品框是否可见时查找父节点层数, 默认6
	--setData.itemData = table            -- 物品数据 ( ！有真实物品数据可直接传, 避免Tips缺漏 )

	local item = GUI:ItemShow_Create(ui_icon, "item", 0, 0, setData)
```
- 示例代码2 (等同于EquipShow创建)

```
	-- 获取装备位1的装备数据
	local equipData    = SL:GetMetaValue("EQUIP_DATA", 1)
    if equipData then
        local info = {}
        info.index = equipData.Index
        info.itemData = equipData		-- 传入装备数据
        info.look = true
        info.bgVisible = true
        info.starLv = true
		local item = GUI:ItemShow_Create(parent, "item", 0, 0, info)
	end
```

# 设置物品框单击事件
## ItemShow_addReplaceClickEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|eventCB     |是|function|单击事件函数|

# 设置物品框双击事件
## ItemShow_addDoubleEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|eventCB    |是|function|双击事件函数|

# 设置物品框长按事件
## ItemShow_addPressEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|eventCB    |是|function|长按事件函数|

# 设置物品框是否置灰
## ItemShow_setIconGrey(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|value      |是|bool|是否置灰|

# 设置物品框是否选中
## ItemShow_setItemShowChooseState(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|value      |是|bool|是否选中|

# 设置物品框是否拖动
## ItemShow_setMoveEable(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|value      |是|bool|是否拖动|

# 更新物品框内容
## ItemShow_updateItem(widget, itemData)
- **不建议使用！ 更不建议高频使用！简单更新可以调用下方函数调用方式 自定义刷新内容。  **

|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|setData   |是|table|配置数据|

# 调用GUILayout/Item.lua中的函数
## ItemShow_OnRunFunc(widget, funcname, ...)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|funcname   |是|string|GUILayout/Item.lua中的函数名字|
|...        |否|any|可变参数

*例如*
```
	-- 设置ItemShow的显示道具数量为20
	local ItemShow = GUI:ItemShow_Create(parent, "Item", 0, 0, itemData)
	ItemShow_OnRunFunc(ItemShow, "SetCount", 20)
```

# 设置物品框是否触摸吞噬
## ItemShow_setItemTouchSwallow(widget, bool)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品框对象|
|value      |是|bool|是否触摸吞噬|