[TOC]
# 创建Spine动画
## SpineAnim_Create(parent, ID, x, y, jsonPath, atlasPath, trackIndex, name, loop)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|jsonPath   |是|string|json文件路径|
|atlasPath  |是|string|atlas文件路径|
|trackIndex |是|int|轨道索引|
|name       |是|string|动画名|
|loop       |是|boolean|动画是否循环|
- 示例代码
示例资源： [nandaoshi.zip](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=09c2fd9bddb3643207257448ff81e6d7 "[nandaoshi.zip")

```lua
GUI:SpineAnim_Create(GUI:Attach_LeftBottom(), "Spine_1", 200, 100, "res/custom/nandaoshi/nandaoshi.json", "res/custom/nandaoshi/nandaoshi.atlas", 1, "animation", true)
```

## Spine38Anim_Create(parent, ID, x, y, jsonPath, atlasPath, trackIndex, name, loop)
* 3.8版本spine动画 参数同上.
- 示例代码
  示例资源：[hero.zip](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=ae109dbe1b3d9cfebcaee2612f3641ab "[hero.zip")

```
GUI:Spine38Anim_Create(GUI:Attach_LeftBottom(), "Spine_hero", 400, 200, "res/custom/hero-ess.json", "res/custom/hero.atlas", 1, "attack", true)
```

- 3.40.xx 版本使用示例

```
	if SL:GetMetaValue("SPINE_VERSION") == "spine 2.1" then
        -- 创建2.1版本spine
        GUI:SpineAnim_Create(GUI:Attach_LeftBottom(), "Spine_1", 200, 100, "res/custom/nandaoshi/nandaoshi.json", "res/custom/nandaoshi/nandaoshi.atlas", 1, "animation", true)

    elseif SL:GetMetaValue("SPINE_VERSION") == "spine 3.8" then
        -- 创建3.8版本spine
        GUI:Spine38Anim_Create(GUI:Attach_LeftBottom(), "Spine_hero", 400, 200, "res/custom/hero-ess.json", "res/custom/hero.atlas", 1, "attack", true)

    else
        -- 不支持spine
    end
```
# 设置动画播放
## SpineAnim_setAnimation(widget, trackIndex, name, loop)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|trackIndex |是|int|轨道索引|
|name       |是|string|动画名|
|loop       |是|boolean|动画是否循环|

# 在指定轨道添加动画播放
## SpineAnim_addAnimation(widget, trackIndex, name, loop)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|trackIndex |是|int|轨道索引|
|name       |是|string|动画名|
|loop       |是|boolean|动画是否循环|
* 等指定轨道当前动画结束单次循环后, 开始这个动画的播放

# 在指定轨道添加动画播放
## SpineAnim_addAnimation(widget, trackIndex, name, loop)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|trackIndex |是|int|轨道索引|
|name       |是|string|动画名|
|loop       |是|boolean|动画是否循环|
* 等指定轨道当前动画结束单次循环后, 开始这个动画的播放

# 动画衔接
## SpineAnim_setMix(widget, fromAnimName, toAnimName, duration)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|fromAnimName |是|string|起始动画名|
|toAnimName   |是|string|目标动画名|
|duration     |是|float|过渡时间|
* 设置从指定动画过渡到另一动画时的mix持续时间


------------

# **以下接口供 spine3.8版本 使用! 3.40.9版本新增!**

# 清除轨道所有动画
## SpineAnim_clearTracks(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|

# 清除指定轨道动画
## SpineAnim_clearTrack(widget, trackIndex)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|trackIndex |是|int|轨道索引|

# 获取动画播放速度
## SpineAnim_getTimeScale(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
* 返回 float 数值

# 设置动画播放速度
## SpineAnim_setTimeScale(widget, scale)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|scale		|是|float|播放间隙缩放值 / 播放速度|
* 默认为1, 数值越大 播放越快

# 重置初始姿态
## SpineAnim_setToSetupPose(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|

# 重置插槽到初始设定
## SpineAnim_setSlotsToSetupPose(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|

# 查找动画
## SpineAnim_findAnimation(widget, name)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|name		|是|string|动画名称|
* 返回为nil 则动画不存在

# 设置皮肤
## SpineAnim_setSkin(widget, name)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|skinName	|是|string|皮肤名称|

# 是否绕X轴翻转
## SpineAnim_setFlipX(widget, bool)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|bool	|是|boolean|是否翻转|

# 是否绕Y轴翻转
## SpineAnim_setFlipY(widget, bool)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|bool	|是|boolean|是否翻转|

# 设置插槽内附件
## SpineAnim_setAttachment(widget, slotName, attachmentName)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|slotName	|是|string|插槽名称|
|attachmentName|是|string|附件名称|
* 此附件在本插槽内

# 获取插槽内附件
## SpineAnim_getAttachment(widget, slotName, attachmentName)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|slotName	|是|string|插槽名称|
|attachmentName|是|string|附件名称|
* 返回 SpineAttachment 附件

# 查找插槽对象
## SpineAnim_findSlot(widget, slotName)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|slotName	|是|string|插槽名称|
* 返回 SpineSlot 插槽对象

# 获取所有插槽对象
## SpineAnim_getSlots(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
* 返回 SpineSlot 插槽对象 列表

# 注册监听事件回调
## SpineAnim_registerSpineEventHandler(widget, handler, eventType)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineAnim对象|
|handler	|是|function|回调方法|
|eventType	|是|int|事件类型<br> 参考:SLDefine.SpineAnimEventType|
```
	handler 回调参数 param1: table值, 参考如下:
    {
        animation: "xxanimation",   -- 动画名
        loopCount: 1,               -- 循环次数
        trackIndex: 0,              -- 轨道索引
        type: "xxx"                 -- 事件类型 "start" "interrupt" "end" "dispose" "complete" "event"
        eventData: table            -- 自定义事件数据 {name: "xx", floatValue: 0, intValue: 0, stringValue: ""}
    }
	
	spineAnim事件类型如下:
	SLDefine.SpineAnimEventType = {
		Start       = 0,
		Interrupt   = 1,
		End         = 2,
		Complete    = 3,
		Dispose     = 4,
		Event       = 5
	}
```

# 插槽对象 SpineSlot
# 获取插槽对象颜色
## SpineSlot_getColor(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineSlot对象|
* 返回颜色table, {r = 1, g = 1, b = 1, a = 1} 数值0-1

# 设置插槽对象颜色
## SpineSlot_setColor(widget, r, g, b, a)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineSlot对象|
|r			|是|float|红 (数值0-1)|
|g			|是|float|绿 (数值0-1)|
|b			|是|float|蓝 (数值0-1)|
|a			|是|float|透明度 (数值0-1)<br> 0: 完全透明 1: 完全不透明|

# 设置插槽对象可见性
## SpineSlot_setVisible(widget, isVisible)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineSlot对象|
|isVisible	|是|boolean|是否可见|

# 设置插槽对象的附件
## SpineSlot_setAttachment(widget, attachment)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget 	|是|widget|SpineSlot对象|
|attachment	|是|widget|SpineAttachment对象|

# 接口示例代码
* **示例资源**: [custom.zip](https://engine-doc.996m2.com/server/index.php?s=/api/attachment/visitFile&sign=2d2e7755042f52dc8fe7ab7cbb07c470 "[custom.zip")

```
	-- 3.40.9 测试代码
    -- 1. 动画衔接
    local parent = GUI:Attach_LeftBottom()
    local spineBoyAnim = GUI:Spine38Anim_Create(parent, "spineBoy", 300, 300, "res/custom/spine/spineboy/spineboy-ess.json", "res/custom/spine/spineboy/spineboy.atlas", 0, "walk", false)
    GUI:setScale(spineBoyAnim, 0.4)

    -- 注册事件
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____START")
    end, SLDefine.SpineAnimEventType.Start)
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____INTERRUPT")
    end, SLDefine.SpineAnimEventType.Interrupt)
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____END")
    end, SLDefine.SpineAnimEventType.End)
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____COMPLETE")
    end, SLDefine.SpineAnimEventType.Complete)
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____DISPOSE")
    end, SLDefine.SpineAnimEventType.Dispose)
    GUI:SpineAnim_registerSpineEventHandler(spineBoyAnim, function(eventData)
        SL:PrintTable(eventData, "____EVENT")
    end, SLDefine.SpineAnimEventType.Event)

    GUI:SpineAnim_setTimeScale(spineBoyAnim, 1.4)
    GUI:SpineAnim_setToSetupPose(spineBoyAnim)
    GUI:SpineAnim_setAnimation(spineBoyAnim, 0, "run", false)
    GUI:SpineAnim_addAnimation(spineBoyAnim, 0, "jump", true)
    GUI:SpineAnim_setMix(spineBoyAnim, "run", "jump", 0.3)

    SL:ScheduleOnce(function()
        -- GUI:SpineAnim_clearTracks(spineBoyAnim)
        GUI:SpineAnim_clearTrack(spineBoyAnim, 0)
    end, 3)

    -- 2. 更换武器/皮肤
    local goblinsAnim = GUI:Spine38Anim_Create(parent, "goblinsAnim", 600, 300, "res/custom/spine/goblins/goblins-ess.json", "res/custom/spine/goblins/goblins.atlas", 0, "walk", true, 0.8)
    GUI:SpineAnim_setSkin(goblinsAnim, "goblin")
    -- GUI:SpineAnim_setSkin(goblinsAnim, "goblingirl")

    local btn_1 = GUI:Button_Create(parent, "btn_1", 800, 500, "res/public/1900000673.png")
    GUI:Button_setTitleText(btn_1, "还原动画")
    GUI:addOnClickEvent(btn_1, function()
        GUI:SpineAnim_setToSetupPose(goblinsAnim)
        -- 重置插槽
        -- GUI:SpineAnim_setSlotsToSetupPose(goblinsAnim)
    end)

    local btn_2 = GUI:Button_Create(parent, "btn_2", 800, 420, "res/public/1900000673.png")
    GUI:Button_setTitleText(btn_2, "更换附件")
    GUI:addOnClickEvent(btn_2, function()
        -- 左手
        GUI:SpineAnim_setAttachment(goblinsAnim, "left-hand-item", "dagger")
        -- 将左手一插槽附件设置到右手插槽附件
        local daggerAttach = GUI:SpineAnim_getAttachment(goblinsAnim, "left-hand-item", "spear")
        local slot = GUI:SpineAnim_findSlot(goblinsAnim, "right-hand-item-top")
        print(slot, daggerAttach)
        if slot and daggerAttach then
            GUI:SpineSlot_setAttachment(slot, daggerAttach)
        end
    end)

    local btn_3 = GUI:Button_Create(parent, "btn_3", 800, 340, "res/public/1900000673.png")
    GUI:Button_setTitleText(btn_3, "调整插槽")
    GUI:addOnClickEvent(btn_3, function()
        -- 不可见
        local slot = GUI:SpineAnim_findSlot(goblinsAnim, "right-hand-item-top")
        if slot then
            GUI:SpineSlot_setVisible(slot, false)
        end
        -- 颜色
        local leftSlot = GUI:SpineAnim_findSlot(goblinsAnim, "left-hand-item")
        if leftSlot then
            GUI:SpineSlot_setColor(leftSlot, 0, 0, 0, 1)
        end
        -- 所有插槽
        -- local slots = GUI:SpineAnim_getSlots(goblinsAnim)
        -- for i = 1, #slots do
        --     local slot = slots[i]
        --     GUI:SpineSlot_setColor(slot, 1, 0, 0, 1)
        -- end
    end)

    local btn_4 = GUI:Button_Create(parent, "btn_4", 800, 260, "res/public/1900000673.png")
    GUI:Button_setTitleText(btn_4, "翻转")
    GUI:addOnClickEvent(btn_4, function()
        -- GUI:SpineAnim_setFlipX(goblinsAnim, true)
        -- Y轴
        GUI:SpineAnim_setFlipY(goblinsAnim, true)
    end)


```