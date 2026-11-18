[TOC]
# 创建复选框
## CheckBox_Create(parent, ID, x, y, nimg, pimg)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|nimg       |是|string|正常图片路径|
|pimg       |是|string|选中图片路径|
- 示例代码
```
local nimg = "res/private/gui_edit/CheckBox_Normal.png"
local pimg = "res/private/gui_edit/CheckBox_Press.png"
local checkBox = GUI:CheckBox_Create(parent, "checkBox", 0, 0, nimg, pimg)
```

# 设置复选框背景图片
## CheckBox_loadTextureBackGround(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|
|value      |是|string|默认状态图片路径|

## CheckBox_loadTextureFrontCross(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|
|value      |是|string|选中状态图片路径|

## CheckBox_loadTextureFrontCrossDisabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|
|value      |是|string|禁用状态图片路径|

# 设置复选框选中或取消
## CheckBox_setSelected(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|
|value      |是|bool|选中或取消|

# 获取复选框是否选中
## CheckBox_isSelected(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|

# 设置复选框监听事件
## CheckBox_addOnEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|复选框对象|
|eventCB    |是|function|事件函数|







