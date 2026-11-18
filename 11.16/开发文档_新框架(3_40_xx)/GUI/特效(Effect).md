[TOC]
# 创建特效
## Effect_Create(parent, ID, x, y, effecttype, effectid, sex, act, dir, speed)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|parent     |是|obj|父节点对象|
|ID         |是|string|唯一ID|
|x          |是|int|位置 横坐标|
|y          |是|int|位置 纵坐标|
|effecttype |是|int|0 特效<br>1 NPC<br>2 怪物<br>3 技能<br>4 人物<br>5 武器<br>6 翅膀<br>7 发型<br>8 盾牌[3.40.3版本]|
|effectid  |是|int|特效id|
|sex       |否|int|性别(0 男 1 女)|
|act       |否|int|0 待机<br>1 走<br>2 攻击<br>3 施法 <br>4 死亡<br>5 跑步|
|dir       |否|int|方向|
|speed     |否|int|播放速度|
- 代码示例

```
-- 特效展示 Ctrl + F4 查看
local sfx = GUI:Effect_Create(parent, "sfx", 0, 0, 0, 4004, 0, 0, 3, 1)
```

# 特效播放
## Effect_play(widget, act, dir, isLoop, speed, isSequence)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|特效对象|
|act        |是|int|0 待机<br>1 走<br>2 攻击<br>3 施法 <br>4 死亡<br>5 跑步|
|dir        |是|int|方向|
|isLoop     |是|bool|是否循环播放|
|speed      |否|int|播放速度|
|isSequence |否|boolean|倒放参数 [仅false为倒放特效 ]|

# 特效停止
## Effect_stop(widget, frameIndex, act, dir)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|特效对象|
|frameIndex |否|int|第几帧|
|act        |否|int|0 待机<br>1 走<br>2 攻击<br>3 施法 <br>4 死亡<br>5 跑步|
|dir        |否|int|方向|

# 特效播放完成事件
## Effect_addOnCompleteEvent(widget, value)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|特效对象|
|value      |是|function|播放完成回调函数|

# 设置特效播放完自动移除 [3.40.3版本]
## Effect_setAutoRemoveOnFinish(widget)
|参数        |必选|类型|注释|
|:----      |:-|:--|:---|
|widget     |是|obj|特效对象|



