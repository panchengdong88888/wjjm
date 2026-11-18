[TOC]
# 创建装备框
## GUI:EquipShow_Create(parent, ID, x, y, pos, isHero, data)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|pos    	|是|int|装备装戴位置|
|isHero		|否|boolean|是否英雄装备|
|data		|否|table|额外参数|
```
	额外参数 参考如下:
	{
		look  = true                  -- boolean 是否显示tips
		noMouseTips = true			-- boolean PC端鼠标移入不显示tips
		bgVisible = true              -- boolean 是否显示背景框
		movable = true				-- boolean 是否可拖动
		doubleTakeOff = true,		 -- boolean 能否双击穿戴
		lookPlayer = true,			-- boolean 查看他人数据
	}
```
示例 :
```
	local equipShow = GUI:EquipShow_Create(GUI:Attach_LeftBottom(), "equipShow1", 400, 300, 1, false, {bgVisible = true, look = true, doubleTakeOff = true})
	-- 装戴后自动刷新
    GUI:EquipShow_setAutoUpdate(equipShow)
```

# 设置装备框显示自动刷新
## GUI:EquipShow_setAutoUpdate(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|装备框对象|