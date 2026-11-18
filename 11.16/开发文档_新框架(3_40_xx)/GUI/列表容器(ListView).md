[TOC]
# 创建列表容器
## ListView_Create(parent, ID, x, y, width, height, direction)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽度|
|height     |是|int|高度|
|direction  |是|int|1：垂直; 2：水平|
- 示例代码


```
local listView = GUI:ListView_Create(parent,"listView", 0, 0, 300, 400, 1)
```


# 设置列表容器对齐方式
## ListView_setGravity(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|0：左对齐<br>1：右对齐<br>2：水平居中<br>3：顶对齐<br>4：底对齐<br>5：垂直居中|


# 设置列表容器滑动方向
## ListView_setDirection(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|1：垂直; 2：水平|

# 获取列表容器滑动方向  [3.40.9版本]
## GUI:ListView_getDirection(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|


# 设置列表容器间隔
## ListView_setItemsMargin(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|间隔大小(50像素)|


# 获取列表容器间隔
## ListView_getItemsMargin(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
-  返回值：间隔距离(像素)


# 设置列表容器是否有回弹
## ListView_setBounceEnabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|bool|是否有回弹|


# 设置列表容器是否有裁切
## ListView_setClippingEnabled(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|bool|是否有裁切|


# 设置列表容器背景颜色
## ListView_setBackGroundColor(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|string|色值("#000000")<br> ! 渐变色需传参table `{"#FF0000", "#FFFFFF"}`|


# 设置列表容器背景颜色类型
## ListView_setBackGroundColorType(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|1：单色，2：渐变色|


# 设置列表容器背景透明度
## ListView_setBackGroundColorOpacity(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|透明度(0-255)|


# 设置列表容器背景图片
## ListView_setBackGroundImage(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|string|图片路径|


# 设置列表容器背景图片九宫格
## ListView_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|scale9l    |是|int|左边比例|
|scale9r    |是|int|右边比例|
|scale9t    |是|int|上边比例|
|scale9b    |是|int|下边比例|


# 移除列表容器背景图片设置 [3.40.5版本]
## ListView_removeBackGroundImage(widget)
|参数       |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|


# 列表容器加载子节点
## ListView_pushBackCustomItem(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|obj|子节点对象（末尾加载）|


## ListView_insertCustomItem(widget, value, value2)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|obj|子节点对象|
|value      |是|int|序列号（index = 1）|


# 列表容器删除所有子节点
## ListView_removeAllItems(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|


# 通过序列号删除列表容器子节点
## ListView_removeItemByIndex(widget, index)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|index      |是|int|序列号位置|


# 列表容器删除子节点
## ListView_removeChild(widget, item)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|item       |是|obj|子节点对象|


# 跳转到列表容器序列号节点位置
## ListView_jumpToItem(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|序列号位置|


# 某一时间内滑动到列表容器顶部
## ListView_scrollToTop(widget,time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|滑动速度是否减弱|


# 某一时间内滑动到列表容器底部
## ListView_scrollToBottom(widget,time, boolvalue)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|time       |是|int|时间|
|boolvalue  |是|bool|滑动速度是否减弱|


# 获取列表容器最顶部可见范围子节点
## ListView_getTopmostItemInCurrentView(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
-- 返回值：顶部范围子节点对象


# 获取列表容器最底部部可见范围子节点
## ListView_getBottommostItemInCurrentView(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：底部范围子节点对象


# 获取子节点序列号
## ListView_getItemIndex(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|obj|子节点对象|
- 返回值：子节点序列号


# 通过子节点序列号获取子节点对象
## ListView_getItemByIndex(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|value      |是|int|子节点序列号|
-  返回值：子控件对象


# 获取列表容器所有子节点对象
## ListView_getItems(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：所有子节点对象


# 获取列表容器所有子节点数量
## ListView_getItemCount(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值：子节点总数量


# 设置列表容器滚动事件
## ListView_addOnScrollEvent(widget, eventCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|eventCB    |是|function|事件函数|


# 列表容器刷新
## ListView_doLayout(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|


# 列表容器可见区域绘制
## ListView_paintItems(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|


# 列表容器可见区域自动绘制
## ListView_autoPaintItems(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|



# 获取列表容器滚动范围大小
## ListView_getInnerContainerSize(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值 列表容器滚动范围大小


# 获取列表容器内部滚动区域坐标
## ListView_getInnerContainerPosition(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
- 返回值 列表容器内部滚动区域坐标


# 设置列表容器滚动到某百分比位置(垂直方向)
## ListView_scrollToPercentVertical(widget, percent, time, bool)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|percent    |是|int|百分比(0-100)|
|time       |是|int|时间(秒)|
|bool       |是|boolean|是否衰减滚动速度|


# 设置列表容器滚动到某百分比位置(水平方向)
## ListView_scrollToPercentHorizontal(widget, percent, time, bool)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|
|percent    |是|int|百分比(0-100)|
|time       |是|int|时间(秒)|
|bool       |是|boolean|是否衰减滚动速度|


# 添加鼠标滚轮滑动列表容器事件
## ListView_addMouseScrollPercent(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|容器对象|






























