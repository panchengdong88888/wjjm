# 检查点155：MainLoop PC1-PC159 前段控制流复核

日期：2026-11-09（Asia/Singapore）
对象：`root.children[45]`（legacy `root/46`），417条物理指令。

## 本批复核范围

本批逐段对照 corrected phase3 反汇编中 MainLoop 的 PC1-PC159、常量池、已有闭包身份审计及当前普通Lua草稿。范围覆盖入口门槛、白名单地图分支、IDLE候选构造、GATHERING等待归属计时和进入主扫描前的调用点。

## 1. 入口运行门槛（PC1-PC4）

- PC1读取UPVALUE_0。
- PC2判断其truthiness；运行标记为true时，条件不触发跳过，执行PC3跳转至PC5，继续主流程。
- 运行标记为false/nil时，PC2跳过PC3并在PC4立即return。
- 因此草稿的`if not UPVALUE_0 then return end`与该控制流一致。此前本段文字把真假分支方向写反，现按PC1-PC4的反汇编语义更正；唯一交付源码无需修改。

## 2. 白名单地图门槛（PC5-PC23）

- PC5-PC6读取并调用环境函数`IsInWhitelistMap()`。
- 返回truthy时跳过PC8的跳转，进入PC9检查当前状态是否为IDLE。
- 当前状态不是IDLE时，PC14-PC22依次输出“在白名单地图, 停止引怪”、设置状态为IDLE、调用状态重置helper；随后PC23 return。
- 当前状态已经是IDLE时，PC13跳至PC23直接return，不重复输出提示或重置。
- 返回false/nil时，PC8跳到PC24，进入普通状态分派。
- 因此草稿“仅当白名单地图且当前状态不是IDLE时提示/切IDLE/重置；无论如何白名单地图直接返回”的结构正确。

## 3. IDLE候选构造（PC24-PC87）

- PC24-PC30判断当前状态是否为IDLE；非IDLE跳过IDLE分支至PC88。
- PC31-PC42输出“扫描怪物中”，调用UPVALUE_7取得候选列表；列表长度为0时输出“视野内没有可攻击怪物”并return。
- PC43创建新空表并写入UPVALUE_8。
- PC44-PC62以`ipairs(candidates)`遍历候选actor；PC49-PC52调用UPVALUE_9(actor, mainPlayerID)，返回truthy时跳过插入；false/nil时读取actor:GetID()并table.insert到UPVALUE_8。
- PC63-PC70检查UPVALUE_8长度；为0时输出“没有可攻击的怪物”并return。
- PC71-PC72将UPVALUE_10设为1、UPVALUE_11设为0。
- PC73-PC86输出开始引怪数量提示并把状态切换到GATHERING；PC87 return。
- 草稿主体与上述路径一致。删除了原稿中额外的`not candidates`保护，因为PC36-PC38只检查`#candidates == 0`，不包含nil保护；这避免把未由字节码证明的容错语义写入候选源码。

## 4. GATHERING等待归属计时（PC88-PC158）

- PC88-PC92确认状态为GATHERING；非GATHERING跳至PC344（后续状态分支）。
- PC96-PC98检查UPVALUE_12等待标志；false/nil直接跳到PC159继续扫描；truthy则读取`os.time()`。
- PC103比较当前时间与UPVALUE_13截止时间。若now小于截止时间，PC105-PC113输出“等待归属变更中”及剩余秒数，PC114立即return。
- 等待到期时，PC104跳至PC116。PC116-PC121调用UPVALUE_15取得actor映射，按UPVALUE_16查目标actor，并读取当前主玩家ID；PC122检查actor是否存在。
- actor存在时，PC124-PC139调用UPVALUE_17(actor, mainPlayerID)，truthy路径输出“归属已变更为自己”；false路径由PC141-PC147输出“归属未变更或已离开视野”。缺失actor同样走未变更/离开视野日志路径。
- PC148-PC158清理等待标志、截止时间、目标ID、目标名称，并把UPVALUE_10推进一位。
- 注意：UPVALUE_15对应的`FindMonsterInCurrViewField`没有形式参数。等待到期分支PC117的调用指令使用两个寄存器参数槽，但其值在本次入口路径上没有稳定的业务身份；helper不读取实参。草稿保留为无参调用，并在源码注释说明该调用点存在两个不具业务语义的寄存器槽。
- PC159-PC160再次调用UPVALUE_15，并将UPVALUE_12作为一个额外实参传入；这是此前检查点153已经确认的调用点。helper没有形式参数且不读取该实参。草稿已修正：等待到期分支不再误传UPVALUE_12，PC159主扫描分支保留`UPVALUE_15(UPVALUE_12)`。
- PC159-PC166随后取得主玩家ID、目标数组长度并准备GATHERING数值for循环；PC166跳至PC313完成循环初始化。其循环体/退出分支已由检查点153闭合。

## 5. 状态写入与提前返回审计

本范围确认的MainLoop显式状态写入：
- 白名单地图：状态切IDLE并调用Reset helper（仅原状态非IDLE）。
- IDLE候选为空：无状态写入，直接return。
- IDLE无未归属候选：无状态写入，直接return。
- IDLE候选可用：UPVALUE_8重建，UPVALUE_10=1，UPVALUE_11=0，状态切GATHERING后return。
- GATHERING等待未到期：仅日志后return，不清等待字段。
- GATHERING等待到期：清UPVALUE_12/13/16/14，并将UPVALUE_10递增。
- 本段没有证据支持额外的nil候选列表保护。

## 6. 本批修改

- 修正`04_源码候选/root45_MainLoop.lua`中两个FindMonsterInCurrViewField调用点的实参归属：PC117等待到期分支不再误传UPVALUE_12；PC159主扫描分支保留UPVALUE_12额外实参。
- 删除IDLE候选列表的额外nil保护，使草稿条件严格对应PC36-PC38。
- 新增本审计；同步更新函数状态CSV、机器状态JSON和checkpoint协议。

## 7. 状态与限制

- MainLoop仍为首版普通Lua草稿，前段已完成本范围逐PC复核，但整个417条指令的CFG尚未全部闭合。
- 不升级完整静态恢复，不计运行时验证。
- 全工程统计保持：普通Lua草稿82；完整静态恢复76/110；运行时验证0。
- 下一步：继续核对MainLoop PC1-PC417剩余分支的完整可达性、所有状态写入和return汇合，重点检查PC314-PC343及各状态之间的边界路径。
