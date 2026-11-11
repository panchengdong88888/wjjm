# 检查点 #187：doInit_UI 首版普通 Lua 草稿数据流与 GUI 参数校正

日期：2026-11-10（Asia/Singapore）
对象：`root.children[42]` / legacy `root/43` / `doInit_UI`
物理指令：419；常量：105；子原型：23；vararg_flag=0。

## 本批工作范围

本批继续第一层普通 Lua 草稿，不以作者级源码的严格验收门槛阻止草稿产出。复用检查点88已有父函数草稿和后续对子原型的复核，不重复反汇编已完成的子函数。更新文件：

- `04_源码候选/短函数草稿_第六十三批.lua`

本批不把doInit_UI升级为完整静态恢复，也不增加完整静态恢复数量。

## 已从现有反汇编/闭包资料校正的内容

1. **MoneyProxy货币快照键**
   - PC59-PC65取得MoneyProxy。
   - 第一组`moneyNames`（元宝、绑定元宝、灵符、绑定灵符）逐项调用`GetMoneyIdByName(name)`，再以返回ID调用`GetMoneyCountById(id)`。
   - PC77-PC85把数量写入`initSnapshot[name]`，键是名称，不是moneyId。
   - 数量false/nil时按PC82-PC84路径归一为0。

2. **背包资源快照来源**
   - 第二组`resourceNames`（声望卷、悟道茶、洗髓丹、转生水晶、恶魔令牌、血龙宝珠）不是继续走MoneyProxy。
   - PC92-PC97调用已独立静态恢复的child[0] `Nested_find(name)`，并写入`initSnapshot[name]`。
   - 草稿已改为按名称保存Nested_find结果；不再错误地通过MoneyProxy查询第二组资源。

3. **cruiseTimer调度参数顺序**
   - PC146-PC156取消旧`cruiseTimer`并写回VM dump中的unknown/nil序列化哨兵。
   - PC158-PC166创建每日巡航回调并调用`SL:Schedule(callback, 1.0)`。
   - 草稿已修正为回调在前、间隔1.0在后；此前版本的参数顺序颠倒。

4. **Attach_UITop调用与返回节点**
   - PC181-PC183确实调用`GUI.Attach_UITop`，调用栈包含7个显式实参。
   - 目前未闭合这7个实参的寄存器生产者及业务意义，草稿新增显式命名的占位变量并加TODO；这些nil占位不是恢复结果，不可当作可运行参数。
   - 调用结果保留为T[6]，后续child[9]及隐藏按钮的`GUI:Button_Create`把它作为父节点参数。

5. **按钮创建实参与闭包捕获**
   - PC338-PC345创建child[9]按钮工厂，捕获顺序为T[6]（Attach_UITop返回父节点）、T[22]（xBase）、T[23]（yBase）、UP[4]（buttonMap）、T[21]（buttonHandlers）。
   - 三个显式参数是配置记录、列索引、行偏移。
   - 坐标：`x = miniChatRight - 10 - 85 * columnIndex`；`y = miniChatY + 1 + rowOffset`；三组偏移为40、0、80。
   - child[9]创建按钮时，`Button_Create`显式接收父节点、key、x、y、贴图；草稿已补回父节点参数。
   - toggle回调的门控规则按已完成的child[9]/child[0]复核表达：存在gate才调用；仅严格返回false时阻止切换；切换后更新文字及红/白颜色。

## 仍未解决，继续保留占位

- doInit_UI的20个UPVALUE中仍有若干业务身份未知；父root T寄存器映射已知不等于所有业务变量名已知。
- `GUI:Attach_UITop`的7个参数来源/含义尚未闭合，当前代码占位不可运行。
- `Nested_Anonymous`（child[22]）创建`Nested_str`时捕获T[0]/UP[0]/T[2]/T[1]；UP[0]=PrintLog已确认，但T[0]/T[1]/T[2]生产者及调用帧参数映射仍未知。不得由下层回调用途倒推命名。
- GUI宿主方法的具体参数语义和视觉布局未运行时验证。
- `Nested_FFFF00`（child[3]，320条）父函数主体仍为首版草稿，需要单独继续恢复；其子函数`Nested_Helper_3`（168条）已在CSV标记完整静态恢复，不应重复处理。

## 统计

- 普通Lua草稿函数：71（本批修订既有草稿，不新增函数计数）。
- 完整静态恢复：102/110（92.7%）。
- 运行时验证：0。
- 本批状态：doInit_UI仍为首版普通Lua草稿，未升级完整静态恢复。

## 下一步

优先转向`root.children[42].children[3]` / `Nested_FFFF00`（320条）主体，基于既有资源统计刷新链候选和已完成的5个子原型，批量恢复父函数普通Lua主体；保留GUI枚举/宿主语义不确定项。之后再回到doInit_UI未闭合的Attach_UITop实参与Nested_Anonymous帧槽来源。
