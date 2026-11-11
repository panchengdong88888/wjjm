# 检查点 #206：StorageItems 普通 Lua 草稿复审与控制流修正

日期：2026-11-10
原型：`root.children[50]`（legacy `root/51`）
规模：224条物理指令、57常量、2个子原型、非变参
源码：`04_源码候选/短函数草稿_第六十批.lua`
反汇编：`03_静态反汇编/MainLeftBottom_vm_disassembly_corrected_phase3.txt`

## 本批工作

重新读取了 StorageItems 当前普通 Lua 草稿和完整 PC1-PC224 反汇编，并针对筛选循环进行控制流对照。没有重复处理两个子原型：child0 Nested_isOutputted（52条）及 child1 Nested_Anonymous_2（27条）均沿用既有静态恢复。

## 已对照的主体路径

- PC1-PC13：读取共享状态 isStoring；已在存仓时直接返回，否则先置true。
- PC14-PC23：零参调用 GetAvailableStoragePage；失败时用UP1通知“仓库已满,无法存仓”，复位isStoring并返回。
- PC24-PC36：NPCStorageProxy:GetMaxPage、GUIDefine.STORAGE_PER_PAGE_MAX假值回退global.MMO.NPC_STORAGE_MAX_PAGE、NPCStorageProxy:GetOpenSize。
- PC37-PC53：按页号从1到maxPage读取GetStorageDataByPage；有数据取#pageData，无数据记0。
- PC54-PC58：创建child1工厂，捕获maxPage/pageCapacity/openSize/storedPageData。
- PC61-PC83：18个特殊名称及单元素过滤表{"待定"}。
- PC84-PC95：读取SL:GetMetaValue("BAG_DATA")；假值时通知“背包物品为空”、复位状态并返回。
- PC100-PC104：创建本轮MakeIndex去重表、请求计数及child0工厂；捕获storageState/notify。
- PC105-PC119：pairs遍历背包；读取item.MakeIndex，缺失或已处理则跳过；ITEM_IS_BIND以完整item对象查询，truthy则跳过。
- PC120-PC150：单元素过滤表ipairs循环；string.find(item.Name, filterName, 1, true)命中时读取ITEM_INDEX_BY_NAME、调用SL:UseItemByIndex并输出“使用: ”提示。
- PC151-PC176：对18项特殊名称逐项纯文本匹配；每次匹配调用child0(item,specialName)，其返回值立即受truthy门控。**发现并修正旧草稿的语义偏差：任意一次匹配后的child0返回false/nil，都会立即跳过当前背包物品；不能继续循环并允许后续匹配覆盖失败结果。**新草稿用matchedSpecialName、shouldStore和break表达该短路；没有匹配名称也不存仓。
- PC177-PC186：每件通过筛选的物品重新调用child1查找目标页；没有页时输出仓库满提示、复位状态并结束函数。
- PC187-PC205：输出“存: ”提示；七项LuaSendMsg调用依次传递消息类型、999999999、MakeIndex、targetPage、0、Name、string.len(Name)。
- PC206-PC211：请求调用返回后才写MakeIndex去重表、增加目标页占用计数及queuedCount。
- PC212-PC224：pairs循环继续；循环结束复位isStoring；queuedCount>0时输出完成数量提示。

## 临时名称与未解决项

- UP0按读写角色命名storageState；UP1按回调用途命名notify；UP2按提示用途命名output。均非作者原始业务名证明。
- 999999999的协议含义未知；服务端第四字段正式定义未知。只保留字节码参数位置和值，不将其解释为页码/角色/操作码等业务语义。
- GetAvailableStoragePage、NPCStorageProxy、SL、GUI/游戏宿主API没有运行时验证。
- VM常量过滤项“待定”照录，不推断为通配符或占位业务类别。
- 本批只完成普通Lua草稿控制流复审及一处语义修正；不升级为完整静态恢复，不计入运行时验证。

## 下一步

继续处理root.children[42] doInit_UI及尚为草稿的Nested_FFFF00/Nested_Anonymous依赖；优先批量补足普通Lua可读主体，再集中静态校正。StorageItems保留草稿等级，后续如需提升完整静态恢复等级，需对父捕获和服务端消息协议做独立审计。
