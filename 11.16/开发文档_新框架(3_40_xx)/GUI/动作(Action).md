[TOC]
#播放动作
## runAction(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|obj|动作内容|

## getActionByTag(widget, tag)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|tag        |是|int|动作标记|
-- 通过标记获取动作内容

#停止所有动作
## stopAllActions(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget       |是|obj|控件对象|

## stopActionByTag(widget, tag)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|tag        |是|int|动作标记|
-- 通过标记停止动作

# 移动
## ActionMoveTo(time, x, y)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
- 移动到B点：以世界坐标系为原点(0,0)

## ActionMoveBy(time, x, y)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
- A点移动到B点 移动相对位置：以A点为原点(0,0)

# 缩放
## ActionScaleTo(time, ratio, ...)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|ratio      |是|int|缩放比例（百分比）|
- 放大或缩小到某一比例
- 有第三个参数时, 后两位参数分别表示X轴缩放比、Y轴缩放比 **3.40.8版本新增**

## ActionScaleBy(time, ratio, ...)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|ratio      |是|int|缩放比例（百分比）|
- 放大或缩小到原来的某一比例
- 有第三个参数时, 后两位参数分别表示X轴缩放比、Y轴缩放比 **3.40.8版本新增**


# 旋转
## ActionRotateTo(time, angle)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|angle      |是|int|旋转角度|
- 旋转到多少角度

## ActionRotateBy(time, angle)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|angle      |是|int|旋转角度|
- 旋转到原来的多少角度

# 淡入淡出
## ActionFadeIn(time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
- 淡入

## ActionFadeOut(time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
- 淡出

# 闪烁
## ActionBlink(time, num)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|time       |是|int|时间|
|num        |是|int|闪烁次数|

# 动画回调函数
## CallFunc(callback)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|callback       |是|function|回调函数|

# 延迟
## DelayTime(time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|callback   |是|int|延迟时间|

# 显示与隐藏
## ActionShow() 显示
## ActionHide() 隐藏

# 移除自身
## ActionRemoveSelf()

# 播放顺序
## ActionSequence(action, ...) 多个动作顺序播放
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|

*示例 : * 
```
	local function callback()
		SL:Print("_____")
	end
	GUI:runAction(item., GUI:ActionSequence(GUI:ActionScaleTo(0.1, 1.4), GUI:ActionScaleTo(0.1, 1), GUI:CallFunc(callback)))
```

## ActionSpawn(action, ...) 多个动作同时播放
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|

# 循环播放
## ActionRepeat(action, time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|
|value       |是|int|循环次数|

## ActionRepeatForever(action)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象（一直循环）|

# 复合动作
## ActionEaseBackIn(action) 加速度向右，反方向缓慢移动
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|
## ActionEaseBackOut(action) 快速移动到结束，然后缓慢返回到结束
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|

# 贝塞尔曲线运动
## ActionBezierTo(time, controlPoint_1, controlPoint_2, endPosition)
|参数        	|必选|类型|注释|
|:----      	|:-|:--|:---|
|time       	|是|int|时间|
|controlPoint_1 |是|table|控制点1 坐标|
|controlPoint_2 |是|table|控制点2 坐标|
|endPosition    |是|table|结束坐标|

*示例 : * 
```
	local btn = GUI:Button_Create(GUI:Attach_LeftBottom(), "btn1", 200, 200, "res/public/1900000510.png")
	local startPos = GUI:p(200, 200)
	local endPos = GUI:p(600, 200)
	local controlPoint_1 = GUI:p(200, 800)
	local controlPoint_2 = GUI:p(600, 500)
	local endPosition = endPos
	local bezier = GUI:ActionBezierTo(2, controlPoint_1, controlPoint_2, endPosition)
	GUI:runAction(btn, bezier)
```

# 指数缓冲动作
## ActionEaseExponentialIn(action) 缓慢开始, 加速结束
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|

## ActionEaseExponentialOut(action) 加速开始, 缓慢结束
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|

## ActionEaseExponentialInOut(action) 动作缓慢开始和终止
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|action     |是|obj|动作对象|











