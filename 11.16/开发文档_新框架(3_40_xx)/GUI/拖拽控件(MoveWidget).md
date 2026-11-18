[TOC]
# 创建拖拽容器
## MoveWidget_Create(parent, ID, x, y, width, height, from, ext)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽|
|height     |是|int|高|
|from     	|是|int|控件来自(界面位置)  官方默认的可参照元变量 ITEMFROMUI_ENUM, <br>自定义类型的示例 : `SL:GetMetaValue("ITEMFROMUI_ENUM").xxx` <br>[xxx: 自定义类型名]|
|ext		|否|table|额外参数<br>beginMoveCB : 开始移动回调 <br>endMoveCB : 结束移动回调<br>cancelMoveCB : 取消移动回调 <br>equipPos: 放置装备的装备位置【来源 `SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP` 时生效】<br>pcDoubleCB : pc双击回调 [3.40.8版本]<br> mouseScrollCB: 鼠标滚轮回调 [3.40.8版本]|

- 装备位30的装备拖动穿脱 的示例代码
```
		local bg = GUI:Image_Create(GUI:Attach_LeftBottom(), "bg_TT", 400, 300, "res/public/btn_npcsm_01.png")
		local function beginMoveCallBack(node)
			GUI:setVisible(node, false)
		end
		local function endMoveCallBack(node)
			GUI:setVisible(node, true)
		end
		local function cancelMoveCallBack(node)
			GUI:setVisible(node, true)
		end
		local moveWidget = GUI:MoveWidget_Create(bg, "moveWidget", 35, 35, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").PALYER_EQUIP, {equipPos = 30, beginMoveCB = beginMoveCallBack, cancelMoveCB = cancelMoveCallBack, endMoveCB = endMoveCallBack})
		local itemData = SL:GetMetaValue("EQUIP_DATA", 30)
		if itemData then
			local item = GUI:ItemShow_Create(moveWidget, "equipItem", 35, 35, {index = itemData.Index, itemData = itemData, look = true})
			GUI:ItemShow_setItemTouchSwallow(item, false)
			GUI:setAnchorPoint(item, 0.5, 0.5)
		end
		-- 穿戴触发
		local function takeOnEquip(data)
			if data.isSuccess and data.pos == 30 then
				GUI:removeAllChildren(moveWidget)
				GUI:setVisible(moveWidget, true)
				local itemData = SL:GetMetaValue("EQUIP_DATA", 30)
				if itemData then
					local item = GUI:ItemShow_Create(moveWidget, "equipItem", 35, 35, {index = itemData.Index, itemData=itemData, look = true})
					GUI:ItemShow_setItemTouchSwallow(item, false)
					GUI:setAnchorPoint(item, 0.5, 0.5)
				end
			end
		end
		-- 脱下触发
		local function takeOffEquip(data)
			if data.isSuccess and data.pos == 30 then
				GUI:removeAllChildren(moveWidget)
				GUI:setVisible(moveWidget, true)
			end
		end
		
		SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, "TESTMove", takeOnEquip)
		SL:RegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, "TESTMove", takeOffEquip)
```

# 新增拖拽类型和拖拽事件
## AddMoveWidgetTypeEvent(fromType, toType, fromToEvent, toFromEvent)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|fromType   |是|string|控件来自位置类型名|
|toType     |是|string|控件到达位置类型名|
|fromToEvent|否|function|从fromType类型控件 拖拽到 toType类型控件 触发的函数|
|toFromEvent|否|function|从toType类型控件 拖拽到 fromType类型控件 触发的函数|
* fromToEvent/toFromEvent 起码实现一个.

- 示例代码
```
	--- 自新增移动类型 来自/去达
    local function fromToEvent(_, data)
        SL:PrintTable(data)
        SL:print("++++++FromToEvent  111 -> 222")
    end
    local function toFromEvent(_, data)
        SL:PrintTable(data)
        SL:print("++++++ToFromEvent  222 -> 111")
    end
    GUI:AddMoveWidgetTypeEvent("from", "to", fromToEvent, toFromEvent)
    local moveWidget11 = GUI:MoveWidget_Create(GUI:Attach_LeftBottom(), "moveWidget11", 500, 300, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").from, {cancelMoveCB = cancelMoveCallBack, endMoveCB = endMoveCallBack})
    local img = GUI:Image_Create(moveWidget11, "img", 0, 0, "res/public/word_fubentg_1.png")
    local tt11 = GUI:Text_Create(moveWidget11, "tt", 0, 35, 18, "#000000", "111")
    
    local moveWidget22 = GUI:MoveWidget_Create(GUI:Attach_LeftBottom(), "moveWidget22", 300, 300, 70, 70, SL:GetMetaValue("ITEMFROMUI_ENUM").to, {cancelMoveCB = cancelMoveCallBack, endMoveCB = endMoveCallBack})
    local img = GUI:Image_Create(moveWidget22, "img", 0, 0, "res/public/word_fubentg_2.png")
    local tt11 = GUI:Text_Create(moveWidget22, "tt", 0, 35, 18, "#000000", "222")
```


