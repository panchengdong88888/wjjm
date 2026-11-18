[TOC]
# 创建按钮
## Button_Create(parent, ID, x, y, nimg)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|nimg       |是|string|图片路径|
- 示例代码
```
local BtnOk = GUI:Button_Create(FrameLayout, "BtnOk", 0, 0, "res/public/1900000611.png")
GUI:setAnchorPoint(BtnOk, { x = 0.5, y = 0.5 })
GUI:Button_setTitleText(BtnOk, "确定")
GUI:Button_setTitleFontSize(BtnOk, 16)
GUI:addOnClickEvent(BtnOk, function()
	-- do something
end)
```

# 设置按钮状态图片
## Button_loadTextures(widget, Normalfilepath, Pressedfilepath, Disabledfilepath, TextureType)
|参数        |必选|类型|注释|
|:----       |:-|:--|:---|
|widget                    |是|obj|按钮对象|
|Normalfilepath            |是|string|正常状态图片路径|
|Pressedfilepath           |否|string|按压状态图片路径|
|Disabledfilepath          |否|string|禁用状态图片路径|
|TextureType               |否|int|加载类型：<br>0 图片<br>1 图片集 plist文件|

## Button_loadTextureNormal(widget, filepath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|filepath   |是|string|图片路径|
- 设置正常状态图片

## Button_loadTexturePressed(widget, filepath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|filepath   |是|string|图片路径|
- 设置按下状态图片

## Button_loadTextureDisabled(widget, filepath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|filepath   |是|string|图片路径|
- 设置禁用状态图片

# 设置按钮文字
## Button_setTitleText(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|string|按钮显示文本|

# 获取按钮文字 [3.40.6版本]
## Button_getTitleText(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|

# 设置按钮文字颜色
## Button_setTitleColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|string|色值（#000000）|

# 设置按钮文字大小
## Button_setTitleFontSize(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|int|字体大小（字号16）|

# 设置按钮文字样式
## Button_setTitleFontName(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|string|字体样式（font.ttf）|

# 设置按钮文本最大宽度
## Button_setMaxLineWidth(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|int|文本最大宽度|

# 设置按钮文本加描边
## Button_titleEnableOutline(widget, color, outline)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|color      |是|string|描边色值（#000000）|
|outline    |是|int|描边大小|

## Button_titleDisableOutLine(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
- 取消按钮文本描边

# 设置按钮是否禁用
## Button_setBright(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|bool|是否禁用（可触摸）|

## Button_setBrightEx(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|bool|是否禁用（不可触摸）|

## Button_setBrightStyle(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|int|状态（0正常 1按下）|

#设置按钮是否灰态
## Button_setGrey(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|value      |是|bool|是否灰态|

#设置按钮九宫格
## Button_setScale9Slice(widget, scale9l, scale9r, scale9t, scale9b)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|按钮对象|
|scale9l    |是|int|左边比例|
|scale9r    |是|int|右边比例|
|scale9t    |是|int|上边比例|
|scale9b    |是|int|下边比例|


















