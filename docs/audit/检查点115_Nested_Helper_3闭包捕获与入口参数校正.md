# 检查点 #115：Nested_Helper_3 闭包捕获与入口参数校正

日期：2026-11-09  
对象：`root.children[42].children[3].children[3]` / legacy `root/43/4/4`  
物理指令：168；常量：31；子原型：0；vararg_flag=0。

## 本批修订

更新源码：`04_源码候选/资源统计刷新链_第六十四批.lua`。

旧候选把10项捕获值错误地写成了Nested_Helper_3的10个函数参数。VM原型vararg_flag=0，函数本体没有读取显式实参；PC300创建闭包时捕获10项，PC311-PC312立即无参调用，后续由SL:Schedule(refreshCallback,1.0)调度。因此应以闭包工厂表达捕获，实际回调签名为`Nested_Helper_3()`。

## 十项UPVALUE映射

父Nested_FFFF00 PC300-PC310的捕获描述和检查点90/95映射：
0. moduleState：MainLeftBottom模块状态表，读取resWin。
1. timerState：独立定时器状态表，读取/清除resTimer。
2. curTimeText：当前时间Text节点。
3. durTimeText：历时Text节点。
4. initState：初始状态表，读取initTime/initSnapshot。
5. moneyProxy：MoneyProxy代理。
6. moneyRows：货币名称到Text节点的映射表。
7. formatNumber：Nested_Helper_2数值格式化函数。
8. itemRows：物品名称到Text节点的映射表。
9. getItemCount：Nested_string背包资源计数函数。

## 静态控制流复核

- PC1-PC19：窗口无效时，若resTimer存在则SL:UnSchedule并将timerState.resTimer置nil，然后返回。
- PC20-PC38：检查os/time并通过pcall取时间；取时失败跳过时间/历时显示，继续执行货币与物品行刷新，不提前退出。
- PC39-PC58：pcall格式化日期，更新“当前时间:”文本，失败或空值回退“--”。
- PC59-PC94：initTime存在且大于0时计算now-initTime，按3600和60换算小时/分钟，调用formatNumber并更新“历时:”文本。
- PC95-PC137：pairs遍历moneyRows；以资源名称调用MoneyProxy:GetMoneyIdByName；取得ID后调用GetMoneyCountById；快照键为initSnapshot[moneyId]；将当前数量与差值分别格式化后写入对应textNode。
- PC138-PC167：pairs遍历itemRows；调用Nested_string(itemName)取得当前非绑定物品数；快照键为initSnapshot[itemName]；更新对应textNode。
- PC168返回。

## 状态与统计

Nested_Helper_3已属于完整静态恢复；本批只修正普通Lua候选中“捕获被误写成形参”的表达，不增加草稿数或完整静态恢复数。宿主GUI、代理对象和定时器行为仍未运行时验证。

统计保持：普通Lua草稿78；完整静态恢复58/110；运行时验证0。

## 下一步

继续检查Nested_Anonymous（`root.children[42].children[22]`）的VM帧入口与T[0]/T[1]/T[2]初始化，尤其追踪T[2]延迟提示回调的来源；不凭调用包装器的两个实参推断寄存器映射。
