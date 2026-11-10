# 检查点 #182：BlacklistPlayerDetection 地图/障碍距离门槛阶段复核

日期：2026-11-10
主原型：root.children[47]（legacy root/48），216条指令。
辅助原型：root.children[22]（legacy root/23），144条指令，vararg_flag=5，无子原型。
本检查点只补充可由调用点与辅助原型指令直接支持的事实；没有将主函数升级为完整静态恢复。

## UP[5] 捕获与五实参调用闭合

- root.children[47] 的13个捕获中，UP[5]捕获父root T[53]；闭包映射与root PC368-PC381捕获顺序一致。
- T[53]是root.children[22] / legacy root/23的距离/地图路径检查辅助函数。
- BlacklistPlayerDetection PC108-PC127依次取得主玩家ACTOR_MAP_X(mainActorID)、主玩家ACTOR_MAP_Y(mainActorID)、当前目标ACTOR_MAP_X(actor)、当前目标ACTOR_MAP_Y(actor)。
- PC128-PC134将四个坐标与UP[5]、blacklistState.distance按顺序组成五实参调用。
- 第五实参来自UP[2].distance，不是actor ID；五实参数据流闭合。

## DistanceCalculation 已确认的入口和几何门槛

- PC1-PC10检查四个坐标输入及第五个范围参数；缺少/假值输入进入nil返回路径。Lua数值0本身为truthy，不会仅因坐标为0被入口拒绝。
- PC13-PC18处理起点与终点坐标完全相同的情形，写入0.0并返回。
- PC19-PC22拒绝非正范围。
- PC23-PC33计算两个坐标轴的绝对差，并取较大值：max(abs(x2-x1), abs(y2-y1))，即Chebyshev距离。
- PC34-PC37在该距离超过第五参数范围时走nil返回路径；等于上限不会因该比较而被拒绝。
- 因此第五实参的已确认语义是最大格数/距离阈值，而非actor标识。

## 地图数据与障碍检查证据

- PC38-PC49读取global.sceneManager并调用GetMapData2DPtr；缺失时走无结果返回。
- PC50-PC53从地图数据对象读取getMapDataRows/getMapDataCols。
- PC54-PC61对目标坐标(x2,y2)执行非负及行列边界检查；超出边界进入无结果返回路径。
- PC64-PC71通过地图数据对象的isObstacle(x2,y2)执行目标点障碍检查；返回值为0时继续，非零值被转为nil结果并返回。
- PC72-PC141存在数值/插值循环，并在PC119-PC124再次调用isObstacle；可确认辅助函数不只是纯几何距离计算，还会沿候选路径进行地图障碍采样。
- 该循环中的步数/插值坐标公式、每个采样点的边界处理及所有分支的精确组合仍需继续逐条复核，本检查点不猜写成Bresenham或其他具体算法。

## 主函数 PC136-PC141 的结果门槛

- PC135将UP[5]调用的返回值放入R14。
- PC136将R14与VM nil哨兵比较；PC137-PC141据此分流。
- nil结果不会更新当前目标名称/距离/发现标志，并退出当前候选路径；非nil结果才将actorName、distance写入当前目标缓存并标记发现黑名单玩家。
- 所以旧草稿中的distance ~= nil候选门槛方向正确；此前“哨兵含义未知”的注释可以移除，但helper内部路径采样公式仍未完全闭合。

## 状态与下一步

- 主函数仍为首版普通Lua草稿，不能因本批调用点和helper部分语义闭合而升级完整静态恢复。
- 新增事实：UP[5]确认为root.children[22]地图感知距离辅助函数；五实参顺序、Chebyshev最大范围、地图数据/目标边界/障碍检查、nil拒绝门槛已闭合。
- 未解决：root.children[22] PC72-PC141插值/采样循环的精确算法；主函数全CFG逐段独立复核及全部分支覆盖。
- 运行时验证仍为0。
- 源码候选已更新：04_源码候选/root47_BlacklistPlayerDetection.lua。
- 下一步：独立完成root.children[22] PC72-PC141障碍采样循环复核，再将其完整语义回填root.children[47]并检查PC74-PC141玩家循环全部控制流。
