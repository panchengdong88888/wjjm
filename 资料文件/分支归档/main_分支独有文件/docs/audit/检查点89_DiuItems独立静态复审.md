# 检查点 #89：DiuItems 独立静态复审与状态升级

日期：2026-11-09
原型：`root.children[46]`（legacy `root/47`），169 条物理指令、64 个常量、1 个子原型。
源码：`04_源码候选/root46_DiuItems.lua`
结论：**完整静态恢复（未运行时验证）**。不是原始源码逐字节恢复；变量名为可读重命名。

## 复审范围与结论

逐段对照 corrected phase3 物理 PC 反汇编、原型索引、闭包捕获映射、GetDroppedItems / ShowLocalNoticeByType 辅助函数及现有检查点 #11–#14，复核源码控制流与数据流。

- **捕获身份**：父 root PC63 创建 DiuItems，捕获父 T[2]、T[5]；对应模块状态表（UP[0]）和 ShowLocalNoticeByType（UP[1]）。子闭包 root.children[46].children[0] 捕获 DiuItems T[5] 关键词表。
- **入口及提前退出**：PC1 上限 35；PC2–8 防重入并设置 isDiuing；PC9–13 使用 GetDroppedItems 第二返回值，false/nil 归零；PC14–26 处理初始数量大于35；PC27–35 读取 BAG_DATA，缺失则清理状态返回。
- **筛选循环**：PC69–114 为 pairs(BAG_DATA)；迭代器第一返回值是 key，第二返回值是 item。item、Name、MakeIndex 必须 truthy；PC82–88 调用 SL:GetMetaValue("ITEM_IS_BIND", item)，返回 truthy 时跳过当前物品。
- **死分支**：PC36 将 R4 设为 1，活动路径至 PC89 前没有改写；PC89 的 R4==1 恒真，PC90 跳过唯一 matcher 调用区 PC91–95。关键词表/闭包仍在字节码中构造，但实际活动路径不会调用 matcher。源码以注释说明并省略纯局部构造，不将其误写为有效筛选条件。
- **候选记录**：PC99–112 插入 `{makeIndex=item.MakeIndex, count=item.OverLap or 1, name=item.Name}`；false/nil OverLap 均回退到1。
- **空候选**：PC115–123 输出“背包无可丢弃物品”，清除 isDiuing 后返回。
- **丢弃循环**：PC124–160 为 ipairs(candidates)；PC129 比较 35<=当前地面数量，满35时输出固定文案“地面物品已满35件，停止丢弃”并退出循环；未满时逐项提示并发送。
- **消息协议**：PC143–156 的参数顺序为 MsgType.MSG_CS_MAP_ITEM_DISCARD、makeIndex、count、0、0、name、string.len(name)。
- **计数与清理**：每次消息发送后 PC157 发送次数+1，PC158 地面数量+1；PC161–169 汇总发送次数、清除 isDiuing 并返回。

## 状态清理与边界

所有静态可见正常/提前退出路径均已在草稿中表达：初始超限、BAG_DATA缺失、候选为空、丢弃循环完成/达到上限。防重入路径不清除他人持有的 isDiuing 标记。函数没有可见 pcall/xpcall/finally；外部调用抛错时标记可能遗留为 true。

## 仍未验证的事项

- 运行时 API 副作用、服务端消息实际接受情况及异常行为未在宿主环境执行验证。
- 关键词匹配区为何保留在字节码中但活动路径不可达，原因未知；不推测其设计意图。
- 不声称恢复了原始局部变量名或原始源码格式。

## 本批状态变化

- 普通 Lua 草稿数量不变：77。
- 完整静态恢复数量：29 → 30 / 110。
- 运行时验证：仍为 0。
- DiuItems 从“首版普通 Lua 草稿（已独立复审）”升级为“完整静态恢复（未运行时验证）”。
- 下一目标按机器状态：继续 Nested_FFFF00 的资源刷新数据流复核，重点是 MoneyProxy 绑定/非绑定分支、Nested_string 多返回值布局及 GUI 构造参数；不重复已闭合的 DiuItems。
