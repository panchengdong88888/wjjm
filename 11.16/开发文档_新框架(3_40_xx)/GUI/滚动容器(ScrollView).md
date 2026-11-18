[TOC]
# 创建滚动容器
## ScrollView_Create(parent, ID, x, y, width, height, direction)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
|direction  |是|int|1：垂直; 2：水平|
- 示例代码

```
local scrollView = GUI:ScrollView_Create(parent, "scrollView", 0, 0, 300, 500, 1)
```

# 设置滚动容器滚动范围大小
## ScrollView_setInnerContainerSize(widget, value1, value2)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value1     |是|int 或 table|宽度 或 尺寸|
|value2     |否|int|高度|
- 代码示例

```
local width = 300
local height = 400
local size = {width = 300, height = 400}
GUI:ScrollView_setInnerContainerSize(ScrollView, width, height)
GUI:ScrollView_setInnerContainerSize(ScrollView, size)
```

# 获取滚动容器滚动范围大小
## ScrollView_getInnerContainerSize(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：滚动容器滚动范围大小

# 获取容器内部滚动区域坐标 [3.40.3版本]
## ScrollView_getInnerContainerPosition(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值 容器内部滚动区域坐标

# 设置滚动容器滚动方向
## ScrollView_setDirection(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|1：垂直; 2：水平|

# 设置滚动容器是否有回弹
## ScrollView_setBounceEnabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|bool|是否有回弹|

# 设置滚动容器是否有裁切
## ScrollView_setClippingEnabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|bool|是否有裁切|

# 设置滚动容器背景颜色
## ScrollView_setBackGroundColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|string|色值("#000000")<br> ! 渐变色需传参table `{"#FF0000", "#FFFFFF"}`|

# 设置滚动容器背景颜色类型
## ScrollView_setBackGroundColorType(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|1：单色，2：渐变色|

# 设置滚动容器背景透明度
## ScrollView_setBackGroundOpacity(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|透明度(0-255)|

# 设置滚动容器背景图片
## ScrollView_setBackGroundImage(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|string|图片路径|

# 设置滚动器背景图片九宫格
## ScrollView_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|scale9l    |是|int|左边比例|
|scale9r    |是|int|右边比例|
|scale9t    |是|int|上边比例|
|scale9b    |是|int|下边比例|

# 移除滚动容器背景图片设置 [3.40.5版本]
## ScrollView_removeBackGroundImage(widget)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|

# 设置滚动容器滚动事件
## ScrollView_addOnScrollEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|eventCB    |是|function|事件函数|

# 滚动容器加载子节点
## ScrollView_addChild(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|obj|子节点对象|

# 滚动容器删除所有子节点
## ScrollView_removeAllChildren(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|

# 滚动容器衰减滚动
## ScrollView_scrollToTop(widget, time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减（顶部）|

## ScrollView_scrollToBottom(widget, time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减（底部）|

## ScrollView_scrollToTopLeft(widget, time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减（顶左）|

## ScrollView_scrollToRight(widget, time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减（右边）|

## ScrollView_scrollToLeft(widget, time, boolvalue) [3.40.5版本]
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减（左边）|

## ScrollView_scrollToPercentVertical(widget, percent, time, bool) [3.40.5版本]
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|percent    |是|int|百分比|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减滚动速度|
- 垂直方向滚动

## ScrollView_scrollToPercentHorizontal(widget, percent, time, bool) [3.40.5版本]
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|percent    |是|int|百分比|
|time       |是|int|时间|
|boolvalue  |是|bool|是否衰减滚动速度|
- 水平方向滚动


# 滚动容器添加滚动条
## SetScrollViewVerticalBar(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|param      |是|table|布局参数|
```lua
        GUI:SetScrollViewVerticalBar(parent, {
            bgPic       = "res/private/gui_edit/scroll/line.png",   -- 背景图
            barPic      = "res/private/gui_edit/scroll/p.png",      -- 滑动按钮图片
            Arr1PicN    = "res/private/gui_edit/scroll/t.png",      -- 上（正常图）
            Arr1PicP    = "res/private/gui_edit/scroll/t_1.png",    -- 上（按下图）可不传
            Arr2PicN    = "res/private/gui_edit/scroll/b.png",      -- 下（正常图）
            Arr2PicP    = "res/private/gui_edit/scroll/b_1.png",    -- 下（按下图）可不传
            default     = 0,                    -- 进度条值（默认是0）
            x           = 0,                    -- 进度条坐标 x
            y           = 0,                    -- 进度条坐标 y
            list        = listHandle,           -- 滚动的容器 list
            callFunc    = function (send)       -- 容器滚动的回调函数
                SL:Print("回调函数")
            end,
        })
```





