[TOC]
#创建图片
## Image_Create(parent, ID, x, y, nimg)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|nimg       |是|string|图片路径|
- 示例代码
```
local imgPath = "res/public/1900000600.png"
local Image_bg = GUI:Image_Create(parent, "Image_bg", 0, 0, imgPath)
```

# 加载纹理图片
## Image_loadTexture(widget, filepath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|图片对象|
|filepath   |是|string|图片路径|

# 设置图片九宫格
## Image_setScale9Slice(widget, scale9l, scale9r, scale9t, scale9b)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|图片对象|
|scale9l    |是|int|左边比例|
|scale9r    |是|int|右边比例|
|scale9t    |是|int|上边比例|
|scale9b    |是|int|下边比例|

# 设置图片是否变灰
## Image_setGrey(widget, isGrey)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|图片对象|
|isGrey     |是|bool|是否置灰|

# 获取图片文件路径   [3.40.9版本]
## GUI:Image_getTextureFile(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|图片对象|
* 返回 图片资源路径 string


