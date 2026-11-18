[TOC]
# 创建富文本
## RichText_Create(parent, ID, x, y, str, width, fontSize, fontColor, vspace, hyperlinkCB, defaultFontFace)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|str        |是|string|文本内容|
|width      |是|int|富文本控件宽度|
|fontSize   |否|int|字体大小|
|fontColor  |否|string|字体颜色|
|vspace     |否|int|富文本行间距|
|hyperlinkCB|否|function|超链回调函数|
- 示例代码

```
local richText = GUI:RichText_Create(parent, "richText", 0, 0, "克里斯蒂亚罗", 100, 16, "#f8e6c6", 0, function()
    -- do something
end)
```

# 创建原始富文本
## RichTextFCOLOR_Create(parent, ID, x, y, str, width, fontSize, color, vspace, hyperlinkCB, fontPath, outlineParam)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|str        |是|string|文本内容|
|width      |是|int|富文本控件宽度|
|fontSize   |否|int|字体大小|
|color      |否|string|字体颜色, 例: "#FFFFFF"|
|vspace     |否|int|富文本行间距|
|hyperlinkCB|否|function|超链回调函数|
|fontPath   |否|string|字体文件路径|
|outlineParam|否|table|描边参数 <br>outlineSize: 描边大小 <br>outlineColor: 描边颜色 C3B <br> (描边颜色 例 : `SL:ConvertColorFromHexString("#FFFFFF")`)|
- 示例代码

```
	local rich = GUI:RichTextFCOLOR_Create(node, "rich", 100, 0, "<灼伤：%s几率灼烧目标/FCOLOR=254>\\<每秒燃烧目标5%生命值/FCOLOR=249>", 600, 16, "#28EF01", 5)

    local rich = GUI:RichTextFCOLOR_Create(GUI:Win_FindParent(107), "rich", -300, 60, "<点击跳转/@llllll>", 600, 16, "#28EF01", 5,function (...)
        SL:Print("超链回调",...)
    end)
```

# 创建自定义组合富文本 [3.40.3版本]
## RichTextCombine_Create(parent, ID, x, y, width, vspace)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|width      |是|int|富文本控件最大宽度|
|vspace     |否|int|富文本行间距|

## 添加自定义富文本cell
## RichTextCombine_pushBackElements(widget, elements)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|elements   |是|obj|[RichTextCombineCell] 单个元素控件对象 或 控件对象table |

## 添加cell完毕格式化富文本
## RichTextCombine_format(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|

# 创建自定义组合富文本cell [3.40.3版本]
## RichTextCombineCell_Create(parent, ID, x, y, type, param)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象 [RichTextCombine]|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|type       |是|int/string|cell类型 <br> 文本类型：1或TEXT<br>节点类型：2或NODE<br>换行类型：3 或 NEWLINE[3.40.4新增]|
|param      |是|table|额外参数, 参考如下:|
```
	{
		node 			= 节点类型必需参数 object 控件对象,
		color			= 颜色值 默认: "#FFFFFF",
		opacity  		= 不透明度 默认: 255,
		str  			= 文本内容 string,
		fontSize 		= 文本字号 默认: SL:GetMetaValue("GAME_DATA", "DEFAULT_FONT_SIZE"),
		fontPath 		= 文本字体路径 默认: "fonts/font2.ttf"
		outlineColor 	= 文本描边颜色 默认: "#000000",
		outlineSize  	= 文本描边大小 默认: 0,
		link 			= 文本点击触发传递内容 string
	}
```

- 示例代码 :

```
		local richText  = GUI:RichTextCombine_Create(GUI:Attach_LeftBottom(), "tt", 500, 320, 1000, 10)
        local element   = GUI:RichTextCombineCell_Create(richText, "txt_1", 0, 0, "TEXT", {
            str         = "1111111",
            color       = "#FF0000",
            fontSize    = 18
        })

        local element   = GUI:RichTextCombineCell_Create(richText, "txt_2", 0, 0, "TEXT", {
            str         = "22222",
            color       = "#0000FF",
            fontSize    = 12
        })
    
        local layout = GUI:Layout_Create(-1, "panel", 0, 0, 50, 50)
        GUI:addStateEvent(layout, function(state)
            if state == "enter" then
                GUI:removeAllChildren(layout)
                local size = GUI:getContentSize(layout)
            local emojiSfx = GUI:Effect_Create(layout, "sfx", size.width / 2, size.height / 2, 0, 1)
            end
        end)
        local element = GUI:RichTextCombineCell_Create(richText, "node_1", 0, 0, "NODE", {node = layout})
```

- 示例 2 : [3.40.4版本]

```
		local elements  = {}
        local element   = GUI:RichTextCombineCell_Create(-1, "show", 0, 0, "TEXT", {
            str         = "第一行文本11111",
            color       = "#FF0000",
            fontSize    = 16
        })
        table.insert(elements, element)

        local element   = GUI:RichTextCombineCell_Create(-1, "111", 0, 0, "NEWLINE", {})
        table.insert(elements, element)

        local element   = GUI:RichTextCombineCell_Create(-1, "222", 0, 0, "TEXT", {
            str         = "第二行文本222222",
            color       = "#00FF00",
            fontSize    = 16
        })
        table.insert(elements, element)

        local richText = GUI:RichTextCombine_Create(GUI:Attach_LeftBottom(), "RichText", 200, 300, 200, 0)
        GUI:RichTextCombine_pushBackElements(richText, elements)
        GUI:RichTextCombine_format(richText)
        GUI:RichText_setBackgroundColor(richText, "#FFFFFF")
```

# 设置富文本背景颜色 [3.40.3版本]
## RichText_setBackgroundColor(widget, color)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|color      |是|string|颜色值, 例: "#000000"|

# 添加富文本url点击触发事件 [3.40.3版本]
## RichText_setOpenUrlEvent(widget, handle)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|handle     |是|function|触发函数 (param1: 富文本控件, param2: string 文本传递内容)|

- 示例:

```
		local str = string.format("<a href='position#%s#200#200'>TTTT</a>", SL:GetMetaValue("MAP_ID"))
		local richText = GUI:RichText_Create(GUI:Attach_LeftBottom(), "rr", 500, 320, str, 1000)
        GUI:RichText_setOpenUrlEvent(richText, function(sender, str)
            SL:Print(str)
            local slices  = string.split(str, "#")
            local command = slices[1]
            if command == "position" then
                local originScale = GUI:getScale(sender)
                GUI:setScale(sender, originScale + 0.2)
                local function reback()
                    GUI:setScale(sender, originScale)
                end
                SL:scheduleOnce(sender, reback, 0.03)
                
                -- find position
                local mapID   = slices[2]
                local x       = tonumber(slices[3])
                local y       = tonumber(slices[4])
                SL:SetMetaValue("BATTLE_MOVE_BEGIN", mapID, x, y)
            end
        end)
```




