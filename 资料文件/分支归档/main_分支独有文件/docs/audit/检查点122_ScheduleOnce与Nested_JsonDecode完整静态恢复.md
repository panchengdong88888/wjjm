# 检查点 #122：ScheduleOnce 与 Nested_JsonDecode 完整静态恢复

日期：2026-11-09

## 一、ScheduleOnce

原型：`root.children[53]` / `root/54`
物理指令：7；常量：2；子原型：0；dump vararg字段：2。

### 指令映射

| PC | 静态行为 |
|---|---|
| 1 | 从环境取得SL |
| 2 | 取得SL.ScheduleOnce方法，并按方法调用约定保留SL接收者 |
| 3 | 将第一个显式参数复制到调用参数寄存器 |
| 4 | 将第二个显式参数复制到调用参数寄存器 |
| 5 | 调用ScheduleOnce并直接返回其全部返回值 |
| 6-7 | 位于PC5无条件return之后，不可达 |

普通Lua表达：

```lua
local function ScheduleOnce(callback, delay)
    return SL:ScheduleOnce(callback, delay)
end
```

该签名和方法接收者形式同时与仓库既有`verified_helpers_batches_1_3.lua`中的root/54独立候选一致。dump的vararg字段本身不单独作为参数个数证明；这里的两个显式参数来自PC3-PC5调用参数构造，接收者来自PC2方法取值。

## 二、Nested_JsonDecode

原型：`root.children[52].children[0]` / `root/53/1`
物理指令：6；常量：2；子原型：0；vararg字段：0。

### 父闭包捕获

父函数onDamageMsg（`root.children[52]`）PC7创建本闭包；紧随其后的捕获操作为`OP_387 A=0 B=1 C=0`，按反汇编捕获规则，子函数UP[0]来自父帧T[1]。旧函数清单将其写为T[3]，本检查点依据原始操作数更正为T[1]；捕获值的业务含义仍由父函数数据流决定，不在本包装器内猜测。

### 本体控制流

| PC | 静态行为 |
|---|---|
| 1 | 取得环境SL，并为方法调用保留接收者 |
| 2 | 取得SL.JsonDecode方法 |
| 3 | 读取UP[0] |
| 4 | 调用SL.JsonDecode(UP[0])并直接返回全部返回值 |
| 5-6 | 位于PC4无条件return之后，不可达 |

普通Lua表达：

```lua
local function Nested_JsonDecode()
    return SL:JsonDecode(UPVALUE_0)
end
```

因此此前状态记录中的“PC5备用返回路径触发条件尚未闭合”应删除：PC4是无条件return，PC5、PC6不可能由正常控制流到达。

## 三、源码与清单修改

- 修改`04_源码候选/短函数草稿_第十七批.lua`：将ScheduleOnce从泛化`(...)`转发修正为两个显式参数`(callback, delay)`，并使用`SL:ScheduleOnce`。
- 新增`04_源码候选/Nested_JsonDecode_JSON解码包装器_第八十一批.lua`。
- 更新`02_基础索引/03_函数状态清单.csv`：ScheduleOnce、Nested_JsonDecode均升级为完整静态恢复；Nested_JsonDecode父捕获源T[3]更正为原始操作数指示的T[1]，备用返回路径标记为不可达。

## 四、统计

普通Lua草稿78；完整静态恢复64/110；运行时验证0。

本批新增2个完整静态恢复函数。两者均未进行游戏客户端运行时验证。
