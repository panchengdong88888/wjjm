[TOC]
# 创建滚动文本
## ScrollText_Create(parent, ID, x, y, width, fontSize, fontColor, str, scrollTime, fontPath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|文本宽度|
|fontSize   |是|int|字体大小|
|fontColor  |是|int|字体颜色|
|str        |是|string|文本内容|
|scrollTime |否 [3.40.4版本生效]|int|滚动时长 (秒)|
|fontPath	|否 [3.40.6版本生效]|string|字体文件路径|
- 示例代码
```
local scrollText = GUI:ScrollText_Create(parent, "scrollText", 0, 0, 100, 16, "#000000", "文本内容")
```


# 设置滚动文本内容
## ScrollText_setString(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动文本对象|
|value      |是|string|文本内容|

# 获取滚动文本内容
## ScrollText_getString(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动文本对象|

# 设置滚动文本描边
## ScrollText_enableOutline(widget, color, size)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动文本对象|
|color      |是|string|描边色值("#000000")|
|size       |是|int|描边大小|

# 设置滚动文本水平对齐
## ScrollText_setHorizontalAlignment(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动文本对象|
|value      |是|int|对齐方式：<br>1 左对齐<br>2 水平居中<br>3 右对齐|

# 设置滚动文本颜色
## ScrollText_setTextColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|滚动文本对象|
|value      |是|string|色值("#000000")|





