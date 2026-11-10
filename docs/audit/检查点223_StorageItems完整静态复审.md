# 检查点 #223：StorageItems 224指令完整静态复审

日期：2026-11-10
原型：`root.children[50]`（legacy `root/51`）
物理指令：224；常量：57；子原型：2；捕获：3。

## 父级捕获

- UPVALUE[0]：存仓状态表，按行为命名为`storageState`。
- UPVALUE[1]：前置检查失败/背包为空提示，并作为Nested_isOutputted的输出回调，按行为命名为`notify`。
- UPVALUE[2]：使用物品、存仓过程、仓库满及完成提示回调，按行为命名为`output`。
- 原始作者变量名未知，不虚构。

## 主体流程

1. PC1-PC7检查isStoring，正在存仓则直接返回，否则置位。
2. PC14-PC23检查可用仓库页；失败时提示并复位。
3. PC24-PC58读取最大页、每页容量、开放格数和每页占用；建立目标页查找闭包。
4. PC61-PC80构造18项特殊名称表；PC81-PC83构造单项过滤表。
5. PC84-PC95读取背包；为空则提示、复位并返回。
6. PC100-PC104初始化MakeIndex去重表、请求计数和Nested_isOutputted闭包。
7. PC105-PC176只遍历一次背包pairs；按MakeIndex去重、过滤绑定物品、执行单项名称匹配，并逐项检查18个特殊名称。
8. 每个特殊名称匹配后立即调用Nested_isOutputted；其返回值false/nil时立刻跳过当前物品，不允许后续名称匹配覆盖该结果。
9. PC177-PC186每件候选物品重新查找目标页；无可用页时输出仓库满、复位状态并退出。
10. PC187-PC205输出存仓过程提示，并调用LuaSendMsg，七个实参顺序保持：`MSG_CS_STORAGE_STORE_REQUEST, 999999999, item.MakeIndex, targetPage, 0, item.Name, string.len(item.Name)`。
11. PC206-PC211仅在发送调用返回后更新本地MakeIndex去重、页占用和请求计数；不将本地计数视为服务端确认。
12. PC214-PC224复位isStoring；queuedCount大于0时输出完成提示。

## 子原型

- child0 Nested_isOutputted：独立恢复，捕获storageState与notify。
- child1 Nested_Anonymous_2：独立恢复，按maxPage/pageCapacity/openSize/storedPageData查找目标页。

## 结论与边界

224条父指令和两个子原型的静态主体均已闭合。999999999的协议语义、服务器字段含义及宿主代理实现不属于本函数字节码可证明范围，原样保留，不做推测。完整静态恢复，未运行时验证。
