# 检查点 #64：Nested_JsonDecode 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：102
- 规范路径：`root.children[52].children[0]`
- legacy 一基路径：`root/53/1`
- 旧状态 CSV 的原路径列曾写作 `root/52/0`，与原型总索引及反汇编的编号体系不一致；本检查点按规范路径和总索引的 `legacy_one_based_label` 纠正为 `root/53/1`。
- 名称：`Nested_JsonDecode`
- 6条物理指令、2个常量、无子原型、vararg_flag=0。

## 创建点与捕获
- 父函数：`root.children[52]`，名称 `onDamageMsg`，legacy `root/53`。
- 父函数 PC7 创建子闭包，capture_count=1。
- 创建指令之后的捕获描述为 `OP_387 A=0 B=1 C=0`；闭包映射所用语义是捕获父级当前 T 寄存器。
- 子函数 UPVALUE_0 对应父函数 T[3]。
- 父函数 PC9 随后以 T[3] 所在参数区间调用其 R2 值。T[3] 的业务来源仍需结合父函数调用者继续追踪；目前不将其命名为 JSON 字符串、黑名单数据或具体消息字段。

## 子函数指令恢复
- PC1：读取环境对象 `SL`，并通过融合载荷读取其 `JsonDecode` 成员。
- PC2：再次读取 `SL.JsonDecode`。
- PC3：读取 UPVALUE_0。
- PC4：调用当前解码器，参数为 UPVALUE_0，并直接返回调用结果。
- PC5：另一条返回路径，表现为返回当前 T 参数区间；由于分支来源和融合读取对控制流的影响尚未完全闭合，不能据此虚构默认值、pcall或错误回退行为。
- PC6：空返回/函数尾部。

## 草稿与限制
- 已恢复最明确的主路径：`return SL.JsonDecode(UPVALUE_0)`。
- 源码候选中保留了PC5的备用无返回值说明；未擅自给出触发条件。
- 本批只新增首版普通Lua草稿，不升级完整静态恢复。
- 未运行时验证。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十批.lua`
- 审计：`docs/audit/检查点64_Nested_JsonDecode首版草稿.md`
