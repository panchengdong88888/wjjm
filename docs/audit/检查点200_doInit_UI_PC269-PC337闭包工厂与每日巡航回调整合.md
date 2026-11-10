# 检查点200：doInit_UI PC269-PC337闭包工厂与每日巡航回调整合

日期：2026-11-10  
对象：root.children[42] / doInit_UI（419条）  
主要源码：04_源码候选/短函数草稿_第六十三批.lua

## 本批目标

沿用检查点88/187首版普通Lua主体与检查点199资源快照校正，继续第一层草稿。批量接入PC269-PC337创建的按钮回调闭包，复用既有完整静态恢复子原型；同时把child12每日巡航回调的已完成主体并入父函数草稿。

## PC269-PC337父闭包注册及捕获顺序

| 父PC | 子原型 | 捕获顺序（父帧来源） | 草稿接入 |
|---|---|---|---|
| 269-276 | child6 Nested_StopGatherMonsters | [UP2, UP11, UP9, UP0, R20, R17] | make_Nested_StopGatherMonsters |
| 277-282 | child2 Nested_Helper | [UP16, UP15, UP11, UP0] | make_Nested_Helper |
| 283-288 | child20 Nested_s | [UP16, UP13, UP11, UP0] | make_Nested_s |
| 289-295 | child1 Nested_SL_2 | [UP2, UP0, UP17, UP18, UP19] | make_Nested_SL_2 + make_Nested_LuaSendMsg |
| 296-298 | child13 Nested_Helper_6 | [UP0] | make_Nested_ClearBlacklistItems |
| 299-306 | child18 Nested_Helper_10 | [UP2, UP0, UP1, R19, R16] | make_Nested_Helper_10 |
| 307-312 | child8 Nested_SL_3 | [UP2, UP0, UP1, UP7] | make_Nested_SL_3 |
| 313-318 | child19 Nested_TakeItems | [UP2, UP0, UP1, UP7] | make_Nested_TakeItems |
| 319-323 | child10 Nested_shiquTimer | [UP2, UP0, UP7] | make_Nested_shiquTimer |
| 324-329 | child21 Nested_dropTimer | [UP2, UP0, UP1, UP7] | make_Nested_dropTimer |
| 330-335 | child3 Nested_FFFF00 | [UP3, UP0, UP2, UP1] | 已接入调用点；工厂主体仍在第六十二批独立候选 |
| 336-337 | child4 Nested_OnGameLeaveWorld | 无捕获 | Nested_OnGameLeaveWorld |

### 相关前置闭包

PC236-PC267一并核对并在草稿中显式记录：

- PC236 child5同步按钮状态回调捕获[T12,UP4]，加入make_Nested_ffffff。
- PC239 child17黑名单定时回调捕获[UP5,UP6,UP2,UP7,UP0]，加入make_Nested_blacklistTimer。
- PC245 child7引怪初始化回调捕获[UP8,UP9]，加入make_Nested_InitGatherMonsters。
- PC248 child22 Nested_Anonymous仅捕获UP0；其父包装器仍未合并。
- PC250 child11 Nested_Helper_4捕获[R18,UP10,UP11,UP0,UP12,UP13,R16,R15]；已加入Helper_4包装器及Helper_5校验回调工厂。
- PC259 child14 Nested_Helper_7捕获[R18,UP14,UP11,UP0,UP12,UP15,R17,R15]；已加入Helper_7包装器及Helper_8校验回调工厂。

### child6分支语义复核

child6在无gatherTimer时调用UP2()检查条件：

- 返回false/nil：调用UP3("路径中没有怪物数量阈值，弹出输入框")，随后调用UP4()打开阈值输入，再返回false。
- 返回truthy：调用UP1("开启引怪功能")，将该truthy值传给UP5(ready)，返回true。
- gatherTimer存在：通知关闭、调用StopGatherMonsters()、返回true。

因此UP3是接收固定提示文本的回调，不是无参输入框回调；输入框为R20对应的child14包装器。第六十三批工厂已按此修正。

## child12每日巡航回调并入

依据检查点111的43条完整静态恢复结果：

- PC160-PC163创建时捕获父R5、父UP3、父UP0。
- PC145先清空父帧T5，child12捕获时日期标记cell初始为nil。
- os.date("*t")返回假值直接退出。
- 仅在当天秒数79205至79208（22:00:05至22:00:08，含边界）继续。
- 通过string.format("%04d%02d%02d",year,month,day)生成YYYYMMDD日期键。
- 日期键与上次发送标记相同则退出；不同则先写回日期标记。
- 随后以点调用形式执行messageSender.LuaSendMsg(9002,55556,1,2,3,"",0)，再调用通知回调“到达 22:00:05，发送开启巡航协议”。
- 草稿已将该主体封装为make_Nested_04d_02d_02d，并接入SL:Schedule(dailyCallback,1.0)。

## 未解决边界

1. make_Nested_Anonymous对应root.children[42].children[22]父包装器尚未并入；Helper_4/Helper_7虽已恢复包装器及其校验回调，但openDialog仍依赖该函数。
2. child3 Nested_FFFF00工厂主体及资源统计刷新子函数依赖仍在第六十二批/第六十四、六十五批候选文件中，尚未合并为当前单文件。
3. GUI:Attach_UITop七个显式实参来源和含义仍未闭合，当前仍是TODO占位。
4. doInit_UI其余UPVALUE业务身份、GUI宿主方法语义仍有未决项。
5. 未进行目标游戏运行时验证；当前文件仍不能作为单文件可运行源码。

## 统计

- 普通Lua草稿：72（修订既有doInit_UI，不增加原型草稿计数）。
- 完整静态恢复：103/110（不变）。
- 运行时验证：0（不变）。

## 下一步

优先恢复child22 Nested_Anonymous父包装器，复用已完成的Nested_str/Nested_match/Nested_Helper_11；随后合并Nested_FFFF00资源统计父工厂及依赖，再继续追踪Attach_UITop七个实参。继续保持草稿、完整静态恢复、运行时验证三项统计独立。
