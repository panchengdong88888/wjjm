# 检查点280：doInit_UI配置闭包调用链功能等价复刻

日期：2026-11-11  
工作分支：`work/functional-equivalent-rebuild-2026-11-11`  
基线：检查点279

## 本批结论

已从 `doInit_UI` 的20项捕获映射和现有23个子原型源码中，核对四个配置包装器与文件检查包装器的实际调用时机、实参来源、返回值用途。配置读写不是初始化时一次性执行，而是在对应按钮回调或输入对话框回调触发时执行。

本批修改了 `04_源码候选/MainLeftBottom_恢复源码.lua`：
- 给配置闭包捕获建立业务语义局部别名。
- 将配置保存/清除子闭包中的模糊形参名改为实际职责名称。
- 所有调用顺序、实参顺序、返回值分支和副作用顺序保持不变。
- 未修改根模块的8个配置函数，也未覆盖检查点278的11个基础辅助函数导出。

## doInit_UI配置捕获映射

| doInit_UI槽位 | 根帧来源 | 实际函数/值 | 使用位置 |
|---|---|---|---|
| UP[6] | T[48] | AnonymousHelper_49 | Nested_Helper_10读取黑名单距离 |
| UP[9] | T[50] | AnonymousHelper_33 | Nested_InitGatherMonsters在threshold为false/nil时读取拉怪数量 |
| UP[10] | T[49] | AnonymousHelper_32 | 黑名单距离输入回调写入包装器 |
| UP[12] | T[44] | GetWritablePath | 保存失败时解析配置文件路径供日志输出 |
| UP[13] | T[42] | blacklist_distance.txt | 黑名单距离配置文件名 |
| UP[14] | T[51] | AnonymousHelper_54 | 拉怪数量输入回调写入包装器 |
| UP[15] | T[43] | gather_monster_count.txt | 拉怪数量配置文件名 |
| UP[16] | T[47] | FileExistCheck_pcall_wrapper | 两个清除配置回调共用的文件状态检查函数 |

## 读取流程

### 黑名单距离

1. doInit_UI构造Nested_Helper_10时，将UP[6]作为读取回调传入。
2. 用户触发黑名单按钮时，若timerState.blacklistTimer已存在，先通知关闭，再调用SL:UnSchedule并清nil，设置moduleState.isBlacklisting=false后返回true；此路径不读取配置。
3. 若定时器不存在，调用AnonymousHelper_49()。
4. AnonymousHelper_49固定调用ReadNumericConfig("blacklist_distance.txt")并原样返回结果。
5. distance大于0时通知开启并调用Nested_blacklistTimer(distance)；否则通知并打开黑名单距离输入框，返回false。

### 拉怪数量

1. doInit_UI构造Nested_InitGatherMonsters时传入UP[8]配置表和UP[9]读取回调。
2. Nested_InitGatherMonsters(threshold)仅在threshold为false/nil时调用AnonymousHelper_33()。
3. AnonymousHelper_33固定调用ReadNumericConfig("gather_monster_count.txt")并原样返回结果。
4. 随后将threshold写入config.GATHER_THRESHOLD；字段仍为false/nil时返回false，否则调用InitGatherMonsters()并返回true。

因此，输入框回调给出truthy数值时不会再次读取文件；读取文件属于无显式阈值时的回退路径。

## 写入流程

### 黑名单距离保存

1. 黑名单输入框由Nested_Helper_4打开；用户输入成功后，Nested_Helper_5(value)被调用。
2. Nested_Helper_5先调用AnonymousHelper_32(value)，失败时提示保存失败并用GetWritablePath(blacklist_distance.txt)生成日志路径，然后返回。
3. 写入回调成功后，先通知并记录保存数值，再调用Nested_blacklistTimer(value)；该回调返回false时停止，返回truthy后才调用按钮状态同步回调。

### 拉怪数量保存

1. 拉怪数量输入框由Nested_Helper_7打开；输入成功后Nested_Helper_8(value)被调用。
2. Nested_Helper_8先调用AnonymousHelper_54(value)，失败时提示并记录GetWritablePath(gather_monster_count.txt)路径，然后返回。
3. 写入回调成功后，先通知并记录阈值，再调用Nested_InitGatherMonsters(value)；返回false时停止，返回truthy后才同步按钮状态。

### 必须保留的参数顺序异常点

- 检查点125和254分别明确确认：
  - AnonymousHelper_32(value)调用PCallHelper("blacklist_distance.txt", value)。
  - AnonymousHelper_54(value)调用PCallHelper("gather_monster_count.txt", value)。
- 检查点26对PCallHelper子闭包的静态恢复是：将第一个固定参数转为文本，并将第二个固定参数传给GetWritablePath后作为writeStringToFile的路径参数。
- 因而按当前已恢复函数体直译，写入包装器会把固定文件名作为文本参数、把输入数值交给路径解析。这与“保存数值到固定配置文件”的业务意图看起来不一致。
- 本批没有擅自交换参数，也没有改写PCallHelper。参数顺序有独立PC证据支持，但这处跨函数行为异常必须作为待复核项保留；后续应回到原始PCallHelper/AnonymousHelper调用窗口逐PC核验，而不是按常见文件写入习惯修正。

## 清除配置回调

- make_Nested_Helper(checkConfigFileState, configFileName, ...)用于拉怪数量配置；make_Nested_s(...)用于黑名单距离配置。
- 两者都调用FileExistCheck_pcall_wrapper(configFileName)，并消费其两个返回值：success、detail/path。
- success truthy时输出“已清空...”提示并记录路径；否则输出“清空失败”提示并记录路径。
- 当前FileExistCheck_pcall_wrapper的已恢复行为是：文件已存在时直接返回true/path；文件不存在时pcall尝试removeFile，再次检查并返回not-exists/path。
- 该函数并不是数值输入校验器；而且“已存在直接返回true”与“清空”提示的语义看起来存在不一致。本批保留原函数和调用，不添加删除现存文件的行为，不把提示文字当作文件系统副作用证据。

## 本批源码调整

- doInit_UI中UP[6]/[9]/[10]/[12]/[13]/[14]/[15]/[16]建立可读局部别名。
- make_Nested_Helper_5 / make_Nested_Helper_8将validateValue改为writeConfigValue，明确这两个回调实际执行写入包装器。
- make_Nested_Helper_4 / make_Nested_Helper_7同步使用写入回调、路径解析器、文件名和后续业务回调等职责名称。
- make_Nested_Helper / make_Nested_s将checkCallback/checkArgument改为checkConfigFileState/configFileName。
- make_Nested_Helper_10将读取回调命名为readBlacklistDistanceConfig。
- 所有替换均为局部命名和绑定表达式替换；未更改任何宿主API调用、参数排列或条件极性。

## 静态核验与限制

- doInit_UI 20项捕获顺序未变。
- UP[6]/[9]/[10]/[14]/[16]的业务用途和调用路径均可在源码中定位。
- 黑名单读取、拉怪读取、两个保存回调、两个清除回调均有静态调用链。
- 写入参数顺序异常已明确记录，没有按意图猜测修复。
- 静态函数恢复统计仍为109/110；普通Lua草稿统计仍为72。
- 当前环境无lua/luac/luajit及Lua解析器；没有声称语法编译通过。
- 目标游戏运行时验证仍为0；没有实际调用FileUtils读写或GUI回调。

## 下一步：检查点281

转入物品/背包/仓库功能组。优先把已有完整静态恢复证据、逻辑较直观的GetAvailableStoragePage和GetStorageItemData整理为可读直接函数，再进入StorageItems；保留NPCStorageProxy等未文档化宿主代理调用，不反汇编代理内部。
