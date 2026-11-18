[TOC]
# 创建旋转容器
## RotateView_Create(parent, ID, x, y, width, scrollGap, param)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
|scrollGap  |是|int|滑动间隙, 默认100|
|param      |是|table|子节点参数, 参考如下|

```
	列表各子节点参数 scale: 缩放大小 img: 图片路径 string node:自定义控件 (img和node不同时存在)
	{
		[1] = {scale = 0.4},
		[2] = {scale = 0.6},
		[3] = {scale = 0.8},
	}
```

# 添加子节点到旋转容器对应下标item
## RotateView_addChild(widget, value, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|旋转容器对象|
|value      |是|obj|控件对象|
|index      |是|int|对应下标|

# 获取对应下标item添加的子节点
## RotateView_getChildByIndex(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|旋转容器对象|
|index      |是|int|对应下标|

- 仅能获取RotateView_addChild方法添加的控件.

# 获取对应下标item
## RotateView_getItemByIndex(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|旋转容器对象|
|index      |是|int|对应下标|


- 示例代码

```
	local param = {
		[1] = {scale = 0.4, img = "res/public/word_fubentg_1.png"},
		[2] = {scale = 0.6, img = "res/public/word_fubentg_2.png"},
		[3] = {scale = 0.8, img = "res/public/word_fubentg_3.png"},
		[4] = {scale = 1.0, img = "res/public/word_fubentg_4.png"},
		[5] = {scale = 0.8, img = "res/public/word_fubentg_5.png"},
		[6] = {scale = 0.6, img = "res/public/word_fubentg_6.png"},
		[7] = {scale = 0.4, img = "res/public/word_fubentg_7.png"},
	}
	local view = GUI:RotateView_Create(GUI:Attach_LeftBottom(), "rotateView_1", 500, 320, 1000, 500, 100, param)
	local item = GUI:RotateView_getItemByIndex(view, 3)
	local itemSize = GUI:getContentSize(item)
	local layout = GUI:Layout_Create(item, "clickLayout", 0, 0, itemSize.width, itemSize.height)
	GUI:setTouchEnabled(layout, true)
	GUI:setSwallowTouches(layout, false)
	GUI:addOnClickEvent(layout, function()
		SL:Print("Click item index 3 !")
		GUI:removeFromParent(view)
	end)
```
