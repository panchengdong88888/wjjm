# 检查点 #80：三个短原型首版普通 Lua 草稿

日期：2026-11-09  
源码批次：`04_源码候选/短函数草稿_第五十六批.lua`  
状态：首版普通 Lua 草稿；未运行时验证。

## 1. Nested_FFFFFF

- 原型索引60；规范路径 `root.children[42].children[3].children[2]`；legacy `root/43/4/3`。
- 65条物理指令、17常量、无子原型、vararg_flag=3。
- 父 `root/43/4` PC265创建，捕获父T[5]、T[1]，分别为UPVALUE_0/1。
- 已确认：计算 `math.ceil(15 / arg1)`；创建GUI Layout；两层数值循环；创建Text单元；设置锚点(0.5,0.5)；按索引写入结果表并返回。
- 常量包括`_cell_`、`_text_`、`Layout_Create`、`Text_Create`、`setAnchorPoint`、`#FFFFFF`、15、30、35、0.5。
- 待复核：vararg参数映射；循环边界/步长；item索引公式；两个捕获值业务身份；GUI创建函数实参顺序及返回契约。

## 2. onDamageMsg / Nested_JsonDecode

- 原型索引101；规范路径 `root.children[52]`；legacy `root/53`。
- 72条物理指令、19常量、1子原型、vararg_flag=2。
- root PC356创建，捕获root T[57]，业务身份未闭合。
- 子原型 `root.children[52].children[0]`（legacy `root/53/1`）6条指令；父PC7创建，捕获父T[3]；主体为`SL.JsonDecode(UPVALUE_0)`并返回。
- 已恢复：输入假值/空字符串退出；pcall保护JSON解码；解码结果必须为table；过滤本机MAIN_ACTOR_ID；检查AttackUserID/UserID；读取ACTOR_IS_HERO、ACTOR_MASTER_ID、ACTOR_NAME；过滤空名称及包含“分身”的名称；写入lastAttacker的id/name。
- 待复核：PC9 vararg/栈参数映射；元数据真假分支方向；GetMetaValue实参语义；root T[57]业务身份；lastAttacker字段来源映射。

## 3. GetStorageItemData

- 原型索引3；规范路径 `root.children[1]`；legacy `root/2`。
- 77条物理指令、16常量、无子原型、vararg_flag=0。
- root PC70创建，捕获root T[4]，业务身份未证实。
- 已恢复：NPCStorageProxy存在性保护；GetMaxPage；逐页GetStorageDataByPage；table结果经ipairs遍历并table.insert汇总；读取STORAGE_PER_PAGE_MAX、MMO.NPC_STORAGE_MAX_PAGE、GetOpenSize；调用捕获回调输出“仓库总可用格子”；返回汇总数组。
- 待复核：页码起始/返回值布局；PC47-PC70容量计算的精确分支、循环及累计公式；UPVALUE_0身份和通知回调契约。
- 草稿中的availableSlots计算是可读骨架，不是已证明的作者算法。

## 统计

- 本批新增普通Lua草稿3个。
- 累计普通Lua草稿70个。
- 完整静态恢复仍29/110（26.4%）。
- 运行时验证仍0。
- 三个函数均不升级为完整静态恢复。
