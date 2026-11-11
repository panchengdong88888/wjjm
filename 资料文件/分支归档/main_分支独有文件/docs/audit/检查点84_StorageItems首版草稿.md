# 检查点 #84：StorageItems 首版普通 Lua 草稿

日期：2026-11-09  
源码：04_源码候选/短函数草稿_第六十批.lua  
状态：首版普通Lua控制流草稿；未运行时验证；不可当作可直接执行的协议实现。

## 原型身份
- 名称 StorageItems；原型索引97。
- 规范路径 root.children[50]；legacy root/51。
- 224条物理指令、57常量、2个子原型、vararg_flag=0。
- root PC73创建主闭包，捕获3个父寄存器（主函数upvalue身份未完整映射）。
- child 0：root.children[50].children[0] / root/51/1，原型索引98，52条指令；已有Nested_isOutputted草稿（检查点56）。
- child 1：root.children[50].children[1] / root/51/2，原型索引99，27条指令；捕获4个父寄存器，当前仍处阶段分析，未升级源码草稿。

## 已恢复的主体结构
1. 检查捕获状态字段isStoring；已在存仓时直接返回，否则置true。
2. 检查NPCStorageProxy；缺失时复位isStoring并返回。
3. 读取GetAvailableStoragePage；失败时提示“仓库已满,无法存仓”，复位状态并返回。
4. 读取GetMaxPage、GUIDefine.STORAGE_PER_PAGE_MAX（缺失时回退global.MMO.NPC_STORAGE_MAX_PAGE）、GetOpenSize。
5. PC37-PC53按页调用GetStorageDataByPage并汇总页数据的循环结构。
6. PC61-PC79构造由18个物品名称组成的特殊名称列表。
7. 读取SL.GetMetaValue("BAG_DATA")；无背包数据时提示“背包物品为空”，复位并返回。
8. PC102创建child0闭包Nested_isOutputted；该子函数已有独立草稿，识别“聚灵珠”、输出物品信息并检查Dura/DuraMax。
9. PC105-PC150包含pairs遍历、MakeIndex/ITEM_IS_BIND读取、ipairs/string.find名称筛选、ITEM_INDEX_BY_NAME读取及UseItemByIndex调用，伴随“使用: ”输出。
10. PC151-PC176包含第二段ipairs/string.find筛选循环。
11. PC177-PC186容量/页数检查失败时提示仓库已满并复位isStoring。
12. PC187-PC215遍历候选物品、输出“存: ”并构造LuaSendMsg(MSG_CS_STORAGE_STORE_REQUEST, ...)存仓请求；末尾复位isStoring并可能输出存仓完成数量。

## 关键未闭合点
- 主函数3个upvalue的父寄存器身份及isStoring所属对象尚未完整映射。
- PC37-PC53的页数边界、页数据汇总结构与PC54创建的child1之间的关系待复核。
- child1（Nested_Anonymous_2）4个捕获值、27条指令中的算术顺序、动态表索引及返回值契约仍未闭合；本源码中的pageCalculation是显式占位，不是已确认调用。
- 特殊名称表的用途、各物品分支的过滤/使用条件需结合融合载荷复核；源码展示的是控制流骨架。
- child0 Nested_isOutputted的调用点、实参位置、输出回调闭包及返回值如何影响后续过滤尚未闭合。
- PC105-PC176两段遍历的容器、条目字段和筛选逻辑有差异，不能合并成已确认的统一过滤规则。
- LuaSendMsg的全部实参顺序、999999999常量含义、MakeIndex/绑定标记/名称长度等字段布局未确认。源码中消息调用是占位表达，不能用于真实服务端协议。
- storedCount是否统计发送尝试还是服务器确认成功、完成提示条件待核。
- isStoring在异常情况下是否保证复位未知。

## 统计
- 本批新增普通Lua草稿：1个（StorageItems主原型）。
- 累计普通Lua草稿：74个（含本批BlacklistPlayerDetection及StorageItems）。
- 完整静态恢复仍29/110（26.4%）。
- 运行时验证仍0。
- child1 Nested_Anonymous_2仍为阶段分析，不计入草稿数；child0已有草稿不重复计数。
