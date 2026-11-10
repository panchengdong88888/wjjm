# 检查点240：root T[45..51]包装闭包与doInit_UI捕获绑定闭合

日期：2026-11-10

## 本批范围与依据

核对root PC298-PC315的闭包创建/捕获，以及root PC390-PC410创建doInit_UI时的20项捕获。证据来源：
- corrected phase3反汇编root PC298-PC315、PC390-PC410；
- `docs/handoff/12_根模块闭包装配表.json` 的58个创建点和OP_387捕获描述；
- 原型索引的canonical children路径、固定参数数量与恢复名称；
- 已存在的短函数源码：ReadNumericConfig、PCallHelper、FileExistCheck_pcall_wrapper、AnonymousHelper_49、AnonymousHelper_32、AnonymousHelper_33、AnonymousHelper_54。

OP_387捕获的是父T表与寄存器编号组成的共享live cell；以下身份按捕获PC之前最后一次写入/闭包创建确定，不按旧寄存器值推断。

## T[45]/T[46]生产者

| 寄存器 | 生产PC | 实际值 | 后续捕获 |
|---|---:|---|---|
| T[45] | PC298 | root.children[9] ReadNumericConfig(GetWritablePath)闭包 | PC305：AnonymousHelper_49 UP[0]；PC311：AnonymousHelper_33 UP[0] |
| T[46] | PC300 | root.children[17] PCallHelper(GetWritablePath)闭包 | PC308：AnonymousHelper_32 UP[0]；PC314：AnonymousHelper_54 UP[0] |

T[45]与T[46]均捕获T[44]=GetWritablePath。PCallHelper的主体和嵌套写文件闭包已在`PCallHelper_文件写入包装_第六批草稿.lua`静态恢复；它调用FileUtils:writeStringToFile并以pcall结果归一为布尔值。此处只确认包装调用关系，不推断目标运行时文件内容或外部副作用。

## PC302-PC315目标寄存器身份

| 目标寄存器 | 创建PC / 原型 | 捕获来源 | 包装行为 |
|---|---|---|---|
| T[47] | PC302，root.children[0] FileExistCheck_pcall_wrapper | PC303捕获T[44]=GetWritablePath | 固定参数path；检查文件是否存在，不存在时pcall执行removeFile并复查；额外vararg不读取 |
| T[48] | PC304，root.children[49] AnonymousHelper_49 | UP[0]=T[45] ReadNumericConfig；UP[1]=T[42] "blacklist_distance.txt" | 零参调用ReadNumericConfig("blacklist_distance.txt")并转发返回值 |
| T[49] | PC307，root.children[32] AnonymousHelper_32 | UP[0]=T[46] PCallHelper；UP[1]=T[42] "blacklist_distance.txt" | 一个显式参数；调用PCallHelper("blacklist_distance.txt", firstArg)并转发全部返回值 |
| T[50] | PC310，root.children[33] AnonymousHelper_33 | UP[0]=T[45] ReadNumericConfig；UP[1]=T[43] "gather_monster_count.txt" | 零参调用ReadNumericConfig("gather_monster_count.txt")并转发返回值 |
| T[51] | PC313，root.children[54] AnonymousHelper_54 | UP[0]=T[46] PCallHelper；UP[1]=T[43] "gather_monster_count.txt" | 一个显式参数；调用PCallHelper("gather_monster_count.txt", firstArg)并转发全部返回值 |

命名纠错：PC310的child index为33，canonical路径是`root.children[33]`，legacy标签是`root/34`，原型索引中的恢复名称为`AnonymousHelper_33`。不要把legacy一基标签误写成函数名AnonymousHelper_34。真正的root.children[34]是另一个Schedule包装原型。

## doInit_UI的实际UPVALUE绑定（root PC390）

PC390按下列顺序捕获20个父T寄存器：

| doInit_UI UP | 父寄存器 | 捕获时值 |
|---:|---:|---|
| UP[0] | T[4] | PrintLog |
| UP[1] | T[2] | MainLeftBottom.z状态表 |
| UP[2] | T[3] | timer-state表 |
| UP[3] | T[0] | MainLeftBottom.a配置表 |
| UP[4] | T[1] | MainLeftBottom.b按钮映射表 |
| UP[5] | T[41] | blacklist状态表 |
| UP[6] | T[48] | AnonymousHelper_49：读取blacklist_distance.txt |
| UP[7] | T[7] | 原型索引已闭合的父寄存器值；本批不重命名 |
| UP[8] | T[8] | gatherConfig |
| UP[9] | T[50] | AnonymousHelper_33：读取gather_monster_count.txt |
| UP[10] | T[49] | AnonymousHelper_32：PCallHelper写入blacklist_distance.txt的参数包装器 |
| UP[11] | T[5] | ShowLocalNoticeByType |
| UP[12] | T[44] | GetWritablePath |
| UP[13] | T[42] | "blacklist_distance.txt" |
| UP[14] | T[51] | AnonymousHelper_54：PCallHelper写入gather_monster_count.txt的参数包装器 |
| UP[15] | T[43] | "gather_monster_count.txt" |
| UP[16] | T[47] | FileExistCheck_pcall_wrapper |
| UP[17] | T[11] | 保留既有闭合身份，不在本批重复命名 |
| UP[18] | T[12] | 保留既有闭合身份，不在本批重复命名 |
| UP[19] | T[9] | 保留既有闭合身份，不在本批重复命名 |

关键目标已闭合：UP[6]/UP[10]/UP[12]/UP[14]分别为读取黑名单距离配置、写入黑名单距离配置、路径解析函数、写入引怪数量配置的包装/基础函数。额外补齐UP[9]与UP[16]，避免只登记用户点名的四项而遗漏同一PC390捕获组。

## 统计与边界

- 本批新增闭合寄存器生命周期：T[45]、T[46]、T[47]、T[48]、T[49]、T[51]，共6个。
- 已闭合具体root父寄存器生命周期：28/57；尚余29个。
- 根模块58/58个直接子原型创建点、135/135个OP_387捕获描述符仍全部有索引。
- 完整静态恢复函数数仍为109/110；本批不新增函数主体恢复数量。
- 运行时验证仍为0；没有声称游戏宿主环境验证通过。
- 根模块PC1-PC412的完整普通Lua装配、模块字段/全局导出总账仍未完成。

## 下一步

检查点241从root PC1-PC85开始，按真实写入指令和赋值目标建立模块字段/全局导出账本；随后继续剩余父寄存器生命周期，最后将root PC1-PC412整理成完整普通Lua模块。
