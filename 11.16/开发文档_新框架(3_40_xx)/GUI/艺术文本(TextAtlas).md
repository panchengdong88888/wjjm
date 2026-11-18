[TOC]
# 创建艺术字文本
## TextAtlas_Create(parent, ID, x, y, stringValue, charMapFile, itemWidth, itemHeight, startCharMap, sheet)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|stringValue   |是|string|文本内容|
|charMapFile   |是|string|艺术字路径|
|itemWidth     |是|int|单个字体宽度|
|itemHeight    |是|int|单个字体高度|
|startCharMap  |是|string|起始字符设置("/")|
|sheet		   |是|string|字体内容(H5专属)<br>比如图片文字是“+-0123456789”,那这个sheet的值就是"+-0123456789"|
- 示例代码1
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=f8affb00678cd1d0bdfc70497a576e48)
```
	local text = GUI:TextAtlas_Create(GUI:Attach_LeftBottom(), "aa", 100, 200, "123", "res/public/word_tywz_01.png", 18, 28, "0")
```

- 示例代码2
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=9777a3d9f0f8d5a7d6b7d8888b2a69e0)
此图对应ASCII码字符依次为 /0123456789:;
```
	-- 0前面的ASCII码 字符 / 代指 图片中减号, 艺术字起始字符为 /
    local text = GUI:TextAtlas_Create(GUI:Attach_LeftBottom(), "TT", 200, 300, "/", "res/private/damage_num/word_ngnz_12.png", 14, 22, "/")
    SL:ScheduleOnce(function()
        -- 顺延0-9后ASCII码 :; 两字符代指 "怒"  
        GUI:TextAtlas_setString(text, ":;99/")
    end, 1)
```
结果如下: ![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=a0c85265b9a0589ae61dee9eafa10174)

# 设置艺术字配置
## TextAtlas_setProperty(widget, stringValue, charMapFile, itemWidth, itemHeight, startCharMap, sheet)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|艺术字对象|
|stringValue   |是|string|文本内容|
|charMapFile   |是|string|艺术字路径|
|itemWidth     |是|int|字体宽度|
|itemHeight    |是|int|字体高度|
|startCharMap  |是|string|起始字符设置("/")|
|sheet		   |是|string|字体内容(H5专属)<br>比如图片文字是“+-0123456789”,那这个sheet的值就是"+-0123456789"|

# 设置艺术字文本
## TextAtlas_setString(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|艺术字对象|
|value      |是|string|文本内容|

# 获取艺术字文本
## TextAtlas_getString(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|艺术字对象|


