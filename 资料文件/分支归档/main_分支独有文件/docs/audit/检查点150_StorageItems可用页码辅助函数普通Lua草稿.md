# 检查点 #150：StorageItems 可用页码辅助函数普通 Lua 草稿

日期：2026-11-09（Asia/Singapore）
对象：`root.children[50].children[1]`（legacy root/51/2）
规模：27条物理指令、1个常量、无子原型；父函数StorageItems在PC54创建，捕获4项

## 本批处理

依据既有检查点144对容量算法的寄存器化简结论，直接形成普通 Lua 草稿，不重新重复整个StorageItems主函数分析。

新增源码：
`04_源码候选/root50_Nested_Anonymous_2.lua`

## 捕获映射

父函数 root/51 PC54 创建 child-index 1，PC55-PC58依次把父R1/R2/R3/R4送入捕获槽位0..3。检查点144已确认其语义：

| 子函数捕获槽 | 父级值 | 语义 |
|---|---|---|
| UP[0] | R1 | maxPage |
| UP[1] | R2 | pageCapacity |
| UP[2] | R3 | openSize |
| UP[3] | R4 | storedPageData（每页已存数量表） |

## 草稿表达的逻辑

1. 数值遍历 page=1..maxPage。
2. 普通页的容量上限为 pageCapacity。
3. 最后一页容量上限为 `min(pageCapacity, openSize - (maxPage - 1) * pageCapacity)`。
4. 读取 `storedPageData[page]`，若当前数量小于该页容量上限，立即返回该页码。
5. 所有页均满则返回nil。

父函数在创建/调用子闭包前已准备逐页计数表，空页计数为0，因此本草稿按直接读取计数处理。

## 状态边界

- 本次把检查点144已经完成的容量页码表达式转成可读普通Lua草稿。
- 不把此草稿自动升级为完整静态恢复；仍保留对27条指令全路径、父级调用点返回消费、边界页容量的独立审计。
- 不运行宿主游戏环境，不计运行时验证。
- 普通Lua草稿数量由78增至79；完整静态恢复76/110不变；运行时验证0不变。

## 下一步

继续优先寻找“已有控制流结论但没有独立普通Lua文件”的短函数/子原型，批量形成第一层草稿；StorageItems主函数及root/47的剩余复杂复核可并行后置，不阻塞草稿覆盖率提升。
