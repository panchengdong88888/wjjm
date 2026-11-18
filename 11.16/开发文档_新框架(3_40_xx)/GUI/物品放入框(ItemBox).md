[TOC]
# 创建物品放入框
## ItemBox_Create(parent, ID, x, y, img, boxindex, stdmode)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|img        |是|string|放置框底图资源路径|
|boxindex   |是|int|放置框 唯一ID|
|stdmode    |是|string/number/table|允许传入的StdMode ("*": 所有 、单个用number 、多个用table)|

# 获取对应ID放置框的物品数据
## ItemBox_GetItemData(widget, boxindex)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品放入框控件对象|
|boxindex   |是|int|放置框 唯一ID|


# 清空对应ID放置框的传入数据
## ItemBox_RemoveBoxData(widget, boxindex)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品放入框控件对象|
|boxindex   |是|int|放置框 唯一ID|

# 更新对应ID放置框的物品数据 [3.40.4]
## ItemBox_UpdateBoxData(widget, boxindex)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|物品放入框控件对象|
|boxindex   |是|int|放置框 唯一ID|
|itemData   |否|tbl|填充指定的ItemData数据<br>[支持版本号3.40.7以上]|