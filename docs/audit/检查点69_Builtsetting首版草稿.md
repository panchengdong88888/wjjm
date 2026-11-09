# 检查点 #69：Builtsetting 首版普通 Lua 草稿

日期：2026-11-09

## 原型身份
- 原型索引：31
- 规范路径：`root.children[23]`
- legacy：`root/24`
- 55条物理指令、15个常量、无子原型、`vararg_flag=0`。

## 闭包捕获
- 根原型PC256创建本闭包，captures=1。
- PC257紧随其后执行`OP_387 A=0 B=5 C=0`，故本函数`UPVALUE_0 <- root R5`。
- 根R5在PC256时的业务语义名称尚未由本批追踪；草稿仅命名为`onSettingMessage`作为局部占位，不断言它是日志/提示/通知API。

## 主体控制流
函数无显式参数、无子原型、无显式返回。55条指令组成6组重复操作，每组先调用环境函数`CHANGE_SETTING`，再调用捕获的`UPVALUE_0`：
1. `CHANGE_SETTING(27, {0})`，随后`UPVALUE_0("关闭背景音乐")`。
2. `CHANGE_SETTING(52, {0})`，随后`UPVALUE_0("关闭游戏音乐")`。
3. `CHANGE_SETTING(1002, {0})`，随后`UPVALUE_0("关闭高帧率")`。
4. `CHANGE_SETTING(57, {1})`，随后`UPVALUE_0("开启人物简装")`。
5. `CHANGE_SETTING(58, {1})`，随后`UPVALUE_0("开启怪物简装")`。
6. `CHANGE_SETTING(2005, {0})`，随后`UPVALUE_0("关闭屏蔽怪物")`。
- 每个设置表均由指令创建为单元素数组，元素为0或1。
- PC55结束返回，无显式返回值。

## 未闭合事项
- 根R5的业务身份未追踪，因此UPVALUE_0的真实函数名及副作用未知。
- 环境函数`CHANGE_SETTING`的内部实现不在本函数内；这里只恢复其调用参数和顺序。
- 本批的控制流、参数值、字符串常量及闭包捕获来源已闭合；但因外部回调语义未知且未运行时验证，仍标记首版普通Lua草稿，不计入完整静态恢复。

## 文件
- 源码：`04_源码候选/短函数草稿_第四十五批.lua`
- 审计：`docs/audit/检查点69_Builtsetting首版草稿.md`
