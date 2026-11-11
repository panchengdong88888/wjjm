# 检查点250：采集状态共享LiveCell与MainLoop装配

日期：2026-11-10

## 本批目标

依据根模块PC181、PC200、PC214-PC255的闭包创建与捕获描述，建立可变父寄存器的共享cell适配，接入采集状态机相关工厂。

## 共享cell设计

恢复装配器为每个父寄存器创建唯一对象：

```lua
local function newLiveCell(value)
    return { value = value }
end
```

T[14..22]初始值来自root模块候选同一词法块导出的值。每个寄存器只创建一个cell对象，闭包捕获的是对象引用；读写经`.value`完成。这是为了在普通Lua候选中模拟OP_387捕获父T寄存器live cell的适配层，不代表原作者使用表包装标量。

| 父寄存器 | 初值/用途 | 共享闭包 |
|---|---|---|
| T[14] | currentState，初值IDLE | FormatStateChange.UP1、MainLoop.UP1 |
| T[15] | 目标ID数组/可替换表 | ResetGather.UP0、MainLoop.UP8 |
| T[16] | 归属计数，0 | ResetGather.UP1、MainLoop.UP11 |
| T[17] | 扫描游标，0 | ResetGather.UP2、MainLoop.UP10 |
| T[18] | 运行标记，false | InitGather.UP1、StopGather.UP0、MainLoop.UP0 |
| T[19] | 等待标记，false | ResetGather.UP4、MainLoop.UP12 |
| T[20] | 截止时间，0 | ResetGather.UP5、MainLoop.UP13 |
| T[21] | 等待目标ID，nil | ResetGather.UP6、MainLoop.UP16 |
| T[22] | 等待名称，空串 | ResetGather.UP7、MainLoop.UP14 |

T[15]是特别需要注意的情况：ResetGatherMonsterData会把父寄存器整体替换成新表，因此不能只共享原始table引用；必须共享cell并执行`rootCells[15].value = {}`。

## 本批实际源码整合

1. FormatStateChange：改为接收currentState cell；读取旧状态、输出日志、日志正常返回后写回新状态。
2. ResetGatherMonsterData：七个可变捕获槽改为cell读写；ClearTargetID_2与PrintLog仍作为稳定函数引用。
3. MainLoop：由22项捕获工厂创建；UP0/UP1/UP8/UP10/UP11/UP12/UP13/UP14/UP16全部通过对应cell.value访问。
4. InitGatherMonsters：运行标记UP1接入rootCells[18]，置true。
5. StopGatherMonsters：运行标记UP0接入rootCells[18]，置false。
6. FindMonsterInCurrViewField：按UP0=IsDie实例化，作为MainLoop.UP15依赖。
7. root T[3] timerState、gatherStatusText及T[14..22]初始值从root模块词法块导出，保留T[21]=nil。

## 静态核对

- 22/22个无捕获直接子原型保持源代码层绑定。
- 有捕获工厂由12/36增至18/36，剩余18。
- MainLoop 22项捕获参数顺序与PC214-PC236父寄存器序列一致：
  T[18],T[14],T[13],T[4],T[23],T[35],T[26],T[34],T[15],T[32],T[17],T[16],T[19],T[20],T[22],T[36],T[21],T[31],T[30],T[33],T[24],T[8]。
- InitGather/StopGather的T[18]与MainLoop T[18]共用同一cell对象。
- FormatStateChange与MainLoop共用T[14]；ResetGather与MainLoop共用T[15..17]、T[19..22]。
- 静态检查未发现把上述共享可变捕获转成独立标量副本的装配路径。

## 计数与限制

- 完整静态恢复：109（不变）。
- 普通Lua草稿：72（不变）。
- 运行时验证：0。
- 本批未声称Lua编译通过，亦未在目标游戏宿主环境运行验证。
- 完整根模块仍是静态装配候选，不是作者原文逐字恢复。

## 下一步

检查点251优先处理剩余18个有捕获工厂中仅依赖稳定函数/表的简单闭包；如发现新的可变父寄存器，先核对其完整生命周期并加入唯一共享cell映射，再实例化捕获工厂。
