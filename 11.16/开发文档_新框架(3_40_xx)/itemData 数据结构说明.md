
## 基础属性字段


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `Index` | number | 道具索引ID | `itemData.Index` |
| `MakeIndex` | number | 道具唯一标识 | `itemData.MakeIndex` |
| `Name` | string | 道具名称 | `itemData.Name` |
| `StdMode` | number | 道具类型标准模式 | `itemData.StdMode` |
| `Shape` | number | 道具形状/子类型 | `itemData.Shape` |
| `Looks` | number | 道具外观ID | `itemData.Looks` |
| `Color` | number | 道具颜色品质 | `itemData.Color` |
| `Desc` | string | 道具描述 | `itemData.Desc` |


## 数量和持久度


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `OverLap` | number | 道具数量/堆叠数 | `itemData.OverLap` |
| `Dura` | number | 当前持久度 | `itemData.Dura` |
| `DuraMax` | number | 最大持久度 | `itemData.DuraMax` |
| `Weight` | number | 道具重量 | `itemData.Weight` |


## 装备相关属性


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `Where` | number | 装备位置 | `itemData.Where` |
| `Source` | number | 强化等级/强度 | `itemData.Source` |
| `AniCount` | number | 负重值或其他计数 | `itemData.AniCount` |
| `Star` | number | 星级 | `itemData.Star` |
| `attribute` | string | 基础属性字符串 | `itemData.attribute` |


## 特殊属性和效果


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `Values` | table | 极品属性数组 | `itemData.Values` |
| `sEffect` | number | 特效ID | `itemData.sEffect` |
| `bEffect` | number | 背景特效ID | `itemData.bEffect` |
| `newEffect` | string | 新特效 | `itemData.newEffect` |
| `newLooks` | number | 新外观 | `itemData.newLooks` |
| `show` | number | 显示控制 | `itemData.show` |


## 绑定和限制


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `Bind` | string | 绑定信息 | `itemData.Bind` |
| `BindInfo` | string | 绑定详细信息 | `itemData.BindInfo` |
| `Need` | number | 使用需求类型 | `itemData.Need` |
| `startLimitTime` | number | 限时开始时间 | `itemData.startLimitTime` |
| `getServerTime` | number | 服务器时间 | `itemData.getServerTime` |


## 扩展信息


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `ExtendInfo` | table | 扩展信息对象 | `itemData.ExtendInfo` |
| `ExtendInfo.Sockets` | table | 宝石镶嵌槽 | `itemData.ExtendInfo.Sockets` |
| `ExtendInfo.LH0` | table | 刀魂数据0 | `itemData.ExtendInfo.LH0` |
| `ExtendInfo.ItmSrc` | string | 道具来源 | `itemData.ExtendInfo.ItmSrc` |
| `ExAbil` | table | 自定义属性 | `itemData.ExAbil` |
| `ExAbil.abilex` | string | 附加属性字符串 | `itemData.ExAbil.abilex` |


## 时间和计时


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `AddValues` | table | 附加值数组(含时间) | `itemData.AddValues` |
| `touBaoTimes` | number | 投保次数 | `itemData.touBaoTimes` |


## 套装相关


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `suitid` | string | 套装ID字符串 | `itemData.suitid` |
| `originName` | string | 原始名称 | `itemData.originName` |


## 回收和价值


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `huishou` | string | 回收信息 | `itemData.huishou` |
| `honour` | string | 荣誉值信息 | `itemData.honour` |
| `InsureGoldList` | string | 投保金额列表 | `itemData.InsureGoldList` |


## 特殊道具字段


| 字段名 | 类型 | 说明 | 示例用法 |
|--------|------|------|----------|
| `effectParam` | string | 效果参数(药水等) | `itemData.effectParam` |
| `TipsShowAttr` | number | 是否显示属性(宠物装备) | `itemData.TipsShowAttr` |
| `sDivParam1` | string | 物品装备表的ITEMPAEAM1 | `itemData.sDivParam1` |
| `sDivParam2` | string | 物品装备表的ITEMPAEAM2 | `itemData.sDivParam2` |

---

- 具体用法可参考 `ItemTips.lua`
