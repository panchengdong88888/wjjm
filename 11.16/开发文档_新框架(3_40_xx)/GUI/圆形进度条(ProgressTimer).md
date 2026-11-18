[TOC]
# 创建圆形进度条
## ProgressTimer_Create(parent, ID, x, y, img)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|img        |是|string|图片路径|
- 示例代码
```
local ui_img = "res/private/main/Skill/hero2/0_0001.png"
local heroProgress = GUI:ProgressTimer_Create(parent, "heroProgress", 0, 0, ui_img)
```

# 设置圆形进度条百分比
## ProgressTimer_setPercentage(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|进度(0-100)|

# 获取圆形进度条百分比
## ProgressTimer_getPercentage(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|

# 设置圆形进度条方向
## ProgressTimer_setReverseDirection(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|bool|true 顺时针<br>false 逆时针|

# 设置圆形进度条动作和回调函数
## ProgressTimer_progressFromTo(widget, time, from, to, completeCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|from       |是|int|开始进度(0-100)|
|to         |是|int|结束进度(0-100)|
|completeCB |是|function|回调函数|

## ProgressTimer_progressTo(widget, time, to, completeCB, tag)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|to         |是|int|结束进度(0-100)|
|completeCB |是|function|回调函数|
|tag        |是|int|标记|

# 设置圆形进度条背景图
## ProgressTimer_ChangeImg(widget, img)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|img        |是|string|图片路径|




