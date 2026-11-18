[TOC]
# 创建翻页容器
## PageView_Create(parent, ID, x, y, width, height)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
- 示例代码

```
local pageView = GUI:PageView_Create(parent, "pageView", 0, 0, 300, 500)
```

# 设置翻页容器是否有裁切
## PageView_setClippingEnabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|bool|是否有裁切|

# 设置翻页容器背景颜色
## PageView_setBackGroundColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|string|色值("#000000")<br> ! 渐变色需传参table `{"#FF0000", "#FFFFFF"}`|

# 设置翻页容器背景颜色类型
## PageView_setBackGroundColorType(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|1：单色，2：渐变色|

# 设置翻页容器背景透明度
## PageView_setBackGroundColorOpacity(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|透明度(0-255)|

# 设置翻页容器滚动到子页面
## PageView_scrollToItem(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|index      |是|int|子页面序列号|

# 获取当前子页面序列号
## PageView_getCurrentPageIndex(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：子页面序列号

# 设置翻页容器当前子页序列号 [3.40.3版本]
## PageView_setCurrentPageIndex(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|index      |是|int|子页面序列号|

# 获取翻页容器子页面
## PageView_getItems(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：子页面对象

# 获取翻页容器子页面数量
## PageView_getItemCount(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：子页面数量

# 翻页容器加载子页面
## PageView_addPage(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|obj|子页面对象|

# 翻页容器加监听事件
## PageView_addOnEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|eventCB    |是|function|监听事件函数|








