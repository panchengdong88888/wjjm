[TOC]
# 创建粒子特效
## ParticleEffect_Create(parent, ID, x, y, res)
|参数 |必选|类型|注释|
|:---- |:-|:--|:---|
|parent |是|obj|父节点对象|
|ID |是|string|唯一ID|
|x |是|int|位置 横坐标|
|y |是|int|位置 纵坐标|
|res |是|string|粒子特效资源路径 plist文件|

# 设置持续时间
## ParticleEffect_setDuration(widget, value)
|参数 |必选|类型|注释|
|:---- |:-|:--|:---|
|widget |是|obj|粒子特效|
|value |是|int|持续时间, 单位: 秒 <br> -1 表示永久|

# 设置总粒子数量
## ParticleEffect_setTotalParticles(widget, value)
|参数 |必选|类型|注释|
|:---- |:-|:--|:---|
|widget |是|obj|粒子特效|
|value |是|int|数量|

示例代码
对应资源: [petal_1.zip](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=04cda6e507da9c0f3835f66758532583 "[petal_1.zip")
```
	local widget = GUI:ParticleEffect_Create(GUI:Attach_LeftBottom(), "TT", 568, 320, "res/private/particles/petal_1.plist")
    GUI:ParticleEffect_setDuration(widget, -1)
    GUI:ParticleEffect_setTotalParticles(widget, 999)
```
