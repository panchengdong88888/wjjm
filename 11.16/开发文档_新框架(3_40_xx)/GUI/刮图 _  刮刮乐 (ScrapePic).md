[TOC]
# 创建刮图
## ScrapePic_Create(parent, ID, x, y, showImg, maskImg, clearHei, moveTime, beginTime, callback)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|showImg    |是|string|展示图片资源|
|maskImg    |是|string|遮罩图片资源|
|clearHei 	|否|int|刮除高度, 默认16|
|moveTime	|是|int|刮除时间, 单位: 秒|
|beginTime  |否|int|开始点击到结束触发间隔, 单位: 秒|
- 示例代码

```
	-- 刮图两秒 自动展示
 	local TT = GUI:ScrapePic_Create(GUI:Attach_LeftBottom(), "ScrapePic", 250, 200, "res/public/word_fubentg_11.png", "res/public/mask_1.png", 18, 2, 5, function()
        SL:Print("刮图完毕|||")
  	end)
```

