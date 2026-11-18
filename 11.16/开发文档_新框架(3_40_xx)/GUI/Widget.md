[TOC]
# 创建Widget
## Widget_Create(parent, ID, x, y, width, height)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|宽|
|height     |是|int|高|
- 示例代码

```
 local widget =  GUI:Widget_Create(parent, "widget_1", 0, 0, 300, 200)
```
