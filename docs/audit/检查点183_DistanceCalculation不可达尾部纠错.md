# 检查点 #183：DistanceCalculation 不可达尾部纠错

日期：2026-11-10
涉及原型：root.children[22]（legacy root/23，144条）及调用者root.children[47]（BlacklistPlayerDetection，216条）。

## 控制流纠错

检查点182将root.children[22] PC38-PC144中的sceneManager、GetMapData2DPtr、地图尺寸与isObstacle指令误读为活动地图/障碍检查。按物理PC和跳转目标重新核验后，撤销该结论。

- PC1-PC10：四个坐标参数和第五个范围参数入口检查。
- PC13-PC18：起点/终点完全相同时写入0.0并返回。
- PC19-PC22：非正距离范围进入nil返回路径。
- PC23-PC33：计算abs(x2-x1)、abs(y2-y1)，再取max，即Chebyshev距离。
- PC34-PC37：比较第五参数与计算距离。超出范围时清空返回槽后走PC37；未超出时跳过清空指令也走PC37。
- PC37是OP_220无条件return。PC1-PC37内没有任何跳转目标指向PC38或之后，因此PC38-PC144从入口不可达。
- PC38-PC144中的sceneManager、地图指针、行列边界和isObstacle调用均为不可达尾部，不构成真实运行路径，也不能据此声称存在地图障碍采样。

## 对BlacklistPlayerDetection的影响

- UP[5]仍然是root.children[22]，调用五实参顺序仍为mainX、mainY、candidateX、candidateY、blacklistState.distance。
- 辅助函数的可达行为是计算Chebyshev距离并按最大距离阈值返回距离或nil。
- 主函数PC136-PC141的nil门槛仍然成立：nil不更新当前目标缓存；非nil才记录距离与目标名称。
- 删除此前“map-aware”“target-cell obstacle”“route-sample obstacle”等不准确注释；替换为Chebyshev distance helper。
- 检查点182审计文件已标注被本检查点纠正，不再作为地图/障碍检查证据。

## 状态结论

本批是对检查点182的必要纠错，不提升BlacklistPlayerDetection状态。普通Lua草稿73；完整静态恢复100/110；运行时验证0。
下一步：逐条复核root.children[47] PC74-PC141玩家扫描循环CFG，包括actor/self筛选、UP[4]双返回值消费、距离结果门槛和多目标覆盖。


> **后续检查点184补充：** 已独立复核调用者root.children[47] PC74-PC141。UP[2].distance为false/nil时跳过UP[5]调用；truthy时以mainX/mainY/actorX/actorY/distance五参调用root.children[22]。helper返回nil时继续下一玩家；非nil时进入循环体内的日志/重试/传送分支。见docs/audit/检查点184_距离辅助函数与BlacklistPlayerDetection玩家循环CFG闭合.md。
