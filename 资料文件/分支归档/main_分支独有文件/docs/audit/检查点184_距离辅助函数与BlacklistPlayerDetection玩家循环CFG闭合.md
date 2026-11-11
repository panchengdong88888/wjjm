# 检查点 #184：距离辅助函数活动路径与黑名单玩家扫描CFG闭合

日期：2026-11-10
目标一：root.children[22] / legacy root/23 / VM索引名GetMapData2DPtr（144条）。
目标二：root.children[47] / legacy root/48 / BlacklistPlayerDetection（216条）。

## 一、root.children[22] 活动路径完成

- 父root PC350创建该闭包，PC351捕获父T[52]为UP[0]。
- 可达路径仅PC1-PC37：PC1-PC10检查五个固定输入；PC13-PC18相同坐标返回0.0；PC19-PC22拒绝非正maxDistance；PC23-PC33计算max(abs(x2-x1),abs(y2-y1))；PC34-PC37超限返回nil，否则返回距离值。
- PC37 OP_220是无条件return；PC1-PC37所有跳转目标均不超过PC37，因此PC38-PC144不可达。
- PC38-PC144虽然出现sceneManager/GetMapData2DPtr/getMapDataRows/getMapDataCols/isObstacle等符号，但不得写进实际执行源码。
- UP[0]在可达PC1-PC37中没有读取。
- 新增源码：04_源码候选/root22_GetMapData2DPtr.lua。源码保留VM索引名，不将推测的作者原名写成事实。

## 二、BlacklistPlayerDetection PC74-PC141 玩家扫描CFG

- PC74-PC77初始化数字循环，索引从1到playerCount，步长1；PC215为循环增量/回跳，回到PC78；PC216为函数return。
- PC78读取players[index]；PC81对nil actor走循环尾；PC83比较actorID与mainActorID，相等时PC84跳过当前玩家并走循环尾。
- PC85-PC89调用UP[4](actorID)，收集两个返回值；PC90仅以第一返回值truthy作为黑名单命中条件。未命中走PC91至循环尾。
- PC92-PC101优先采用第二返回值作为显示名；缺失时查询SL:GetMetaValue("ACTOR_NAME", actorID)；仍缺失则用“黑名单玩家”。
- PC102-PC107读取UP[2].distance。若该值为false/nil，跳过坐标读取和UP[5]调用，直接进入PC139-PC140后续处理；距离展示路径将nil值格式化为0.0。
- 若UP[2].distance truthy，PC108-PC127读取mainActorID与actorID的X/Y坐标，PC128-PC135调用UP[5](mainX,mainY,actorX,actorY,distance)。
- PC136-PC141检查UP[5]结果：nil时跳至PC215，继续下一个玩家；非nil时进入PC142日志/重试/传送路径。
- 所以distance配置缺失与helper返回nil是不同路径：前者绕过距离计算并接受该黑名单玩家；后者拒绝当前玩家并继续扫描。

## 三、日志/重试/传送实际位于循环体内

- PC142-PC159对当前命中玩家执行日志节流：os.time() - (alertAt or 0)达到UP[6]阈值时写回alertAt并调用UP[7]；格式化距离使用distance或0.0。
- PC160-PC163检查nextTryAt；若nextTryAt > now，直接跳到PC216退出整个回调。
- PC164-PC167调用UP[8]查找/使用随机传送道具；truthy结果进入成功分支PC168-PC192。
- 成功分支写nextTryAt=now+UP[9]、noStoneWarned=false，显示通知并记录带道具名的日志，PC192跳到PC216退出。
- 失败分支PC193-PC214写nextTryAt=now+UP[11]；若noStoneWarned尚未置位，则置true、显示一次通知并输出table.concat(UP[12],"/")；PC214同样跳到PC216退出。
- PC215只负责循环推进，主要用于空actor、自身、非黑名单和距离helper返回nil的路径。
- 因此不存在“遍历全部玩家后再统一选择目标”的后处理阶段。第一个通过距离门槛的黑名单玩家进入处理路径后，无论重试门槛、成功或失败，都会结束本次回调；只有距离helper返回nil才继续扫描后续玩家。

## 四、源码修正与状态

- 修正root47草稿：移除currentTargetName/currentTargetDistance/blacklistedTargetFound的后置聚合；把日志/重试/传送放回玩家循环体；加入distance配置false/nil时绕过坐标/helper、显示距离0的分支；成功/失败/nextTryAt路径均return。
- root.children[22]升级为完整静态恢复（未运行时验证）；root.children[47]仍为普通Lua草稿，等待剩余CFG与调用链复核。
- 新增源码：04_源码候选/root22_GetMapData2DPtr.lua；更新源码：04_源码候选/root47_BlacklistPlayerDetection.lua。
- 统计：普通Lua草稿72；完整静态恢复101/110；运行时验证0。
- 下一步：对root.children[47] PC1-PC73入口/HP状态机、PC142-PC216通知/重试分支与前述循环CFG做全函数合并复审。


> **检查点185纠错补充：** 本审计中PC63-PC73玩家列表读取后使用#players的表达已被撤销。PC66 OP_233明确收集两个返回值players与playerCount，PC69/71检查第二返回值，PC74-PC77直接使用该值作为数字循环上界。详见检查点185审计。
