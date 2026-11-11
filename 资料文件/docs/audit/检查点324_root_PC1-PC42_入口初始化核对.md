# 检查点324：root PC1-PC42入口初始化逐条核对

日期：2026-11-11
仓库：panchengdong88888/wjjm / main

## 核对范围与证据

- 原始VM：`资料文件/02_基础索引/MainLeftBottom_vm_dump.json`，root原型，412条物理指令。
- 唯一交付源码：`MainLeftBottom_唯一交付文件.lua`，本轮读取Blob SHA `eda5d22a63bbaa18b760317355a07c79b30f4ffb`。
- 本批只核对root PC1-PC42，不将后续闭包、全局导出或UI初始化算作完成。

## 对照结果

| VM物理PC | VM动作/字段 | 唯一源码对应 | 结果 |
|---|---|---|---|
| PC1-PC2 | 创建模块根表并写入当前chunk ENV的MainLeftBottom | 第27-28行创建表并写入rootEnvironment.MainLeftBottom | 一致 |
| PC3-PC5 | 创建a表，并重新从ENV读取MainLeftBottom后写入a字段 | 第31-34行创建a并通过moduleForA写入 | 一致 |
| PC6 | a.version = "10000" | 第36行 | 一致 |
| PC7-PC11 | SL:GetMetaValue("SCREEN_WIDTH")并写入a.screenW | 第39-40行 | 一致 |
| PC12-PC16 | SL:GetMetaValue("SCREEN_HEIGHT")并写入a.screenH | 第42-43行 | 一致 |
| PC17-PC23 | 按1.0、9.0、10.0、60000.0顺序构造Blocklist并挂入a | 第46-48行数组及第49行赋值 | 一致 |
| PC24-PC25 | 创建并挂入SendHookList空表 | 第52-53行 | 一致 |
| PC26-PC27 | 创建并挂入RecvHookList空表 | 第55-56行 | 一致 |
| PC28-PC29 | isHidden=true、hidebut=nil | 第59-60行 | 一致 |
| PC30-PC32 | 创建b表，重新读取ENV.MainLeftBottom并写入b | 第63-65行 | 一致 |
| PC33-PC35 | 创建z表，重新读取ENV.MainLeftBottom并写入z | 第68-71行 | 一致 |
| PC36-PC41 | 按序初始化六个z状态字段 | 第73-78行 | 一致 |
| PC42 | 创建timerState空表 | 第81行 | 一致 |

## 语义核对

1. Lua 5.1目标环境优先使用`getfenv(1)`取得当前chunk环境；不会无条件把ENV等同于`_G`。在目标Lua 5.1环境中该路径与VM的ENV读写模型一致。
2. a、b、z均通过对应PC重新读取`rootEnvironment.MainLeftBottom`后挂入，未以局部根表引用替代ENV读取。
3. Blocklist元素顺序和值、空表初始化、布尔值和nil字段均与VM常量及写入顺序一致。
4. 本批只确认入口初始化段，不代表root PC43-PC412或整个模块入口装配完成。

## 结论

root PC1-PC42本轮直接静态对照通过，未发现明确源码错配，因此本批不修改唯一交付源码。未执行Lua 5.1编译，未执行目标游戏运行验证。

## 下一步

继续核对root PC43-PC85的闭包创建、全局导出及捕获来源；完成后立即更新机器状态和AI_START_HERE并提交main。