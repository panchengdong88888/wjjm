[TOC]
# 创建进度条
## LoadingBar_Create(parent, ID, x, y, nimg, direction)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|nimg       |是|string|图片路径|
|direction  |是|int|方向：<br>0 从左到右<br>1 从右到左|
- 示例代码
```
local imgBar = "res/private/gui_edit/LoadingBar.png"
local loadingBar = GUI:LoadingBar_Create(parent, "loadingBar", 0, 0, imgBar, 0)
```

# 设置进度条图片
## LoadingBar_loadTexture(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
|value      |是|string|图片路径|

# 设置进度条方向
## LoadingBar_setDirection(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
|value      |是|int|方向：<br>0 从左到右<br>1 从右到左|

# 设置进度条进度
## LoadingBar_setPercent(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
|value      |是|int|进度(0-100)|

# 获取进度条进度
## LoadingBar_getPercent(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
- 返回值：进度条进度

# 设置进度条颜色
## LoadingBar_setColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
|value      |是|string|色值("#000000")|

# 获取进度条颜色
## LoadingBar_getColor(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|进度条对象|
- 返回值：string 进度条颜色值











