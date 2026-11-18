[TOC]
# 创建滚动条
## Slider_Create(parent, ID, x, y, barimg, pbarimg, nimg)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|barimg     |是|string|滚动条背景图片|
|pbarimg    |是|string|滚动条图片|
|nimg       |是|string|滚动条拖动块图片|
- 示例代码
```
local barimg = "res/private/new_setting/bg_progress.png"
local pbarimg = "res/private/new_setting/bg_progress2.png"
local nimg = "res/private/new_setting/icon_xdtzy_17.png"
local Slider_progress = GUI:Slider_Create(parent, "Slider_progress", 0, 0, barimg, pbarimg, nimg)
```

# 设置滚动条背景图
## Slider_loadBarTexture(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|string|背景图路径|

# 设置滚动条图片
## Slider_loadProgressBarTexture(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|string|滚动条图片路径|

# 设置滚动条拖动块普通图片
## Slider_loadSlidBallTextureNormal(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|string|拖动块图片路径|

# 设置滚动条进度
## Slider_setPercent(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|int|滚动条进度(0-100)|

# 获得滚动条进度
## Slider_getPercent(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
- 返回值：滚动条进度

# 设置滚动条最大进度值 [3.40.3版本]
## Slider_setMaxPercent(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|int|滚动条最大进度值|


# 设置滚动条触摸事件
## Slider_addOnEvent(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动条对象|
|value      |是|function|事件函数|








