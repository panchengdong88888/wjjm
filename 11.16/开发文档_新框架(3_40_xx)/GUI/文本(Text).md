[TOC]
# 创建文本
## Text_Create(parent, ID, x, y, fontSize, fontColor, str)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|fontSize   |是|int|字体大小|
|fontColor  |是|stirng|字体颜色|
|str        |是|string|文本|
- 示例代码
```
local str = "我的名字" or ""
local Text_name = GUI:Text_Create(parent, "Text_name", 0, 0, 16, "#ffffff", str)
```


# 设置文本
## Text_setString(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|string|文本|


# 获取文本
## GUI:Text_getString(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


# 设置文本颜色
## Text_setTextColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|string|色值("#000000")|


# 设置字体大小
## Text_setFontSize(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|int|字体大小|


# 设置字体路径
## Text_setFontName(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|string|字体文件路径<br>例: "fonts/font.ttf"|


# 设置字体描边
## Text_enableOutline(widget, color, size)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|color      |是|string|色值("#000000")|
|size       |是|int|描边宽度|


# 设置是否启用下划线
## GUI:Text_enableUnderline(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|文本对象|


# 设置文本最大行宽
## Text_setMaxLineWidth(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|int|宽度|
```lua
    -- 需要在设置文本最大行宽后再填充文本内容
    local Text_name = GUI:Text_Create(parent, "Text_name", 0,0, 16, "#ffffff", "")
    GUI:Text_setMaxLineWidth(Text_name, 100)
    GUI:Text_setString(Text_name, "设置文本最大行宽这是一段神奇的文字")
```


# 禁用文本特效
## Text_disableEffect(widget, param)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|int|特效类型：<br>0：正常<br> 1：描边<br>2：阴影<br>3：发光<br>4：斜体<br>5：粗体<br>6：下划线|


## Text_disableNormal(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


## Text_disableOutLine(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


## Text_disableShadow(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


## Text_disableGlow(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|


# 设置文本垂直对齐
## Text_setTextVerticalAlignment(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|int|0：顶对齐<br> 1：垂直居中<br>2：底对齐|


# 设置文本水平对齐
## Text_setTextHorizontalAlignment(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|int|0：顶对齐<br> 1：水平居中<br>2：底对齐|


# 设置文本尺寸
## Text_setTextAreaSize(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|table|{width = 0, height = 0}|


# 设置倒计时文本
## Text_COUNTDOWN(widget, time, callback)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|time       |是|int|倒计时时间, 单位:秒|
|callback   |否|function|每秒触发回调, 传入参数: 剩余时间<br>**版本号[3.40.4]及以后改为倒计时结束触发**|
|showType   |否|int|倒计时时间显示方式 <br>0: xx时xx分xx秒 <br>1: 小于1天显示xx:xx:xx 大于显示xx天xx时xx分 [3.40.8版本新增]|
























