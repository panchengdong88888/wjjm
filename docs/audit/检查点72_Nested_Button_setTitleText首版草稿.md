# 检查点 #72：Nested_Button_setTitleText 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：69
- 规范路径：`root.children[42].children[9].children[0]`
- legacy：`root/43/10/1`
- 48条物理指令、10个常量、无子原型、`vararg_flag=0`。

## 创建点及捕获
父函数`Nested_Button_setTitleFontSize`（`root/43/10`）PC45创建本闭包，captures=3：
- child UPVALUE_0 <- parent R4
- child UPVALUE_1 <- parent T[0]
- child UPVALUE_2 <- parent T[3]

父函数在PC15-PC17已将按钮写入UPVALUE_3[button.key]；但PC45捕获的是父R4，而非UPVALUE_3。不要把child UPVALUE_0未经证明直接命名为buttonRegistry；草稿仅作暂定用途名并标注待核验。

## 已确认的状态操作
- 常量包括`toggle`、`toggled`、`name`、`key`、`#ff0000`、`#ffffff`。
- PC11-PC16对`UPVALUE_1.toggle`及前序有效性结果进行分支判断；toggle为真或前置判断不满足时跳到函数尾部。
- PC17-PC21从UPVALUE_1读取`toggled`，取逻辑非，并写回`UPVALUE_1.toggled`。
- PC22-PC35取得`GUI.Button_setTitleText`，随后读取UPVALUE_1的`toggle/name`相关状态及UPVALUE_2；其调用参数的精确寄存器映射仍需结合融合载荷复核。
- PC36-PC47取得`GUI.Button_setTitleColor`；颜色常量为红色`#ff0000`和白色`#ffffff`，并存在基于toggle状态的条件分支。

## 保留的未闭合事项
- PC1-PC9有多条融合载荷：注册表/键值访问、可调用对象及结果检查的准确数据流未闭合。
- child UPVALUE_0来自parent R4，而父函数此前的R4/R3/UPVALUE_3在不同PC具有不同含义；必须按父函数R4当时的值追踪，不能直接认定为注册表。
- PC22-PC35与PC36-PC47的GUI调用参数寄存器顺序仍需复核；草稿保留明确TODO，不将猜测写成执行代码。
- 本函数无子原型、无显式返回；未运行时验证。
- 只计首版普通Lua草稿，不计入完整静态恢复。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十八批.lua`
- 审计：`docs/audit/检查点72_Nested_Button_setTitleText首版草稿.md`
