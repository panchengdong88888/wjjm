# 检查点268：PC389-T59模块表重读与doInit捕获校正

日期：2026-11-10  
仓库：panchengdong88888/wjjm / main

## 一、本批核查范围

本批针对根模块PC389-PC411，回查原始VM Dump，而不是仅沿用候选源码注释或闭包装配表旧值。重点确认：
- PC389全局模块表重读写入哪个寄存器；
- doInit_UI在PC392/393/394捕获的T[2]/T[3]/T[0]在捕获时分别是什么；
- PC411最终写入哪个表对象。

原始文件：`02_基础索引/MainLeftBottom_vm_dump.json`，root.ins长度412。直接读取PC385-PC412原始记录，关键记录如下（记录数组格式沿用仓库[FLAG,OPCODE,A,B,C]）：

| PC | 原始记录 | 结论 |
|---:|---|---|
| 389 | `[82,137,59,"MainLeftBottom",null]` | 将全局MainLeftBottom读取到独立临时寄存器T[59] |
| 390 | `[0,27,60,42,20]` | 创建root.children[42] doInit_UI到T[60]，随后捕获20项 |
| 392 | `[192,387,0,2,0]` | doInit_UI UP[1]捕获父T[2] |
| 393 | `[0,387,0,3,0]` | doInit_UI UP[2]捕获父T[3] |
| 394 | `[0,387,0,0,0]` | doInit_UI UP[3]捕获父T[0] |
| 411 | `[144,268,59,"doInit",60]` | 将T[60]闭包写入T[59].doInit |

## 二、捕获对象身份的正确结论

PC389写入目标是T[59]，不是T[2]、T[3]或T[0]。因此此前的寄存器生命周期仍然成立：

- T[2]在PC33创建并挂入MainLeftBottom.z，PC392捕获时仍是z状态表。
- T[3]在PC42创建timerState，PC393捕获时仍是timerState表。
- T[0]在PC3创建并挂入MainLeftBottom.a，PC394捕获时仍是a UI状态表。
- T[59]在PC389单独读取`_ENV.MainLeftBottom`，PC411写入其doInit字段。

所以doInit_UI的前五项捕获为：
- UP[0]=T[4]=PrintLog
- UP[1]=T[2]=MainLeftBottom.z
- UP[2]=T[3]=timerState
- UP[3]=T[0]=MainLeftBottom.a
- UP[4]=T[1]=MainLeftBottom.b

主恢复稿此前对UP[1]/UP[2]/UP[3]的实参注入（rootModule.z、rootSource.timerState、rootModule.a）是正确的；不能按旧闭包装配表中错误的value文字将它们改成模块根表。

## 三、本批修正

1. 主恢复稿`04_源码候选/MainLeftBottom_恢复源码.lua`：
   - 修正第二处doInit_UI主体注释，明确UP[1]=z、UP[2]=timerState、UP[3]=a。
   - 在doInit_UI工厂创建前执行`local doInitModule = _G.MainLeftBottom`，模拟PC389把全局模块表保存到独立T[59]。
   - PC411不再直接写`rootModule.doInit`，改为`doInitModule.doInit = rootPrototypes.doInit_UI`，并校验写入对象。
   - 保留UP[1]/UP[2]/UP[3]现有正确工厂参数，不作错误改动。
2. `docs/handoff/12_根模块闭包装配表.json`：
   - 更正doInit_UI的UP[1]/UP[2]/UP[3]值描述。
   - PC411 module_fields增加`target_register=59`及`target_reread_pc=389`。
   - 增加PC389/PC411原始指令及T[59]临时寄存器事件记录。
   - 增加`root_assembly_checkpoint_268`作为本段核对结果。
3. 主恢复稿的root_assembly_checkpoint增加`checkpoint268_root_pc389_t59_reread_preserved`标志。

## 四、修正边界

- 本批确认的是根模块父帧寄存器和字段写入对象，不代表doInit_UI的宿主GUI行为已运行验证。
- PC389的全局表重读与PC411写入目标按原始指令保留；主恢复稿仍是恢复适配结构，不冒充作者原始源码逐字还原。
- 运行时验证仍为0；未执行Lua解释器/luac或目标游戏运行。

## 五、下一批

检查点269：继续对账root PC389-PC412最终段的全部捕获值、字段写入和返回寄存器；特别核对T[59]与rootModule的对象身份假设、PC412返回值，并检查doInit_UI 20项捕获中其他寄存器值是否与register_value_timeline一致。完成后再将根模块状态从“分段适配草稿”推进到更完整的连续可读源码组织，不把静态装配标志当作作者级完整源码。
