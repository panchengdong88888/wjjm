[TOC]
# 创建节点
## Node_Create(parent, ID, x, y)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
- 示例代码

```
 local node = GUI:Node_Create(parent, "node", 0, 0)
```
