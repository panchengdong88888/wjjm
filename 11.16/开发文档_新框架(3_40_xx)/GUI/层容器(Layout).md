[TOC]
# 创建层容器
## Layout_Create(parent, ID, x, y, width, height, isClip)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|长度|
|isClip     |是|bool|是否裁切|
- 示例代码
```
local layout = GUI:Layout_Create(parent, "layout", 0, 0, 100, 100, false)
```

# 设置层背景颜色
## Layout_setBackGroundColor(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|string|色值("#000000")<br> ! 渐变色需传参table `{"#FF0000", "#FFFFFF"}`|

# 设置层背景颜色类型
## Layout_setBackGroundColorType(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|int|类型(1单色，2渐变色)|

# 设置层背景颜色不透明度
## Layout_setBackGroundColorOpacity(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|int|不透明度(0-255)|

# 设置层背景是否裁切
## Layout_setClippingEnabled(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|bool|是否裁切|

# 设置层背景图片
## Layout_setBackGroundImage(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|string|图片路径|

# 设置层背景图片九宫格
## Layout_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|scale9l    |是|int|左边比例|
|scale9r    |是|int|右边比例|
|scale9t    |是|int|上边比例|
|scale9b    |是|int|下边比例|

# 设置层背景图片不透明度  [3.40.9版本]
## Layout_setBackGroundImageOpacity(widget, value)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|
|value      |是|int|不透明度(0-255)|

# 移除层背景图片设置 [3.40.5版本]
## Layout_removeBackGroundImage(widget)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|

# 获取层背景图片文件路径 [3.40.8版本]
## Layout_getBackGroundImageFile(widget)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|层对象|










