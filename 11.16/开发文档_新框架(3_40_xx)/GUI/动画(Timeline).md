[TOC]
#界面弹窗特效
## Timeline_Window1(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=03f85a6ed2e55e4683fcfa2b2065ef89)


## Timeline_Window2(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=680189876aeeed47b9a4146b5b5fe836)


## Timeline_Window3(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=295f3c9fdd8a23f472baadd4e3da2b91)


## Timeline_Window4(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=576798efe374c994ec5420673ce7c2bf)


## Timeline_Window5(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=300d9ba741e3140577e17e3b878a261e)


## Timeline_Window6(widget, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|timelineCB |是|function|回调函数|
- 弹窗效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=dc71a59d3d406543465c92db7c69bf2b)


# 设置动画标记
## Timeline_SetTag(action, tag)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|tag        |是|int|标记值|


# 停止所有动画
## Timeline_StopAll(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|


## Timeline_StopByTag(widget, tag)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|tag        |是|int|标记值|
- 通过标记停止动画


# 动画淡出效果
## Timeline_FadeOut(widget, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 淡出效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=3900ccbab7b16c56dbcfb2fc62cd18b2)


## Timeline_FadeIn(widget, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|


> **淡入需要先设置控件透明度**


- 淡入效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=51a54ae9f13a972b70e71e2cba2d025d)


## Timeline_FadeTo(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|透明度(0-255)|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 修改透明度到某个值
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=81918cf5e2aaf95e6eded401758fa4db)


# 放大缩小动画
## Timeline_ScaleTo(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|缩放比例(0-100)|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 放大缩小到某个比例（放大缩小到原始的倍数）
```lua
-- 实际上图片只放大了2倍
local img = GUI:Image_Create(parent, "img", 0, 0, "res/bg.png")
GUI:Timeline_ScaleTo(img, 2, 1, nil)
GUI:Timeline_ScaleTo(img, 2, 1, nil)
```
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=fc336fbabc3a576209d113141791986e)


## Timeline_ScaleBy(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|缩放比例(0-100)|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 放大缩小到某个比例（放大缩小多少倍数）
```lua
-- 实际上图片放大了4倍
local img = GUI:Image_Create(parent, "img", 0, 0, "res/bg.png")
GUI:Timeline_ScaleBy(img, 2, 1, nil)
GUI:Timeline_ScaleBy(img, 2, 1, nil)
```
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=9e8394c7a44e7232fae9d2500167771f)



# 旋转动画
## Timeline_RotateTo(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|旋转角度(0-360)|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 旋转到某个角度（旋转到指定角度）
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=42b1c0005259534480b7cd6f059dc3aa)


## Timeline_RotateBy(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|旋转角度(0-360)|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 旋转到某个角度（从原来角度 旋转到 某个角度）



# 移动动画
## Timeline_MoveTo(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|table|{x = 0, y = 0}|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 移动到某坐标（移动绝对位置）
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=0f04a0785fb11a638b54455340566c9d)


## Timeline_MoveBy(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|table|{x = 0, y = 0}|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 移动到某坐标（移动相对位置）


# 闪烁动画
## Timeline_Blink(widget, value, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|value      |是|int|闪烁次数|
|time       |是|int|时间|
|timelineCB |是|function|回调函数|
- 闪烁效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=7a39a973ecae51a8f66748c0da9e5faa)


# 震动动画
## Timeline_Shake(widget, time, x, y, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|x          |是|int|X轴震动像素|
|y          |是|int|Y轴震动像素|
|timelineCB |是|function|回调函数|
- 震动效果
![](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=782737b2cce9e0cbe34f030b1e870faf)


# 疯狂抖动动画
## Timeline_Waggle(widget, time, angle)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|时间|
|angle      |是|int|抖动幅度（0-360）|
- 震动效果



# 动画延迟播放
## Timeline_DelayTime(widget, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|延迟时间|
|timelineCB |是|function|回调函数|


# 动画回调方法
## Timeline_CallFunc(widget, time, timelineCB)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|延迟时间|
|timelineCB |是|function|回调函数|


# 动画延迟显示
## Timeline_Show(widget, time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|延迟时间|


# 动画延迟隐藏
## Timeline_Hide(widget, time)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|控件对象|
|time       |是|int|延迟时间|


# 缓动动画
## Timeline_EaseSineIn_MoveTo(widget, value, time, callback)


` widget 对象由慢到快，移动到目标位置 `


|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|table|目标坐标位置|
|time       |是|int|动作时间|
|callback   |否|function|动作执行完的回调|


## Timeline_EaseSineOut_MoveTo(widget, value, time, callback)


` widget 对象由快到慢，移动到目标位置 `


|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象|
|value      |是|table|目标坐标位置|
|time       |是|int|动作时间|
|callback   |否|function|动作执行完的回调|


## Timeline_DigitChange(widget, cur, target, interval)


` widget 数字滚动动画 `


|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|对象 [ 仅限Button、Text控件] （3.40.8支持TextAtlas控件）|
|cur        |是|int|当前数值|
|target     |是|int|目标数值|
|interval   |否|int|变动间隔（秒）|



































