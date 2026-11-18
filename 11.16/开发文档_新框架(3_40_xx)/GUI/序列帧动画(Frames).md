[TOC]
# 创建序列帧动画
## Frames_Create(parent, ID, x, y, prefix, suffix, beginframe, finishframe, ext)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|prefix     |是|string|前缀|
|suffix     |是|string|后缀|
|beginframe |否|int|起始帧, 默认1|
|finishframe|否|int|结束帧|
|ext        |否|table|附加参数 {speed = 播放速度(毫秒),<br> count = 图片数量,<br>  loop = 播放次数(-1: 循环),<br>  finishhide = 播放结束是否隐藏(1: 隐藏)<br>callback = 播放结束回调|
- 示例代码

```
 	local ext = {
        count = 10,
        speed = 100,
        loop  =  1,
        finishhide = 1,
        callback  = function ()
        	SL:Print("创建序列帧动画结束回调")
        end
    }
	local frames = GUI:Frames_Create(wnd, "Frames_1", 200, 200, "res/public/word_fubentg_", ".png", 1, 10, ext)
```
