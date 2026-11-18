[TOC]
# 创建人物模型
## UIModel_Create(parent, ID, x, y, sex, feature, scale, useStaticScale, job, ext_param)
|参数 |必选|类型|注释|
|:---- |:-|:--|:---|
|parent |是|obj|父节点对象|
|ID |是|string|唯一ID|
|x |是|int|位置 横坐标|
|y |是|int|位置 纵坐标|
|sex |是|int|0 男性 1 女性|
|feature |是|table|模型属性|
|scale |否|int|缩放比例(0-1)|
|useStaticScale|否|boolean|是否使用game_data配置staticSacle数据, 默认忽略|
|job |否|int|职业id 012 战法道等新增职业 [3.40.5版本新增字段]|
|ext_param |否|table|额外参数列表 [3.40.8版本新增字段]|
- 示例代码

```tips
feature 使用方法可参考引擎 PlayerEquip.lua 脚本
```
```
-- feature 使用方法
--！！除特效ID外 其余装备ID传入对应装备数据的Looks参数.
---local feature= {}
---feature.clothID            -- 衣服
---feature.weaponID           -- 武器id
---feature.headID             -- 头盔id
---feature.headEffectID       -- 头盔特效id
---feature.weaponEffectID     -- 武器特效id
---feature.clothEffectID      -- 衣服特效id
---feature.capID              -- 斗笠id
---feature.shieldID           -- 盾牌id
---feature.shieldEffectID     -- 盾牌特效id
---feature.tDressID           -- 时装id
---feature.tDressEffectID     -- 时装特效id
---feature.tWeaponID          -- 时装武器id
---feature.tWeaponEffectID    -- 时装武器特效id
---feature.capEffectID        -- 斗笠特效id
---feature.veilID             -- 面巾id
---feature.veilEffectID       -- 面巾特效id
---feature.showNodeModel      -- 是否显示裸模
---feature.showHair           -- 是否显示头发
---feature.showHelmet         -- 是否显示头盔
---feature.hairID             -- 头发id
---feature.embattlesID        -- 法阵id列表(table)     
local UIModel = GUI:UIModel_Create(parent, "UIMODEL", 0, 0, 0, feature)
```


