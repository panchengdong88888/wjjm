[TOC]
# 创建Bmp文本
## BmpText_Create(parent, ID, x, y, fontColor, str, fontPath)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|fontColor  |否|stirng|字体颜色, [3.40.7版本支持传空]|
|str        |是|string|文本|
|fontPath   |是|string|字体文件路径, 例：`"fonts/stfont.fnt"`|
- PC端 12号宋体
- 示例代码
```
local str = "我的名字" or ""
local Text_name = GUI:BmpText_Create(parent, "Text_name", 0, 0, "#ffffff", str)
```
